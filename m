Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab0LNKRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:17:24 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:55758 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0LNKRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:17:23 -0500
Date: Tue, 14 Dec 2010 15:47:33 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 15/21] Collect ELF Core notes data
Message-ID: <20101214154733.495bd2e7@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collect the PT_NOTE information for the core. 

There are two "process wide" notes. NT_PRPSINFO and NT_AUXV. These are captured 
in the core_proc structure.

Each thread gets a NT_PRSTATUS note, which will contain the GPR contents. A 
thread may have additional notes depending on the other register sets used by it.
Uses struct elf_thread_core_info to capture the thread specific information.

fill_thread_core_info() fills in the notes for a thread.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N. Mavinakayanahalli <ananth@in.ibm.com>

---
 fs/proc/gencore-elf.c |  183 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/proc/gencore.c     |   67 ++++++++++++++++--
 fs/proc/gencore.h     |   28 +++++++
 3 files changed, 268 insertions(+), 10 deletions(-)

Index: linux-2.6.36-rc7/fs/proc/gencore.h
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.h
+++ linux-2.6.36-rc7/fs/proc/gencore.h
@@ -3,16 +3,44 @@
 
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/elfcore.h>
+#include <linux/elfcore-internal.h>
+
+struct elf_thread_core_info {
+	unsigned short num_notes;	/* Number of notes for this thread */
+	struct elf_thread_core_info *next;
+	struct task_struct *task;
+	struct elf_prstatus prstatus;
+	struct memelfnote notes[0];
+};
 
 struct core_proc {
 	struct list_head list;
 	struct task_struct *task;
 	void *shdr;		/* elf_shdr, in case nphdrs > PN_XNUM */
 	char *elf_buf;		/* buffer for elf_hdr + phdrs + notes */
+	struct elf_thread_core_info *tinfo;
+	struct memelfnote psinfo;
+	struct memelfnote auxv;
+	struct elf_prpsinfo prpsinfo;
 	size_t elf_buflen;	/* size of elf_buf */
 	size_t nphdrs;		/* number of phdrs */
+	size_t notes_size;
 };
 
+#ifdef CORE_DUMP_USE_REGSET
+#include <linux/regset.h>
+
+static inline int  get_max_regsets(struct task_struct *task)
+{
+	const struct user_regset_view *view = task_user_regset_view(task);
+	return view->n;
+}
+
+#else
+#define get_max_regsets(task)	3 /* GPR, FP, XFP? */
+#endif
+
 extern ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
 					size_t buflen, loff_t *foffset);
 #endif
Index: linux-2.6.36-rc7/fs/proc/gencore.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.c
+++ linux-2.6.36-rc7/fs/proc/gencore.c
@@ -25,6 +25,7 @@
 #include <linux/seq_file.h>
 #include <linux/elf.h>
 #include <linux/freezer.h>
+#include <linux/sched.h>
 
 #include "internal.h"
 #include "gencore.h"
@@ -70,6 +71,39 @@ out:
 	return ret;
 }
 
