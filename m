Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3ACKrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:47:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6842 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3ACKr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:47:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 Jan 2013 02:43:28 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <linus.walleij@linaro.org>,
        <grant.likely@secretlab.ca>, <akpm@linux-foundation.org>
CC: <a.zummo@towertech.it>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] mfd: palmas: add rtc irq number as irq resource for palmas-rtc
Date: Thu, 3 Jan 2013 16:16:57 +0530
Message-ID: <1357210020-19876-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palma RTC is capable of generating alarm interrupt. Pass the alarm interrupt
as IRQ_RESOURCE for palmas-rtc sub device driver so that rtc driver can get
irq as platform_get_irq().

Also pass the irq domain in mfd_add_devices() to properly offset the irqs for
sub devices. This is needed when adding device through DT.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/palmas.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 6ffd7a2..bbdbc50 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -39,6 +39,14 @@ enum palmas_ids {
 	PALMAS_USB_ID,
 };
 
+static struct resource palmas_rtc_resources[] = {
+	{
+		.start  = PALMAS_RTC_ALARM_IRQ,
+		.end    = PALMAS_RTC_ALARM_IRQ,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
 static const struct mfd_cell palmas_children[] = {
 	{
 		.name = "palmas-pmic",
@@ -59,6 +67,8 @@ static const struct mfd_cell palmas_children[] = {
 	{
 		.name = "palmas-rtc",
 		.id = PALMAS_RTC_ID,
+		.resources = &palmas_rtc_resources[0],
+		.num_resources = ARRAY_SIZE(palmas_rtc_resources),
 	},
 	{
 		.name = "palmas-pwrbutton",
@@ -456,8 +466,8 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 
 	ret = mfd_add_devices(palmas->dev, -1,
 			      children, ARRAY_SIZE(palmas_children),
-			      NULL, regmap_irq_chip_get_base(palmas->irq_data),
-			      NULL);
+			      NULL, 0,
+			      regmap_irq_get_domain(palmas->irq_data));
 	kfree(children);
 
 	if (ret < 0)
-- 
1.7.1.1

