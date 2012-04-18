Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2DROSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:18:44 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:44505 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064Ab2DROSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:18:42 -0400
Message-ID: <4F8ECD39.3080900@ti.com>
Date: Wed, 18 Apr 2012 19:48:33 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        svenjoac@gmx.de, tglx@linutronix.de, rjw@sisk.pl
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Fix oneshot broadcast setup really
References: <alpine.LFD.2.02.1204181205540.2542@ionos> <tip-b435092f70ec5ebbfb6d075d5bf3c631b49a51de@git.kernel.org> <CAMQu2gx4-4kbgEHXUbU0SR=Xj6pe5FxjYJJ_dZD5D=jZs7f03A@mail.gmail.com>
In-Reply-To: <CAMQu2gx4-4kbgEHXUbU0SR=Xj6pe5FxjYJJ_dZD5D=jZs7f03A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2012 06:49 PM, Shilimkar, Santosh wrote:
> On Wed, Apr 18, 2012 at 5:37 PM, tip-bot for Thomas Gleixner
> <tglx@linutronix.de> wrote:
>> Commit-ID:  b435092f70ec5ebbfb6d075d5bf3c631b49a51de
>> Gitweb:     http://git.kernel.org/tip/b435092f70ec5ebbfb6d075d5bf3c631b49a51de
>> Author:     Thomas Gleixner <tglx@linutronix.de>
>> AuthorDate: Wed, 18 Apr 2012 12:08:23 +0200
>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>> CommitDate: Wed, 18 Apr 2012 14:00:56 +0200
>>
>> tick: Fix oneshot broadcast setup really
>>
>> Sven Joachim reported, that suspend/resume on rc3 trips over a NULL
>> pointer dereference. Linus spotted the clockevent handler being NULL.
>>
>> commit fa4da365b(clockevents: tTack broadcast device mode change in
>> tick_broadcast_switch_to_oneshot()) tried to fix a problem with the
>> broadcast device setup, which was introduced in commit 77b0d60c5(
>> clockevents: Leave the broadcast device in shutdown mode when not
>> needed).
>>
>> The initial commit avoided to set up the broadcast device when no
>> broadcast request bits were set, but that left the broadcast device
>> disfunctional. In consequence deep idle states which need the
>> broadcast device were not woken up.
>>
>> commit fa4da365b tried to fix that by initializing the state of the
>> broadcast facility, but that missed the fact, that nothing initializes
>> the event handler and some other state of the underlying clock event
>> device.
>>
>> The fix is to revert both commits and make only the mode setting of
>> the clock event device conditional on the state of active broadcast
>> users.
>>
>> That initializes everything except the low level device mode, but this
>> happens when the broadcast functionality is invoked by deep idle.
>>
>> Reported-and-tested-by: Sven Joachim <svenjoac@gmx.de>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
>> Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1204181205540.2542@ionos
>>
>> ---
>>  kernel/time/tick-broadcast.c |    7 +------
>>  1 files changed, 1 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
>> index bf57abd..119aca5 100644
>> --- a/kernel/time/tick-broadcast.c
>> +++ b/kernel/time/tick-broadcast.c
>> @@ -531,7 +531,6 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
>>                int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
>>
>>                bc->event_handler = tick_handle_oneshot_broadcast;
>> -               clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
>>
>>                /* Take the do_timer update */
>>                tick_do_timer_cpu = cpu;
>> @@ -549,6 +548,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
>>                           to_cpumask(tmpmask));
>>
>>                if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
>> +                       clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);

For some reason above if() check fails in my case, so broadcast device
never set to ONESHOT mode. That explains the problem I am seeing on
OMAP with the $subject patch. At this point of time bc->mode is
CLOCK_EVT_MODE_UNUSED.

Regards
Santosh
