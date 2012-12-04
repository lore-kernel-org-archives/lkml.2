Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2LDOBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:01:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23341 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2LDOBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:01:34 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b2-50be023c63b1
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        Kevin Liu <keyuan.liu@gmail.com>
Subject: [PATCH 1/3] regulators: add regulator_can_change_voltage() function
Date: Tue, 04 Dec 2012 15:01:01 +0100
Message-id: <1354629663-29091-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
References: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t9jQV0bpn0BBpMPSVpc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLeL7vCXHBesOLZNpEGxj98XYwcHBICJhK92+26GDmB
	TDGJC/fWs3UxcnEICUxnlHj5cwsrSEJIoJ1Jom1ZFIjNJmAo0fW2iw2kV0TAWmLvQl+QemaB
	t4wSy29tZwGJCwv4SNx7YApSziKgKvH+3l12EJtXwEOicecmFoi1ChJzJtmAmJwCnhJvfzJC
	LPKQuLd8HeMERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYI9/kxqB+PKBotDjAIc
	jEo8vDMe7gkQYk0sK67MPcQowcGsJMKr8GFvgBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeZo+U
	ACGB9MSS1OzU1ILUIpgsEwenVANjnpDA3FsnshdvdHi7TfbqtxOcKg5cLv83ex28NeWiik9K
	AV/srKUenmExh13ZSq6kvDr9cNqb4vDfdkdX1qznCj8+gYlXtrl1xzZO04o9a+J6glTF2uOv
	cxa22Kq6zDv6Jm37HLn3EwsqrrGndjTuOZ995NaN9U/W6rrKff/g97ExMS56/uf5SizFGYmG
	WsxFxYkAID/KnfQBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a regulator_can_change_voltage() function for the subsytems or
drivers which might check if applying voltage change is possible and use
special workaround code when the driver is used with fixed regulators or
regulators with disabled ability to change the voltage.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/core.c           |   22 ++++++++++++++++++++++
 include/linux/regulator/consumer.h |    1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5c4829c..24623b8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1861,6 +1861,28 @@ int regulator_is_enabled(struct regulator *regulator)
 EXPORT_SYMBOL_GPL(regulator_is_enabled);
 
 /**
+ * regulator_can_change_voltage - check if regulator can change voltage
+ * @regulator: regulator source
+ *
+ * Returns positive if the regulator driver backing the source/client
+ * can change its voltage, false otherwise. Usefull for detecting fixed
+ * or dummy regulators and disabling voltage change logic in the client
+ * driver.
+ */
+int regulator_can_change_voltage(struct regulator *regulator)
+{
+	struct regulator_dev	*rdev = regulator->rdev;
+
+	if (rdev->constraints &&
+	    rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE &&
+	    rdev->desc->n_voltages > 1)
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(regulator_can_change_voltage);
+
+/**
  * regulator_count_voltages - count regulator_list_voltage() selectors
  * @regulator: regulator source
  *
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index c43cd35..5d0f7c1 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -160,6 +160,7 @@ int regulator_bulk_force_disable(int num_consumers,
 void regulator_bulk_free(int num_consumers,
 			 struct regulator_bulk_data *consumers);
 
+int regulator_can_change_voltage(struct regulator *regulator);
 int regulator_count_voltages(struct regulator *regulator);
 int regulator_list_voltage(struct regulator *regulator, unsigned selector);
 int regulator_is_supported_voltage(struct regulator *regulator,
-- 
1.7.9.5

