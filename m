Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2JNTGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:06:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43649 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2JNTGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:06:49 -0400
Date: Sun, 14 Oct 2012 20:06:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Daniel Mack <zonque@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [revert request for commit 9fff2fa] Re: [git pull] signals pile 3
Message-ID: <20121014190646.GY2616@ZenIV.linux.org.uk>
References: <20121013005334.GM2616@ZenIV.linux.org.uk>
 <507ADBBB.9090209@gmail.com>
 <20121014164020.GV2616@ZenIV.linux.org.uk>
 <CACTFLAOpcLtHNx-TCHQkUOPNAkTO8EgDhbyZSGQ9ag+Wu_cNRw@mail.gmail.com>
 <20121014172640.GW2616@ZenIV.linux.org.uk>
 <20121014175541.GX2616@ZenIV.linux.org.uk>
 <507B02C1.1090101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507B02C1.1090101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 08:21:53PM +0200, Daniel Mack wrote:
> On 14.10.2012 19:55, Al Viro wrote:
> > On Sun, Oct 14, 2012 at 06:26:40PM +0100, Al Viro wrote:
> >> On Sun, Oct 14, 2012 at 06:44:12PM +0200, Daniel Mack wrote:
> >>> On Oct 14, 2012 6:40 PM, "Al Viro" <viro@zeniv.linux.org.uk> wrote:
> >>>>
> >>>> On Sun, Oct 14, 2012 at 05:35:23PM +0200, Daniel Mack wrote:
> >>>>
> >>>>> I rebased my ARM development branch and figured that your patch 9fff2fa
> >>>>> ("arm: switch to saner kernel_execve() semantics") breaks the boot on my
> >>>>> board right after init is invoked via NFS:
> >>>>
> >>>> OK, revert it is, then.  Nothing in the tree has dependencies on that
> >>> sucker
> >>>> and while it survives testing here, it's obviously not ready for mainline.
> >>>> So, with abject apologies to everyone involved, please revert.
> >>>
> >>> Reverting it is not straight forward, and half of this patch doesn't seem
> >>> to cause issues.
> >>>
> >>> I can resend my patch with an S-o-b if you want me to.
> >>
> >> Um...  That's _really_ interesting.  First of all, revert is absolutely
> >> straightforward; the only change in Kconfig is "remove the damn select"
> >> and it's not hard to resolve.  But I actually wonder what the hell is
> >> going on with that breakage - the *only* thing your revert changes is
> >> that instead of letting the kernel_thread callback return all the way
> >> to returning 0 to ret_from_kernel_thread() on do_execve() success you
> >> have it do ret_from_kernel_execve() instead.  Hmm...
> >>
> >> Could you try to print current_pt_regs()->ARM_r0 in kernel_execve() before
> >> calling ret_from_kernel_execve() with your patch applied?  If that somehow
> >> got non-zero, we'd see trouble, all right, but I don't see any places where
> >> it could.
> >>
> >> Wait a minute...  I think I see what might be going on, but I don't
> >> understand it at all.  Look: arm start_thread() is
> >> #define start_thread(regs,pc,sp)                                        \
> >> ({                                                                      \
> >>         unsigned long *stack = (unsigned long *)sp;                     \
> >>         memset(regs->uregs, 0, sizeof(regs->uregs));                    \
> >>         if (current->personality & ADDR_LIMIT_32BIT)                    \
> >>                 regs->ARM_cpsr = USR_MODE;                              \
> >>         else                                                            \
> >>                 regs->ARM_cpsr = USR26_MODE;                            \
> >>         if (elf_hwcap & HWCAP_THUMB && pc & 1)                          \
> >>                 regs->ARM_cpsr |= PSR_T_BIT;                            \
> >>         regs->ARM_cpsr |= PSR_ENDSTATE;                                 \
> >>         regs->ARM_pc = pc & ~1;         /* pc */                        \
> >>         regs->ARM_sp = sp;              /* sp */                        \
> >>         regs->ARM_r2 = stack[2];        /* r2 (envp) */                 \
> >>         regs->ARM_r1 = stack[1];        /* r1 (argv) */                 \
> >>         regs->ARM_r0 = stack[0];        /* r0 (argc) */                 \
> >>         nommu_start_thread(regs);                                       \
> >> })
> >> and the last 3 make no sense whatsoever.  Note that on normal execve() we'll
> >> be going through the syscall return, so the userland will see 0 in there,
> >> no matter what do we do here.  Theoretically, it might've been done for
> >> ptrace sake (it will be able to observe the values in those registers before
> >> the tracee reaches userland), but there's another oddity involved - "stack"
> >> is a userland pointer here.  Granted, it's been recently written to, so
> >> we are not likely to hit a pagefault here, but...  What happens if we are
> >> under enough memory pressure to swap those pages out?  PF in the kernel
> >> mode with no exception table entries for those insns?
> > 
> > FWIW, if you don't mind an experiment, try to take mainline (with that
> > commit not reverted) and add
> > 	strne	r0, [sp, #S_R0]
> > right before
> > 	get_thread_info tsk
> > in ret_from_fork().  And see if that changes behaviour.
> > 
> 
> I don't mind experiments at all :)
> 
> However, with that extra line in place as described, I'm still getting
> the Oops below. If you want me to test anything else, please let me know.
> 
> 
> [    4.683182] VFS: Mounted root (nfs filesystem) on device 0:12.
> [    4.742007] devtmpfs: mounted
> [    4.745746] Freeing init memory: 172K
> [    5.038724] Internal error: Oops - undefined instruction: 0 [#1] SMP
> THUMB2
> [    5.046044] Modules linked in:
> [    5.049263] CPU: 0    Not tainted  (3.6.0-11053-g56c8535-dirty #136)
> [    5.055925] PC is at cpsw_probe+0x422/0x9ac
> [    5.060314] LR is at trace_hardirqs_on_caller+0x8f/0xfc
> [    5.065790] pc : [<c03493de>]    lr : [<c005e81f>]    psr: 60000113
> [    5.065790] sp : cf055fb0  ip : 00000000  fp : 00000000
> [    5.077800] r10: 00000000  r9 : 00000000  r8 : 00000000
> [    5.083270] r7 : 00000000  r6 : 00000000  r5 : c034458d  r4 : 00000000
> [    5.090101] r3 : cf057a40  r2 : 00000000  r1 : 00000001  r0 : 00000000
> [    5.096936] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
> Segment user
> [    5.104406] Control: 50c5387d  Table: 8f434019  DAC: 00000015
> [    5.110422] Process init (pid: 1, stack limit = 0xcf054240)
> [    5.116257] Stack: (0xcf055fb0 to 0xcf056000)
> [    5.120824] 5fa0:                                     00000001
> 00000000 00000000 00000000
> [    5.129390] 5fc0: cf055fb0 c000d1a8 00000000 00000000 00000000
> 00000000 00000000 00000000
> [    5.137957] 5fe0: 00000000 becedf10 00000000 b6f81dd0 00000010
> 00000000 aaaabfaf a8babbaa
> [    5.146529] Code: 2206a010 718ef508 0184f8da f8b1f65d (3070f8d8)
> [    5.152915] ---[ end trace 7362bbe8e73e6b07 ]---
> [    5.158324] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x0000000b
> [    5.158324]

Very interesting...  So we have kernel_thread() payload called and we have
it reach kernel_execve() (otherwise your reverting kernel_execve() change
would've had no effect).  Said payload returns, and sp value seems to be
sane.  Buggered return address, perhaps?  But that would be killing the
damn thing everywhere...

Just in case - print __builtin_return_address(0) in the beginning of
kernel_init(); it ought to point at the end of ret_from_fork...

And kill that strne along with assignment to ->ARM_r0 in start_thread().
I've missed the obvious problem with strne - flag values won't survive the
call of payload ;-/  IOW, it's still possible that we are getting bitten
by strange value left in there.  Removing the assignment in start_thread()
would check that possiblity...
