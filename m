Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2JNR0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 13:26:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43460 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2JNR0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 13:26:46 -0400
Date: Sun, 14 Oct 2012 18:26:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Daniel Mack <zonque@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [revert request for commit 9fff2fa] Re: [git pull] signals pile 3
Message-ID: <20121014172640.GW2616@ZenIV.linux.org.uk>
References: <20121013005334.GM2616@ZenIV.linux.org.uk>
 <507ADBBB.9090209@gmail.com>
 <20121014164020.GV2616@ZenIV.linux.org.uk>
 <CACTFLAOpcLtHNx-TCHQkUOPNAkTO8EgDhbyZSGQ9ag+Wu_cNRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACTFLAOpcLtHNx-TCHQkUOPNAkTO8EgDhbyZSGQ9ag+Wu_cNRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 06:44:12PM +0200, Daniel Mack wrote:
> On Oct 14, 2012 6:40 PM, "Al Viro" <viro@zeniv.linux.org.uk> wrote:
> >
> > On Sun, Oct 14, 2012 at 05:35:23PM +0200, Daniel Mack wrote:
> >
> > > I rebased my ARM development branch and figured that your patch 9fff2fa
> > > ("arm: switch to saner kernel_execve() semantics") breaks the boot on my
> > > board right after init is invoked via NFS:
> >
> > OK, revert it is, then.  Nothing in the tree has dependencies on that
> sucker
> > and while it survives testing here, it's obviously not ready for mainline.
> > So, with abject apologies to everyone involved, please revert.
> 
> Reverting it is not straight forward, and half of this patch doesn't seem
> to cause issues.
> 
> I can resend my patch with an S-o-b if you want me to.

Um...  That's _really_ interesting.  First of all, revert is absolutely
straightforward; the only change in Kconfig is "remove the damn select"
and it's not hard to resolve.  But I actually wonder what the hell is
going on with that breakage - the *only* thing your revert changes is
that instead of letting the kernel_thread callback return all the way
to returning 0 to ret_from_kernel_thread() on do_execve() success you
have it do ret_from_kernel_execve() instead.  Hmm...

Could you try to print current_pt_regs()->ARM_r0 in kernel_execve() before
calling ret_from_kernel_execve() with your patch applied?  If that somehow
got non-zero, we'd see trouble, all right, but I don't see any places where
it could.

Wait a minute...  I think I see what might be going on, but I don't
understand it at all.  Look: arm start_thread() is
#define start_thread(regs,pc,sp)                                        \
({                                                                      \
        unsigned long *stack = (unsigned long *)sp;                     \
        memset(regs->uregs, 0, sizeof(regs->uregs));                    \
        if (current->personality & ADDR_LIMIT_32BIT)                    \
                regs->ARM_cpsr = USR_MODE;                              \
        else                                                            \
                regs->ARM_cpsr = USR26_MODE;                            \
        if (elf_hwcap & HWCAP_THUMB && pc & 1)                          \
                regs->ARM_cpsr |= PSR_T_BIT;                            \
        regs->ARM_cpsr |= PSR_ENDSTATE;                                 \
        regs->ARM_pc = pc & ~1;         /* pc */                        \
        regs->ARM_sp = sp;              /* sp */                        \
        regs->ARM_r2 = stack[2];        /* r2 (envp) */                 \
        regs->ARM_r1 = stack[1];        /* r1 (argv) */                 \
        regs->ARM_r0 = stack[0];        /* r0 (argc) */                 \
        nommu_start_thread(regs);                                       \
})
and the last 3 make no sense whatsoever.  Note that on normal execve() we'll
be going through the syscall return, so the userland will see 0 in there,
no matter what do we do here.  Theoretically, it might've been done for
ptrace sake (it will be able to observe the values in those registers before
the tracee reaches userland), but there's another oddity involved - "stack"
is a userland pointer here.  Granted, it's been recently written to, so
we are not likely to hit a pagefault here, but...  What happens if we are
under enough memory pressure to swap those pages out?  PF in the kernel
mode with no exception table entries for those insns?
