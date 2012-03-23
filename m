Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2CWItf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:49:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51623 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab2CWIta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:49:30 -0400
Message-ID: <1332492562.27981.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: Convert pcap-regulator to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Ribeiro <drwyrm@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 23 Mar 2012 16:49:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After converting to set_voltage_sel, we can remove the workaroud of getting
the best match voltage for V1. The core will iterate through the whole voltage
table and find the best match for us.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/pcap-regulator.c |   33 ++++++---------------------------
 1 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index a5aab1b..b9666a2 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -150,40 +150,19 @@ static struct pcap_regulator vreg_table[] = {
 	VREG_INFO(SW2S,  PCAP_REG_LOWPWR,  NA, 20, NA, NA), */
 };
 
-static int pcap_regulator_set_voltage(struct regulator_dev *rdev,
-				      int min_uV, int max_uV,
-				      unsigned *selector)
+static int pcap_regulator_set_voltage_sel(struct regulator_dev *rdev,
+					  unsigned selector)
 {
 	struct pcap_regulator *vreg = &vreg_table[rdev_get_id(rdev)];
 	void *pcap = rdev_get_drvdata(rdev);
-	int uV;
-	u8 i;
 
 	/* the regulator doesn't support voltage switching */
 	if (vreg->n_voltages == 1)
 		return -EINVAL;
 
-	for (i = 0; i < vreg->n_voltages; i++) {
-		/* For V1 the first is not the best match */
-		if (i == 0 && rdev_get_id(rdev) == V1)
-			i = 1;
-		else if (i + 1 == vreg->n_voltages && rdev_get_id(rdev) == V1)
-			i = 0;
-
-		uV = vreg->voltage_table[i] * 1000;
-		if (min_uV <= uV && uV <= max_uV) {
-			*selector = i;
-			return ezx_pcap_set_bits(pcap, vreg->reg,
-					(vreg->n_voltages - 1) << vreg->index,
-					i << vreg->index);
-		}
-
-		if (i == 0 && rdev_get_id(rdev) == V1)
-			i = vreg->n_voltages - 1;
-	}
-
-	/* the requested voltage range is not supported by this regulator */
-	return -EINVAL;
+	return ezx_pcap_set_bits(pcap, vreg->reg,
+				 (vreg->n_voltages - 1) << vreg->index,
+				 selector << vreg->index);
 }
 
 static int pcap_regulator_get_voltage(struct regulator_dev *rdev)
@@ -248,7 +227,7 @@ static int pcap_regulator_list_voltage(struct regulator_dev *rdev,
 
 static struct regulator_ops pcap_regulator_ops = {
 	.list_voltage	= pcap_regulator_list_voltage,
-	.set_voltage	= pcap_regulator_set_voltage,
+	.set_voltage_sel = pcap_regulator_set_voltage_sel,
 	.get_voltage	= pcap_regulator_get_voltage,
 	.enable		= pcap_regulator_enable,
 	.disable	= pcap_regulator_disable,
-- 
1.7.5.4



