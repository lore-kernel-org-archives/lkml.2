Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0JRNzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:55:08 -0400
Received: from lo.gmane.org ([80.91.229.12]:54873 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921Ab0JRNzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:55:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Darius Augulis <augulis.darius@gmail.com>
Subject: Re: [PATCH 2/9 v2] ARM: S3C64XX: add nand support for mach-real6410
Date: Mon, 18 Oct 2010 16:50:45 +0300
Message-ID: <4CBC50B5.5090006@gmail.com>
References: <20100929192354.25307.40197.stgit@darius-desktop> <20100929193134.25307.65614.stgit@darius-desktop> <04a401cb6ec7$b8291b00$287b5100$%kim@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 85-255-63-153.ip.kis.lt
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
In-Reply-To: <04a401cb6ec7$b8291b00$287b5100$%kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 04:23 PM, Kukjin Kim wrote:
> Darius Augulis wrote:
>>
>> Add nand device support and mtd partition table
>> for mach-real6410
>>
>> Signed-off-by: Darius Augulis<augulis.darius@gmail.com>
>> ---
>>
>> Changelog since v1:
>>   - Changed dependency on other patches
>>
>>   arch/arm/mach-s3c64xx/Kconfig         |    1 +
>>   arch/arm/mach-s3c64xx/mach-real6410.c |   40
>> +++++++++++++++++++++++++++++++++
>>   2 files changed, 41 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
>> index 3bbd418..e4aede1 100644
>> --- a/arch/arm/mach-s3c64xx/Kconfig
>> +++ b/arch/arm/mach-s3c64xx/Kconfig
>> @@ -106,6 +106,7 @@ config MACH_REAL6410
>>   	select S3C64XX_SETUP_SDHCI
>>   	select S3C_DEV_FB
>>   	select S3C64XX_SETUP_FB_24BPP
>> +	select S3C_DEV_NAND
>>   	help
>>   	  Machine support for the CoreWind REAL6410
>>
>> diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-
>> s3c64xx/mach-real6410.c
>> index bed75d2..9fd943d 100644
>> --- a/arch/arm/mach-s3c64xx/mach-real6410.c
>> +++ b/arch/arm/mach-s3c64xx/mach-real6410.c
>> @@ -19,6 +19,8 @@
>>   #include<linux/kernel.h>
>>   #include<linux/list.h>
>>   #include<linux/dm9000.h>
>> +#include<linux/mtd/mtd.h>
>> +#include<linux/mtd/partitions.h>
>>   #include<linux/platform_device.h>
>>   #include<linux/serial_core.h>
>>   #include<linux/types.h>
>> @@ -37,6 +39,7 @@
>>   #include<plat/cpu.h>
>>   #include<plat/devs.h>
>>   #include<plat/fb.h>
>> +#include<plat/nand.h>
>>   #include<plat/regs-serial.h>
>>
>>   #include<video/platform_lcd.h>
>> @@ -147,11 +150,47 @@ static struct s3c_fb_platdata real6410_lcd_pdata
>> __initdata = {
>>   	.vidcon1	= VIDCON1_INV_HSYNC | VIDCON1_INV_VSYNC,
>>   };
>>
>> +static struct mtd_partition real6410_nand_part[] = {
>> +	[0] = {
>> +		.name	= "uboot",
>> +		.size	= SZ_1M,
>> +		.offset	= 0,
>> +	},
>> +	[1] = {
>> +		.name	= "kernel",
>> +		.size	= SZ_2M,
>> +		.offset	= SZ_1M,
>> +	},
>> +	[2] = {
>> +		.name	= "rootfs",
>> +		.size	= MTDPART_SIZ_FULL,
>> +		.offset	= SZ_1M + SZ_2M,
>> +	},
>> +};
>> +
>> +static struct s3c2410_nand_set real6410_nand_sets[] = {
>> +	[0] = {
>> +		.name		= "nand",
>> +		.nr_chips	= 1,
>> +		.nr_partitions	= ARRAY_SIZE(real6410_nand_part),
>> +		.partitions	= real6410_nand_part,
>> +	},
>> +};
>> +
>> +static struct s3c2410_platform_nand real6410_nand_info = {
>> +	.tacls		= 25,
>> +	.twrph0		= 55,
>> +	.twrph1		= 40,
>> +	.nr_sets	= ARRAY_SIZE(real6410_nand_sets),
>> +	.sets		= real6410_nand_sets,
>> +};
>> +
>>   static struct platform_device *real6410_devices[] __initdata = {
>>   	&real6410_device_eth,
>>   	&s3c_device_hsmmc0,
>>   	&s3c_device_hsmmc1,
>>   	&s3c_device_fb,
>> +	&s3c_device_nand,
>>   };
>>
>>   static void __init real6410_map_io(void)
>> @@ -249,6 +288,7 @@ static void __init real6410_machine_init(void)
>>   		real6410_lcd_pdata.win[0]->win_mode.yres);
>>
>>   	s3c_fb_set_platdata(&real6410_lcd_pdata);
>> +	s3c_nand_set_platdata(&real6410_nand_info);
>>
>>   	/* configure nCS1 width to 16 bits */
>>
> Where is 'END' of patch mark?
> maybe broken your patch file...?

Confused. What 'END' mark are you missing?
All patches are sent by stg mail, all apply fine, no conflict or other 
messages from stgit.
Please explain what you mean.

>
> Others, looks ok to me.
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim<kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>


