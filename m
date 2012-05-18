Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967344Ab2ERUhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:37:11 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2301 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965278Ab2ERUhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:37:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 18 May 2012 13:36:56 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@slimlogic.co.uk>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/3] mfd: save device node parsed platform data for sub devices
Date: Sat, 19 May 2012 02:01:41 +0530
Message-ID: <1337373103-23933-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337373103-23933-1-git-send-email-ldewangan@nvidia.com>
References: <1337373103-23933-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the allocated memory to store the parsed device node information
to the global device structure so that sub devices can directly use this
pointer.
In this way, the sub devices does not require to re-allocate the
memory for storing the sub-devices specific device node information.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65910.c       |    6 +++++-
 include/linux/mfd/tps65910.h |    3 +++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 18b30cf..05d449b 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -209,14 +209,17 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 {
 	struct tps65910 *tps65910;
 	struct tps65910_board *pmic_plat_data;
+	struct tps65910_board *of_pmic_plat_data = NULL;
 	struct tps65910_platform_data *init_data;
 	int ret = 0;
 	int chip_id = id->driver_data;
 
 	pmic_plat_data = dev_get_platdata(&i2c->dev);
 
-	if (!pmic_plat_data && i2c->dev.of_node)
+	if (!pmic_plat_data && i2c->dev.of_node) {
 		pmic_plat_data = tps65910_parse_dt(i2c, &chip_id);
+		of_pmic_plat_data = pmic_plat_data;
+	}
 
 	if (!pmic_plat_data)
 		return -EINVAL;
@@ -229,6 +232,7 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 	if (tps65910 == NULL)
 		return -ENOMEM;
 
+	tps65910->of_plat_data = of_pmic_plat_data;
 	i2c_set_clientdata(i2c, tps65910);
 	tps65910->dev = &i2c->dev;
 	tps65910->i2c_client = i2c;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index ab04e90..dd8dc0a 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -830,6 +830,9 @@ struct tps65910 {
 	struct tps65910_rtc *rtc;
 	struct tps65910_power *power;
 
+	/* Device node parsed board data */
+	struct tps65910_board *of_plat_data;
+
 	/* IRQ Handling */
 	struct mutex irq_lock;
 	int chip_irq;
-- 
1.7.1.1

