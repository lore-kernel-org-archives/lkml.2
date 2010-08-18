Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0HRPHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:07:38 -0400
Received: from kroah.org ([198.145.64.141]:47465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0HRPHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:07:35 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 18 08:05:57 2010
Message-Id: <20100818150557.194426287@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 18 Aug 2010 08:01:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [1/6] mm: keep a guard page below a grow-down stack segment
In-Reply-To: <20100818150615.GA4752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 320b2b8de12698082609ebbc1a17165727f4c893 upstream.

This is a rather minimally invasive patch to solve the problem of the
user stack growing into a memory mapped area below it.  Whenever we fill
the first page of the stack segment, expand the segment down by one
page.

Now, admittedly some odd application might _want_ the stack to grow down
into the preceding memory mapping, and so we may at some point need to
make this a process tunable (some people might also want to have more
than a single page of guarding), but let's try the minimal approach
first.

Tested with trivial application that maps a single page just below the
stack, and then starts recursing.  Without this, we will get a SIGSEGV
_after_ the stack has smashed the mapping.  With this patch, we'll get a
nice SIGBUS just as the stack touches the page just above the mapping.

Requested-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2396,6 +2396,26 @@ out_nomap:
 }
 
 /*
+ * This is like a special single-page "expand_downwards()",
+ * except we must first make sure that 'address-PAGE_SIZE'
+ * doesn't hit another vma.
+ *
+ * The "find_vma()" will do the right thing even if we wrap
+ */
+static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned long address)
+{
+	address &= PAGE_MASK;
+	if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
+		address -= PAGE_SIZE;
+		if (find_vma(vma->vm_mm, address) != vma)
+			return -ENOMEM;
+
+		expand_stack(vma, address);
+	}
+	return 0;
+}
+
+/*
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
@@ -2408,6 +2428,9 @@ static int do_anonymous_page(struct mm_s
 	spinlock_t *ptl;
 	pte_t entry;
 
+	if (check_stack_guard_page(vma, address) < 0)
+		return VM_FAULT_SIGBUS;
+
 	/* Allocate our own private page. */
 	pte_unmap(page_table);
 


