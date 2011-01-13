Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1AMFJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 00:09:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63747 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab1AMFJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 00:09:29 -0500
MIME-Version: 1.0
In-Reply-To: <201101081136.06682.rjw@sisk.pl>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
	<AANLkTin8cntsFpaikpfzPbWL1YFb702rPync240X4axW@mail.gmail.com>
	<1294367420.4518.171.camel@work-vm>
	<201101081136.06682.rjw@sisk.pl>
Date: Wed, 12 Jan 2011 21:03:45 -0800
Message-ID: <AANLkTinnCQzG2rsfyy9yHJR8eSVGYdPHMb8HaBfAaOxQ@mail.gmail.com>
Subject: Re: [PATCH 12/12] [RFC] Introduce Alarm (hybrid) timers
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 8, 2011 at 2:36 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, January 07, 2011, John Stultz wrote:
>> On Thu, 2011-01-06 at 16:58 -0800, Arve Hjønnevåg wrote:
>> > 2011/1/6 John Stultz <john.stultz@linaro.org>:
>> > > So otherwise, do you see any reason why android might not be able to
>> > > adapt this code to replace the android alarm timers?
>> > >
>> >
>> > The user-space interface does not look appealing, but I don't see any
>> > reason why the in-kernel interface(s) cannot be shared. Our user-space
>> > code has a single thread that waits for alarms to trigger, while the
>> > alarms can be modified from any thread.
>>
>> So its something like nanosleep(), only other threads can extend or
>> shorten the sleep time?
>>
>> Could you explain some of the rational for such an interface, so I can
>> better understand the need?
>>
>> >  As far as I can tell, using
>> > the posix interface would either require a thread per alarm (up to 5)
>> > or using signals. Both make the user-space code more complicated, and
>>
>> Yea, it probably would need signals, but I'd have to grok the use case a
>> little better. And its possible it would complicate the user-space code
>> some, but on the other hand, it would be using a more standard kernel
>> interface. The other option is extending the posix interface to try to
>> better match the need.
>>
>> > it is not clear if either of them provide a clear hand-off between
>> > where the kernel needs to block suspend because the alarm has not been
>> > delivered to user-space and where user-space needs to block suspend
>> > because it is handling the alarm.
>>
>> Indeed. I'm still looking into the pm_wake details to see the
>> limitations there. Some method of inheriting a stay_awake seems to be
>> needed, but sounds pretty ugly. Alternatively we may need some method or
>> callback to the kernel to detect that a signal has been handled by
>> userland (allowing the pm_relax to occur).
>>
>> Rafael: Any thoughts here?
>
> I think this problem is specific to Android where suspend is started
> automatically from kernel space, so user space needs an interface to actively
> prevent the kernel from starting suspend.
>
> The mainline model is that suspend will always be started from user space,
> so instead of telling the kernel not to suspend user space needs to avoid
> starting suspend in the first place.  In this model the kernel code can simply
> call pm_relax() as soon as _it_ doesn't need to prevent the system from
> suspending any more (eg. it knows that user space has learnt of the alarm) and
> it need not worry about the user space part (eg. whether or not user space
> is still handling the alarm).
>

You still have to make sure a race free implementation is possible. If
you are implementing alarms by calling nano-sleep, your model require
the nano-sleeping thread to also respond to requests from the thread
that initiates suspend when that thread checks if it is safe to
suspend.

-- 
Arve Hjønnevåg