+static void free_notes_data(struct elf_thread_core_info *tinfo)
+{
+	int i;
+
+	for (i = 1; i < tinfo->num_notes; i++)
+		if (tinfo->notes[i].data) {
+			kfree(tinfo->notes[i].data);
+			tinfo->notes[i].data = NULL;
+		}
+}
+
+static void cleanup_cp(struct core_proc *cp)
+{
+	struct elf_thread_core_info *tmp, *tinfo = cp->tinfo;
+
+	mutex_lock(&core_mutex);
+	list_del(&cp->list);
+	mutex_unlock(&core_mutex);
+
+	if (tinfo) {
+		do {
+			tmp = tinfo;
+			tinfo = tinfo->next;
+			free_notes_data(tmp);
+			kfree(tmp);
+		} while (tinfo != NULL);
+	}
+	if (cp->shdr)
+		kfree(cp->shdr);
+	kfree(cp->elf_buf);
+	kfree(cp);
+}
+
 static int release_gencore(struct inode *inode, struct file *file)
 {
 	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
@@ -89,14 +123,11 @@ static int release_gencore(struct inode 
 
 	mutex_lock(&core_mutex);
 	cp = get_core_proc(task);
-	if (cp) {
-		list_del(&cp->list);
-		if (cp->shdr)
-			kfree(cp->shdr);
-		kfree(cp->elf_buf);
-		kfree(cp);
-	}
 	mutex_unlock(&core_mutex);
+
+	if (cp)
+		cleanup_cp(cp);
+
 	put_task_struct(task);
 	return 0;
 }
@@ -133,9 +164,11 @@ static int open_gencore(struct inode *in
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct task_struct *t;
+	struct elf_thread_core_info *tinfo = NULL;
 	struct core_proc *cp;
+	int elf_class, max_regset, i;
 	int ret = 0;
-	int elf_class;
+
 
 	if (!task)
 		return -ENOENT;
@@ -164,10 +197,28 @@ static int open_gencore(struct inode *in
 	list_add(&cp->list, &core_list);
 	mutex_unlock(&core_mutex);
 
+	max_regset = get_max_regsets(task);
+
+	for (i = 0; i < get_nr_threads(task); i++) {
+		tinfo = kzalloc(offsetof(struct elf_thread_core_info,
+					notes[max_regset]), GFP_KERNEL);
+		if (unlikely(!tinfo)) {
+			cleanup_cp(cp);
+			ret = -ENOMEM;
+			goto out;
+		}
+		tinfo->next = cp->tinfo;
+		cp->tinfo = tinfo;
+	}
+
 	/* freeze the processes */
 	t = task;
 	read_lock(&tasklist_lock);
 	do {
+		if (tinfo) {
+			tinfo->task = t;
+			tinfo = tinfo->next;
+		}
 		if (frozen(t) || !freezeable(t) || freezing(t))
 			continue;
 
Index: linux-2.6.36-rc7/fs/proc/gencore-elf.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore-elf.c
+++ linux-2.6.36-rc7/fs/proc/gencore-elf.c
@@ -30,6 +30,158 @@
 
 #include "gencore.h"
 
+static int notesize(struct memelfnote *men)
+{
+	int size = sizeof(struct elf_note);
+
+	size += roundup(strlen(men->name) + 1, 4);
+	size += roundup(men->datasz, 4);
+
+	return size;
+}
+
+/* Store the note in the header buffer */
+static char *storenote(struct memelfnote *men, char *bufp)
+{
+	struct elf_note *en = (struct elf_note *)bufp;
+
+	en->n_namesz = strlen(men->name) + 1;
+	en->n_descsz = men->datasz;
+	en->n_type = men->type;
+	bufp = (char *) (en + 1);
+
+	memcpy(bufp, men->name, en->n_namesz);
+	bufp = (char *) roundup((unsigned long)bufp + en->n_namesz, 4);
+
+	memcpy(bufp, men->data, men->datasz);
+	bufp = (char *) roundup((unsigned long)bufp + men->datasz, 4);
+
+	return bufp;
+}
+
+#ifdef CORE_DUMP_USE_REGSET
+static void do_thread_regset_writeback(struct task_struct *task,
+				const struct user_regset *regset)
+{
+	if (regset->writeback)
+		regset->writeback(task, regset, 1);
+}
+
+static int fill_thread_core_info(struct elf_thread_core_info *tinfo,
+					struct core_proc *cp)
+{
+	unsigned int i;
+	const struct user_regset_view *view = task_user_regset_view(tinfo->task);
+
+	fill_prstatus(&tinfo->prstatus, tinfo->task, 0);
+
+	do_thread_regset_writeback(tinfo->task, &view->regsets[0]);
+	(void) view->regsets[0].get(tinfo->task, &view->regsets[0],
+				0, sizeof(tinfo->prstatus.pr_reg),
+				&tinfo->prstatus.pr_reg, NULL);
+	fill_note(&tinfo->notes[0], "CORE", NT_PRSTATUS,
+			sizeof(tinfo->prstatus), &tinfo->prstatus);
+	cp->notes_size += notesize(&tinfo->notes[0]);
+	tinfo->num_notes = view->n;
+
+	for (i = 1; i < view->n; i++) {
+		const struct user_regset *regset = &view->regsets[i];
+
+		do_thread_regset_writeback(tinfo->task, regset);
+		if (regset->core_note_type &&
+			(!regset->active || regset->active(tinfo->task, regset))) {
+			int ret;
+			size_t size = regset->n * regset->size;
+			void *data = kzalloc(size, GFP_KERNEL);
+			if (!unlikely(data))
+				return 0;
+			ret = regset->get(tinfo->task, regset,
+					0, size, data, NULL);
+			if (unlikely(ret))
+				kfree(data);
+			else {
+				if (regset->core_note_type != NT_PRFPREG)
+					fill_note(&tinfo->notes[i], "LINUX",
+						regset->core_note_type,
+						size, data);
+				else {
+					tinfo->prstatus.pr_fpvalid = 1;
+					fill_note(&tinfo->notes[i], "CORE",
+						NT_PRFPREG, size, data);
+				}
+				cp->notes_size += notesize(&tinfo->notes[i]);
+			}
+		}
+	}
+	return 1;
+}
+#else
+static int fill_thread_core_info(struct elf_thread_core_info *tinfo,
+					struct core_proc *cp)
+{
+	elf_fpregset_t fpu, *pfpu;
+#ifdef ELF_CORE_COPY_XFPREGS
+	elf_fpxregset_t xfpu, *pxfpu;
+#endif
+
+	fill_prstatus(&tinfo->prstatus, t->task, 0);
+	elf_core_copy_task_regs(t->task, &tinfo->prstatus.pr_reg);
+	fill_note(&tinfo->notes[0], "CORE", NT_PRSTATUS,
+			sizeof(t->prstatus), &t->prstatus);
+
+	cp->notes_size += notesize(&tinfo->notes[0]);
+	tinfo->num_notes = 1;
+
+	if (tinfo->prstatus.pr_fpvalid = elf_core_copy_task_fpregs(tinfo->task,
+							NULL, &fpu)) {
+		pfpu = kzalloc(sizeof(*pfpu), GFP_KERNEL);
+		if (pfpu == NULL)
+			return 0;
+		memcpy(pfpu, &fpu, sizeof(fpu));
+		fill_note(&tinfo->notes[tinfo->num_notes], "CORE", NT_PRFPREG,
+				sizeof(*pfpu), pfpu);
+		cp->notes_size += notesize(&tinfo->notes[tinfo->num_notes]);
+		tinfo->num_notes++;
+	}
+#ifdef ELF_CORE_COPY_XFPREGS
+	if (elf_core_copy_task_xfpregs(tinfo->task, &xfpu)) {
+		pxfpu = kzalloc(sizeof(*pxfpu), GFP_KERNEL);
+		if (!pxfpu)
+			return 0;
+		memcpy(pxfpu, &xfpu, sizeof(xfpu));
+		fill_note(&tinfo->notes[tinfo->num_notes], "LINUX",
+			ELF_CORE_XFPREG_TYPE, sizeof(*pxfpu), pxfpu);
+		cp->notes_size += notesize(&tinfo->notes[tinfo->num_notes]);
+		tinfo->num_notes++;
+	}
+#endif
+	return 1;
+}
+#endif
+
+/* Returns 0 on error, 1 on success */
+static int collect_notes(struct core_proc *cp)
+{
+	struct elf_thread_core_info *tinfo;
+
+	/* Fill the 2 process wide notes */
+	fill_psinfo(&cp->prpsinfo, cp->task, cp->task->mm);
+	fill_note(&cp->psinfo, "CORE", NT_PRPSINFO,
+			sizeof(struct elf_prpsinfo), &cp->prpsinfo);
+	cp->notes_size += notesize(&cp->psinfo);
+
+	fill_auxv_note(&cp->auxv, cp->task->mm);
+	cp->notes_size += notesize(&cp->auxv);
+
+	tinfo = cp->tinfo;
+	while (tinfo != NULL) {
+		if (!fill_thread_core_info(tinfo, cp))
+			return 0;
+		tinfo = tinfo->next;
+	}
+	return 1;
+}
+
 static void get_elfhdr_size(struct core_proc *cp)
 {
 	struct vm_area_struct *gate_vma;
@@ -47,7 +199,9 @@ static void get_elfhdr_size(struct core_
 
 	cp->nphdrs = segs;
 	cp->elf_buflen = sizeof(struct elfhdr) +
-			(cp->nphdrs * sizeof(struct elf_phdr));
+			(cp->nphdrs * sizeof(struct elf_phdr)) +
+			cp->notes_size;
+
 	cp->elf_buflen = roundup(cp->elf_buflen, ELF_EXEC_PAGESIZE);
 
 	return;
@@ -62,11 +216,13 @@ static int create_elf_header(struct core
 	struct elfhdr *elf = (struct elfhdr *)cp->elf_buf;
 	struct elf_phdr *note;
 	struct vm_area_struct *vma, *gate_vma = get_gate_vma(cp->task);
+	struct elf_thread_core_info *tinfo;
 	char *bufp;
 	off_t dataoff, offset;
 	short e_phnum = (cp->nphdrs > PN_XNUM ? PN_XNUM : cp->nphdrs);
 	size_t exphdrs_sz = 0;
 	unsigned long limit = elf_core_extra_phdrs() * sizeof(struct elf_phdr);
+	int first = 1;
 
 #ifdef CORE_DUMP_USE_REGSET
 	const struct user_regset_view *view = task_user_regset_view(cp->task);
@@ -88,7 +244,7 @@ static int create_elf_header(struct core
 	note->p_offset = dataoff;
 	note->p_vaddr = 0;
 	note->p_paddr = 0;
-	/* TODO: Needs to be populated with the size of the notes section */
+	note->p_filesz = cp->notes_size;
 	note->p_memsz = 0;
 	note->p_flags = 0;
 	note->p_align = 0;
@@ -134,6 +290,22 @@ static int create_elf_header(struct core
 						dataoff, cp->nphdrs);
 		dataoff += sizeof(struct elf_shdr);
 	}
+	/* Store the notes */
+	tinfo = cp->tinfo;
+	do {
+		int i;
+
+		bufp = storenote(&tinfo->notes[0], bufp);
+		if (first) {
+			bufp = storenote(&cp->psinfo, bufp);
+			bufp = storenote(&cp->auxv, bufp);
+		}
+		for (i = 1; i < tinfo->num_notes; i++)
+			if (tinfo->notes[i].data != NULL)
+				bufp = storenote(&tinfo->notes[i], bufp);
+		first = 0;
+		tinfo = tinfo->next;
+	} while (tinfo != NULL);
 
 	return 0;
 }
@@ -143,6 +315,13 @@ ssize_t elf_read_gencore(struct core_pro
 {
 	ssize_t ret = 0;
 
+	if (!cp->notes_size) {
+		if (!collect_notes(cp)) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
 	if (!cp->elf_buf) {
 		get_elfhdr_size(cp);
 
