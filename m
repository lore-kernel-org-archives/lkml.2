Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab1GSWRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:17:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52114 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1GSWRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:17:04 -0400
MIME-Version: 1.0
In-Reply-To: <4E1DD5DF.2040408@candelatech.com>
References: <4E1DD5DF.2040408@candelatech.com>
Date: Tue, 19 Jul 2011 15:17:03 -0700
X-Google-Sender-Auth: MExAPxmmWZkEMgVjyx83cZyVFgI
Message-ID: <CANcMJZBHMKXbDqgvKnZ-iiCbFm0a_5zyP179ReXF+cmRyM=O7w@mail.gmail.com>
Subject: Re: BUG spinlock lockup, rtc related, 3.0-rc7+
From: john stultz <johnstul@us.ibm.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 10:29 AM, Ben Greear <greearb@candelatech.com> wrote:
> This is on the same nfs testing machine I've been posting about.  This
> has some additional nfs patches included, running tests to mount, do io,
> unmount
> over and over again.  Seems that the NFS bugs might be finally fixed, but
> system is still un-stable in general when under load.
>
> This info was printed after several other warnings that I previously posted
> to lkml.
>
> This one appears to lock up the machine pretty badly though...can't ssh into
> it anymore, and similar messages keep spewing every few minutes.
>
> I *think* the BUG at the end of this email is the important part, but
> maybe it's just a symptom of something else...

Huh. So does this trigger frequently, or was this just a one time
thing? I suspect the latter.

>From the looks of it, there's the btserver process (on cpu4) which
during exit is caught up spinning trying to get the hrtimer base lock
from hrtimer_cancel() in rtc_irq_set_state() when cleaning up from
rtc_device_release().

Meanwhile, On cpu0, a rtc periodic timer has fired and we're stuck in
rtc_handle_legacy_irq(), likely waiting for the irq_task_lock held by
cpu4 in rtc_irq_set_state().

The rest of the cpus are idle, with the exception of the one that
detected the stall from the normal timer tick.

Hrmm.. It sounds like a circular lock between the rtc->irq_task_lock
and the hrtimer base lock.

rtc_irq_set_state: Grab irq_task_lock -> call hrtimer_cancel -> grab
hrtimer_base_lock

IRQ:  grab hrtimer_base_lock -> run timers -> rtc_handle_legacy_irq ->
grab irq_task_lock

But looking at __run_hrtimer(), the base lock should be released
before the timer is run.

So I'm not really sure what would be gumming up things here.

Thomas: Any thoughts? There shouldn't be an issue calling
hrtimer_cancel or other hrtimer operations from an  hrtimer handler
right?

thanks
-john
