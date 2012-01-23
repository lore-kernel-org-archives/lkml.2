Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2AWRu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:50:26 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26373 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AWRuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:50:24 -0500
Date: Mon, 23 Jan 2012 18:50:22 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
In-reply-to: <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        =?UTF-8?B?IidcIuuwleqyveuvvA==?=
	 =?UTF-8?B?L01vYmlsZSBTL1cgUGxhdGZvcm0gTGFiKERNQ+yXsCkvRTUo7LGF7J6EKS/sgrw=?=
	 =?UTF-8?B?7ISx7KCE7J6QXCInIg==?= <kyungmin.park@samsung.com>
Message-id: <4F1D9DDE.2070106@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
 <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.01.2012 08:35, Thomas Abraham wrote:

Hi!

> Add device tree based discovery support for max8997.

> +static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
> +					struct max8997_platform_data *pdata)
> +{
...
> +	pdata->regulators = rdata;
> +	for_each_child_of_node(regulators_np, reg_np) {
> +		for (i = 0; i<  ARRAY_SIZE(regulators); i++)
> +			if (!of_node_cmp(reg_np->name, regulators[i].name))
> +				break;

If I read your patch correctly it would impossible to configure 
following outputs when pmic is instantiated from DT:

     enum max8998_regulators {
     ...
  1    MAX8997_EN32KHZ_AP,
  2    MAX8997_EN32KHZ_CP,
  3    MAX8997_CHARGER_CV,
  4    MAX8997_CHARGER_TOPOFF, /* MBCCTRL5 */

This is due to use of embedded spaces in regulator names (which are used 
in comparision).

This can be fixed with trivial patch[1].

What bothers me more, are following regulators:

       MAX8997_EN32KHZ_AP,
       MAX8997_EN32KHZ_CP,
       MAX8997_ENVICHG,
       MAX8997_ESAFEOUT1,
       MAX8997_ESAFEOUT2,

Aren't these fixed? i.e. - is it really needed to configure these either 
by platform data or DT at all?


[1]

 From 5cfba526210bc596c7d14e33fea93648baa0a227 Mon Sep 17 00:00:00 2001
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Date: Mon, 23 Jan 2012 17:20:25 +0100
Subject: [PATCH] max8997: Avoid spaces in regulator names

max8997-pmic instantiated from device tree uses names,
not numerical ids to distinguish between outputs.

Use names without spaces to make it possible to specify
parameters for said regulators in DTS.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
  drivers/regulator/max8997.c |    8 ++++----
  1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 053d0b7..4b572eb 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -910,13 +910,13 @@ static struct regulator_desc regulators[] = {
         },
         regulator_desc_buck(7),
         {
-               .name   = "EN32KHz AP",
+               .name   = "EN32KHz_AP",
                 .id     = MAX8997_EN32KHZ_AP,
                 .ops    = &max8997_fixedvolt_ops,
                 .type   = REGULATOR_VOLTAGE,
                 .owner  = THIS_MODULE,
         }, {
-               .name   = "EN32KHz CP",
+               .name   = "EN32KHz_CP",
                 .id     = MAX8997_EN32KHZ_CP,
                 .ops    = &max8997_fixedvolt_ops,
                 .type   = REGULATOR_VOLTAGE,
@@ -940,7 +940,7 @@ static struct regulator_desc regulators[] = {
                 .type   = REGULATOR_VOLTAGE,
                 .owner   = THIS_MODULE,
         }, {
-               .name   = "CHARGER CV",
+               .name   = "CHARGER_CV",
                 .id     = MAX8997_CHARGER_CV,
                 .ops    = &max8997_fixedstate_ops,
                 .type   = REGULATOR_VOLTAGE,
@@ -952,7 +952,7 @@ static struct regulator_desc regulators[] = {
                 .type   = REGULATOR_CURRENT,
                 .owner   = THIS_MODULE,
         }, {
-               .name   = "CHARGER TOPOFF",
+               .name   = "CHARGER_TOPOFF",
                 .id     = MAX8997_CHARGER_TOPOFF,
                 .ops    = &max8997_charger_fixedstate_ops,
                 .type   = REGULATOR_CURRENT,
-- 
1.7.8.3

