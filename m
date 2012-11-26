Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab2KZHul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 02:50:41 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37252 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2KZHuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 02:50:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAAfyv35QOvgvH8xoMkE-S5Zf-9HF5Jb9X1EbMoi2FCcx1UMXNA@mail.gmail.com>
References: <slrnkb64p3.2k6.narkewoody@zuhnb712.local.com>
	<CAAfyv35QOvgvH8xoMkE-S5Zf-9HF5Jb9X1EbMoi2FCcx1UMXNA@mail.gmail.com>
Date: Mon, 26 Nov 2012 15:50:39 +0800
Message-ID: <CAEk7JKbG3FgcGWxN_BgqpuWB0JD6QkchwFR15H=eSva-CSJjTA@mail.gmail.com>
Subject: Re: The ethernet driver doesn't get probed
From: "Li, Zhen-Hua" <lizhenhua.dev@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Woody Wu <narkewoody@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First you  should run "lspci -n" to check your device ID and vendor
ID, and make sure they are in the map list in
/lib/modules/<your-version>/modules.alias .


On Mon, Nov 26, 2012 at 3:47 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
> On Mon, Nov 26, 2012 at 7:59 AM, Woody Wu <narkewoody@gmail.com> wrote:
>> Hi, List
>>
>> I enabled an ax88796 Ethernet driver in the kernel configuration menu.
>> Kernel version is 3.4.19. The arch is ARM and the system type is
>> Samsung S3C2410.
>>
>> In my debugging, I found the probe function of the driver did not get
>> invoked.
> Did you define platform data and platform device in board file?
> See: arch/arm/mach-pxa/colibri-pxa300.c (line ~87)
>>
>> This driver is declared as platform_driver
>>
>> static struct platform_driver axdrv = {
>>         .driver = {
>>                 .name           = "ax88796",
>>                 .owner          = THIS_MODULE,
>>         },
>>         .probe          = ax_probe,
>>         .remove         = ax_remove,
>>         .suspend        = ax_suspend,
>>         .resume         = ax_resume,
>> };
>>
>> module_platform_driver(axdrv);
>>
>> So, its driver init function actually goes through
>> platform_driver_register() and then driver_register(), which eventually
>> call driver_attach() trying to attach the driver to the "platform" bus.
>> But, on the platform bus, there is no any device that can match the
>> ax88796 driver, hence the driver failed in attaching.
>>
>> I discovered the full list of devices found on the platform bus:
>>
>>     s3c2410-ohci,
>>     s3c2410-lcd,
>>     s3c2410-wdt,
>>     s3c2410-i2c,
>>     s3c24xx-iis,
>>     s3c2410-nand,
>>     s3c24xx_led,
>>     s3c2410-uart,
>>
>> You see, in the list, there is no a device looks like ax88796. All these
>> already existed devices on the platform bus are build-in peripherals on
>> the SoC of s3c2410, they are compiled into the code by enabling some
>> kernel configuration options.
>>
>> My question is, in terms of Linux driver technology, how to enable a
>> non-PCI and not on-chip device driver? I think the ax_probe function
>> must be called somehow, is this thinking right? If yes, I think before
>> the driver get initialized, the corresponding device has to appear on
>> the bus, but now it seems not.
>>
>> Thanks in advance.
>>
>> --
>> woody
>> I can't go back to yesterday - because I was a different person then.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Cheers,
>
> mbe
>
> --
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
>
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> twitter: #opennandra
> web: http://open-nandra.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
