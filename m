Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab2I1OYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:24:47 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:38394 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561Ab2I1OYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:24:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432Id6f1izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd25he5bhf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
Message-ID: <5065B534.7040602@freescale.com>
Date: Fri, 28 Sep 2012 11:33:24 -0300
From: Fabio Estevam <fabio.estevam@freescale.com>
Organization: Freescale Semiconductor
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Fabio Estevam <festevam@gmail.com>, <sameo@linux.intel.com>,
        Marek Vasut <marex@denx.de>, <ashish.jangam@kpitcummins.com>,
        <dchen@diasemi.com>, <arnd@arndb.de>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mfd: da9052-core:  Use regmap_irq_get_virq() and fix
 the probe
References: <1348797458-2562-1-git-send-email-festevam@gmail.com> <20120928104944.GB30869@opensource.wolfsonmicro.com>
In-Reply-To: <20120928104944.GB30869@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Mark Brown wrote:
> On Thu, Sep 27, 2012 at 10:57:38PM -0300, Fabio Estevam wrote:
> 
>> -	da9052->irq_base = regmap_irq_chip_get_base(da9052->irq_data);
>> +	da9052->irq = regmap_irq_get_virq(da9052->irq_data, DA9052_IRQ_ADC_EOM);
>>  
>> -	ret = request_threaded_irq(DA9052_IRQ_ADC_EOM, NULL, da9052_auxadc_irq,
>> +	if (da9052->irq < 0) {
>> +		ret = da9052->irq;
>> +		dev_err(da9052->dev, "regmap_irq_get_virq failed: %d\n", ret);
>> +		goto regmap_err;
>> +	}
>> +
>> +	ret = request_threaded_irq(da9052->irq, NULL, da9052_auxadc_irq,
> 
> This will fix the problem but the usage of da9052->irq here is very odd,
> normally that'd be the primary IRQ for the device but this is actually
> just the interrupt for the ADC.
> 
> Otherwise
> 
> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 

Would you prefer the version below? If so, I can send it as v3:

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index a0a62b2..4f74bf6 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -782,35 +782,41 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 
 	da9052->chip_id = chip_id;
 
-	if (!pdata || !pdata->irq_base)
-		da9052->irq_base = -1;
-	else
-		da9052->irq_base = pdata->irq_base;
-
 	ret = regmap_add_irq_chip(da9052->regmap, da9052->chip_irq,
 				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				  da9052->irq_base, &da9052_regmap_irq_chip,
+				  -1, &da9052_regmap_irq_chip,
 				  &da9052->irq_data);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(da9052->dev, "regmap_add_irq_chip failed: %d\n", ret);
 		goto regmap_err;
+	}
 
-	da9052->irq_base = regmap_irq_chip_get_base(da9052->irq_data);
+	da9052->irq = regmap_irq_get_virq(da9052->irq_data, 0);
 
-	ret = request_threaded_irq(DA9052_IRQ_ADC_EOM, NULL, da9052_auxadc_irq,
+	if (da9052->irq < 0) {
+		ret = da9052->irq;
+		dev_err(da9052->dev, "regmap_irq_get_virq failed: %d\n", ret);
+		goto regmap_err;
+	}
+
+	ret = request_threaded_irq(da9052->irq + DA9052_IRQ_ADC_EOM, NULL, 
+				   da9052_auxadc_irq,
 				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   "adc irq", da9052);
+				   "adc-irq", da9052);
 	if (ret != 0)
 		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n", ret);
 
 	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
 			      ARRAY_SIZE(da9052_subdev_info), NULL, 0, NULL);
-	if (ret)
+	if (ret) {
+		dev_err(da9052->dev, "mfd_add_devices failed: %d\n", ret);
 		goto err;
+	}
 
 	return 0;
 
 err:
-	free_irq(DA9052_IRQ_ADC_EOM, da9052);
+	free_irq(da9052->irq + DA9052_IRQ_ADC_EOM, da9052);
 	mfd_remove_devices(da9052->dev);
 regmap_err:
 	return ret;
@@ -818,7 +824,7 @@ regmap_err:
 
 void da9052_device_exit(struct da9052 *da9052)
 {
-	free_irq(DA9052_IRQ_ADC_EOM, da9052);
+	free_irq(da9052->irq + DA9052_IRQ_ADC_EOM, da9052);
 	regmap_del_irq_chip(da9052->chip_irq, da9052->irq_data);
 	mfd_remove_devices(da9052->dev);
 }
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 0507c4c..f0b259d 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -99,6 +99,7 @@ struct da9052 {
 	u8 chip_id;
 
 	int chip_irq;
+	int irq;
 };
 
 /* ADC API */

