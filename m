Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0IACyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:54:47 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:64533 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0IACyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:54:46 -0400
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.56,301,1280721600"; 
   d="scan'208";a="21280841"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] regulator: ad5398 - fix a memory leak
Date: Wed, 1 Sep 2010 10:56:14 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA06CEDBBC@chinexm1.ad.analog.com>
In-Reply-To: <1283308158.23075.1.camel@mola>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] regulator: ad5398 - fix a memory leak
Thread-Index: ActJfQf0FpO/ZuELRLG07sey98qkbwAA0sVw
References: <1283308158.23075.1.camel@mola>
To: "Axel Lin" <axel.lin@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
CC: "Liam Girdwood" <lrg@slimlogic.co.uk>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>
X-OriginalArrivalTime: 01 Sep 2010 02:54:45.0000 (UTC) FILETIME=[085B4880:01CB4981]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Axel Lin [mailto:axel.lin@gmail.com] 
>Sent: Wednesday, September 01, 2010 10:29 AM
>To: linux-kernel
>Cc: Liam Girdwood; Mark Brown; Zhang, Sonic
>Subject: [PATCH] regulator: ad5398 - fix a memory leak
>
>In current implementation, the address return from 
>regulator_register() is different from the address for 
>regulator_unregister().
>

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

>Signed-off-by: Axel Lin <axel.lin@gmail.com>
>---
> drivers/regulator/ad5398.c |   12 ++++++------
> 1 files changed, 6 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/regulator/ad5398.c 
>b/drivers/regulator/ad5398.c index 15ff61d..a4be416 100644
>--- a/drivers/regulator/ad5398.c
>+++ b/drivers/regulator/ad5398.c
>@@ -25,7 +25,7 @@ struct ad5398_chip_info {
> 	unsigned int current_level;
> 	unsigned int current_mask;
> 	unsigned int current_offset;
>-	struct regulator_dev rdev;
>+	struct regulator_dev *rdev;
> };
> 
> static int ad5398_calc_current(struct ad5398_chip_info *chip, 
>@@ -211,7 +211,6 @@ MODULE_DEVICE_TABLE(i2c, ad5398_id);  
>static int __devinit ad5398_probe(struct i2c_client *client,
> 				const struct i2c_device_id *id)
> {
>-	struct regulator_dev *rdev;
> 	struct regulator_init_data *init_data = 
>client->dev.platform_data;
> 	struct ad5398_chip_info *chip;
> 	const struct ad5398_current_data_format *df = @@ -233,9 
>+232,10 @@ static int __devinit ad5398_probe(struct i2c_client *client,
> 	chip->current_offset = df->current_offset;
> 	chip->current_mask = (chip->current_level - 1) << 
>chip->current_offset;
> 
>-	rdev = regulator_register(&ad5398_reg, &client->dev, 
>init_data, chip);
>-	if (IS_ERR(rdev)) {
>-		ret = PTR_ERR(rdev);
>+	chip->rdev = regulator_register(&ad5398_reg, &client->dev,
>+					init_data, chip);
>+	if (IS_ERR(chip->rdev)) {
>+		ret = PTR_ERR(chip->rdev);
> 		dev_err(&client->dev, "failed to register %s %s\n",
> 			id->name, ad5398_reg.name);
> 		goto err;
>@@ -254,7 +254,7 @@ static int __devexit ad5398_remove(struct 
>i2c_client *client)  {
> 	struct ad5398_chip_info *chip = i2c_get_clientdata(client);
> 
>-	regulator_unregister(&chip->rdev);
>+	regulator_unregister(chip->rdev);
> 	kfree(chip);
> 
> 	return 0;
>--
>1.7.2
>
>
>
>
