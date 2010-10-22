Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab0JVSle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:41:34 -0400
Received: from kroah.org ([198.145.64.141]:45940 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758814Ab0JVSl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:29 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:40:32 2010
Message-Id: <20101022184032.674627375@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:39:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tony Luck <tony.luck@intel.com>, dann frazier <dannf@debian.org>
Subject: [02/17] guard page for stacks that grow upwards
In-Reply-To: <20101022184048.GA25391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luck, Tony <tony.luck@intel.com>

commit 8ca3eb08097f6839b2206e2242db4179aee3cfb3 upstream.

pa-risc and ia64 have stacks that grow upwards. Check that
they do not run into other mappings. By making VM_GROWSUP
0x0 on architectures that do not ever use it, we can avoid
some unpleasant #ifdefs in check_stack_guard_page().

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/mm.h |    8 +++++++-
 mm/memory.c        |   15 +++++++++++----
 mm/mmap.c          |    3 ---
 3 files changed, 18 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -87,7 +87,11 @@ extern unsigned int kobjsize(const void
 #define VM_MAYSHARE	0x00000080
 
 #define VM_GROWSDOWN	0x00000100	/* general info on the segment */
+#if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
 #define VM_GROWSUP	0x00000200
+#else
+#define VM_GROWSUP	0x00000000
+#endif
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
 
@@ -1181,8 +1185,10 @@ unsigned long max_sane_readahead(unsigne
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
-#ifdef CONFIG_IA64
+#if VM_GROWSUP
 extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
+#else
+  #define expand_upwards(vma, address) do { } while (0)
 #endif
 extern int expand_stack_downwards(struct vm_area_struct *vma,
 				  unsigned long address);
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2396,11 +2396,9 @@ out_nomap:
 }
 
 /*
- * This is like a special single-page "expand_downwards()",
- * except we must first make sure that 'address-PAGE_SIZE'
+ * This is like a special single-page "expand_{down|up}wards()",
+ * except we must first make sure that 'address{-|+}PAGE_SIZE'
  * doesn't hit another vma.
- *
- * The "find_vma()" will do the right thing even if we wrap
  */
 static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned long address)
 {
@@ -2412,6 +2410,15 @@ static inline int check_stack_guard_page
 
 		expand_stack(vma, address);
 	}
+	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
+		struct vm_area_struct *next = vma->vm_next;
+
+		/* As VM_GROWSDOWN but s/below/above/ */
+		if (next && next->vm_start == address + PAGE_SIZE)
+			return next->vm_flags & VM_GROWSUP ? 0 : -ENOMEM;
+
+		expand_upwards(vma, address + PAGE_SIZE);
+	}
 	return 0;
 }
 
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1589,9 +1589,6 @@ static int acct_stack_growth(struct vm_a
  * PA-RISC uses this for its stack; IA64 for its Register Backing Store.
  * vma is the last one with address > vma->vm_end.  Have to extend vma.
  */
-#ifndef CONFIG_IA64
-static inline
-#endif
 int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 {
 	int error;


