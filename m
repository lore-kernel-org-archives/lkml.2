Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0LNKP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:15:59 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60628 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab0LNKP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:15:58 -0500
Date: Tue, 14 Dec 2010 15:46:07 +0530
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
Subject: [Patch 14/21] Create ELF header
Message-ID: <20101214154607.3ace278c@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build the ELF header on the fly for the very first read request. The ELF Header,
 Program Headers are stored in a buffer for processing future read() requests.

gencore-elf.c contains the ELF class specific functions.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N.Mavinakayanahalli <ananth@in.ibm.com>

---
 fs/proc/Makefile      |    2 
 fs/proc/gencore-elf.c |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/gencore.c     |    5 +
 fs/proc/gencore.h     |    6 +
 4 files changed, 189 insertions(+), 1 deletion(-)

Index: linux-2.6.36-rc7/fs/proc/gencore.h
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.h
+++ linux-2.6.36-rc7/fs/proc/gencore.h
@@ -7,6 +7,12 @@
 struct core_proc {
 	struct list_head list;
 	struct task_struct *task;
+	void *shdr;		/* elf_shdr, in case nphdrs > PN_XNUM */
+	char *elf_buf;		/* buffer for elf_hdr + phdrs + notes */
+	size_t elf_buflen;	/* size of elf_buf */
+	size_t nphdrs;		/* number of phdrs */
 };
 
+extern ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
+					size_t buflen, loff_t *foffset);
 #endif
