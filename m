Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab1BVG0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 01:26:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48237 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1BVG0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 01:26:19 -0500
Message-ID: <66FC4FA6F0A146B68ED19D473735C15D@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Sergei Shtylyov" <sshtylyov@mvista.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Russell King" <linux@arm.linux.org.uk>,
        "Kevin Hilman" <khilman@deeprootsystems.com>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-12-git-send-email-subhasish@mistralsolutions.com> <4D5584EC.4070506@mvista.com>
In-Reply-To: <4D5584EC.4070506@mvista.com>
Subject: Re: [PATCH v2 11/13] da850: pruss SUART board specific additions.
Date: Tue, 22 Feb 2011 11:52:08 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Have modified this as shown below:
Please let me know if this looks ok.

diff --git a/arch/arm/mach-davinci/board-da850-evm.c 
b/arch/arm/mach-davinci/board-da850-evm.c
+static struct da850_evm_pruss_can_data can_data = {
        .version        = 1,
 };

+static struct resource da850_evm_suart_resource[] = 
  ------------------------->>> Added a separate resource structure for 
suart.
+       {
+               .name   = "da8xx_mcasp0_iomem",
+               .start  = DAVINCI_DA8XX_MCASP0_REG_BASE,
+               .end    = DAVINCI_DA8XX_MCASP0_REG_BASE +
+                               (SZ_1K * 12) - 1,
+               .flags  = IORESOURCE_MEM,
+       },
+};
+
 static struct da8xx_pruss_devices pruss_devices[] = {
        {
                .dev_name       = "da8xx_pruss_can",
                .pdata          = &can_data,
                .pdata_size     = sizeof(can_data),
                .setup          = da850_evm_setup_pruss_can,
+               .num_resources  = 0,
+               .resources      = NULL,
        },
        {
                .dev_name       = "da8xx_pruss_uart",
                .pdata          = &suart_data,
                .pdata_size     = sizeof(suart_data),
                .setup          = da850_evm_setup_pruss_suart,
+               .num_resources  = ARRAY_SIZE(da850_evm_suart_resource),
+               .resources      = 
a850_evm_suart_resource,  ---------------------------- >>>>> Initialized it 
here
        },
        {
                .dev_name       = NULL,


diff --git a/drivers/mfd/da8xx_pru.c b/drivers/mfd/da8xx_pru.c
index f7868a4..140bf14 100644
--- a/drivers/mfd/da8xx_pru.c
+++ b/drivers/mfd/da8xx_pru.c
@@ -332,6 +332,8 @@ static int pruss_mfd_add_devices(struct platform_device 
*pdev)
                cell.name               = (dev_data + count)->dev_name;
                cell.platform_data      = (dev_data + count)->pdata;
                cell.data_size          = (dev_data + count)->pdata_size;
+               cell.resources          = (dev_data + 
ount)->resources;  ---------------------->>>Modified the MFD driver to add 
the resources.
+               cell.num_resources      = (dev_data + count)->num_resources;


diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart.c 
b/drivers/tty/serial/da8xx_pruss/pruss_suart.c

+       res = platform_get_resource(pdev, IORESOURCE_MEM, 
0); ------------------>> Used platform infrastructure to get the data.
+       if (!res) {
+               dev_err(&pdev->dev, "Failed to get resource");
+               return -ENOMEM;
+       }
+
+       if (!request_mem_region(res->start,
+                       resource_size(res),



--------------------------------------------------
From: "Sergei Shtylyov" <sshtylyov@mvista.com>
Sent: Saturday, February 12, 2011 12:20 AM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>; 
<sachi@mistralsolutions.com>; "Russell King" <linux@arm.linux.org.uk>; 
"Kevin Hilman" <khilman@deeprootsystems.com>; <nsekhar@ti.com>; "open list" 
<linux-kernel@vger.kernel.org>; <m-watkins@ti.com>; 
<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 11/13] da850: pruss SUART board specific additions.

> Subhasish Ghosh wrote:
>
>> This patch adds the pruss SUART pin mux and registers the device
>> with the pruss mfd driver.
>
>> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
>> ---
>>  arch/arm/mach-davinci/board-da850-evm.c |   36 
>> +++++++++++++++++++++++++++++++
>>  1 files changed, 36 insertions(+), 0 deletions(-)
>
>> diff --git a/arch/arm/mach-davinci/board-da850-evm.c 
>> b/arch/arm/mach-davinci/board-da850-evm.c
>> index f9c38f8..3858516 100644
>> --- a/arch/arm/mach-davinci/board-da850-evm.c
>> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> [...]
>> @@ -1085,6 +1104,17 @@ static int __init da850_evm_setup_pruss_can(void)
>>  return ret;
>>  }
>>  +static struct da850_evm_pruss_suart_data suart_data = {
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
>
>    I don't think passing a resource thru platform data is good idea... 
> Resources should be bound to the platform device.
>
> WBR, Sergei 

