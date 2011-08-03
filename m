Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1HCVJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:09:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29186 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1HCVJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:09:15 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: tpmdd-devel@lists.sourceforge.net, m.selhorst@sirrix.com,
        srajiv@linux.vnet.ibm.com, debora@linux.vnet.ibm.com,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH] CHROMIUM: tpm: tpm_tis_i2c: Lock the I2C adapter for a sequence of requests.
Date: Wed,  3 Aug 2011 14:08:50 -0700
Message-Id: <1312405730-22741-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is derived from Peter Huewe's recommended fix:

On some ChromeOS systems, a TPM sharing the I2C bus with another device
gets confused when it sees I2C requests to that other device.
This change locks the I2C adapter for the duration of the full sequence
of I2C requests the TPM needs to complete.

smbus_xfer is not supported, but SMBUS is not supported by the original
driver, either.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/char/tpm/tpm_tis_i2c.c |   42 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_i2c.c b/drivers/char/tpm/tpm_tis_i2c.c
index 8696b5f..4bd182e 100644
--- a/drivers/char/tpm/tpm_tis_i2c.c
+++ b/drivers/char/tpm/tpm_tis_i2c.c
@@ -64,6 +64,28 @@ static struct tpm_inf_dev tpm_dev;
 
 
 /*
+ * Copy i2c-core:i2c_transfer() as close as possible without the adapter locks
+ * and algorithm check.  These are done by the caller for atomicity.
+ */
+static int i2c_transfer_nolock(struct i2c_adapter *adap, struct i2c_msg *msgs,
+			       int num)
+{
+	unsigned long orig_jiffies;
+	int ret, try;
+
+	/* Retry automatically on arbitration loss */
+	orig_jiffies = jiffies;
+	for (ret = 0, try = 0; try <= adap->retries; try++) {
+		ret = adap->algo->master_xfer(adap, msgs, num);
+		if (ret != -EAGAIN)
+			break;
+		if (time_after(jiffies, orig_jiffies + adap->timeout))
+			break;
+	}
+	return ret;
+}
+
+/*
  * iic_tpm_read() - read from TPM register
  * @addr: register address to read from
  * @buffer: provided by caller
@@ -86,8 +108,13 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 	int rc;
 	int count;
 
+	/* Lock the adapter for the duration of the whole sequence. */
+	if (!tpm_dev.client->adapter->algo->master_xfer)
+		return -EOPNOTSUPP;
+	i2c_lock_adapter(tpm_dev.client->adapter);
+
 	for (count = 0; count < MAX_COUNT; count++) {
-		rc = i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
+		rc = i2c_transfer_nolock(tpm_dev.client->adapter, &msg1, 1);
 		if (rc > 0)
 			break; /* break here to skip sleep */
 
@@ -95,19 +122,21 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 	}
 
 	if (rc <= 0)
-		return -EIO;
+		goto out;
 
 	/* After the TPM has successfully received the register address it needs
 	 * some time, thus we're sleeping here again, before retrieving the data
 	 */
 	for (count = 0; count < MAX_COUNT; count++) {
 		usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
-		rc = i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
+		rc = i2c_transfer_nolock(tpm_dev.client->adapter, &msg2, 1);
 		if (rc > 0)
 			break;
 
 	}
 
+out:
+	i2c_unlock_adapter(tpm_dev.client->adapter);
 	if (rc <= 0)
 		return -EIO;
 
@@ -124,17 +153,22 @@ static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
 
 	struct i2c_msg msg1 = { tpm_dev.client->addr, 0, len + 1, tpm_dev.buf };
 
+	if (!tpm_dev.client->adapter->algo->master_xfer)
+		return -EOPNOTSUPP;
+	i2c_lock_adapter(tpm_dev.client->adapter);
+
 	tpm_dev.buf[0] = addr;
 	memcpy(&(tpm_dev.buf[1]), buffer, len);
 
 	for (count = 0; count < max_count; count++) {
-		rc = i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
+		rc = i2c_transfer_nolock(tpm_dev.client->adapter, &msg1, 1);
 		if (rc > 0)
 			break;
 
 		usleep_range(sleep_low, sleep_hi);
 	}
 
+	i2c_unlock_adapter(tpm_dev.client->adapter);
 	if (rc <= 0)
 		return -EIO;
 
-- 
1.7.3.1

