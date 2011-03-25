Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab1CYF4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 01:56:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58258 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1CYF4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 01:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UFOnmfYd8Xt9NfNjsjVEKnCiosOo8abaJXVjrqpGYRhxGETBftUFwFK97xw9P2awa2
         5QpYIttxohlZfTWM3ZlOOcDAkfozymuG98vXfFLh3jb0eW7Uu2Wat6eDN9AMKOmMBstM
         e6AYMm6guC7jekGNXpHUgv1m7OkICmOjJr+Mk=
MIME-Version: 1.0
In-Reply-To: <1301001498.848.160.camel@work-vm>
References: <1300781334-30308-1-git-send-email-myungjoo.ham@samsung.com>
	<1300823076.2731.123.camel@work-vm>
	<AANLkTinuwuosJ27BRjREEq8m2_Z+0=U0x6ujGMS-5rKm@mail.gmail.com>
	<1301001498.848.160.camel@work-vm>
Date: Fri, 25 Mar 2011 14:56:42 +0900
X-Google-Sender-Auth: X027ntudaLaXrHnYqwxKwPaY-8A
Message-ID: <AANLkTinS33QRLUxcqN_UtKMrA7PfRD3J2=YTF0Jj-zZ4@mail.gmail.com>
Subject: Re: [PATCH v2] RTC: Selectively enable PIE-Hrtimer emulation.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: John Stultz <john.stultz@linaro.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, kyungmin.park@samsung.com,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 6:18 AM, John Stultz <john.stultz@linaro.org> wrote:
> On Thu, 2011-03-24 at 14:28 +0900, MyungJoo Ham wrote:
>> On Wed, Mar 23, 2011 at 4:44 AM, John Stultz <john.stultz@linaro.org> wrote:
>> > On Tue, 2011-03-22 at 17:08 +0900, MyungJoo Ham wrote:
>> >> The patch of John Stultz, "RTC: Rework RTC code to use timerqueue for
>> >> events", has enabled PIE interrupt emulation with hrtimer unconditionally.
>> >> However, we do have RTC devices that support PIE and such devices are
>> >> not meant to be emulated by hrtimer.
>> >
>> > I guess the question I want to ask here, is what is the value of getting
>> > PIE interrupts over the hrtimer? For most cases it is yet another
>> > interrupt. Could you expand a bit more on why you need real PIE irqs?
>>
>> I have been implementing charger driver (and then, moving on to
>> charger "framework") that requires periodic monitoring on the
>> thermistors and properties of battery chargers that do not have
>> interrupts. Because the chargers keep charging during suspend, I need
>> to keep monitoring them during suspend. I have been doing this by
>> periodically waking up the system during suspend with usually 30 secs.
>> Although the PIE frequency is over 1Hz, the RTC device in the CPUs we
>> use (S3Cxxxx, S5Pxxxx) have TICCNT entry, which allows to have PIE
>> interrupt every TICCNT-th PIE-Tick; e.g., with TICCNT=30 and
>> PIE-frequency=1Hz, we have an interrupt every 30 seconds. (This TICCNT
>> feature is not included in mainline rtc-s3c, yet.)
>>
>> For now, I use an additional EXPORTed functions for setting TICCNT
>> provided with rtc-s3c.c.
>
> Ok, so this is a special feautre of the s3c hardware and its being
> exposed via adding new functionality to the PIE mode in an out of tree
> patch.
>
> So, just to further understand what you're doing, is the periodic
> monitoring done in userland, or is this all via in-kernel drivers?

It is all via in-kernel drivers; i.e., charger-framework,
board-support-files, and rtc-s3c.c. For now, I'm using a function,
"s3c_rtc_tick_setup", which is not in mainline yet.

