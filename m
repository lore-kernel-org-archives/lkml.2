Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1LFOLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:11:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50154 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1LFOLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:11:35 -0500
MIME-Version: 1.0
In-Reply-To: <4644874.uYs2CCTrg9@pali-elitebook>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
	<8650361.EbH1hYJT76@pali-elitebook>
	<CAMP44s3hxKgP_epT48vwqwM-jme7ZsZx0U1xW4DTrn9aSpb6hg@mail.gmail.com>
	<4644874.uYs2CCTrg9@pali-elitebook>
Date: Tue, 6 Dec 2011 16:11:33 +0200
Message-ID: <CAMP44s1uQJZ8nhjMqUXPZLL+XvnWUAZ+qeKejeZdA0WwiS3e=Q@mail.gmail.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
From: Felipe Contreras <felipe.contreras@gmail.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 3:27 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Tuesday 06 December 2011 12:58:06 you wrote:
>> Ok. A device with such debugfs would be nice, but I would start
>> without one, just something that works.
>
> I think we do not need in mainline kernel driver which "only works" without
> any debug or additional support.

I think that's a good start, and that's what I will focus on.

>> I don't know if the regulator interface makes sense, but I think not.
>> Anyway, I don't see how my code is specific to rx51, it should work
>> with all bq2415x models.
>
> voltage and current values could be different for other boards. So each board
> (with bq2415x chip) should have defined default charge properties (in platform
> data structure or something else...). your interface does not support such as
> other changes.

No, they wouldn't, that depends on many things, like the type of
charger. As Sebastian pointed out, the current *sense* voltage, is
board specific, but that's about it.

>> Why do we need user-space for the boost mode?
>
> Because on n900 we *want* USB host mode. Without boost mode support (in kernel
> driver) again will need to rmmod driver (now we stopping BME) and start
> handling it in userspace.

But we can have boost mode *without* user-space. There's no reason why
it can't be handled by the kernel.

>> >> I'm not familiar with any of this stuff, so don't take my opinions too
>> >> seriously :)
>> >
>> > Consider my code. We do not need two (or more) implementation of same
>> > driver in kernel. And also we do not need only rx51 specified code.
>>
>> Of course, that's why I am discussing this :)
>>
>> > I separated bq2415x register access into one module (bq2415x.c - without
>> > any logic, only cover chip options) and real battery charging should be
>> > done in power_supply interface (bq2415x_charger.c)
>>
>> I don't see the point of having two drivers.
>
> Because proper charging on n900 needs interact with isp1704 driver. But this
> is specified for n900, not for all boards. bq2415x module should be general
> for all boards - so it should cover *only* bq2415x chip - nothing other.

Yes, and that be done with hooks. The bq2415x driver will have hooks,
and the rx51 board configuration will connect isp1704 to bq2415x, and
that's it. No need for yet another driver.

>> > My code has also prepaired boost support - for usb host mode, which must
>> > be done in driver.
>>
>> Well, yeah, in my driver it can be added as well, however, I don't
>> think it's _needed_ right now.
>
> Of course, but I (and maybe some other people) do not need uncompleted chip
> driver.

Anything is better than what we have now, which is nothing. Look for
example to how the bq27x00 battery driver evolved; it started very
simple.

>> First, I would like something that works by itself (without
>> user-space), which I already have. Next, I would like it to plug into
>> isp1704 to detect when a charger is connected, and select the correct
>> limits accordingly. I guess this hooks should be connected on the
>> board code. Once having that, I think the driver should be ready for
>> merging, the rest of the features can come later.
>
> Working without userspace is my primary goal. But also for debugging (and
> status apps/scripts) is needed direct register access. isp1704 interaction
> should not be in bq2415x chip driver, but in some rx51 specified code.

Yes.

> Charging should be done in power_supply interface.
>
> See also api specification by Joerg Reisenweber (one of n900 usb hostmode
> support) on http://maemo.cloud-7.de/bq24150-sysnode.spec.txt
> Similar interface is needed for proper usb host mode.

That is very interesting... Is there yet another module for this?
Again, I don't understand why interaction with user-space is *needed*
for host mode.

> Also your driver does not handle errors, when charging and watchdog should be
> stopped. Charging is *very* crytical parts and it really should detect errors.

Indeed, that's why this is RFC only.

> When in future I (or someone else) will want to add all missing features into
> bq2415x chip driver, it will be needed to rewrite it... (e.g. handling errors
> in boost mode)...

Perhaps, but I don't think so. Anyway, again, see the evolution of
bq27x00, or basically anything in the kernel. If something needs to be
refactored for new features, so be it.

But I think there is some consensus; the drivers should be in
drivers/power, and have a power supply interface, rx51 board info
should configure some sense voltage, and hook it up with
isp1704_charger somehow. Once this is done and driver is merged, I
don't expect that to change.

> Why to very very quicky merge uncompleted (but working) driver to upstream? I
> think we should finish bq2415x chip driver and if all will be implemented,
> then to merge it. What other developers think about that?

This version of the driver is not the one I am proposing to merge. The
one I'm proposed to merge should be a good basis for future work (or
what you are doing right now).

Cheers.

-- 
Felipe Contreras
