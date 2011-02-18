Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1BRHMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 02:12:31 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43293 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1BRHM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 02:12:29 -0500
Message-ID: <B7287DA9F96B436894703FF6663F1E13@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Michael Williamson" <michael.williamson@criticallink.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Russell King" <linux@arm.linux.org.uk>,
        "Kevin Hilman" <khilman@deeprootsystems.com>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-12-git-send-email-subhasish@mistralsolutions.com> <4D555523.7040507@criticallink.com>
In-Reply-To: <4D555523.7040507@criticallink.com>
Subject: Re: [PATCH v2 11/13] da850: pruss SUART board specific additions.
Date: Fri, 18 Feb 2011 12:43:32 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------------------------------------------
From: "Michael Williamson" <michael.williamson@criticallink.com>
Sent: Friday, February 11, 2011 8:56 PM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>; 
<sachi@mistralsolutions.com>; "Russell King" <linux@arm.linux.org.uk>; 
"Kevin Hilman" <khilman@deeprootsystems.com>; "open list" 
<linux-kernel@vger.kernel.org>; <m-watkins@ti.com>; 
<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 11/13] da850: pruss SUART board specific additions.

> Hi Subhasish,
>
> On 2/11/2011 9:51 AM, Subhasish Ghosh wrote:
>
>> This patch adds the pruss SUART pin mux and registers the device
>> with the pruss mfd driver.
>>
>> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
>> ---
>>  arch/arm/mach-davinci/board-da850-evm.c |   36 
>> +++++++++++++++++++++++++++++++
>>  1 files changed, 36 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/board-da850-evm.c 
>> b/arch/arm/mach-davinci/board-da850-evm.c
>> index f9c38f8..3858516 100644
>> --- a/arch/arm/mach-davinci/board-da850-evm.c
>> +++ b/arch/arm/mach-davinci/board-da850-evm.c
>> @@ -1060,6 +1060,25 @@ const short da850_evm_pruss_can_pins[] = {
>>  -1
>>  };
>>
>> +const short da850_evm_pruss_suart_pins[] = {
>> + DA850_AHCLKX, DA850_ACLKX, DA850_AFSX,
>> + DA850_AHCLKR, DA850_ACLKR, DA850_AFSR,
>> + DA850_AXR_13, DA850_AXR_9, DA850_AXR_7,
>> + DA850_AXR_14, DA850_AXR_10, DA850_AXR_8,
>> + -1
>> +};
>> +
>
>
> Shouldn't this pins select PRU[0,1]_XXX type functions and not McASP 
> functions?
> E.G.: PRU0_R31[17] instead of AHCLKX, PRU0_R31[18] instead of AHCLKR, etc.
>

SG - The Soft-UART implementation uses the McASP as shift registers to push 
out the data sequentially.
            Hence, we configure the McASP PINS and not the PRU PINS.

>> +static int __init da850_evm_setup_pruss_suart(void)
>> +{
>> + int ret;
>> +
>> + ret = davinci_cfg_reg_list(da850_evm_pruss_suart_pins);
>> + if (ret)
>> + pr_warning("%s: da850_evm_pruss_suart_pins "
>> + "mux setup failed: %d\n", __func__, ret);
>> + return ret;
>> +}
>> +
>>  static int __init da850_evm_setup_pruss_can(void)
>>  {
>>  int ret, val = 0;
>> @@ -1085,6 +1104,17 @@ static int __init da850_evm_setup_pruss_can(void)
>>  return ret;
>>  }
>>
>> +static struct da850_evm_pruss_suart_data suart_data = {
>> + .version = 1,
>> + .resource = {
>> + .name = "da8xx_mcasp0_iomem",
>> + .start = DAVINCI_DA8XX_MCASP0_REG_BASE,
>> + .end = DAVINCI_DA8XX_MCASP0_REG_BASE +
>> + (SZ_1K * 12) - 1,
>> + .flags = IORESOURCE_MEM,
>> + },
>> +};
>> +
>>  static struct da8xx_pruss_can_data can_data = {
>>  .version = 1,
>>  };
>> @@ -1094,6 +1124,12 @@ static struct da8xx_pruss_devices pruss_devices[] 
>> = {
>>  .dev_name = "da8xx_pruss_can",
>>  .pdata = &can_data,
>>  .pdata_size = sizeof(can_data),
>> + .setup = da850_evm_setup_pruss_suart,
>
>
> Should this be da850_evm_setup_pruss_can instead?

SG - This just the way the patch is displayed. In the code the order is 
correct.

>
>> + },
>> + {
>> + .dev_name = "da8xx_pruss_uart",
>> + .pdata = &suart_data,
>> + .pdata_size = sizeof(suart_data),
>>  .setup = da850_evm_setup_pruss_can,
>
>
> Should this be da850_evm_setup_pruss_suart instead?
SG - Ditto
>
>>  },
>>  {
>
>
> -Mike
> 