>
>
>> >> Besides, we sometimes need RTC-PIE
>> >> to function while hrtimer does not; e.g., CPU's RTC PIE as a
>> >> suspend-to-RAM wakeup source.
>> >
>> > So this indeed is a limitation. hrtimer emulated PIE's won't wake the
>> > system up.  So is this a "Besides...sometimes" sort of case, or is PIE
>> > wakeups really the only issue here?
>>
>> So far, this is the only issue affecting us with the PIE emulation.
>>
>> Some potential issues that I'm not concerned for now are;
>> a. we are blocking a hardware's function with an emulated feature.
>
> Well, the current rtc interface is poor, as it has limited granularity
> and exposes too much hardware detail directly to userland.  We need to
> preserve the existing behavior, but before we extend it to enable new
> hardware functionality, I think we should consider if the functionality
> should be just tacked on, or added in a better way.
>
>> b. there could be multiple rtc devices in a system and we may need to
>> setup them anyway without any s/w interrupt handlers. (RTC PIEs
>> directly signalling some other H/W pieces?)
>
> Maybe I'm misunderstanding, but this sounds like an abuse of the RTC
> interface. If you're using the RTC interface to enable some sort of
> inter-hardware signaling, where the kernel itself wouldn't be handling
> the irq, you probably really want to use a different driver
> all-together. But again, I might just not understand what you're
> meaning.

I use RTC-ALARM (not PIE anyway) to boot up the system at a designated
time. I thought someone might need similar behaviors (RTC interrupt
events setup without S/W handlers involved) with RTC PIEs; thus, it is
not an issue I'm concerned with.

>
>
>> I think providing hrtimer-based emulation for RTC PIE interrupts is
>> fine; however, for RTC devices that want to use their own PIE
>> features, I think the framework needs not to block them.
>
> Well, lets take just a small step back. Instead of thinking in specific
> hardware features, we need a somewhat generalized abstraction so we can
> enable the functionality in a common way across a wide array of
> hardware.

Ok. Then, wouldn't this be out of a specific device driver's
interface? For example when "/dev/rtc0" represents "rtc-s3c" and
"/dev/rtc1" represents "rtc-max8998", such in-kernel s/w emulation
needs to have its own interface; e.g., "/dev/rtc2", "/dev/rtc-kernel",
or something not representing a specific h/w piece.

>
> For instance, with the current code in 2.6.38, we can easily provide the
> behavior you're looking for (ie: 30-second interval RTC triggered
> events) in the kernel:
>
> Just create a struct rtc_timer, use rtc_timer_init() to initialize it
> with a call back function and ptr, then call rtc_timer_start() with the
> expiration time and the 30 second period. The callback will then be
> called every 30 seconds, triggered by the RTC alarm.
>
> The benefit here is that since the kernel manages all of this, it will
> then work on any RTC hardware that supports alarms, and doesn't need
> some hardware-specific PIE mode support. Even better, since the kernel
> can allow for multiplexing of events, userland can still set AIE mode
> alarms using the legacy interface without affecting your periodic
> rtc_timer.
>
> Now, currently this is kernel-internal functionality, and hasn't yet
> been exposed to userland, but I'm looking to change that via the posix
> alarm timers work. Where one could simply set a standard timer against
> CLOCK_REALTIME_ALARM, and that timer will fire regardless of if the
> system is in suspend or not.

Cool. I wasn't aware of this feature and this can be one possible way
to replace TICCNT+RTC-PIE feature in the charger-framework/drivers.
However, this rtc_timer is based on rtc-alarm; thus, TICCNT, which is
for PIE (Tick) events, has nothing to do with rtc_timer.

>
> In the meantime, you might even be able to convert your currently
> out-of-tree TICCNT patch to make use of the rtc_timer to provide
> equivalent behavior (Having not seen it, I'm not quite sure how the
> TICCNT mode is enabled from userland in your code, but I'd be happy to
> look at it and make suggestions on how to change it).
>
> thanks
> -john
>
>
>

I still think this hrtimer emulation should be either separated from
rtc-device-interface that is accessed through /dev/rtcX or optional
for each rtc-device. However, I'll keep the recurring wakeup feature
as an in-kernel-drivers only function provided by rtc-s3c.

Thanks a lot.


Cheers! It's Friday! :)
- MyungJoo
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