Index: linux-2.6.36-rc7/fs/proc/gencore-elf.c
===================================================================
--- /dev/null
+++ linux-2.6.36-rc7/fs/proc/gencore-elf.c
@@ -0,0 +1,177 @@
+/*
+ * Application core dump - ELF Class specific code
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2010
+ */
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/freezer.h>
+#include <linux/elf.h>
+#include <linux/elfcore.h>
+#include <linux/elfcore-internal.h>
+
+#ifdef CORE_DUMP_USE_REGSET
+#include <linux/regset.h>
+#endif
+
+#include "gencore.h"
+
+static void get_elfhdr_size(struct core_proc *cp)
+{
+	struct vm_area_struct *gate_vma;
+	int segs;
+
+	segs = cp->task->mm->map_count;
+	segs += elf_core_extra_phdrs();
+
+	gate_vma = get_gate_vma(cp->task);
+	if (gate_vma != NULL)
+		segs++;
+
+	/* One phdr for PT_NOTE */
+	segs++;
+
+	cp->nphdrs = segs;
+	cp->elf_buflen = sizeof(struct elfhdr) +
+			(cp->nphdrs * sizeof(struct elf_phdr));
+	cp->elf_buflen = roundup(cp->elf_buflen, ELF_EXEC_PAGESIZE);
+
+	return;
+}
+
+/*
+ * Fill the elf_hdr and the phdrs
+ * Returns 0 on success. On error, returns errno
+ */
+static int create_elf_header(struct core_proc *cp)
+{
+	struct elfhdr *elf = (struct elfhdr *)cp->elf_buf;
+	struct elf_phdr *note;
+	struct vm_area_struct *vma, *gate_vma = get_gate_vma(cp->task);
+	char *bufp;
+	off_t dataoff, offset;
+	short e_phnum = (cp->nphdrs > PN_XNUM ? PN_XNUM : cp->nphdrs);
+	size_t exphdrs_sz = 0;
+	unsigned long limit = elf_core_extra_phdrs() * sizeof(struct elf_phdr);
+
+#ifdef CORE_DUMP_USE_REGSET
+	const struct user_regset_view *view = task_user_regset_view(cp->task);
+
+	fill_elf_header(elf, e_phnum, view->e_machine, view->e_flags,
+					view->ei_osabi);
+#else
+	fill_elf_header(elf, e_phnum, ELF_ARCH, ELF_CORE_EFLAGS, ELF_OSABI);
+#endif
+	offset = sizeof(struct elfhdr);
+ 	bufp = cp->elf_buf + offset;
+	dataoff = offset + (cp->nphdrs * sizeof(struct elf_phdr));
+
+	/* Setup ELF PT_NOTE */
+	note = (struct elf_phdr*)bufp;
+	bufp += sizeof(struct elf_phdr);
+	offset += sizeof(struct elf_phdr);
+	note->p_type = PT_NOTE;
+	note->p_offset = dataoff;
+	note->p_vaddr = 0;
+	note->p_paddr = 0;
+	/* TODO: Needs to be populated with the size of the notes section */
+	note->p_memsz = 0;
+	note->p_flags = 0;
+	note->p_align = 0;
+
+	dataoff = cp->elf_buflen;
+
+	/* Write the phdrs for memory segments */
+	down_read(&cp->task->mm->mmap_sem);
+	for (vma = first_vma(cp->task, gate_vma); vma != NULL;
+			vma = next_vma(vma, gate_vma)) {
+		struct elf_phdr *phdr = (struct elf_phdr  *)bufp;
+
+		bufp += sizeof(struct elf_phdr);
+		offset += sizeof(struct elf_phdr);
+
+		phdr->p_type = PT_LOAD;
+		phdr->p_offset = dataoff;
+		phdr->p_vaddr = vma->vm_start;
+		phdr->p_paddr = 0;
+		phdr->p_filesz = vma_dump_size(cp->task, vma, cp->task->mm->flags);
+		phdr->p_memsz = vma->vm_end - vma->vm_start;
+		phdr->p_flags = (vma->vm_flags & VM_READ) ? PF_R : 0;
+		if (vma->vm_flags & VM_WRITE)
+			phdr->p_flags |= PF_W;
+		if (vma->vm_flags & VM_EXEC)
+			phdr->p_flags |= PF_X;
+		phdr->p_align = ELF_EXEC_PAGESIZE;
+
+		dataoff += phdr->p_filesz;
+	}
+	up_read(&cp->task->mm->mmap_sem);
+
+	if (!elf_core_copy_extra_phdrs(bufp, dataoff, &exphdrs_sz, limit))
+		return -EIO;
+	bufp += exphdrs_sz;
+	dataoff += elf_core_extra_data_size();
+
+	if (e_phnum == PN_XNUM) {
+		cp->shdr = kzalloc(sizeof(struct elf_shdr), GFP_KERNEL);
+		if (!cp->shdr)
+			return -ENOMEM;
+		fill_extnum_info(elf, (struct elf_shdr *)cp->shdr,
+						dataoff, cp->nphdrs);
+		dataoff += sizeof(struct elf_shdr);
+	}
+
+	return 0;
+}
+
+ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
+				size_t buflen, loff_t *fpos)
+{
+	ssize_t ret = 0;
+
+	if (!cp->elf_buf) {
+		get_elfhdr_size(cp);
+
+		cp->elf_buf = kzalloc(cp->elf_buflen, GFP_KERNEL);
+		if (!cp->elf_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = create_elf_header(cp);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (*fpos < cp->elf_buflen) {
+		size_t bcp = cp->elf_buflen - *fpos;
+
+		bcp = (bcp < buflen) ? bcp : buflen;
+		if (copy_to_user(buffer, (cp->elf_buf + *fpos), bcp)) {
+			ret = -EFAULT;
+			goto out;
+		} else {
+			ret = bcp;
+			*fpos += bcp;
+			buflen -= bcp;
+			buffer += bcp;
+		}
+	}
+
+out:
+	return ret;
+}
Index: linux-2.6.36-rc7/fs/proc/Makefile
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/Makefile
+++ linux-2.6.36-rc7/fs/proc/Makefile
@@ -19,7 +19,7 @@ proc-y	+= stat.o
 proc-y	+= uptime.o
 proc-y	+= version.o
 proc-y	+= softirqs.o
-proc-$(CONFIG_ELF_CORE)	+= gencore.o
+proc-$(CONFIG_ELF_CORE)	+= gencore.o gencore-elf.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
Index: linux-2.6.36-rc7/fs/proc/gencore.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.c
+++ linux-2.6.36-rc7/fs/proc/gencore.c
@@ -63,6 +63,8 @@ static ssize_t read_gencore(struct file 
 	}
 	mutex_unlock(&core_mutex);
 
+	ret = elf_read_gencore(cp, buffer, buflen, fpos);
+
 out:
 	put_task_struct(task);
 	return ret;
@@ -89,6 +91,9 @@ static int release_gencore(struct inode 
 	cp = get_core_proc(task);
 	if (cp) {
 		list_del(&cp->list);
+		if (cp->shdr)
+			kfree(cp->shdr);
+		kfree(cp->elf_buf);
 		kfree(cp);
 	}
 	mutex_unlock(&core_mutex);
