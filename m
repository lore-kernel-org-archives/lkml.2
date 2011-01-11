Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab1AKTXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:23:00 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34236 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab1AKTW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:22:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LxecsYb4uG7JOruddQeMt6SbrDjoy1AF2s9IMw8zhGaazCONIiRoUMMLuhHzTZJMCE
         oOBbq6jXGxfHUKn3tCAI55aDJ/q8siiW3YrjETbKMtC7+UmE5gYQZQYTP0W/pN1DGeKY
         hCkDMyiUTrQu+D6ticLU6YG8v7M+21epnlWY8=
MIME-Version: 1.0
In-Reply-To: <1294772163.3441.42.camel@work-vm>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
	<1294280159-2513-13-git-send-email-john.stultz@linaro.org>
	<AANLkTi=i9bnAz9FoB_Q1u4pTOwpBCTHK4S21iukZWBpF@mail.gmail.com>
	<1294772163.3441.42.camel@work-vm>
Date: Tue, 11 Jan 2011 21:22:56 +0200
Message-ID: <AANLkTin3AFzQUHzJay9sZpRRVuUKPvojTyFq3Z4b=zfy@mail.gmail.com>
Subject: Re: [PATCH 12/12] [RFC] Introduce Alarm (hybrid) timers
From: Anca Emanuel <anca.emanuel@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/11 John Stultz <john.stultz@linaro.org>:
> On Wed, 2011-01-05 at 20:07 -0800, Arve Hjønnevåg wrote:
>> I don't know how suited the posix interface is for this, but I think
>> it is critical to prevent suspend while an alarm is pending. If an
>> alarm is important enough to wake the system up from suspend, it is
>> probably not safe to suspend right after it triggered. The android
>> alarm driver holds a wakelock until user-space calls back in to wait
>> for the next alarm, while in-kernel alarms are called from interrupt
>> context. The apis provided in include/linux/pm_wakeup.h should provide
>> the functionality you need to prevent suspend until the alarms have
>> been fully processed, but I have not tried this api yet.
>
> So again, I was really hoping to avoid wading into the wakelocks
> discussion. However, I'm hesitant to push the posix alarm timers
> interface into the kernel if it is insufficient to replace the android
> alarm driver.  Wakelocks are not upstream, so they shouldn't block
> upstream progress, but I don't want to create an interface that ends up
> being short sighted if some wakelock-like solution were to later be
> included upstream.
>
> So into the water i slowly wade.
>
> I've been thinking about Arve's example above. The part that concerns me
> the most is the implicit suspend blocker that is acquired by the kernel
> when the alarm fires in order to inhibit suspend during the user-space
> processing until the process calls back into the alarm device.
>
> I was considering various ideas, like a special signal that tells
> userland that it holds a wakelock and is responsible for dropping it. Or
> some sort of callback when signal handling is complete by userland
> allowing userland to grab its own lock and let the kernel drop its held
> lock.
>
> But in my mind, it seems it would be cleaner if the userland application
> did something to mark itself as inhibiting suspend. Then if it was to
> block waiting on something like an alarm timer, the kernel would drop
> the suspend blocker. Then when the alarm timer fires, the kernel would
> re-aquire the suspend-blocker for the process when waking it up (the
> kernel may do its own suspend inhibition internally as well - but there
> wouldn't be any cross kernel/userland implicit lock passing). This is
> sort of like SCHED_FIFO 99 style semantics, where a realtime process
> won't be preempted unless it explicitly blocks.
>
> I realize this might be more complicated, as suspend inhibition might be
> desirable while a process is blocked, such as waiting on the disk, or
> blocking on non-alarm triggering timers (although that seems wasteful).
> But it seems that any blocking on devices that trigger wakeups would be
> fine time for us to drop suspend blocker, as we know we will be woken up
> after that point.
>
> Arve: Would something like the above resolve the issue you brought up? I
> realize Android might not be eager to convert to some new semantics,
> (nor the upstream kernel be eager to start using optimistic suspend),
> but should that day come, do you think such a solution would be
> sufficient?
>
> thanks
> -john
>

This is offtopic, but I set 60 minutes on my system until it suspends.
And 5 minutes for the screen.
I move my mouse, to avoid the suspend.
This is not the most trivial way of suspend blocker ?
If I see an movie on my pc, I want the movie app to be a suspend
blocker, because I want to see it until it finishes.
But what if I go away ? Then some sensor will tell to pause the movie,
and suspend.
