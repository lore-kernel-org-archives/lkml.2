Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1IBOvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:51:14 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:38872 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1IBOvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:51:13 -0400
In-Reply-To: <20110901140000.GF29729@n2100.arm.linux.org.uk>
References: <20110823220056.GK3895@n2100.arm.linux.org.uk> <20110825130907.GO3286@htj.dyndns.org> <20110825145558.GF8883@n2100.arm.linux.org.uk> <201108261644.26329.arnd@arndb.de> <OF2C5ADB6A.65B1BE36-ONC12578FE.00493A67-C12578FE.004B3315@de.ibm.com> <20110901140000.GF29729@n2100.arm.linux.org.uk>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
X-KeepSent: 69A57AB0:CF22689A-C12578FF:004EDD71;
 type=4; name=$KeepSent
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linaro-toolchain@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Martin Schwidefsky <martin.schwidefsky@de.ibm.com>
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OF69A57AB0.CF22689A-ONC12578FF.004EDD71-C12578FF.005142FF@de.ibm.com>
From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Date: Fri, 2 Sep 2011 16:47:35 +0200
X-MIMETrack: Serialize by Router on D12ML069/12/M/IBM(Release 8.0.2FP2|June 22, 2009) at
 02/09/2011 16:51:00
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> wrote on 09/01/2011
04:00:00 PM:
> On Thu, Sep 01, 2011 at 03:41:22PM +0200, Ulrich Weigand wrote:
> > One way to fix this might be to make the TIF_SYS_RESTART flag
> > itself visible to ptrace, so the GDB could save/restore it
> > along with the rest of the register set; this would be similar
> > to how that problem is handled on other platforms.  However,
> > there doesn't appear to be an obvious place for the flag in
> > the ptrace register set ...
>
> Thanks for looking at this.
>
> I don't think we can augment the ptrace register set - that would be a
> major API change which would immediately break lots of userspace,
> causing user stack overflows and such like.

Well, it wouldn't need to go into the default register set (REGSET_GPR),
but could be in a new register set.  This shouldn't change anything for
existing applications, but GDB could probe for support for the new
regset and use it if present.

> I can't see a way out of this - and given the seriousness of the kernel
> side issue (causing kernel warnings), and that your change altered the
> strace behaviour (an unintended user-visible change) I think we're going
> to have to live with the gdb testcase failing until we can come up with
> a better fix for it.

The change you suggest, with the addition of making the flag available
to the debugger in a new register set, should be fine for GDB.

I agree that the race you pointed out in the initial mail to this thread
needs to be fixed; an in fact, it seems that this race is also present
on s390 ...  In discussions with Martin, we were wondering however
whether the fix you suggest does actually fully plug the race:

Assume the scenario you initally describe, where a first signal is
ignored and leads to system call restart.  With your latest patch,
you call into syscall_restart which sets everything up to restart
the call (with interrupts disabled).  Then, you go back to user space,
with PC pointing to the SVC that is to be restarted.  Now assume that
some interrupt is pending at this point.  At the switch to user
space, interrupts will be enabled.  Can it now happen that this
pending interrupt is recognized *before* the SVC is executed?
(Maybe the hardware doesn't allow that on ARM ... it definitely
*is* possible on s390, though.)

If so, can this not then lead to the exact same race you initially
described (the interrupt causing some other task to be scheduled,
and then an second signal to be delivered to the task about to
restart the SVC)?

I guess one way to fix this would be to not actually go back to
user space for system call restart at all, but instead just short-
cut this in entry.S and simply go right back to the system call
entry path.  As a side benefit, this could eliminate the need to
create a stack frame for the OABI RESTARTBLOCK case ...  (This is
what we do on s390 b.t.w., where there is a similar issue with the
system call number being an immediate argument to the SVC
instruction.)

> I also wonder what the validity of this behaviour is - there are cases
> where you can't do what gdb's trying to do - eg, with a syscall using
> a restart block (-ERESTART_RESTARTBLOCK) because the restart information
> could be wiped out by a new syscall performed by the function gdb wants
> to run.  Or when the program receives a signal for it to handle while
> running that function.

Yes, performing an inferior call during a system call that restarts
using RESTARTBLOCK is broken.  This is a problem on all architectures,
and has been ever since the RESTARTBLOCK mechanism was introduced ...

To really fix this case would probably require some way for the
debugger to save and restore the restore_block saved state.  This
is not quite trivial, since it would expose that state to user space,
effectively creating a new ABI (and probably requiring sanity checks
to ensure a valid state is restored).  This probably cannot be fixed
by one architecture for itself, but would need support from common
kernel code.

Bye,
Ulrich

