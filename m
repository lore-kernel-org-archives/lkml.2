Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1KKSL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 13:11:28 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:52155 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1KKSL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 13:11:27 -0500
X-Spam-Flag: NO
X-Spam-Score: -19.658
Message-ID: <4EBD653A.8060701@tremplin-utc.net>
Date: Fri, 11 Nov 2011 19:11:06 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111006 Thunderbird/7.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3lv02d: Avoid zero-division
References: <s5hy5vx9zmr.wl%tiwai@suse.de> <4EB8A8B6.1010205@tremplin-utc.net> <s5hr51jm8zc.wl%tiwai@suse.de>
In-Reply-To: <s5hr51jm8zc.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 08-11-11 07:19, Takashi Iwai schreef:
> At Tue, 08 Nov 2011 04:57:42 +0100,
> Éric Piel wrote:
>>
>> Op 03-11-11 13:09, Takashi Iwai schreef:
>>> In some weird situation, HP DriveGuard chip can't read ODR value
>>> correctly, and it results in a zero-division Oops in lis3lv02d driver.
>>> This patch fixes the Oops by checking the value appopriately, and skips
>>> if any weird value is read.
>> Hi Takashi,
>> Actually, a similar patch already just landed in linus' tree:
>> 1510dd5954 (lis3lv02d: avoid divide by zero due to unchecked)
>>
>> However, in the patch applied, the device is disabled (until next
>> reboot) while in yours, the sleep is just skipped. Does it work again
>> after the read of odr fails? If so, maybe I could improve the current
>> version by, after the odr read fails, sleeping a long and safe time and
>> then trying to read the odr again. Then if it fails again, we give up,
>> otherwise the device can be used again.
>
> I guess it's possible to use the device afterward.  The possible
> reason is either the chip is set to an invalid mode or ACPI isn't set
> up properly.  But this path usually means that ACPI does work more or
> less since you could read WHOAMI.
>
>> Do you have such a device yourself? Could you let me know if after a
>> failing read of the odr, the device keeps working?
>
> I have a machine but I'm not quite sure how to reproduce this error.
> It happened casually during the installation of a new system, so it's
> not so trivial to switch the module during it...
Dear Takashi,

I've looked more at the error. Now it seems to me that the fact that 
get_odr() returns 0 is not because there is a problem with the device 
but just because it is powered off: for the "3dc" device, this reflects 
in rate of 0. We assume that the ACPI code does turn the device on, but 
it might not do it, or the device might still need more time to fully 
initialize. So, just turning the device on and waiting a bit long should 
work fine.

However, looking for the spec document of lis3dc (or hp3dc), I couldn't 
find any reference to such device. I've found documents for lis3dh, with 
apparently same registers and WHOAMI value. However, contrarily to what 
is currently expected, it's a 16-bit device, not 8-bit. So my main 
question is: are you sure the device you have is 8-bit? Isn't your 
device a 16-bit lis3dh? Do you have the spec of lis3dc/hp3dc?

If it's indeed a 16-bit device, I'll update the support for this device 
to obtain a better precision.

Éric
