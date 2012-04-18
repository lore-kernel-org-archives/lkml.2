Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab2DRFmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:42:19 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33501 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab2DRFmR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:42:17 -0400
MIME-Version: 1.0
In-Reply-To: <1334689888.28674.140.camel@sbsiddha-desk.sc.intel.com>
References: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com>
 <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com> <4F8AC59D.6070909@ti.com>
 <1334613816.28674.108.camel@sbsiddha-desk.sc.intel.com> <4F8D266D.4030207@ti.com>
 <1334689888.28674.140.camel@sbsiddha-desk.sc.intel.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 18 Apr 2012 11:11:53 +0530
Message-ID: <CAMQu2gw0gd6HBVWRRLATH=BfLwgJjgr-pwfQk-HJxuK3yovzgQ@mail.gmail.com>
Subject: Re: [PATCH] clockevents: Leave broadcast device shtudown only if the
 current device is always running.
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 12:41 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Tue, 2012-04-17 at 13:44 +0530, Santosh Shilimkar wrote:
>> On Tuesday 17 April 2012 03:33 AM, Suresh Siddha wrote:
>> > On Sun, 2012-04-15 at 18:27 +0530, Santosh Shilimkar wrote:
>> >> The main issue is, you are not letting the one time setup
>> >> needed for the broadcast device. Even with above change,
>> >> the 'tick_broadcast_device.evtdev' is still in SHUTDOWN
>> >> mode and the event handler is pointing to clockevents_handle_noop()
>
> If you see this, handler was not even set to the periodic mode handler.
> So the periodic mode for the broadcast device also was not working
> before (even with out the recent change).
>
> In tick_check_broadcast_device(), we do this:
>
>        if (!cpumask_empty(tick_get_broadcast_mask()))
>                tick_broadcast_start_periodic(dev);
>
> So with out the CLOCK_EVT_NOTIFY_BROADCAST_ON notification, we won't be
> even setting up the periodic mode correctly.
>
> I just extended this to the oneshot mode too, exposing the issue in your
> cpuidle code.
>
Periodic mode for broad-cast device was any way not much important and hence
the issue was hidden I guess.

>> >
>> > On x86, idle driver (like drivers/idle/intel_idle.c:
>> > __setup_broadcast_timer()) calls clockevents_notify() with
>> > CLOCK_EVT_NOTIFY_BROADCAST_ON, during which we do
>> > tick_broadcast_setup_oneshot(). See tick_do_broadcast_on_off() which
>> > does this. That should setup the evtdev handler, mode etc.
>> >
>> > And during the next CLOCK_EVT_NOTIFY_BROADCAST_ENTER we program the next
>> > broadcast event.
>> >
>> I see.
>>
>> >
>> > Anyways, can you add CLOCK_EVT_NOTIFY_BROADCAST_ON/OFF notifications in
>> > your idle driver to see if it addresses the problem. That is the correct
>> > thing to do here.
>> >
>> Before your commit 77b0d60c{clockevents: Leave the broadcast device..},
>> my idle driver was working without CLOCK_EVT_NOTIFY_BROADCAST_ON
>> notifier. Now it's clear that it was relying on the default
>> 'tick_broadcast_setup_oneshot()' which was happening during boot.
>>
>> And ofcource notifying explicitly with BROADCAST_ON does the
>> tick setup. Will update my idle driver accordingly but can
>> you please explain me why the proposed patch [1] is not correct
>> approach ? It should be also do what you intended to do
>> with minimal change, right ?
>
> Please see the above. Essentially irrespective of the recent change,
> periodic mode was also broken. Probably no one cared about that mode and
> we didn't notice that issue so far. Anyhow, the correct thing to do here
> is to add those notifications to the cpuidle driver. Can you please
> check if the appended/untested patch fixes your issue? If so, please
> push this to your driver. thanks.
>
As I mentioned earlier, I have already tried my driver  with
CLOCK_EVT_NOTIFY_BROADCAST_ON update yesterday and pushed
a patch for the same.
Thanks for the periodic mode point which i missed previously.

Regards
Santosh
