Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0HMXNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:13:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:50600 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab0HMXNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:13:48 -0400
Date: Fri, 13 Aug 2010 16:07:12 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [0/3] 2.6.27.52 stable review
Message-ID: <20100813230712.GA1703@suse.de>
References: <20100813214704.GA18960@kroah.com>
 <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 14, 2010 at 08:36:34AM +1000, Grant Coady wrote:
> On Fri, 13 Aug 2010 14:47:04 -0700, you wrote:
> 
> >NOTE!
> >
> >If I could get some people to please test this -rc release?  It contains
> >a few core changes that I couldn't validate myself as I don't seem to
> >have a machine that will even boot the .27 kernel anymore after my move.
> 
> I surely will, just as soon as the thing appears ;)  Ftp and http 
> return nothing just now.

Odd, it should be there.

Here it is, attached below.  It's small enough to send out this way.

thanks,

greg k-h

--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch-2.6.27.52-rc1"

diff --git a/Makefile b/Makefile
index 5382c55..c7fde5f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .51
+EXTRAVERSION = .52-rc1
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3384255..9d3c576 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -589,6 +589,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	unsigned long address;
 	int write, si_code;
 	int fault;
+	int should_exit_no_context = 0;
 #ifdef CONFIG_X86_64
 	unsigned long flags;
 #endif
@@ -876,6 +877,9 @@ no_context:
 	oops_end(flags, regs, SIGKILL);
 #endif
 
+	if (should_exit_no_context)
+		return;
+
 /*
  * We ran out of memory, or some other thing happened to us that made
  * us unable to handle the page fault gracefully.
@@ -901,8 +905,11 @@ do_sigbus:
 	up_read(&mm->mmap_sem);
 
 	/* Kernel mode? Handle exceptions or die */
-	if (!(error_code & PF_USER))
+	if (!(error_code & PF_USER)) {
+		should_exit_no_context = 1;
 		goto no_context;
+	}
+
 #ifdef CONFIG_X86_32
 	/* User space => ok to do another page fault */
 	if (is_prefetch(regs, address, error_code))
diff --git a/mm/memory.c b/mm/memory.c
index 1300b70..7e308fc 100644
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
@@ -2408,6 +2428,11 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pte_t entry;
 
+	if (check_stack_guard_page(vma, address) < 0) {
+		pte_unmap(page_table);
+		return VM_FAULT_SIGBUS;
+	}
+
 	/* Allocate our own private page. */
 	pte_unmap(page_table);
 

--bg08WKrSYDhXBjb5--
