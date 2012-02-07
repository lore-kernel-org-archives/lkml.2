Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2BGNJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:09:36 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:58409 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab2BGNJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:09:35 -0500
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dan.Morav@nuvoton.com, KC@nuvoton.com,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [PATCH 2/2] tpm_nuvoton_i2c: Use exported symbol for status probe
Date: Tue,  7 Feb 2012 11:06:54 -0200
Message-Id: <1328620014-9369-3-git-send-email-srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <y>
References: <y>
x-cbid: 12020713-9254-0000-0000-0000080BEFA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed internal tpm_i2c_wait_for_stat() in favor of already exported
wait_for_tpm_stat().

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm_nuvoton_i2c.c |   92 +++++++-----------------------------
 1 files changed, 18 insertions(+), 74 deletions(-)

diff --git a/drivers/char/tpm/tpm_nuvoton_i2c.c b/drivers/char/tpm/tpm_nuvoton_i2c.c
index daf0d49..0ad67e7 100644
--- a/drivers/char/tpm/tpm_nuvoton_i2c.c
+++ b/drivers/char/tpm/tpm_nuvoton_i2c.c
@@ -170,63 +170,12 @@ static int tpm_i2c_get_burstcount(struct i2c_client *tpm_i2c_client,
 	return burst_count;
 }
 
-/*
- * WPCT301/NPCT501 SINT# supports only dataAvail
- * any call to this function which is not waiting for dataAvail will
- * set queue to NULL to avoid waiting for interrupt
- */
-static bool tpm_i2c_check_status(struct tpm_chip *chip, u8 mask, u8 value)
-{
-	u8 status = tpm_i2c_read_status(chip);
-	return (status != TPM_STS_ERR_VAL) && ((status & mask) == value);
-}
-
-static int tpm_i2c_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
-				 u32 timeout, wait_queue_head_t * queue)
-{
-	unsigned long ten_msec, stop;
-	bool status_valid;
-	s32 rc;
-
-	/* check current status */
-	status_valid = tpm_i2c_check_status(chip, mask, value);
-	if (status_valid)
-		return 0;
-	if (chip->vendor.irq && !queue) {
-		/* use interrupt to wait for the event */
-		rc = wait_event_interruptible_timeout(*queue,
-						      tpm_i2c_check_status(chip,
-									   mask,
-									   value),
-						      timeout);
-		if (rc > 0)
-			return 0;
-	} else {
-		/* use polling to wait for the event */
-		ten_msec = jiffies + msecs_to_jiffies(TPM_I2C_RETRY_DELAY_LONG);
-		stop = jiffies + timeout;
-		do {
-			if (time_before(jiffies, ten_msec))
-				msleep(TPM_I2C_RETRY_DELAY_SHORT);
-			else
-				msleep(TPM_I2C_RETRY_DELAY_LONG);
-			status_valid = tpm_i2c_check_status(chip, mask, value);
-			if (status_valid)
-				return 0;
-		} while (time_before(jiffies, stop));
-	}
-	dev_err(chip->dev, "%s(%02x, %02x) -> timeout\n", __func__, mask,
-		value);
-	return -ETIMEDOUT;
-}
-
 /* wait for dataAvail field to be set in the TPM_STS register */
 static int tpm_i2c_wait_for_data_avail(struct tpm_chip *chip, u32 timeout,
 				       wait_queue_head_t * queue)
 {
-	return tpm_i2c_wait_for_stat(chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-				     TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-				     timeout, queue);
+	return wait_for_tpm_stat(chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+				 timeout, queue);
 }
 
 /* Read @count bytes into @buf from TPM_RD_FIFO register */
@@ -326,10 +275,10 @@ static int tpm_i2c_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 			size = -EIO;
 			continue;
 		}
-		if (tpm_i2c_wait_for_stat(chip,
-					  TPM_STS_VALID | TPM_STS_DATA_AVAIL,
-					  TPM_STS_VALID, chip->vendor.timeout_c,
-					  NULL)) {
+		if (wait_for_tpm_stat(chip,
+				      TPM_STS_VALID | TPM_STS_DATA_AVAIL,
+				      chip->vendor.timeout_c,
+				      NULL)) {
 			dev_err(dev, "%s() error left over data\n", __func__);
 			size = -ETIMEDOUT;
 			continue;
@@ -358,9 +307,8 @@ static int tpm_i2c_send(struct tpm_chip *chip, u8 * buf, size_t len)
 
 	for (retries = 0; retries < TPM_RETRY; retries++) {
 		tpm_i2c_ready(chip);
-		if (tpm_i2c_wait_for_stat(chip, TPM_STS_COMMAND_READY,
-					  TPM_STS_COMMAND_READY,
-					  chip->vendor.timeout_b, NULL)) {
+		if (wait_for_tpm_stat(chip, TPM_STS_COMMAND_READY,
+				      chip->vendor.timeout_b, NULL)) {
 			dev_err(dev, "%s() timeout on commandReady\n",
 				__func__);
 			rc = -EIO;
@@ -387,13 +335,11 @@ static int tpm_i2c_send(struct tpm_chip *chip, u8 * buf, size_t len)
 			}
 			dev_dbg(dev, "%s(%d):", __func__, bytes2write);
 			count += bytes2write;
-			rc = tpm_i2c_wait_for_stat(chip,
-						   TPM_STS_VALID |
-						   TPM_STS_EXPECT,
-						   TPM_STS_VALID |
-						   TPM_STS_EXPECT,
-						   chip->vendor.timeout_c,
-						   NULL);
+			rc = wait_for_tpm_stat(chip,
+					       TPM_STS_VALID |
+					       TPM_STS_EXPECT,
+					       chip->vendor.timeout_c,
+					       NULL);
 			if (rc < 0) {
 				dev_err(dev, "%s() timeout on Expect\n",
 					__func__);
@@ -414,9 +360,8 @@ static int tpm_i2c_send(struct tpm_chip *chip, u8 * buf, size_t len)
 			continue;
 		}
 		dev_dbg(dev, "%s(last): %02x", __func__, buf[count]);
-		rc = tpm_i2c_wait_for_stat(chip, TPM_STS_VALID | TPM_STS_EXPECT,
-					   TPM_STS_VALID,
-					   chip->vendor.timeout_c, NULL);
+		rc = wait_for_tpm_stat(chip, TPM_STS_VALID | TPM_STS_EXPECT,
+				       chip->vendor.timeout_c, NULL);
 		if (rc) {
 			dev_err(dev, "%s() timeout on Expect to clear\n",
 				__func__);
@@ -616,10 +561,9 @@ static int tpm_i2c_probe(struct i2c_client *client,
 			/* Clear any pending interrupt */
 			tpm_i2c_ready(chip);
 			/* - wait for TPM_STS==0xA0 (stsValid, commandReady) */
-			rc = tpm_i2c_wait_for_stat(chip, TPM_STS_COMMAND_READY,
-						   TPM_STS_COMMAND_READY,
-						   chip->vendor.timeout_b,
-						   NULL);
+			rc = wait_for_tpm_stat(chip, TPM_STS_COMMAND_READY,
+					       chip->vendor.timeout_b,
+					       NULL);
 			if (rc == 0) {
 				/*
 				 * TIS is in ready state
-- 
1.7.3.4

