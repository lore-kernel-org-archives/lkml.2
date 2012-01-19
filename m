Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab2ASRK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:10:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2ASRKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:10:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Date: Thu, 19 Jan 2012 17:10:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com> <201201181711.15751.arnd@arndb.de> <331ABD5ECB02734CA317220B2BBEABC13177DFF6@DBDE01.ent.ti.com>
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13177DFF6@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201191710.45862.arnd@arndb.de>
X-Provags-ID: V02:K0:Fw1KMWvKG9bUOLwqvn1AuqeZRup8sqwmCkVsQ5F/IM9
 me0OVnIsd1nJjJpD9MLiDuCeuGVFsNTafl5i5yirrP9bw9kLyP
 W5Isrj8M6trRmHgiIrz4aA4XItiO/8zmdQiH+fGR/hoONr4vWO
 pc2Ehq2sPi5T7Mp2r+T1D0Q0/CNz+TzOAH6D5IxVmqrbV9Go5j
 qGsMxZKco5mRSHkAF4/17Wl5BvktlKZUursAOA0OtLw1DIAvcT
 xYKP28XFLoZ8niGxfuXLmarlGqUTpXPhps2M/7Pdego+dSfOz2
 cnFSmSyzZC69Cod87w9iWIXZZFo7VadLhZSPeF6KKStVQDBK0f
 dYlQFdpyJdb07QzAFaSA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 January 2012, AnilKumar, Chimata wrote:
> Android userspace running on TI AM335x EVM is using the interface
> provided by lis3lv02d. They were asking some more interfaces from
> lis3lvo2d driver.
> 
> There are multiple ways we can interface accelerometer to Android layers,
> which is implemented on hardware abstraction layer (HAL) in Andriod.
> 
> 1) Interrupt mode
> 2) Polling mode
>    2a) Kernel polling
>    2b) Timer polling
> 
> Based on the interfaces provided by the lis3lv02d as well as
> lis331dlh (H/W not supporting the interrupts) they were implementing
> the kernel polling mechanism.
> 
> So implementation on HAL is like this if accelerometer interface is
> opened then kernel will start polling this driver periodically and
> pass events to input subsystem. (It's a little bit over head)
> 
> Generally the device should be open but kernel should only poll
> when an app that uses accelerometer is started.
> 
> The biggest requirement for them (Andriod people) is to allow user to
> enable / disable accelerometer from user space and to configure
> the accelerometer polling frequency.
> 
> Today there is no option in lis3lvo2d driver to provide this kind
> of functionalities

Hi AnilKumar,

This all sounds like the interface is not completely thought through.

I did not realize that the driver actually uses the input subsystem
in addition to its own interfaces. This is definitely good, and it
means that we can move the files from drivers/misc to drivers/input/misc
or drivers/input/accelerometer, making it Dmitry's problem instead of
mine ;-)

Having custom user interfaces inside an input driver however is very
bad. I'm sure that other accelerometers will have the same requirements
regarding polling frequency and enable/disable in android as well as
anytwhere else and it should absolutely not be handled by a user space
HAL but instead inside of the kernel, using a common method for all
available drivers.

Based on that, I also doubt we should apply your patch to add the
"range" attribute (adding support for lis33ldlh is fine though).
Instead I would ask you to first fix what's there by moving the
user space interfaces into the input core from the driver
and documenting them.

I don't know what the preferred way for doing things is there
(joystick ioctl, sysfs attribute, ...) but Dmitry should
be able to provide advice there. Then add interfaces for the
additional stuff you need (range, disable, ...) in the same
place and implement them as callbacks in the driver itself.

	Arnd
