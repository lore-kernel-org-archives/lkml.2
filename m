Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2DGVE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 17:04:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37448 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2DGVE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 17:04:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMiPZ0so-ZN0HCHHhw16oPWWgfVD5t--wKSvEUtzQx94CA@mail.gmail.com>
References: <1333777207-4151-1-git-send-email-olof@lixom.net>
	<20120407070206.GA17623@core.coreip.homeip.net>
	<4F8089A9.6080704@raumfeld.com>
	<CAOesGMiPZ0so-ZN0HCHHhw16oPWWgfVD5t--wKSvEUtzQx94CA@mail.gmail.com>
Date: Sat, 7 Apr 2012 23:04:54 +0200
Message-ID: <CAGhQ9VwBBF97uM7kjfLz_VH12P7HpoKajBoF26vH7QAmQFDcFw@mail.gmail.com>
Subject: Re: [PATCH] Input: eeti_ts: Mark as CONFIG_BROKEN
From: Joachim Eastwood <manabian@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Sven Neumann <s.neumann@raumfeld.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Mack <daniel@caiaq.de>, Daniel Mack <zonque@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 7, 2012 at 10:32 PM, Olof Johansson <olof@lixom.net> wrote:
> On Sat, Apr 7, 2012 at 11:38 AM, Sven Neumann <s.neumann@raumfeld.com> wrote:
>> Hi,
>>
>>
>> On 07.04.12 09:02, Dmitry Torokhov wrote:
>>>
>>> On Fri, Apr 06, 2012 at 10:40:07PM -0700, Olof Johansson wrote:
>>>>
>>>> This seems to have been broken since 2010, so obviously noone actually
>>>> cares about the driver:
>>>>
>>>> make[4]: *** [drivers/input/touchscreen/eeti_ts.o] Error 1
>>>> drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':
>>>> drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration of
>>>> function 'irq_to_gpio' [-Werror=implicit-function-declaration]
>>>>
>>>> irq_to_gpio isn't available on most platforms today, so the driver
>>>> will need some rework by someone who has hardware access and can test
>>>> (to make sure that, for example, switching to level interrupts and just
>>>> keep taking them while there's more to process works).
>>>>
>>>> I guess it could just be scheduled for removal, but let's start with
>>>> marking it CONFIG_BROKEN.
>>>
>>>
>>> Well, it probably works quite well on arches that do have irq_to_gpio(),
>>> let's ask Daniel and Sven if they still have this hardware and if they
>>> can try the patch below that implements what you suggested.
>>
>>
>> This hardware is still in use and we also still follow kernel development
>> and try to update our customer devices to recent kernel versions regularly.
>> Currently we are at 3.1.10 and the touchscreen works well with that. I'll
>> try to update to a more recent kernel next week and will try your patch.
>
> Ah, you're right, and this was my bad. Looks like this change was
> introduced in 3.2 and broke this and one more driver (ezx-pcap):
>
> Author:     Haojian Zhuang <haojian.zhuang@marvell.com>
> AuthorDate: Mon Oct 10 16:03:51 2011 +0800
> Commit:     Haojian Zhuang <haojian.zhuang@marvell.com>
> CommitDate: Mon Nov 14 21:07:59 2011 +0800
>
>    ARM: pxa: rename gpio_to_irq and irq_to_gpio
>
>    Avoid to define gpio_to_irq() and irq_to_gpio() for potential name
>    confliction since multiple architecture will be built together.
>
>    Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
>
>
> Haojian, I think it was probably premature to do the multiplatform
> change like that, since it means that a PXA-only kernel has no mapping
> from irq_to_gpio to pxa_irq_to_gpio. Can you please address this as a
> fix for 3.4?
>
>
> Thanks,
>
> -Olof

It's the same story with AT91. Here irq_to_gpio was also removed some
time ago. I believe it's the same for a lot of other ARM architectures
also.
Currently there 7 drivers that uses irq_to_gpio, these are obviously
broken on architectures that not provide the function.

I think it would be better to fix the drivers rather than resurrect
irq_to_gpio on the individual architectures.

Users of irq_to_gpio in drivers:
pata_rb532_cf, eeti_ts, egalax_ts, ezx-pcap, db1xxx_ss, tosa_battery, lis3l02dq

regards
Joachim Eastwood

> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
