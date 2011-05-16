Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1EPHPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:15:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61611 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1EPHPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:15:39 -0400
X-AuditID: cbfee60e-b7c46ae00000121c-ce-4dd0cf176ff9
Date: Mon, 16 May 2011 07:15:35 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] regulator: Simplify
 MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS macros
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110516065919475@myungjoo.ham
Msgkey: 20110516065919475@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110516065919475@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25864346.87131305530134778.JavaMail.weblogic@epml26>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4G7Fn7F023230

Hello,

> Sender : Axel Lin<axel.lin@gmail.com>
> Date : 2011-05-16 15:52 (GMT+09:00)
> Title : [PATCH] regulator: Simplify MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS macros
> 
> Looks like the original macro implementation assumes the caller pass the
> parameter starting from 1.
> Since now we have +1 operation from all the caller, it would be easier to
> assume the caller pass the parameter starting from 0.
> Then we can simplify the +1 operation from the caller and then -1 operation
> in the macro implementation.
> 
> I think this change also improves readability.
> 
> Signed-off-by: Axel Lin 

Well, I'd rather just change the for loop statement for your purpose, which I also agree.

The reason I've used BUCKxDVS1 as the starting point is because of the register names; register names of BUCKxDVS starts from 1, not from 0.

Thus, in order to maintain the consistency between the code and the chip manual, I'd rather not change that part, but change like this:

---
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index b1c1444..aad85e4 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -1031,12 +1031,12 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 	}
 
 	/* For the safety, set max voltage before setting up */
-	for (i = 0; i < 8; i++) {
-		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i + 1),
+	for (i = 1; i <= 8; i++) {
+		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i),
 				max_buck1, 0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i + 1),
+		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i),
 				max_buck2, 0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i + 1),
+		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i),
 				max_buck5, 0x3f);
 	}

--
1.7.4.1

How about this one?

> ---
> drivers/regulator/max8997.c         |   12 ++++++------
> include/linux/mfd/max8997-private.h |    6 +++---
> 2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index b1c1444..664a31f 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
> @@ -1032,11 +1032,11 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
> 
> /* For the safety, set max voltage before setting up */
> for (i = 0; i < 8; i++) {
> - max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i + 1),
> + max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i),
> max_buck1, 0x3f);
> - max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i + 1),
> + max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i),
> max_buck2, 0x3f);
> - max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i + 1),
> + max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i),
> max_buck5, 0x3f);
> }
> 
> @@ -1113,13 +1113,13 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
> 
> /* Initialize all the DVS related BUCK registers */
> for (i = 0; i < 8; i++) {
> - max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i + 1),
> + max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i),
> max8997->buck1_vol[i],
> 0x3f);
> - max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i + 1),
> + max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i),
> max8997->buck2_vol[i],
> 0x3f);
> - max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i + 1),
> + max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i),
> max8997->buck5_vol[i],
> 0x3f);
> }
> diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
> index 69d1010..bf580a4 100644
> --- a/include/linux/mfd/max8997-private.h
> +++ b/include/linux/mfd/max8997-private.h
> @@ -311,9 +311,9 @@ enum max8997_irq {
> MAX8997_IRQ_NR,
> };
> 
> -#define MAX8997_REG_BUCK1DVS(x) (MAX8997_REG_BUCK1DVS1 + (x) - 1)
> -#define MAX8997_REG_BUCK2DVS(x) (MAX8997_REG_BUCK2DVS1 + (x) - 1)
> -#define MAX8997_REG_BUCK5DVS(x) (MAX8997_REG_BUCK5DVS1 + (x) - 1)
> +#define MAX8997_REG_BUCK1DVS(x) (MAX8997_REG_BUCK1DVS1 + (x))
> +#define MAX8997_REG_BUCK2DVS(x) (MAX8997_REG_BUCK2DVS1 + (x))
> +#define MAX8997_REG_BUCK5DVS(x) (MAX8997_REG_BUCK5DVS1 + (x))
> 
> #define MAX8997_NUM_GPIO 12
> struct max8997_dev {
> -- 
> 1.7.1
> 
> 
> 
> 



 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
