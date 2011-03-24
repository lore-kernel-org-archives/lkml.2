Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1CXF2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 01:28:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58397 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1CXF2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 01:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pQ9U9OjbbJjCS1XUWJzN/cc1VMsPiGlaHc5MZwlVaiJlA/15cgpcMjfHZ39V+Fk47d
         Pxz1KHbnRibLsbNP3gTh312y56/Nu120sKxeWCNPGh0g/X3/LsDT3Scsv4N2QOcXFkvo
         VvONIUs1Bg0w4u/dfc12MIkeRCEic2UgRllSI=
MIME-Version: 1.0
In-Reply-To: <1300823076.2731.123.camel@work-vm>
References: <1300781334-30308-1-git-send-email-myungjoo.ham@samsung.com>
	<1300823076.2731.123.camel@work-vm>
Date: Thu, 24 Mar 2011 14:28:20 +0900
X-Google-Sender-Auth: t1zrhYfx5vYGP46j5DOcNomy-RQ
Message-ID: <AANLkTinuwuosJ27BRjREEq8m2_Z+0=U0x6ujGMS-5rKm@mail.gmail.com>
Subject: Re: [PATCH v2] RTC: Selectively enable PIE-Hrtimer emulation.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: John Stultz <john.stultz@linaro.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, kyungmin.park@samsung.com,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 4:44 AM, John Stultz <john.stultz@linaro.org> wrote:
> On Tue, 2011-03-22 at 17:08 +0900, MyungJoo Ham wrote:
>> The patch of John Stultz, "RTC: Rework RTC code to use timerqueue for
>> events", has enabled PIE interrupt emulation with hrtimer unconditionally.
>> However, we do have RTC devices that support PIE and such devices are
>> not meant to be emulated by hrtimer.
>
> I guess the question I want to ask here, is what is the value of getting
> PIE interrupts over the hrtimer? For most cases it is yet another
> interrupt. Could you expand a bit more on why you need real PIE irqs?

I have been implementing charger driver (and then, moving on to
charger "framework") that requires periodic monitoring on the
thermistors and properties of battery chargers that do not have
interrupts. Because the chargers keep charging during suspend, I need
to keep monitoring them during suspend. I have been doing this by
periodically waking up the system during suspend with usually 30 secs.
Although the PIE frequency is over 1Hz, the RTC device in the CPUs we
use (S3Cxxxx, S5Pxxxx) have TICCNT entry, which allows to have PIE
interrupt every TICCNT-th PIE-Tick; e.g., with TICCNT=30 and
PIE-frequency=1Hz, we have an interrupt every 30 seconds. (This TICCNT
feature is not included in mainline rtc-s3c, yet.)

For now, I use an additional EXPORTed functions for setting TICCNT
provided with rtc-s3c.c.

>
>> Besides, we sometimes need RTC-PIE
>> to function while hrtimer does not; e.g., CPU's RTC PIE as a
>> suspend-to-RAM wakeup source.
>
> So this indeed is a limitation. hrtimer emulated PIE's won't wake the
> system up.  So is this a "Besides...sometimes" sort of case, or is PIE
> wakeups really the only issue here?

So far, this is the only issue affecting us with the PIE emulation.

Some potential issues that I'm not concerned for now are;
a. we are blocking a hardware's function with an emulated feature.
b. there could be multiple rtc devices in a system and we may need to
setup them anyway without any s/w interrupt handlers. (RTC PIEs
directly signalling some other H/W pieces?)

>
> To better understand the scope of the issue, I'd like to know more about
> your uage of PIE mode as a wakeup source. Given PIE mode is for sub 1HZ
> irqs, do you really use suspend/resume at a periodic rate multiple times
> a second? Is this done with the current mainline kernel? What would be
> the penalty of moving to a 1HZ wakeup?

No, I don't use it for periodic sub-1HZ wakeups. I use it for
several-seconds periodic wakeups. I have not posted such features to
mainline kernel, yet.


>
> If this indeed a critical limitation, then it needs to be solved.
> However, instead of just re-enabling the pie mode access to userland
> (which will likely need more then the patch here provides to avoid
> breaking the RTC event multiplexing), I'd much prefer to see the the
> solution as extending the in-kernel RTC API to allow for sub-second
> resolution alarms, then using a periodic mode rtc alarm to emulate PIE
> mode irqs out to userland.

If we are to provide in-kernel RTC eumulation API to userland, why
don't we separate it from H/W RTC API dev? (e.g., provide emulated rtc
as /dev/rtc, and provide H/W rtc as /dev/rtcX). We already have
multiple H/W RTC devs (e.g., /dev/rtc0, /dev/rtc1) in some systems. In
the current scheme, we may have multiple H/W RTCs with each having S/W
emulated PIEs (essentially same and redundant.)

>
> Alessandro: Your thoughts here? As it seems most RTC hardware can handle
> it, any objections to extending the in-kernel interface to provide
> sub-second resolution (it doesn't mean they will provide it, but it
> doesn't limit the hardware at the interface level).
>
>> This patch allows to selectively use the PIE emulation. If the rtc
>> driver has implemented PIE related ops (irq_set_state and irq_set_freq),
>
> So, both irq_set_state and irq_set_freq were removed upstream in the
> 2.6.39-rc1 merge window, so this patch def won't work upstream.
>
> Sorry for the trouble here! Hopefully we can get things resolved and
> working shortly here.
>
> thanks
> -john
>
>

I think providing hrtimer-based emulation for RTC PIE interrupts is
fine; however, for RTC devices that want to use their own PIE
features, I think the framework needs not to block them.


Cheers!

- MyungJoo
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
