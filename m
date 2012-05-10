Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab2EJNtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:49:12 -0400
Received: from lmv.inov.pt ([146.193.64.2]:33298 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759404Ab2EJNtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:49:08 -0400
Message-ID: <4FABC720.5090301@inov.pt>
Date: Thu, 10 May 2012 14:48:16 +0100
From: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?= 
	<jose.goncalves@inov.pt>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: SAMSUNG: Fix for S3C2412 EBI memory mapping.
References: <1336607209-6409-1-git-send-email-jose.goncalves@inov.pt> <036701cd2e8e$cf4cc100$6de64300$%kim@samsung.com>
In-Reply-To: <036701cd2e8e$cf4cc100$6de64300$%kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (lmv.inov.pt [146.193.64.2]); Thu, 10 May 2012 14:48:04 +0100 (WEST)
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-05-2012 10:25, Kukjin Kim wrote:
> José Miguel Gonçalves wrote:
>> While upgrading the kernel on a S3C2412 based board I've noted that it was
>> impossible to boot the board with a 2.6.32 or upper kernel.
>> I've tracked down the problem to the EBI virtual memory mapping that is in
>> conflict with the IO mapping definition in arch/arm/mach-s3c24xx/s3c2412.c.
>>
>> Signed-off-by: José Miguel Gonçalves<jose.goncalves@inov.pt>
>> ---
>>   arch/arm/plat-samsung/include/plat/map-s3c.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/plat-samsung/include/plat/map-s3c.h b/arch/arm/plat-
>> samsung/include/plat/map-s3c.h
>> index 7d04875..c0c70a8 100644
>> --- a/arch/arm/plat-samsung/include/plat/map-s3c.h
>> +++ b/arch/arm/plat-samsung/include/plat/map-s3c.h
>> @@ -22,7 +22,7 @@
>>   #define S3C24XX_VA_WATCHDOG	S3C_VA_WATCHDOG
>>
>>   #define S3C2412_VA_SSMC		S3C_ADDR_CPU(0x00000000)
>> -#define S3C2412_VA_EBI		S3C_ADDR_CPU(0x00010000)
>> +#define S3C2412_VA_EBI		S3C_ADDR_CPU(0x00100000)
>>
>>   #define S3C2410_PA_UART		(0x50000000)
>>   #define S3C24XX_PA_UART		S3C2410_PA_UART
>> --
>> 1.7.5.4
> Yeah, as you said, the mapping for SSMC invade EBI area but I think, just SZ_4K is enough for SSMC. So following is better in this case. How do you think? And there is no problem on your board?
>
> diff --git a/arch/arm/mach-s3c24xx/s3c2412.c b/arch/arm/mach-s3c24xx/s3c2412.c
> index d4bc7f9..ac906bf 100644
> --- a/arch/arm/mach-s3c24xx/s3c2412.c
> +++ b/arch/arm/mach-s3c24xx/s3c2412.c
> @@ -72,7 +72,7 @@ static struct map_desc s3c2412_iodesc[] __initdata = {
>   	{
>   		.virtual = (unsigned long)S3C2412_VA_SSMC,
>   		.pfn     = __phys_to_pfn(S3C2412_PA_SSMC),
> -		.length  = SZ_1M,
> +		.length  = SZ_4K,
>   		.type    = MT_DEVICE,
>   	},
>   	{
>

It does not work! I tried also a 64K length and also did not work. With your patch 
my console (with earlyprintk set) only displays the following:

## Booting image at 30800000 ...
    Image Name:   Linux-3.2.16-inov1
    Created:      2012-05-10  12:42:49 UTC
    Image Type:   ARM Linux Kernel Image (uncompressed)
    Data Size:    1202592 Bytes =  1.1 MB
    Load Address: 30008000
    Entry Point:  30008000
    Verifying Checksum ... OK
OK

Starting kernel ...

Uncompressing Linux... done, booting the kernel.
Linux version 3.2.16-inov1 (jmpg@st-ze) (gcc version 4.6.4 20120402 (prerelease) 
(crosstool-NG 1.15.2) ) #3 PREEMPT Thu May 10 13:42:48 WEST 2012
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: SMDK2412
bootconsole [earlycon0] enabled
Memory policy: ECC disabled, Data cache writeback
CPU S3C2412 (id 0x32412003)

My guess is that the MMU initialization on the S3C2412 chip only allows a minimum 
of 1MB for the page size.

Best regards,
José Gonçalves

