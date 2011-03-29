Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1C2GRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:17:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18472 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1C2GRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:17:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 28 Mar 2011 23:17:00 -0700
From: wni@nvidia.com
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Cc: ccross@android.com, vwadekar@nvidia.com, Wei Ni <wni@nvidia.com>
Subject: [PATCH] mfd: call disable_irq()/enable_irq() in suspend/resume
Date: Tue, 29 Mar 2011 14:16:30 +0800
Message-Id: <1301379390-28063-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Ni <wni@nvidia.com>

When use rtc tps6586x wakealarm to suspend/resume system,
it will show a lot error messages:
"tps6586x 4-0034: failed to read interrupt status
tps6586x 4-0034: failed reading from 0xb5"
After resume, the system will call the mfd tps6586x driver's interrupt handle
tps6586x_irq(). This handle will read tps6586x interrupt status (0xb5), but at
that time the i2c driver didn't resume yet, so the reading will be failed.
I call the disble_irq in the suspend, and enable_irq in the resume, which will
delay the delivery of the irq until the i2c driver has been resumed.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/mfd/tps6586x.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index b600808..c7bd96b 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -569,6 +569,22 @@ static const struct i2c_device_id tps6586x_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tps6586x_id_table);
 
+#ifdef CONFIG_PM
+static int tps6586x_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	if (client->irq)
+		disable_irq(client->irq);
+	return 0;
+}
+
+static int tps6586x_resume(struct i2c_client *client)
+{
+	if (client->irq)
+		enable_irq(client->irq);
+	return 0;
+}
+#endif
+
 static struct i2c_driver tps6586x_driver = {
 	.driver	= {
 		.name	= "tps6586x",
@@ -577,6 +593,10 @@ static struct i2c_driver tps6586x_driver = {
 	.probe		= tps6586x_i2c_probe,
 	.remove		= __devexit_p(tps6586x_i2c_remove),
 	.id_table	= tps6586x_id_table,
+#ifdef CONFIG_PM
+	.suspend	= tps6586x_suspend,
+	.resume		= tps6586x_resume,
+#endif
 };
 
 static int __init tps6586x_init(void)
-- 
1.7.0

