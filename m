Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab0HNSro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 14:47:44 -0400
Received: from kroah.org ([198.145.64.141]:34518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab0HNSrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 14:47:43 -0400
Date: Sat, 14 Aug 2010 11:47:25 -0700
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <gregkh@suse.de>, Grant Coady <gcoady.lk@gmail.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [0/3] 2.6.27.52 stable review
Message-ID: <20100814184724.GA10227@kroah.com>
References: <20100813214704.GA18960@kroah.com>
 <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com>
 <20100813230712.GA1703@suse.de>
 <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com>
 <20100814001158.GA2849@suse.de>
 <AANLkTin0Gb0q_jgJDROqBGsM4fa=LiAax-J0Q4FRyRGG@mail.gmail.com>
 <20100814025323.GA4779@suse.de>
 <20100814054335.GB21003@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100814054335.GB21003@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Aug 14, 2010 at 07:43:35AM +0200, Willy Tarreau wrote:
> On Fri, Aug 13, 2010 at 07:53:23PM -0700, Greg KH wrote:
> > On Fri, Aug 13, 2010 at 05:51:56PM -0700, Linus Torvalds wrote:
> > > On Fri, Aug 13, 2010 at 5:11 PM, Greg KH <gregkh@suse.de> wrote:
> > > >
> > > > That's a warning that current->mm is null.  I don't know enough about
> > > > the mm subsystem to say if this is normal or not, and I don't at first
> > > > glance, see how this patch could have caused this to happen.
> > > 
> > > We call that whole "expand_stack()" through handle_mm_fault(), and
> > > that's _not_ called just for the process itself. So "current->mm" is
> > > sometimes simply the wrong thing to use - like when you access the VM
> > > of another process (during fork for the argument setup of the new VM,
> > > or during ptrace etc).
> > > 
> > > Which is why I think commit 05fa199d45c should fix it. It makes the
> > > stack expansion thing use the right mm. Which it just _happened_ to do
> > > before, because it was always called just from the faulting code where
> > > current->mm happened to be the right mm.
> > > 
> > > But I really don't know if there might be other issues lurking too.
> > 
> > Ok, I'll go add that commit, and I unpacked my older machine that runs
> > the .27 kernel and will beat on it with that box tomorrow to see if
> > anything else pops up.
> 
> Greg, I confirm that 05fa199d45c fixes the warnings. I did not have them
> in .51, got them with .52-rc1 and got rid of it with the patch above.

Wonderful.  I've released a 2.6.27.52-rc2 with this fix in it.  I'm
building it and will test it on my box now.  The full patch is below if
anyone wants to try it out.

Odds are it will need whatever patch Linus is currently working on for
mainline, so I'll hold off on releasing a real release until that is all
worked out.

thanks,

greg k-h


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch-2.6.27.52-rc2"

diff --git a/Makefile b/Makefile
index 5382c55..096cde6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .51
+EXTRAVERSION = .52-rc2
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
 
diff --git a/mm/mmap.c b/mm/mmap.c
index f3e5bfe..08a32cf 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1573,7 +1573,7 @@ static int acct_stack_growth(struct vm_area_struct * vma, unsigned long size, un
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory(grow))
+	if (security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	/* Ok, everything looks good - let it rip */

--VbJkn9YxBvnuCH5J--
