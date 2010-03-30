Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0CaAXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:23:48 -0400
Received: from kroah.org ([198.145.64.141]:49037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab0C3XMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:38 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:40 2010
Message-Id: <20100330225839.832918094@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wolfram Sang <w.sang@pengutronix.de>, Jean Delvare <khali@linux-fr.org>,
       Jean Delvare <jdelvare@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [51/89] i2c/pca: Dont use *_interruptible
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 22f8b2695eda496026623020811cae34590ee3d7 upstream.

Unexpected signals can disturb the bus-handling and lock it up. Don't use
interruptible in 'wait_event_*' and 'wake_*' as in commits
dc1972d02747d2170fb1d78d114801f5ecb27506 (for cpm),
1ab082d7cbd0f34e39a5396cc6340c00bc5d66ef (for mpc),
b7af349b175af45f9d87b3bf3f0a221e1831ed39 (for omap).

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
Tested with custom hardware.

 drivers/i2c/busses/i2c-pca-isa.c      |    4 ++--
 drivers/i2c/busses/i2c-pca-platform.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -75,7 +75,7 @@ static int pca_isa_waitforcompletion(voi
 	unsigned long timeout;
 
 	if (irq > -1) {
-		ret = wait_event_interruptible_timeout(pca_wait,
+		ret = wait_event_timeout(pca_wait,
 				pca_isa_readbyte(pd, I2C_PCA_CON)
 				& I2C_PCA_CON_SI, pca_isa_ops.timeout);
 	} else {
@@ -96,7 +96,7 @@ static void pca_isa_resetchip(void *pd)
 }
 
 static irqreturn_t pca_handler(int this_irq, void *dev_id) {
-	wake_up_interruptible(&pca_wait);
+	wake_up(&pca_wait);
 	return IRQ_HANDLED;
 }
 
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -84,7 +84,7 @@ static int i2c_pca_pf_waitforcompletion(
 	unsigned long timeout;
 
 	if (i2c->irq) {
-		ret = wait_event_interruptible_timeout(i2c->wait,
+		ret = wait_event_timeout(i2c->wait,
 			i2c->algo_data.read_byte(i2c, I2C_PCA_CON)
 			& I2C_PCA_CON_SI, i2c->adap.timeout);
 	} else {
@@ -122,7 +122,7 @@ static irqreturn_t i2c_pca_pf_handler(in
 	if ((i2c->algo_data.read_byte(i2c, I2C_PCA_CON) & I2C_PCA_CON_SI) == 0)
 		return IRQ_NONE;
 
-	wake_up_interruptible(&i2c->wait);
+	wake_up(&i2c->wait);
 
 	return IRQ_HANDLED;
 }


