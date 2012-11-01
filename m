Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936066Ab2KAQV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 12:21:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36923 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab2KAQVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:21:53 -0400
Message-ID: <5092A156.4000601@ti.com>
Date: Thu, 1 Nov 2012 18:20:38 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ARM: OMAP4: ID: Improve features detection and check
References: <1351765401-12487-1-git-send-email-ivan.khoronzhuk@ti.com> <50925E7F.7080602@ti.com>
In-Reply-To: <50925E7F.7080602@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.123]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 01:35 PM, Santosh Shilimkar wrote:
> On Thursday 01 November 2012 03:53 PM, Ivan Khoronzhuk wrote:
>> Replaces several flags bearing the same meaning. There is no need
>> to set flags due to different omap types here, it can be checked
>> in appropriate places as well.
>>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: linux-omap@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>>   arch/arm/mach-omap2/id.c  |   25 +++++++------------------
>>   arch/arm/mach-omap2/soc.h |    8 ++------
>>   2 files changed, 9 insertions(+), 24 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
>> index cf2362c..3c47a19 100644
>> --- a/arch/arm/mach-omap2/id.c
>> +++ b/arch/arm/mach-omap2/id.c
>> @@ -28,6 +28,9 @@
>>   #include "soc.h"
>>   #include "control.h"
>>
>> +#define OMAP4_SILICON_TYPE_STANDARD        0x01
>> +#define OMAP4_SILICON_TYPE_PERFORMANCE        0x02
>> +
>>   static unsigned int omap_revision;
>>   static const char *cpu_rev;
>>   u32 omap_features;
>> @@ -273,25 +276,11 @@ void __init omap4xxx_check_features(void)
>>   {
>>       u32 si_type;
>>
>> -    if (cpu_is_omap443x())
>> -        omap_features |= OMAP4_HAS_MPU_1GHZ;
>> -
>> +    si_type =
>> +    (read_tap_reg(OMAP4_CTRL_MODULE_CORE_STD_FUSE_PROD_ID_1) >> 16) 
>> & 0x03;
>>
>> -    if (cpu_is_omap446x()) {
>> -        si_type =
>> - read_tap_reg(OMAP4_CTRL_MODULE_CORE_STD_FUSE_PROD_ID_1);
>> -        switch ((si_type & (3 << 16)) >> 16) {
>> -        case 2:
>> -            /* High performance device */
>> -            omap_features |= OMAP4_HAS_MPU_1_5GHZ;
>> -            break;
>> -        case 1:
>> -        default:
>> -            /* Standard device */
>> -            omap_features |= OMAP4_HAS_MPU_1_2GHZ;
>> -            break;
>> -        }
>> -    }
>> +    if (si_type == OMAP4_SILICON_TYPE_PERFORMANCE)
>> +        omap_features = OMAP4_HAS_PERF_SILICON;
>
> Well the detection isn't for performance/standard but there are some
> features depend on it. For example 1 GHz doesn't DPLL DCC enable feature
> where as 1.2 GHz, 1.5 GHz doesn't need. This is the main reason this
> information is also effused. Have you considered this aspect while
> creating this patch ?
>
> Regards
> Santosh
>

I had considered it. There is no dependency on the features.
DCC usage depends on asked frequency on the fly, not from the features.
Depending on "performance/standard" feature the available frequencies
should be chosen in places where they are needed, for example while
initializing OPPs.

Currently we have several features while it is only one indeed.


-- 
Regards,
Ivan Khoronzhuk

