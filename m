Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1HWPrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:47:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39929 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1HWPrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:47:04 -0400
Date: Tue, 23 Aug 2011 16:43:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110823154329.GF3895@n2100.arm.linux.org.uk>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823151936.GM9232@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 04:19:36PM +0100, Mark Brown wrote:
> The recent series of commits reworking the freezer appear to have
> caused serious issues on ARM.  The kernel constantly complains that
> try_to_freeze() is bring called with interrupts disabled:
> 
> [   75.380000] BUG: sleeping function called from invalid context at include/linux/freezer.h:44
> [   75.380000] in_atomic(): 0, irqs_disabled(): 128, pid: 1517, name: Xorg
> [   75.380000] no locks held by Xorg/1517.
> [   75.380000] [<c0014308>] (unwind_backtrace+0x0/0x12c) from
> [<c0464400>] (dump_stack+0x20/0x24)
> [   75.380000] [<c0464400>] (dump_stack+0x20/0x24) from [<c0022b80>]
> (__might_sleep+0xfc/0x11c)
> [   75.380000] [<c0022b80>] (__might_sleep+0xfc/0x11c) from [<c0011520>]
> (do_signal+0x94/0x230)
> [   75.380000] [<c0011520>] (do_signal+0x94/0x230) from [<c00116e4>]
> (do_notify_resume+0x28/0x6c)
> [   75.380000] [<c00116e4>] (do_notify_resume+0x28/0x6c) from
> [<c000eaf8>] (work_pending+0x24/0x28)
> 
> and the boot runs very slowly.  Reverting the series merged in 56f0be
> appears to resolve the issue, though looking at the changes I'd expect
> there's some underlying bug here that just doesn't trigger very often.
> I don't really have the bandwidth to understand what's gone wrong right
> now but should be able to run tests if you've got anything you'd like
> looking atl.

The signal handling is rather yucky, and it seems it needs to run with
IRQs enabled - but we run it with IRQs disabled.

There's horrible issues in there.  One such issue is the syscall restart
handling.  Here's an example:

	sys_ppoll
	...
	receives signal
	returns ERESTARTNOHAND (restart syscall if no handler)

On the exit path, we notice that we have TIF_SIGPENDING set.  So we call
do_notify_resume() and eventually do_signal().  At this point, 'syscall'
is set.

The first thing do_signal() does is fiddle with the stack to fake a
restart.  If we don't gain a signal here, everything is fine and we
return.  So far so good.

Lets say for the sake of argument that we've run do_signal() with IRQs
enabled.  Now, a scheduling event has come along and set TIF_NEED_RESCHED.

So, having returned from do_notify_resume(), we disable interrupts, reload
the work mask, and notice that TIF_NEED_RESCHED is set.  We now switch
away from this thread and do something else.

While something else is running, lets say a SIGHUP is sent to our process,
and there's a handler installed.

When we switch back, we again disable interrupts, reload the work mask,
and notice this time that TIF_SIGPENDING is again set.  So, just like
last time, we call do_notify_resume() and eventually do_signal().  This
time, syscall is false.

So we obtain the signal, save the current state, and set userspace up to
call the handler.

The state which we've saved though is the state required for the syscall
restart - but that's wrong, because the return code said 'restart if
no handler' and we're now invoking a handler.

What should happen is that the syscall is not restarted, and -EINTR is
returned instead.

What has this got to do with the issue you raise?  Having interrupts
off during signal handling helps to avoid this problem by ensuring that
we can't get resched events if there's a signal with no handler present.
Enabling interrupts for do_signal opens that race up.

Now, having interrupts disabled for writing to the processes stack is
technically bad news (although in the last 18 or so years its never
caused a problem.)  That said, we really should enable interrupts
before calling handle_signal() - which should be safe from the above
race.

But... without serious amounts of rework of the signal handling code
to avoid the above race I don't see how we can allow try_to_freeze()
to run with IRQs enabled and still have race-free syscall restarting.
