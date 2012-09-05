Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab2IEKEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:04:08 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:48913 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758426Ab2IEJ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:50 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 09/17] mfd: prcmu: add db9540 support
Date: Wed, 5 Sep 2012 11:59:05 +0200
Message-ID: <1346839153-6465-10-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Light modifications to add db9540 support
and ab9540 detection.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 3df427f..eb327f3 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2994,6 +2994,23 @@ static struct mfd_cell db8500_prcmu_devs[] = {
 	},
 };
 
+static struct mfd_cell db9540_prcmu_devs[] = {
+	{
+		.name = "db8500-prcmu-regulators",
+		.of_compatible = "stericsson,db8500-prcmu-regulator",
+		.platform_data = &db8500_regulators,
+		.pdata_size = sizeof(db8500_regulators),
+	},
+	{
+		.name = "ab9540-i2c",
+		.of_compatible = "stericsson,ab8500",
+		.num_resources = ARRAY_SIZE(ab8500_resources),
+		.resources = ab8500_resources,
+		.id = AB8500_VERSION_AB9540,
+	},
+};
+
+
 /**
  * prcmu_fw_init - arch init call for the Linux PRCMU fw init logic
  *
@@ -3035,11 +3052,16 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (cpu_is_u8500v20_or_later())
+	if (cpu_is_u8500v20_or_later() && !cpu_is_u9540())
 		prcmu_config_esram0_deep_sleep(ESRAM0_DEEP_SLEEP_STATE_RET);
 
-	err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
+	if (cpu_is_u9540())
+			err = mfd_add_devices(&pdev->dev, 0, db9540_prcmu_devs,
+			ARRAY_SIZE(db9540_prcmu_devs), NULL, 0);
+	else
+		err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
 			ARRAY_SIZE(db8500_prcmu_devs), NULL, 0);
+
 	if (err) {
 		pr_err("prcmu: Failed to add subdevices\n");
 		return err;
-- 
1.7.11.1

