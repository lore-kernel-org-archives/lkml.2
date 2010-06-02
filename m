Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0FBBKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 21:10:45 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:42240 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab0FBBKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 21:10:44 -0400
MIME-Version: 1.0
In-Reply-To: <1275431816.21962.1108.camel@mulgrave.site>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100601135102.GA8098@srcf.ucam.org>
	<1275426085.21962.967.camel@mulgrave.site>
	<201006020024.14220.rjw@sisk.pl>
	<1275431816.21962.1108.camel@mulgrave.site>
Date: Tue, 1 Jun 2010 18:10:42 -0700
Message-ID: <AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>, mark.gross@intel.com,
       Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 3:36 PM, James Bottomley <James.Bottomley@suse.de> wrote:
> On Wed, 2010-06-02 at 00:24 +0200, Rafael J. Wysocki wrote:
>> On Tuesday 01 June 2010, James Bottomley wrote:
>> > On Tue, 2010-06-01 at 14:51 +0100, Matthew Garrett wrote:
>> > > On Mon, May 31, 2010 at 04:21:09PM -0500, James Bottomley wrote:
>> > >
>> > > > You're the one mentioning x86, not me.  I already explained that some
>> > > > MSM hardware (the G1 for example) has lower power consumption in S3
>> > > > (which I'm using as an ACPI shorthand for suspend to ram) than any
>> > > > suspend from idle C state.  The fact that current x86 hardware has the
>> > > > same problem may be true, but it's not entirely relevant.
>> > >
>> > > As long as you can set a wakeup timer, an S state is just a C state with
>> > > side effects. The significant one is that entering an S state stops the
>> > > process scheduler and any in-kernel timers. I don't think Google care at
>> > > all about whether suspend is entered through an explicit transition or
>> > > something hooked into cpuidle - the relevant issue is that they want to
>> > > be able to express a set of constraints that lets them control whether
>> > > or not the scheduler keeps on scheduling, and which doesn't let them
>> > > lose wakeup events in the process.
>> >
>> > Exactly, so my understanding of where we currently are is:
>>
>> Thanks for the recap.
>>
>> >      1. pm_qos will be updated to be able to express the android suspend
>> >         blockers as interactivity constraints (exact name TBD, but
>> >         probably /dev/cpu_interactivity)
>>
>> I think that's not been decided yet precisely enough.  I saw a few ideas
>> here and there in the thread, but which of them are we going to follow?
>
> Well, android only needs two states (block and don't block), so that
> gets translated as 2 s32 values (say 0 and INT_MAX).  I've seen defines
> like QOS_INTERACTIVE and QOS_NONE (or QOS_DRECKLY or QOS_MANANA) to
> describe these, but if all we're arguing over is the define name, that's
> progress.

I think we need separate state constraints for suspend and idle low
power modes. On the msm platform only a subset of the interrupts can
wake up from the low power mode, so we block the use if the low power
mode from idle while other interrupts are enabled. We do not block
suspend however if those interrupts are not marked as wakeup
interrupts. Most constraints that prevent suspend are not hardware
specific and should not prevent entering low power modes from idle. In
other words we may need to prevent low power idle modes while allowing
suspend, and we may need to prevent suspend while allowing low power
idle modes.

It would also be good to not have an implementation that gets slower
and slower the more clients you have. With binary constraints this is
trivial.

>
> The other piece they need is the suspend block name, which comes with
> the stats API, and finally we need to decide what the actual constraint
> is called (which is how the dev node gets its name) ...
>
>> >      2. pm_qos will be updated to be callable from atomic context
>> >      3. pm_qos will be updated to export statistics initially closely
>> >         matching what suspend blockers provides (simple update of the rw
>> >         interface?)

4. It would be useful to change pm_qos_add_request to not allocate
anything so can add constraints from init functions that currently
cannot fail.

>> >
>> > After this is done, the current android suspend block patch becomes a
>> > re-expression in kernel space in terms of pm_qos, with the current
>> > userspace wakelocks being adapted by the android framework into pm_qos
>> > requirements expressed to /dev/cpu_interactivity (or whatever name is
>> > chosen).  Then opportunistic suspend is either a small add-on kernel
>> > patch they have in their tree to suspend when the interactivity
>> > constraint goes to NONE, or it could be done entirely by a userspace
>> > process.  Long term this could migrate to the freezer and suspend from
>> > idle approach as the various problem timers get fixed.
>> >
>> > I think the big unresolved issue is the stats extension.  For android,
>> > we need just a name written along with the value, so we have something
>> > to hang the stats off ... current pm_qos userspace users just write a
>> > value, so the name would be optional.  From the kernel, we probably just
>> > need an additional API that takes a stats name or NULL if none
>> > (pm_qos_add_request_named()?).  Then reading the stats could be done by
>> > implementing a fops read routine on the misc device.
>>
>> Is the original idea of having that information in debugfs objectionable?
>
> Well ... debugfs is usually used to get around the sysfs rules.  In this
> case, pm_qos has a dev interface ... I don't specifically object to
> using debugfs, but I don't see any reason to forbid it from being a
> simple dev read interface either.
>

We don't currently have a dev interface for stats so this is not an
immediate requirement. The suspend blocker debugfs interface is just
as good as the proc interface we have for wakelocks.

-- 
Arve Hjønnevåg
