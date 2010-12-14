Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab0LNKEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:04:25 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:59848 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab0LNKEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:04:24 -0500
Date: Tue, 14 Dec 2010 15:34:32 +0530
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
Subject: [Patch 6/21] Export the reusable ELF core generation routines
Message-ID: <20101214153432.4889fdc1@suzukikp>
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

Export the ELF class specific core generation helper functions via 
elfcore-internal.h

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/binfmt_elf.c                  |   10 +++++-----
 include/linux/elfcore-internal.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 5 deletions(-)

Index: linux-2.6.36-rc7/fs/binfmt_elf.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/binfmt_elf.c
+++ linux-2.6.36-rc7/fs/binfmt_elf.c
@@ -1129,7 +1129,7 @@ static int writenote(struct memelfnote *
 }
 #undef DUMP_WRITE
 
-static void fill_elf_header(struct elfhdr *elf, int segs,
+void fill_elf_header(struct elfhdr *elf, int segs,
 			    u16 machine, u32 flags, u8 osabi)
 {
 	memset(elf, 0, sizeof(*elf));
@@ -1169,7 +1169,7 @@ static void fill_elf_note_phdr(struct el
  * fill up all the fields in prstatus from the given task struct, except
  * registers which need to be filled up separately.
  */
-static void fill_prstatus(struct elf_prstatus *prstatus,
+void fill_prstatus(struct elf_prstatus *prstatus,
 		struct task_struct *p, long signr)
 {
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
@@ -1199,7 +1199,7 @@ static void fill_prstatus(struct elf_prs
 	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
 }
 
-static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
+int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 		       struct mm_struct *mm)
 {
 	const struct cred *cred;
@@ -1253,7 +1253,7 @@ static int fill_psinfo(struct elf_prpsin
 	return 0;
 }
 
-static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
+void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
 {
 	elf_addr_t *auxv = (elf_addr_t *) mm->saved_auxv;
 	int i = 0;
@@ -1722,7 +1722,7 @@ static void free_note_info(struct elf_no
 
 #endif
 
-static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
+void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
 			     elf_addr_t e_shoff, int segs)
 {
 	elf->e_shoff = e_shoff;
Index: linux-2.6.36-rc7/include/linux/elfcore-internal.h
===================================================================
--- linux-2.6.36-rc7.orig/include/linux/elfcore-internal.h
+++ linux-2.6.36-rc7/include/linux/elfcore-internal.h
@@ -15,6 +15,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/elfcore.h>
+
 /* An ELF note in memory */
 struct memelfnote
 {
@@ -40,5 +42,32 @@ extern struct vm_area_struct *next_vma(s
 extern unsigned long vma_dump_size(struct task_struct *task,
 			struct vm_area_struct *vma, unsigned long mm_flags);
 
+/* Core dump generation routines for native ELF class */
+extern void fill_elf_header(struct elfhdr *elf, int segs,
+				u16 machine, u32 flags, u8 osabi);
+extern void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr,
+				elf_addr_t e_shoff, int segs);
+extern void fill_prstatus(struct elf_prstatus *prstatus,
+				struct task_struct *p, long signr);
+extern int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
+				struct mm_struct *mm);
+extern void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm);
+
+/* compat ELF class variant of the above helpers*/
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+#include <linux/elfcore-compat.h>
+
+extern void compat_fill_extnum_info(struct elf32_hdr *elf, struct elf32_shdr *shdr,
+				Elf32_Addr e_shoff, int segs);
+extern void compat_fill_prstatus(struct compat_elf_prstatus *prstatus,
+					struct task_struct *p, long signr);
+extern int compat_fill_psinfo(struct compat_elf_prpsinfo *psinfo, struct task_struct *p,
+				struct mm_struct *mm);
+extern void compat_fill_auxv_note(struct memelfnote *note, struct mm_struct *mm);
+
+extern void compat_fill_elf_header(struct elf32_hdr *elf, int segs,
+				u16 machine, u32 flags, u8 osabi);
+#endif /* CONFIG_COMPAT_BINFMT_ELF */
+
 #endif
 #endif
