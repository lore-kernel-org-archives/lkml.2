Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2KGPjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:39:54 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45615 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab2KGPjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:39:52 -0500
Message-ID: <509A80A9.7050800@ti.com>
Date: Wed, 7 Nov 2012 10:39:21 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <hs@denx.de>, <nsekhar@ti.com>, <mikedunn@newsguy.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>,
        <hdoyu@nvidia.com>
Subject: Re: [RFC v2 PATCH 1/2] memory: davinci - add aemif controller platform
 driver
References: <1352238427-26085-1-git-send-email-m-karicheri2@ti.com> <1352238427-26085-2-git-send-email-m-karicheri2@ti.com> <5099AFF6.50400@ti.com>
In-Reply-To: <5099AFF6.50400@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santhosh,

Thanks for the review. Some of the comments below applies to the 
original code as this driver is moved from mach-davinci to memory. I 
will fix them though. See below my response.
>> +
>> +    curr_cs_data = get_cs_data(chip_cs);
>> +    if (curr_cs_data) {
>> +        /* for configuration we use cs since it is used to index ACR */
>> +        ret = davinci_aemif_config_abus(chip_cs, aemif->base, data);
>> +        if (!ret) {
>> +            *curr_cs_data = *data;
>> +            return 0;
>> +        }
>> +    }
>> +
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL(davinci_aemif_set_abus_params);
>> +
> Who is the user of this EXPORT ?
Mostly not needed, but there is a use case for connecting FPGA that 
needs to do the configuration dynamically I guess. Want to hear from 
others if this is needed? Same for below comment. May be we can remove 
this now and add it later if needed.
>
>> +/**
>> + * davinci_aemif_get_abus_params - Get bus configuration data for a 
>> given cs
>> + * @cs: chip-select, values 2-5
>> + * returns: ptr to a struct having the current configuration data
>> + */
>> +struct davinci_aemif_cs_data *davinci_aemif_get_abus_params(unsigned 
>> int cs)
>> +{
>> +    /* translate to chip CS which starts at 2 */
>> +    return get_cs_data(cs + 2);
>> +}
>> +EXPORT_SYMBOL(davinci_aemif_get_abus_params);
>> +
> This one too.
>
> [...]
>
>> +static int __devinit davinci_aemif_probe(struct platform_device *pdev)
>> +{
>> +    struct davinci_aemif_pdata *cfg;
>> +    int ret  = -ENODEV, i;
>> +    struct resource *res;
>> +
>> +    aemif = devm_kzalloc(&pdev->dev, sizeof(*aemif), GFP_KERNEL);
>> +
>> +    if (!aemif)
>> +        return -ENOMEM;
>> +
>> +    aemif->clk = clk_get(NULL, "aemif");
> Please use dev attributes. Above usage of clk_get isn't recommonded
> in drivers. You might have to add alias entries in your clock data for
> it to work though.
>
Need to investigate.
>> +    if (IS_ERR(aemif->clk))
>> +        return PTR_ERR(aemif->clk);
>> +
>> +    clk_prepare_enable(aemif->clk);
>> +    aemif->clk_rate = clk_get_rate(aemif->clk) / 1000;
>> +
> /1000 for what ? Converting it into KHz ?
>
Yes. WIll add a comment.
>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +    if (!res) {
>> +        pr_err("No IO memory address defined\n");
>> +        goto error;
>> +    }
>> +
>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +
>> +    aemif->base = devm_request_and_ioremap(&pdev->dev, res);
>> +    if (!aemif->base) {
>> +        ret = -EBUSY;
>> +        pr_err("ioremap failed\n");
>> +        goto error;
>> +    }
>> +
>> +    if (pdev->dev.platform_data == NULL) {
>> +        /* Not platform data, we get the cs data from the cs nodes */
>> +        cfg = devm_kzalloc(&pdev->dev, sizeof(*cfg), GFP_KERNEL);
>> +        if (cfg == NULL)
>> +            return -ENOMEM;
>> +
>> +        aemif->cfg = cfg;
>> +        if (of_davinci_aemif_cs_init(pdev->dev.of_node) < 0) {
>> +            pr_err("No platform data or cs of node present\n");
>> +            goto error;
>> +        }
>> +    } else {
>> +        cfg = pdev->dev.platform_data;
>> +        aemif->cfg = cfg;
>> +    }
>> +
>> +    for (i = 0; i < cfg->num_cs; i++) {
>> +        /* cs is from 2-5. Internally we use cs-2 to access ACR */
>> +        ret = davinci_aemif_config_abus(cfg->cs_data[i].cs - 2,
>> +                aemif->base, &cfg->cs_data[i]);
>> +        if (ret < 0) {
>> +            pr_err("Error configuring chip select %d\n",
>> +                cfg->cs_data[i].cs);
>> +            goto error;
>> +        }
>> +    }
>> +    return 0;
>> +error:
>> +    clk_disable_unprepare(aemif->clk);
>> +    clk_put(aemif->clk);
> Alos unmap 'aemif->base' here..
>
I thought devm_ API do this automatically. I will check.
>> +    return ret;
>> +}
>> +
>> +static struct platform_driver davinci_aemif_driver = {
>> +    .probe = davinci_aemif_probe,
>> +    .driver = {
>> +        .name = DRV_NAME,
>> +        .owner = THIS_MODULE,
>> +        .of_match_table = davinci_aemif_of_match,
>> +    },
>> +};
>> +
>> +static int __init davinci_aemif_init(void)
>> +{
>> +    return platform_driver_register(&davinci_aemif_driver);
>> +}
>> +subsys_initcall(davinci_aemif_init);
>> +
>> +static void __exit davinci_aemif_exit(void)
>> +{
>> +    clk_disable_unprepare(aemif->clk);
>> +    clk_put(aemif->clk);
>> +    platform_driver_unregister(&davinci_aemif_driver);
>> +}
>> +module_exit(davinci_aemif_exit);
>> +
>> +MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");
>> +MODULE_DESCRIPTION("Texas Instruments AEMIF driver");
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_ALIAS("platform:" DRV_NAME);
>> diff --git a/include/linux/platform_data/davinci-aemif.h 
>> b/include/linux/platform_data/davinci-aemif.h
>> new file mode 100644
>> index 0000000..03f3ad0
>> --- /dev/null
>> +++ b/include/linux/platform_data/davinci-aemif.h
>> @@ -0,0 +1,47 @@
>> +/*
>> + * TI DaVinci AEMIF support
>> + *
>> + * Copyright 2010 (C) Texas Instruments, Inc. http://www.ti.com/
>> + *
> s/2010/2012
>> + * This file is licensed under the terms of the GNU General Public 
>> License
>> + * version 2. This program is licensed "as is" without any warranty 
>> of any
>> + * kind, whether express or implied.
>> + */
>> +#ifndef _MACH_DAVINCI_AEMIF_H
>> +#define _MACH_DAVINCI_AEMIF_H
> Fix the header guard as per new directory
>
Ok.
> Regards
> Santosh
>
>

