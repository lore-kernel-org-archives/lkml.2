Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab1IAOBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:01:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57080 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab1IAOBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:01:52 -0400
Date: Thu, 1 Sep 2011 15:00:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linaro-toolchain@lists.linaro.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110901140000.GF29729@n2100.arm.linux.org.uk>
References: <20110823220056.GK3895@n2100.arm.linux.org.uk> <20110825130907.GO3286@htj.dyndns.org> <20110825145558.GF8883@n2100.arm.linux.org.uk> <201108261644.26329.arnd@arndb.de> <OF2C5ADB6A.65B1BE36-ONC12578FE.00493A67-C12578FE.004B3315@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF2C5ADB6A.65B1BE36-ONC12578FE.00493A67-C12578FE.004B3315@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 03:41:22PM +0200, Ulrich Weigand wrote:
> The problem now occurs if at point [0.] the target process just
> happened to be blocked in a restartable system call.  For this
> sequence to then work as expected, two things have to happen:
> 
> - at point [3.], the kernel must *not* attempt to restart a
>   system call, even though it thinks we're stopped in a
>   restartable system call
> 
> - at point [5.], the kernel now *must* restart the originally
>   interrupted system call, even though it thinks we're stopped
>   at some breakpoint, and not within a system call
> 
> My patch achieved both these goals, while it would seem your
> patch only solves the first issue, not the second one.  In
> fact, since any interaction with ptrace will always cause the
> TIF_SYS_RESTART flag to be *reset*, and there is no way at all
> to *set* it, there doesn't appear to be any way for GDB to
> achive that second goal.
...
> One way to fix this might be to make the TIF_SYS_RESTART flag
> itself visible to ptrace, so the GDB could save/restore it
> along with the rest of the register set; this would be similar
> to how that problem is handled on other platforms.  However,
> there doesn't appear to be an obvious place for the flag in
> the ptrace register set ...

Thanks for looking at this.

I don't think we can augment the ptrace register set - that would be a
major API change which would immediately break lots of userspace,
causing user stack overflows and such like.

I can't see a way out of this - and given the seriousness of the kernel
side issue (causing kernel warnings), and that your change altered the
strace behaviour (an unintended user-visible change) I think we're going
to have to live with the gdb testcase failing until we can come up with
a better fix for it.

I also wonder what the validity of this behaviour is - there are cases
where you can't do what gdb's trying to do - eg, with a syscall using
a restart block (-ERESTART_RESTARTBLOCK) because the restart information
could be wiped out by a new syscall performed by the function gdb wants
to run.  Or when the program receives a signal for it to handle while
running that function.
