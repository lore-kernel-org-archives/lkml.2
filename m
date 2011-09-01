Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab1IANlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 09:41:49 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:49160 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab1IANlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 09:41:47 -0400
In-Reply-To: <201108261644.26329.arnd@arndb.de>
References: <20110823220056.GK3895@n2100.arm.linux.org.uk> <20110825130907.GO3286@htj.dyndns.org> <20110825145558.GF8883@n2100.arm.linux.org.uk> <201108261644.26329.arnd@arndb.de>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
X-KeepSent: 2C5ADB6A:65B1BE36-C12578FE:00493A67;
 type=4; name=$KeepSent
To: Arnd Bergmann <arnd@arndb.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linaro-toolchain@lists.linaro.org
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OF2C5ADB6A.65B1BE36-ONC12578FE.00493A67-C12578FE.004B3315@de.ibm.com>
From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Date: Thu, 1 Sep 2011 15:41:22 +0200
X-MIMETrack: Serialize by Router on D12ML069/12/M/IBM(Release 8.0.2FP2|June 22, 2009) at
 01/09/2011 15:41:37
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote on 08/26/2011 04:44:26 PM:
> On Thursday 25 August 2011, Russell King - ARM Linux wrote:
> >
> > Arnd, can you test this to make sure your gdb test case still works,
and
> > Mark, can you test this to make sure it fixes your problem please?
>
> Hi Russell,
>
> The patch in question was not actually from me but from Ulrich Weigand,
> so he's probably the right person to test your patch.
> I'm forwarding it in full to Uli for reference.

Hi Arnd, hi Russell,

sorry for the late reply, I've just returned from vacation today ...

I've not yet run the test, but just from reading through the patch
it seems that this will at least partially re-introduce the problem
my original patch was trying to fix.

The situation here is about GDB performing an "inferior function
call", e.g. via the GDB "call" command.  To do so, GDB will:

0. [ Have gotten control of the target process via some ptrace
   intercept previously, and then ... ]
1. Save the register state
2. Create a dummy frame on the stack and set up registers (PC, SP,
   argument registers, ...) as appropriate for a function call
3. Restart via PTRACE_CONTINUE
   [ ... at this point, the target process runs the function until
     it returns to a breakpoint instruction and GDB gets control
     again via another ptrace intercept ... ]
4. Restore the register state saved in [1.]
5. At some later point, continue the target process [at its
   original location] with PTRACE_CONTINUE

The problem now occurs if at point [0.] the target process just
happened to be blocked in a restartable system call.  For this
sequence to then work as expected, two things have to happen:

- at point [3.], the kernel must *not* attempt to restart a
  system call, even though it thinks we're stopped in a
  restartable system call

- at point [5.], the kernel now *must* restart the originally
  interrupted system call, even though it thinks we're stopped
  at some breakpoint, and not within a system call

My patch achieved both these goals, while it would seem your
patch only solves the first issue, not the second one.  In
fact, since any interaction with ptrace will always cause the
TIF_SYS_RESTART flag to be *reset*, and there is no way at all
to *set* it, there doesn't appear to be any way for GDB to
achive that second goal.

[ With my patch, that second goal was implicitly achieved by
the fact that at [1.] GDB would save a register state that
already corresponds to the way things should be for restarting
the system call.  When that register set is then restored in [4.],
restart just happens automatically without any further kernel
intervention. ]

One way to fix this might be to make the TIF_SYS_RESTART flag
itself visible to ptrace, so the GDB could save/restore it
along with the rest of the register set; this would be similar
to how that problem is handled on other platforms.  However,
there doesn't appear to be an obvious place for the flag in
the ptrace register set ...


Bye,
Ulrich

