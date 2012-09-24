Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab2IXR5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:57:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34476 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab2IXR5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:57:02 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: [RFC] regulator: core: Support for continuous voltage range
Date: Mon, 24 Sep 2012 18:56:53 +0100
Message-Id: <1348509414-21261-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 24 Sep 2012 17:57:00.0076 (UTC) FILETIME=[FED7D6C0:01CD9A7D]
X-MC-Unique: 112092418570001001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8OHvBWh021716

Some regulators can set any voltage within the constraints range,
not being limited to specified operating points.

This patch makes it possible to describe such regulator and makes
the regulator_is_supported_voltage() function behave correctly.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/regulator/core.c         |    5 +++++
 include/linux/regulator/driver.h |    3 +++
 2 files changed, 8 insertions(+)

Hi Mark,

This is roughly what we discussed last week. Alternatively, it could be
also a "universal" unsigned regulator_desc.flags field with #define
REGULATOR_FLAG_CONTINUOUS_VOLTAGE_RAGE 0x1.

Regards

Pawel

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4838531..808928a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1947,6 +1947,11 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 			return ret;
 	}
 
+	/* Any voltage within constrains range is fine? */
+	if (rdev->desc->continuous_voltage_range)
+		return min_uV >= rdev->constraints->min_uV &&
+				max_uV <= rdev->constraints->max_uV;
+
 	ret = regulator_count_voltages(regulator);
 	if (ret < 0)
 		return ret;
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index bac4c87..2f915b9 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -171,6 +171,8 @@ enum regulator_type {
  * @type: Indicates if the regulator is a voltage or current regulator.
  * @owner: Module providing the regulator, used for refcounting.
  *
+ * @continuous_voltage_range: Indicates if the regulator can set any
+ *                            voltage within constrains range.
  * @n_voltages: Number of selectors available for ops.list_voltage().
  *
  * @min_uV: Voltage given by the lowest selector (if linear mapping)
@@ -189,6 +191,7 @@ struct regulator_desc {
 	const char *name;
 	const char *supply_name;
 	int id;
+	bool continuous_voltage_range;
 	unsigned n_voltages;
 	struct regulator_ops *ops;
 	int irq;
-- 
1.7.9.5


