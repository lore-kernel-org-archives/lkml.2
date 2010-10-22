Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab0JVSvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:51:37 -0400
Received: from kroah.org ([198.145.64.141]:45715 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab0JVSif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:35 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:58 2010
Message-Id: <20101022183558.731328280@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:34:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [28/66] i2c-pca: Fix waitforcompletion() return value
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-pca-isa.c      |   12 ++++++++----
 drivers/i2c/busses/i2c-pca-platform.c |   11 +++++++----
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -71,8 +71,8 @@ static int pca_isa_readbyte(void *pd, in
 
 static int pca_isa_waitforcompletion(void *pd)
 {
-	long ret = ~0;
 	unsigned long timeout;
+	long ret;
 
 	if (irq > -1) {
 		ret = wait_event_timeout(pca_wait,
@@ -81,11 +81,15 @@ static int pca_isa_waitforcompletion(voi
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
 
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -80,8 +80,8 @@ static void i2c_pca_pf_writebyte32(void
 static int i2c_pca_pf_waitforcompletion(void *pd)
 {
 	struct i2c_pca_pf_data *i2c = pd;
-	long ret = ~0;
 	unsigned long timeout;
+	long ret;
 
 	if (i2c->irq) {
 		ret = wait_event_timeout(i2c->wait,
@@ -90,10 +90,13 @@ static int i2c_pca_pf_waitforcompletion(
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


