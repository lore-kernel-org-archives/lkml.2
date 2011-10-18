Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab1JRMGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:06:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53163 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab1JRMGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:06:47 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, jic23@cam.ac.uk, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv2 1/7] input/cma3000_d0x: Support devices without pdata
Date: Tue, 18 Oct 2011 14:06:30 +0200
Message-Id: <1318939596-27330-2-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures based on device-tree does not have platform data
associated to the spi/i2c devices.
This patch allows those architectures to use the cma3000 driver with
a default configuration.

---

v2: Fixes suggested by Jonathan Cameron
    -Spelling
    -Simplify pdata!=NULL check

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/input/misc/cma3000_d0x.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
index 1633b63..f2e87e3 100644
--- a/drivers/input/misc/cma3000_d0x.c
+++ b/drivers/input/misc/cma3000_d0x.c
@@ -62,6 +62,18 @@
 #define BIT_TO_2G  18
 #define BIT_TO_8G  71
 
+static struct cma3000_platform_data cma3000_default_pdata = {
+	.mdthr = 0x8,
+	.mdfftmr = 0x33,
+	.ffthr = 0x8,
+	.mode = CMAMODE_MEAS400,
+	.g_range = CMARANGE_2G,
+	.fuzz_x = BIT_TO_2G,
+	.fuzz_y = BIT_TO_2G,
+	.fuzz_z = BIT_TO_2G,
+	.irqflags = 0,
+};
+
 struct cma3000_accl_data {
 	const struct cma3000_bus_ops *bus_ops;
 	const struct cma3000_platform_data *pdata;
@@ -289,13 +301,11 @@ struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
 	int rev;
 	int error;
 
-	if (!pdata) {
-		dev_err(dev, "platform data not found\n");
-		error = -EINVAL;
-		goto err_out;
+	if (pdata == NULL) {
+		dev_info(dev, "platform data not found, using default\n");
+		pdata = &cma3000_default_pdata;
 	}
 
-
 	/* if no IRQ return error */
 	if (irq == 0) {
 		error = -EINVAL;
-- 
1.7.7

