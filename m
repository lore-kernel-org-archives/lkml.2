Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2D2AzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 20:55:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55025 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab2D2AzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 20:55:12 -0400
Date: Sun, 29 Apr 2012 01:55:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/tile: avoid calling do_signal() after fork from a
 kernel thread
Message-ID: <20120429005505.GX6871@ZenIV.linux.org.uk>
References: <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120427202002.8ED632C0BF@topped-with-meat.com>
 <20120427211244.GO6871@ZenIV.linux.org.uk>
 <20120427212729.652542C0AF@topped-with-meat.com>
 <20120427231526.GP6871@ZenIV.linux.org.uk>
 <20120427235023.GR6871@ZenIV.linux.org.uk>
 <201204281858.q3SIwC7H014319@farm-0027.internal.tilera.com>
 <20120428205517.GW6871@ZenIV.linux.org.uk>
 <4F9C6525.3050405@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9C6525.3050405@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 05:46:13PM -0400, Chris Metcalf wrote:

> It's OK, since we will jump to .Lresume_userspace from interrupt_return in
> the latter case:
> 
> STD_ENTRY(interrupt_return)
>         /* If we're resuming to kernel space, don't check thread flags. */
>         {
>          [...]
>          PTREGS_PTR(r29, PTREGS_OFFSET_EX1)
>         }
>         ld      r29, r29
>         andi    r29, r29, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
>         {
>          beqzt  r29, .Lresume_userspace
>          [...]
>         }
> 
> The struct ptregs "ex1" field will reliably tell us whether we came from
> kernel or userspace context.  Certainly for fork() this will indicate
> userspace, since it's the return register info for the syscall.   And for
> kernel_thread() we explicitly set up ex1 to indicate kernel privilege as well.
> 
> > For another,
> > there's kernel_execve() and if it fails (binary doesn't exist/has wrong
> > format/etc.) you'll get to .Lresume_userspace with EX1_PL(regs->ex1)
> > unchanged, i.e. the kernel one...
> 
> This is a good point.  The current syscall return path goes directly to
> .Lresume_userspace, which will screw up kernel syscalls.  I think the right
> answer is still to jump to interrupt_return from those cases, though.  In
> particular, this gets rid of the existing cruftiness where we have to
> document that a local label (.Lresume_userspace) can be the target of jumps
> from outside the containing function.

Point, but...  Are you sure you want to add extra work to a very hot path?
Leaving the "we don't have any pending work to do" unburdened by that check
would reduce the overhead a lot.
