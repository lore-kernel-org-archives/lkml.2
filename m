Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab1AKS4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:56:16 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40585 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550Ab1AKS4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:56:14 -0500
Subject: Re: [PATCH 12/12] [RFC] Introduce Alarm (hybrid) timers
From: John Stultz <john.stultz@linaro.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <AANLkTi=i9bnAz9FoB_Q1u4pTOwpBCTHK4S21iukZWBpF@mail.gmail.com>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
	 <1294280159-2513-13-git-send-email-john.stultz@linaro.org>
	 <AANLkTi=i9bnAz9FoB_Q1u4pTOwpBCTHK4S21iukZWBpF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 10:56:03 -0800
Message-ID: <1294772163.3441.42.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 20:07 -0800, Arve Hjønnevåg wrote:
> I don't know how suited the posix interface is for this, but I think
> it is critical to prevent suspend while an alarm is pending. If an
> alarm is important enough to wake the system up from suspend, it is
> probably not safe to suspend right after it triggered. The android
> alarm driver holds a wakelock until user-space calls back in to wait
> for the next alarm, while in-kernel alarms are called from interrupt
> context. The apis provided in include/linux/pm_wakeup.h should provide
> the functionality you need to prevent suspend until the alarms have
> been fully processed, but I have not tried this api yet.

So again, I was really hoping to avoid wading into the wakelocks
discussion. However, I'm hesitant to push the posix alarm timers
interface into the kernel if it is insufficient to replace the android
alarm driver.  Wakelocks are not upstream, so they shouldn't block
upstream progress, but I don't want to create an interface that ends up
being short sighted if some wakelock-like solution were to later be
included upstream.

So into the water i slowly wade. 

I've been thinking about Arve's example above. The part that concerns me
the most is the implicit suspend blocker that is acquired by the kernel
when the alarm fires in order to inhibit suspend during the user-space
processing until the process calls back into the alarm device.

I was considering various ideas, like a special signal that tells
userland that it holds a wakelock and is responsible for dropping it. Or
some sort of callback when signal handling is complete by userland
allowing userland to grab its own lock and let the kernel drop its held
lock.

But in my mind, it seems it would be cleaner if the userland application
did something to mark itself as inhibiting suspend. Then if it was to
block waiting on something like an alarm timer, the kernel would drop
the suspend blocker. Then when the alarm timer fires, the kernel would
re-aquire the suspend-blocker for the process when waking it up (the
kernel may do its own suspend inhibition internally as well - but there
wouldn't be any cross kernel/userland implicit lock passing). This is
sort of like SCHED_FIFO 99 style semantics, where a realtime process
won't be preempted unless it explicitly blocks.

I realize this might be more complicated, as suspend inhibition might be
desirable while a process is blocked, such as waiting on the disk, or
blocking on non-alarm triggering timers (although that seems wasteful).
But it seems that any blocking on devices that trigger wakeups would be
fine time for us to drop suspend blocker, as we know we will be woken up
after that point.

Arve: Would something like the above resolve the issue you brought up? I
realize Android might not be eager to convert to some new semantics,
(nor the upstream kernel be eager to start using optimistic suspend),
but should that day come, do you think such a solution would be
sufficient?

thanks
-john


