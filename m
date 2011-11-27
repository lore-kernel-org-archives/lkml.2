Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1K0MBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:01:52 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34087 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560Ab1K0MBv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:01:51 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Nov 2011 07:01:51 EST
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111127113529.GG2896@opensource.wolfsonmicro.com>
References: <1322360030.6779.1.camel@phoenix> <20111127113529.GG2896@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 27 Nov 2011 19:56:20 +0800
Message-ID: <CAF+7xWk8f-qiodctY3U3FRJiohZzYNO4KaE7v5qi1C52HUySNg@mail.gmail.com>
Subject: Re: [PATCH] regulator: Avoid potential NULL dereference in reg_fixed_voltage_probe()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/27 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Sun, Nov 27, 2011 at 10:13:50AM +0800, Axel Lin wrote:
>
>> -     if (pdev->dev.of_node)
>> +     if (pdev->dev.of_node) {
>>               config = of_get_fixed_voltage_config(&pdev->dev);
>> +             if (!config)
>> +                     return -ENOMEM;
>> +     }
>
> Looking at this I'm thinking it's better to just drop the check for
> of_node entirely and just let of_get_fixed_voltage_config() fail to find
> what it needs.
>
In the case of pdev->dev.of_node == NULL, config points to
pdev->dev.platform_data.

Or do you prefer change it this way:

--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -163,12 +163,17 @@ static struct regulator_ops fixed_voltage_ops = {

 static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 {
-       struct fixed_voltage_config *config = pdev->dev.platform_data;
+       struct fixed_voltage_config *config;
        struct fixed_voltage_data *drvdata;
        int ret;

        if (pdev->dev.of_node)
                config = of_get_fixed_voltage_config(&pdev->dev);
+       else
+               config = pdev->dev.platform_data;
+
+       if (!config)
+               return -ENOMEM;

        drvdata = kzalloc(sizeof(struct fixed_voltage_data), GFP_KERNEL);
        if (drvdata == NULL) {
