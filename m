Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0KAIFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:05:53 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:40308 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751690Ab0KAIFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:05:51 -0400
Message-ID: <4CCE74DB.8000206@arndnet.de>
Date: Mon, 01 Nov 2010 09:05:47 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: regression: b43-sdio: probe of mmc0:0001:1 failed with error
 -16
References: <4CCDA454.708@arndnet.de> <AANLkTin80pwnb1DX8OdZK3Wgsq0nj==G9VM3pahsmo0U@mail.gmail.com> <4CCDE4EB.7060001@arndnet.de> <AANLkTik52SVa0SC_RtNtgFu2U9Gye7BKtQ7jNgMPKe=W@mail.gmail.com>
In-Reply-To: <AANLkTik52SVa0SC_RtNtgFu2U9Gye7BKtQ7jNgMPKe=W@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.11.2010 05:50, schrieb Ohad Ben-Cohen:
> On Sun, Oct 31, 2010 at 11:51 PM, Arnd Hannemann <arnd@arndnet.de> wrote:
>>> In Daniel's scenario, mmc_sdio_init_card() fails because
>>> mmc_send_relative_addr() returns -110.
>>>
>>> Can you please check out if that's the same thing you have too ?
>>
>> No, it seems to be the pm_runtime_get_sync in sdio_bus.c::sdio_bus_probe().
> 
> Yeah, this is just the symptom though - pm_runtime_get_sync tries to
> power up the card, and eventually mmc_sdio_init_card() is called (by
> mmc_sdio_resume which is invoked by mmc_resume_host).

No, actually mmc_sdio_init_card() is called _before_ sdio_bus_probe and
the failing pm_runtime_get_sync in my case.
Also mmd_sdio_resume is not called at all.

> On the XO-1.5 mmc_sdio_init_card() seems to fail due to
> mmc_send_relative_addr() returning -110; this may suggest that
> although mmc_power_off() and mmc_power_on() were called, we still
> didn't have a full power reset, and the card/controller are left at a
> weird state.
> 
> Can you please check out if that's the same failure in your case too ?

No mmc_send_relative_addr() does _not_ return -110, actually it
is not called at all.

I inserted a WARN_ON() in sdio_bus_probe, and here is the backtrace I get:
[   32.351562] [<c0034754>] (warn_slowpath_null+0x0/0x2c) from [<c017ef48>] (sdio_bus_probe+0x5c/0xe8)
[   32.359375] [<c017eeec>] (sdio_bus_probe+0x0/0xe8) from [<c014e908>] (driver_probe_device+0xd0/0x18c)
[   32.367187]  r8:c00250c4 r7:bf12a210 r6:bf12a210 r5:c728dc3c r4:c728dc08
[   32.367187] r3:c017eeec
[   32.375000] [<c014e838>] (driver_probe_device+0x0/0x18c) from [<c014ea2c>] (__driver_attach+0x68/0x8c)
[   32.382812]  r7:00000000 r6:bf12a210 r5:c728dc3c r4:c728dc08
[   32.390625] [<c014e9c4>] (__driver_attach+0x0/0x8c) from [<c014e0c8>] (bus_for_each_dev+0x54/0x84)
[   32.398437]  r6:00000000 r5:c014e9c4 r4:bf12a210 r3:00000000
[   32.406250] [<c014e074>] (bus_for_each_dev+0x0/0x84) from [<c014e72c>] (driver_attach+0x20/0x28)
[   32.414062]  r6:c02b9440 r5:c72bf2c0 r4:bf12a210
[   32.414062] [<c014e70c>] (driver_attach+0x0/0x28) from [<c014d9b4>] (bus_add_driver+0xa8/0x21c)
[   32.421875] [<c014d90c>] (bus_add_driver+0x0/0x21c) from [<c014ed64>] (driver_register+0xb0/0x140)
[   32.429687] [<c014ecb4>] (driver_register+0x0/0x140) from [<c017f144>] (sdio_register_driver+0x24/0x2c)
[   32.437500]  r8:c00250c4 r7:00000000 r6:0001cfe0 r5:bf132000 r4:bf12a714
[   32.445312] r3:c02b9440
[   32.445312] [<c017f120>] (sdio_register_driver+0x0/0x2c) from [<bf120a0c>] (b43_sdio_init+0x14/0x1c [b43])
[   32.453125] [<bf1209f8>] (b43_sdio_init+0x0/0x1c [b43]) from [<bf132018>] (b43_init+0x18/0x88 [b43])
[   32.460937] [<bf132000>] (b43_init+0x0/0x88 [b43]) from [<c002441c>] (do_one_initcall+0xd4/0x1a8)
[   32.468750]  r4:bf12a714
[   32.468750] [<c0024348>] (do_one_initcall+0x0/0x1a8) from [<c005c564>] (sys_init_module+0x9c/0x1b4)
[   32.476562] [<c005c4c8>] (sys_init_module+0x0/0x1b4) from [<c0024f40>] (ret_fast_syscall+0x0/0x30)
[   32.484375]  r7:00000080 r6:00000000 r5:00000000 r4:0001b070
[   32.492187] ---[ end trace cb2ed4a07515af72 ]---

Regards,
Arnd

