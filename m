Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2BPLu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:50:28 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:60255 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab2BPLu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:50:27 -0500
Message-ID: <4F3CED7C.8060406@ti.com>
Date: Thu, 16 Feb 2012 17:20:20 +0530
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH 6/8] misc: emif: add interrupt and temperature handling
References: <1328357771-31644-1-git-send-email-aneesh@ti.com> <1328357771-31644-7-git-send-email-aneesh@ti.com> <4F3CDD5E.8020600@ti.com>
In-Reply-To: <4F3CDD5E.8020600@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 February 2012 04:11 PM, Santosh Shilimkar wrote:
> On Saturday 04 February 2012 05:46 PM, Aneesh V wrote:
>> Add an ISR for EMIF that:
>> 	1. reports details of access errors
>> 	2. takes action on thermal events
>>
>> On thermal events SDRAM timing parameters are
>> adjusted to ensure safe operation
>>
>> Also clear all interrupts on shut-down. Pending IRQs
>> may casue problems during warm-reset.
>>
> Add some more details like MR4, EMIF polling frequency etc
> for better understanding.

Will do.



>
>> Signed-off-by: Aneesh V<aneesh@ti.com>
>> ---
>>   drivers/misc/emif.c |  209 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 files changed, 207 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/misc/emif.c b/drivers/misc/emif.c
>> index 36ba6f4..5c2b0ae 100644
>> --- a/drivers/misc/emif.c
>> +++ b/drivers/misc/emif.c
>> @@ -500,6 +500,45 @@ static u32 get_pwr_mgmt_ctrl(u32 freq, struct emif_data *emif, u32 ip_rev)
>>   }
>>
>>   /*
>> + * Get the temperature level of the EMIF instance:
>> + * Reads the MR4 register of attached SDRAM parts to find out the temperature
>> + * level. If there are two parts attached(one on each CS), then the temperature
>> + * level for the EMIF instance is the higher of the two temperatures.
>> + */
>> +static void get_temperature_level(struct emif_data *emif)
>> +{
>> +	u32		temp, temperature_level;
>> +	unsigned long	irqs;
>> +	void __iomem	*base;
>> +
>> +	base = emif->base;
>> +
>> +	/* Read mode register 4 */
>> +	writel(DDR_MR4, base + EMIF_LPDDR2_MODE_REG_CONFIG);
>> +	temperature_level = readl(base + EMIF_LPDDR2_MODE_REG_DATA);
>> +	temperature_level = (temperature_level&  MR4_SDRAM_REF_RATE_MASK)>>
>> +				MR4_SDRAM_REF_RATE_SHIFT;
>> +
>> +	if (emif->plat_data->device_info->cs1_used) {
>> +		writel(DDR_MR4 | CS_MASK, base + EMIF_LPDDR2_MODE_REG_CONFIG);
>> +		temp = readl(base + EMIF_LPDDR2_MODE_REG_DATA);
>> +		temp = (temp&  MR4_SDRAM_REF_RATE_MASK)
>> +				>>  MR4_SDRAM_REF_RATE_SHIFT;
>> +		temperature_level = max(temp, temperature_level);
>> +	}
>> +
>> +	spin_lock_irqsave(&emif->lock, irqs);
> Add a line here.

Will do.

>> +	/* treat everything less than nominal(3) in MR4 as nominal */
>> +	if (unlikely(temperature_level<  SDRAM_TEMP_NOMINAL))
>> +		temperature_level = SDRAM_TEMP_NOMINAL;
>> +
>> +	/* if we get reserved value in MR4 persist with the existing value */
>> +	if (likely(temperature_level != SDRAM_TEMP_RESERVED_4))
>> +		emif->temperature_level = temperature_level;
>> +	spin_unlock_irqrestore(&emif->lock, irqs);
>> +}
>> +
>
> rest of the patch looks fine to me

Thanks,
Aneesh
