Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129Ab0LNK0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:26:09 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:50353 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab0LNK0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:26:07 -0500
Date: Tue, 14 Dec 2010 15:56:14 +0530
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
Subject: [Patch 20/21] Add supporting for compat ELF class data structures
Message-ID: <20101214155614.215b39ff@suzukikp>
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

Redefine the structures to include the compat class variant of the data 
structures.

gencore-elf.c will be reused for the compat ELF class support. Hence, define 
macros to get the right member for each class.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>

---
 fs/proc/gencore-elf.c |   37 +++++++++++++++++++++++++------------
 fs/proc/gencore.h     |   18 ++++++++++++++++--
 2 files changed, 41 insertions(+), 14 deletions(-)

Index: linux-2.6.36-rc7/fs/proc/gencore-elf.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore-elf.c
+++ linux-2.6.36-rc7/fs/proc/gencore-elf.c
@@ -16,6 +16,8 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2010
+ *
+ * This code is reused in gencore-compat-elf.c for compat ELF class support.
  */
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -30,6 +32,17 @@
 
 #include "gencore.h"
 
+#ifndef et_prstatus
+/* prstatus field for native elf,  in elf_thread_core_info*/
+#define et_prstatus u.prstatus
+#endif
+
+#ifndef cp_prpsinfo
+/* prpsinfo field for native elf, in core_proc */
+#define cp_prpsinfo u.prpsinfo
+#endif
+
+
 static int notesize(struct memelfnote *men)
 {
 	int size = sizeof(struct elf_note);
@@ -73,14 +86,14 @@ static int fill_thread_core_info(struct 
 	unsigned int i;
 	const struct user_regset_view *view = task_user_regset_view(tinfo->task);
 
-	fill_prstatus(&tinfo->prstatus, tinfo->task, 0);
+	fill_prstatus(&tinfo->et_prstatus, tinfo->task, 0);
 
 	do_thread_regset_writeback(tinfo->task, &view->regsets[0]);
 	(void) view->regsets[0].get(tinfo->task, &view->regsets[0],
-				0, sizeof(tinfo->prstatus.pr_reg),
-				&tinfo->prstatus.pr_reg, NULL);
+				0, sizeof(tinfo->et_prstatus.pr_reg),
+				&tinfo->et_prstatus.pr_reg, NULL);
 	fill_note(&tinfo->notes[0], "CORE", NT_PRSTATUS,
-			sizeof(tinfo->prstatus), &tinfo->prstatus);
+			sizeof(tinfo->et_prstatus), &tinfo->et_prstatus);
 	cp->notes_size += notesize(&tinfo->notes[0]);
 	tinfo->num_notes = view->n;
 
@@ -105,7 +118,7 @@ static int fill_thread_core_info(struct 
 						regset->core_note_type,
 						size, data);
 				else {
-					tinfo->prstatus.pr_fpvalid = 1;
+					tinfo->et_prstatus.pr_fpvalid = 1;
 					fill_note(&tinfo->notes[i], "CORE",
 						NT_PRFPREG, size, data);
 				}
@@ -124,15 +137,15 @@ static int fill_thread_core_info(struct 
 	elf_fpxregset_t xfpu, *pxfpu;
 #endif
 
-	fill_prstatus(&tinfo->prstatus, t->task, 0);
-	elf_core_copy_task_regs(t->task, &tinfo->prstatus.pr_reg);
+	fill_prstatus(&tinfo->et_prstatus, t->task, 0);
+	elf_core_copy_task_regs(t->task, &tinfo->et_prstatus.pr_reg);
 	fill_note(&tinfo->notes[0], "CORE", NT_PRSTATUS,
-			sizeof(t->prstatus), &t->prstatus);
+			sizeof(t->et_prstatus), &t->et_prstatus);
 
 	cp->notes_size += notesize(&tinfo->notes[0]);
 	tinfo->num_notes = 1;
 
-	if (tinfo->prstatus.pr_fpvalid = elf_core_copy_task_fpregs(tinfo->task,
+	if (tinfo->et_prstatus.pr_fpvalid = elf_core_copy_task_fpregs(tinfo->task,
 							NULL, &fpu)) {
 		pfpu = kzalloc(sizeof(*pfpu), GFP_KERNEL);
 		if (pfpu == NULL)
@@ -168,7 +181,7 @@ static void zero_thread_state(struct elf
 {
 	int i;
 
-	memset(&tinfo->prstatus.pr_reg, 0, sizeof(tinfo->prstatus.pr_reg));
+	memset(&tinfo->et_prstatus.pr_reg, 0, sizeof(tinfo->et_prstatus.pr_reg));
 	for (i = 1; i < tinfo->num_notes; i++)
 		if (tinfo->notes[i].data)
 			memset(tinfo->notes[i].data, 0, tinfo->notes[i].datasz);
@@ -180,9 +193,9 @@ static int collect_notes(struct core_pro
 	struct elf_thread_core_info *tinfo;
 
 	/* Fill the 2 process wide notes */
-	fill_psinfo(&cp->prpsinfo, cp->task, cp->task->mm);
+	fill_psinfo(&cp->cp_prpsinfo, cp->task, cp->task->mm);
 	fill_note(&cp->psinfo, "CORE", NT_PRPSINFO,
-			sizeof(struct elf_prpsinfo), &cp->prpsinfo);
+			sizeof(struct elf_prpsinfo), &cp->cp_prpsinfo);
 	cp->notes_size += notesize(&cp->psinfo);
 
 	fill_auxv_note(&cp->auxv, cp->task->mm);
Index: linux-2.6.36-rc7/fs/proc/gencore.h
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.h
+++ linux-2.6.36-rc7/fs/proc/gencore.h
@@ -6,6 +6,10 @@
 #include <linux/elfcore.h>
 #include <linux/elfcore-internal.h>
 
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+#include <linux/elfcore-compat.h>
+#endif
+
 enum { ELF_CLASS_NATIVE, ELF_CLASS_COMPAT };
 
 struct elf_thread_core_info {
@@ -13,7 +17,12 @@ struct elf_thread_core_info {
 	unsigned short num_notes;	/* Number of notes for this thread */
 	struct elf_thread_core_info *next;
 	struct task_struct *task;
-	struct elf_prstatus prstatus;
+	union {
+		struct elf_prstatus prstatus;
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+		struct compat_elf_prstatus compat_prstatus;
+#endif
+	} u;
 	struct memelfnote notes[0];
 };
 
@@ -25,7 +34,12 @@ struct core_proc {
 	struct elf_thread_core_info *tinfo;
 	struct memelfnote psinfo;
 	struct memelfnote auxv;
-	struct elf_prpsinfo prpsinfo;
+	union {
+		struct elf_prpsinfo prpsinfo;
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+		struct compat_elf_prpsinfo compat_prpsinfo;
+#endif
+	} u;
 	size_t elf_buflen;	/* size of elf_buf */
 	size_t nphdrs;		/* number of phdrs */
 	size_t notes_size;
