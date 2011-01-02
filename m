Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1ABHle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:41:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:36604 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab1ABHYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:46 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Yegor Yefremov <yegor_sub1@visionsystems.de>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 185/260] i2c-pca: Fix waitforcompletion() return value
Date: Sun,  2 Jan 2011 02:18:01 -0500
Message-Id: <1293952756-15010-186-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:33.0666 (UTC) FILETIME=[F699A820:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yegor Yefremov <yegor_sub1@visionsystems.de>

commit 6abb930af064fb1cf4177d32e2c7bfb89eee0fe5 upstream.

ret is still -1, if during the polling read_byte() returns at once
with I2C_PCA_CON_SI set. So ret > 0 would lead *_waitforcompletion()
to return 0, in spite of the proper behavior.

The routine was rewritten, so that ret has always a proper value,
before returning.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/i2c/busses/i2c-pca-isa.c      |   12 ++++++++----
 drivers/i2c/busses/i2c-pca-platform.c |   11 +++++++----
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
index f7346a9..62a5ce5 100644
--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -71,8 +71,8 @@ static int pca_isa_readbyte(void *pd, int reg)
 
 static int pca_isa_waitforcompletion(void *pd)
 {
-	long ret = ~0;
 	unsigned long timeout;
+	long ret;
 
 	if (irq > -1) {
 		ret = wait_event_timeout(pca_wait,
@@ -81,11 +81,15 @@ static int pca_isa_waitforcompletion(void *pd)
 	} else {
 		/* Do polling */
 		timeout = jiffies + pca_isa_ops.timeout;
-		while (((pca_isa_readbyte(pd, I2C_PCA_CON)
-				& I2C_PCA_CON_SI) == 0)
-				&& (ret = time_before(jiffies, timeout)))
+		do {
+			ret = time_before(jiffies, timeout);
+			if (pca_isa_readbyte(pd, I2C_PCA_CON)
+					& I2C_PCA_CON_SI)
+				break;
 			udelay(100);
+		} while (ret);
 	}
+
 	return ret > 0;
 }
 
diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index 5b2213d..1d8c208 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -80,8 +80,8 @@ static void i2c_pca_pf_writebyte32(void *pd, int reg, int val)
 static int i2c_pca_pf_waitforcompletion(void *pd)
 {
 	struct i2c_pca_pf_data *i2c = pd;
-	long ret = ~0;
 	unsigned long timeout;
+	long ret;
 
 	if (i2c->irq) {
 		ret = wait_event_timeout(i2c->wait,
@@ -90,10 +90,13 @@ static int i2c_pca_pf_waitforcompletion(void *pd)
 	} else {
 		/* Do polling */
 		timeout = jiffies + i2c->adap.timeout;
-		while (((i2c->algo_data.read_byte(i2c, I2C_PCA_CON)
-				& I2C_PCA_CON_SI) == 0)
-				&& (ret = time_before(jiffies, timeout)))
+		do {
+			ret = time_before(jiffies, timeout);
+			if (i2c->algo_data.read_byte(i2c, I2C_PCA_CON)
+					& I2C_PCA_CON_SI)
+				break;
 			udelay(100);
+		} while (ret);
 	}
 
 	return ret > 0;
-- 
1.7.3.3

