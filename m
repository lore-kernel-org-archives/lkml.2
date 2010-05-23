Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0EWTsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 15:48:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57611 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab0EWTsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 15:48:07 -0400
Date: Sun, 23 May 2010 20:47:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] ARM: fix 'unannotated irqs-on' lockdep warning
Message-ID: <20100523194746.GE950@n2100.arm.linux.org.uk>
References: <1274615328-27953-1-git-send-email-tom.leiming@gmail.com> <20100523123801.GC950@n2100.arm.linux.org.uk> <AANLkTikRp0EHxshKYq39p18ymoRNAtyHrNm3yq6A49-r@mail.gmail.com> <20100523141300.GD950@n2100.arm.linux.org.uk> <AANLkTinV9Na9zxYMIfTr893Ynnc0YOk2B6uPKEa9s4R1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinV9Na9zxYMIfTr893Ynnc0YOk2B6uPKEa9s4R1@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 11:07:50PM +0800, Ming Lei wrote:
> 2010/5/23 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> > On Sun, May 23, 2010 at 09:44:20PM +0800, Ming Lei wrote:
> >> 2010/5/23 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> >> >>  ENTRY(ret_to_user)
> >> >>  ret_slow_syscall:
> >> >> -     disable_irq                             @ disable interrupts
> >> >> +     disable_irq_notrace                             @ disable interrupts
> >> >
> >> > I think this one does need to be traced - the pending work functions are
> >> > all C code which could call back into lockdep.
> >>
> >> If there are pending works, schedule will be called to give cpu to it,
> >> I wonder why the work function to be scheduled will be run with irq
> >> disabled. Seems we should enable irq again before calling schedule,
> >> not sure.
> >
> > No.  I'm talking about things like do_notify_resume().
> >
> > I think the above should be left as-is, so that as far as lockdep is
> > concerned, IRQs are off while userspace runs.  What happens between
> > returning to userspace and re-entering the kernel has no bearing what
> > so ever on lockdep.
> >
> 
> Oh, trace_ret_hardirqs_on has to be added before returning to user-space to
> remove the warning, like x86 and mips. If you agree, I'd like to post
> a new version patch.

Let me explain again.  We have this series of actions:

- in userspace
- exception happens
- cpu disables interrupts itself
- save state
- enable interrupts, and tell lockdep that IRQs are unmasked
- we process the exception, and ultimately call ret_fast_syscall or
  ret_slow_syscall

Now, what was happening in existing kernels is:

POINT A.
- disable interrupts, and tell lockdep that IRQs are masked
- check for any work pending
  - if work pending, call function - with IRQs still masked
  - go back to point A.
- restore state
- resume userspace, which implicitly re-enables IRQs

This results in a balanced and afaics correct setup.  Lockdep doesn't
care about the state of userspace - it only cares about state (and its
code only ever runs) when we're in kernel mode.

With your change above, what's happening is the above is replaced by:

POINT A.
- disable interrupts, but don't tell lockdep that IRQs are masked
- check for any work pending
  - if work pending, call function - with IRQs still masked
	*but* lockdep believes IRQs are enabled.  Therefore, I believe
	false warnings are probable from things like the scheduler,
	signal handling paths, etc.
  - go back to point A.
- restore state
- resume userspace, which implicitly re-enables IRQs

So can you now see why I believe the above change I've quoted is wrong?

Moreover, I put to you that it's utterly pointless - and a waste of CPU
time - telling lockdep about the IRQ masking when an exception occurs,
and it's also pointless telling lockdep about the IRQ unmasking when we
resume userspace.
