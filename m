Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab1LFK6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:58:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44728 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089Ab1LFK6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:58:07 -0500
MIME-Version: 1.0
In-Reply-To: <8650361.EbH1hYJT76@pali-elitebook>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
	<2013134.msetbOSBe8@pali-elitebook>
	<CAMP44s1TrRkcy-xS+fXMyv0FAL1TnsPnnTa=gHSd2=P=iFkSUg@mail.gmail.com>
	<8650361.EbH1hYJT76@pali-elitebook>
Date: Tue, 6 Dec 2011 12:58:06 +0200
Message-ID: <CAMP44s3hxKgP_epT48vwqwM-jme7ZsZx0U1xW4DTrn9aSpb6hg@mail.gmail.com>
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

On Tue, Dec 6, 2011 at 9:25 AM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Tuesday 06 December 2011 02:12:47 you wrote:
>> On Tue, Dec 6, 2011 at 1:05 AM, Pali Rohár <pali.rohar@gmail.com> wrote:
>> > I started writing other implementaion of bq2415x charger driver, which
>> > should support also setting usb host mode. Code is still unfinished,
>> > but now is devided into 2 parts: one power_supply driver and one driver
>> > which cover all bq registers. See:
>> >
>> > http://atrey.karlin.mff.cuni.cz/~pali/bq2415x/
>> >
>> > Felipe Contreras, I think that my implementation is better - it will
>> > export all bq registers (which is needed for hostmode boost) and will
>> > also register regulator interface.
>>
>> I took a look at your driver, and there's definitely good stuff in it.
>> However, I think there's a lot of unnecessary stuff, like the
>> miscdevice stuff (which was frowned upon for bq27x00), and a lot of
>> user-space interface. Moreover, it doesn't seem to do anything on its
>> own (it needs interaction from user-space).
>
> Ignore miscdevice, I will remove them from driver. I will add some debugfs
> interface for getting registers output (needed for debugging)

Ok. A device with such debugfs would be nice, but I would start
without one, just something that works.

>> IMO the first step should be to have a minimal driver that just works,
>> even if it doesn't achieve the absolute best charging performance.
>> More features could be added later on.
>>
>> Also, I'm not familiar with the regulator interface, but it seems to
>> be meant for real regulators, which have consumers, and based on those
>> consumers's needs the real voltage changes. This battery charger on
>> the other hand doesn't have anything like that. There will be no
>> consumer, and some stuff like the weak battery voltage is not even
>> related to a voltage supply, but rather a threshold that can be
>> configured to change some behavior of the charger, but there's no
>> point in changing it dynamically (or maybe at all).
>
> If regulator interface is not good, I can change it to some sysfs interface.
> But bq2415x chip driver is not only rx51 specified, so it should handle all
> chip capabilities.

I don't know if the regulator interface makes sense, but I think not.
Anyway, I don't see how my code is specific to rx51, it should work
with all bq2415x models.

>> I guess the important one is the charge voltage, which is linked to a
>> real voltage, but what consumers would it have? I don't think there's
>> any.
>>
>> Finally, I don't think user-space interaction should be needed at all.
>> The driver should start charging immediately when there power supply
>> available, and stop when there isn't any. Maybe at some point a
>> user-space interface will be useful later on (I don't see why), but I
>> don't think it should be *necessary*.
>
> Userspace interfaction is needed. We need to tell driver to boost - for usb
> host mode. But of course, battery charging should be automatic without
> userspace interfaction.

Why do we need user-space for the boost mode?

>> I'm not familiar with any of this stuff, so don't take my opinions too
>> seriously :)
>
> Consider my code. We do not need two (or more) implementation of same driver
> in kernel. And also we do not need only rx51 specified code.

Of course, that's why I am discussing this :)

> I separated bq2415x register access into one module (bq2415x.c - without any
> logic, only cover chip options) and real battery charging should be done in
> power_supply interface (bq2415x_charger.c)

I don't see the point of having two drivers.

> My code has also prepaired boost support - for usb host mode, which must be
> done in driver.

Well, yeah, in my driver it can be added as well, however, I don't
think it's _needed_ right now.

First, I would like something that works by itself (without
user-space), which I already have. Next, I would like it to plug into
isp1704 to detect when a charger is connected, and select the correct
limits accordingly. I guess this hooks should be connected on the
board code. Once having that, I think the driver should be ready for
merging, the rest of the features can come later.

Cheers.

-- 
Felipe Contreras
