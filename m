Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2FLMyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:54:15 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:15434 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2FLMyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:54:13 -0400
X-SBRS: None
From: Peter Huewe <peter.huewe@infineon.com>
To: <srajiv@linux.vnet.ibm.com>
CC: <tpmdd@selhorst.net>, <tpmdd-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        Luigi Semenzato <semenzato@google.com>, <andi.shyti@gmail.com>,
        Bryan Freed <bfreed@chromium.org>,
        Peter Huewe <peter.huewe@infineon.com>
Subject: [PATCH 2/2] CHROMIUM: tpm: tpm_i2c_infineon: Lock the I2C adapter for a sequence of requests.
Date: Tue, 12 Jun 2012 14:43:54 +0200
Message-ID: <1339505034-6400-2-git-send-email-peter.huewe@infineon.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1339505034-6400-1-git-send-email-peter.huewe@infineon.com>
References: <1339505034-6400-1-git-send-email-peter.huewe@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.170.180]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Freed <bfreed@chromium.org>

This is derived from Peter Huewe's recommended fix:

On some ChromeOS systems, a TPM sharing the I2C bus with another device
gets confused when it sees I2C requests to that other device.
This change locks the I2C adapter for the duration of the full sequence
of I2C requests the TPM needs to complete.

smbus_xfer is not supported, but SMBUS is not supported by the original
driver, either.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
---
 drivers/char/tpm/tpm_i2c_infineon.c |   45 +++++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 54b9a5e..1794a09 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -68,6 +68,31 @@ struct tpm_inf_dev {
 static struct tpm_inf_dev tpm_dev;
 static struct i2c_driver tpm_tis_i2c_driver;
 
+
+/*
+ * Copy i2c-core:i2c_transfer() as close as possible without the adapter locks
+ * and algorithm check.  These are done by the caller for atomicity.
+ * Unfortunately we have to use this as a workaround in multislave environments
+ * as no other suitable and working mechanism is available.
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
 /*
  * iic_tpm_read() - read from TPM register
  * @addr: register address to read from
@@ -96,8 +121,13 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
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
 			break;	/* break here to skip sleep */
 
@@ -105,19 +135,21 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
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
 
@@ -136,6 +168,10 @@ static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
 	if (len > TPM_BUFSIZE)
 		return -EINVAL;
 
+	if (!tpm_dev.client->adapter->algo->master_xfer)
+		return -EOPNOTSUPP;
+	i2c_lock_adapter(tpm_dev.client->adapter);
+
 	/* prepend the 'register address' to the buffer */
 	tpm_dev.buf[0] = addr;
 	memcpy(&(tpm_dev.buf[1]), buffer, len);
@@ -145,13 +181,14 @@ static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
 	 * cannot rely on the standard behavior of i2c_transfer.
 	 */
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
1.7.6.msysgit.0

