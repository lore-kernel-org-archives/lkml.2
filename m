Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0EGAKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 20:10:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55510 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab0EGAKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 20:10:13 -0400
MIME-Version: 1.0
In-Reply-To: <20100506170420.GB30928@atomide.com>
References: <20100505202826.GB7450@linux.intel.com>
	 <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
	 <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
	 <20100505234755.GI29604@atomide.com>
	 <l2ra55d774e1005051656wbf4f3d7cr8cc9de0478e509f1@mail.gmail.com>
	 <20100506000552.GJ29604@atomide.com>
	 <g2yd6200be21005052116n5dd8708fk33eaf8944379bfc2@mail.gmail.com>
	 <20100506170420.GB30928@atomide.com>
Date: Thu, 6 May 2010 17:10:11 -0700
Message-ID: <i2od6200be21005061710mae9a437by90b22f61cbc2ae15@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/6 Tony Lindgren <tony@atomide.com>:
> * Arve Hjønnevåg <arve@android.com> [100505 21:11]:
>> On Wed, May 5, 2010 at 5:05 PM, Tony Lindgren <tony@atomide.com> wrote:
>> > * Brian Swetland <swetland@google.com> [100505 16:51]:
>> >> On Wed, May 5, 2010 at 4:47 PM, Tony Lindgren <tony@atomide.com> wrote:
>> >> > * Brian Swetland <swetland@google.com> [100505 14:34]:
>> >> >> On Wed, May 5, 2010 at 2:12 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> >> >> >>
>> >> >> >> Oh, like tell the modem that user mode has handled the ring event and
>> >> >> >> its ok to un-block?
>> >> >> >
>> >> >> > No, that's not how it works.  It would go like this:
>> >> >> >
>> >> >> >        The modem IRQ handler queues its event to the input subsystem.
>> >> >> >        As it does so the input subsystem enables a suspend blocker,
>> >> >> >        causing the system to stay awake after the IRQ is done.
>> >> >
>> >> > How about instead the modem driver fails to suspend until it's done?
>> >> >
>> >> > Each driver could have a suspend_policy sysfs entry with options such
>> >> > as [ forced | safe ]. The default would be forced. Forced would
>> >> > be the current behaviour, while safe would refuse suspend until the
>> >> > driver is done processing.
>> >> >
>> >> >> >        The user program enables its own suspend blocker before reading
>> >> >> >        the input queue.  When the queue is empty, the input subsystem
>> >> >> >        releases its suspend blocker.
>> >> >
>> >> > And also the input layer could refuse to suspend until it's done.
>> >> >
>> >> >> >        When the user program finishes processing the event, it
>> >> >> >        releases its suspend blocker.  Now the system can go back to
>> >> >> >        sleep.
>> >> >
>> >> > And here the user space just tries to suspend again when it's done?
>> >> > It's not like you're trying to suspend all the time, so it should be
>> >> > OK to retry a few times.
>> >>
>> >> We actually are trying to suspend all the time -- that's our basic
>> >> model -- suspend whenever we can when something doesn't prevent it.
>> >
>> > Maybe that state could be kept in some userspace suspend policy manager?
>> >
>> >> >> > At no point does the user program have to communicate anything to the
>> >> >> > modem driver, and at no point does it have to do anything out of the
>> >> >> > ordinary except to enable and disable a suspend blocker.
>> >> >>
>> >> >> Exactly -- and you can use the same style of overlapping suspend
>> >> >> blockers with other drivers than input, if the input interface is not
>> >> >> suitable for the particular interaction.
>> >> >
>> >> > Would the suspend blockers still be needed somewhere in the example
>> >> > above?
>> >>
>> >> How often would we retry suspending?
>> >
>> > Well based on some timer, the same way the screen blanks? Or five
>> > seconds of no audio play? So if the suspend fails, then reset whatever
>> > userspace suspend policy timers.
>> >
>> >> If we fail to suspend, don't we have to resume all the drivers that
>> >> suspended before the one that failed?  (Maybe I'm mistaken here)
>> >
>> > Sure, but I guess that should be a rare event that only happens when
>> > you try to suspend and something interrupts the suspend.
>> >
>>
>> This is not a rare event. For example, the matrix keypad driver blocks
>> suspend when a key is down so it can scan the matrix.
>
> Sure, but how many times per day are you suspending?
>

How many times we successfully suspend is irrelevant here. If the
driver blocks suspend the number of suspend attempts depend on your
poll frequency.

>> >> With the suspend block model we know the moment we're capable of
>> >> suspending and then can suspend at that moment.  Continually trying to
>> >> suspend seems like it'd be inefficient power-wise (we're going to be
>> >> doing a lot more work as we try to suspend over and over, or we're
>> >> going to retry after a timeout and spend extra time not suspended).
>> >>
>> >> We can often spend minutes (possibly many) at a time preventing
>> >> suspend when the system is doing work that would be interrupted by a
>> >> full suspend.
>> >
>> > Maybe you a userspace suspend policy manager would do the trick if
>> > it knows when the screen is blanked and no audio has been played for
>> > five seconds etc?
>> >
>>
>> If user space has to initiate every suspend attempt, then you are
>> forcing it to poll whenever a driver needs to block suspend.
>
> Hmm I don't follow you. If the userspace policy daemon timer times
> out, the device suspends. If the device does not suspend because of
> a blocking driver, then the timers get reset and you try again based
> on some event such as when the screen blanks.
>

This retry is what I call polling. You have to keep retrying until you
succeed. Also, using the screen blank timeout for this polling is not
a good idea. You do not want to toggle the screen off and on with with
every suspend attempt.

-- 
Arve Hjønnevåg
