Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2DNWxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 18:53:09 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24930 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2DNWxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 18:53:07 -0400
Date: Sun, 15 Apr 2012 00:53:04 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: David Woodhouse <dwmw2@infradead.org>,
        Andres Salomon <dilinger@queued.net>,
        Jordan Crouse <jordan@cosmicpenguin.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: olpc_dcon.c: checkpatch.pl and style fixups
Message-ID: <alpine.LNX.2.00.1204150049270.15578@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the few checkpatch.pl issues that are currently
reported for this file.

It makes these changes:

1. Quoted strings that were broken over multiple lines are put on a
   single line for easier grep'ability.

2. Add missing level to a printk().

3. A few casts have had their space between the cast and variable
   removed.

4. Two msleep() calls with times <= 20 have been changed to
   usleep_range() calls instead since msleep(<=20) may sleep for 20ms
   (on 100Hz kernels for instance).
   Picking a value for the lower bound of the range was easy, that was
   just the value passed to msleep(). As for picking the upper bound
   of the sleep I just went with two times the lower bound, for no
   other reason than the fact that in both cases that value was <=20ms
   and the end result will in any case be closer to the intention than
   a 20ms sleep.

It all seemed trivial enough to just do as one patch, but I can split
it if wanted.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 3d91993..80e8395 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -71,8 +71,8 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 
 	ver = dcon_read(dcon, DCON_REG_ID);
 	if ((ver >> 8) != 0xDC) {
-		printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx: 0x%04x "
-				"instead.\n", ver);
+		printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx: 0x%04x instead.\n",
+				ver);
 		rc = -ENXIO;
 		goto err;
 	}
@@ -134,27 +134,26 @@ static int dcon_bus_stabilize(struct dcon_priv *dcon, int is_powered_down)
 power_up:
 	if (is_powered_down) {
 		x = 1;
-		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
+		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
 		if (x) {
-			printk(KERN_WARNING "olpc-dcon:  unable to force dcon "
-					"to power up: %d!\n", x);
+			printk(KERN_WARNING "olpc-dcon:  unable to force dcon to power up: %d!\n",
+					x);
 			return x;
 		}
-		msleep(10); /* we'll be conservative */
+		usleep_range(10000, 20000); /* we'll be conservative */
 	}
 
 	pdata->bus_stabilize_wiggle();
 
 	for (x = -1, timeout = 50; timeout && x < 0; timeout--) {
-		msleep(1);
+		usleep_range(1000, 2000);
 		x = dcon_read(dcon, DCON_REG_ID);
 	}
 	if (x < 0) {
-		printk(KERN_ERR "olpc-dcon:  unable to stabilize dcon's "
-				"smbus, reasserting power and praying.\n");
+		printk(KERN_ERR "olpc-dcon:  unable to stabilize dcon's smbus, reasserting power and praying.\n");
 		BUG_ON(olpc_board_at_least(olpc_board(0xc2)));
 		x = 0;
-		olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
+		olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
 		msleep(100);
 		is_powered_down = 1;
 		goto power_up;	/* argh, stupid hardware.. */
@@ -220,10 +219,10 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 
 	if (sleep) {
 		x = 0;
-		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
+		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
 		if (x)
-			printk(KERN_WARNING "olpc-dcon:  unable to force dcon "
-					"to power down: %d!\n", x);
+			printk(KERN_WARNING "olpc-dcon:  unable to force dcon to power down: %d!\n",
+					x);
 		else
 			dcon->asleep = sleep;
 	} else {
@@ -232,8 +231,8 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 			dcon->disp_mode |= MODE_BL_ENABLE;
 		x = dcon_bus_stabilize(dcon, 1);
 		if (x)
-			printk(KERN_WARNING "olpc-dcon:  unable to reinit dcon"
-					" hardware: %d!\n", x);
+			printk(KERN_WARNING "olpc-dcon:  unable to reinit dcon hardware: %d!\n",
+				x);
 		else
 			dcon->asleep = sleep;
 
@@ -304,7 +303,7 @@ static void dcon_source_switch(struct work_struct *work)
 
 	switch (source) {
 	case DCON_SOURCE_CPU:
-		printk("dcon_source_switch to CPU\n");
+		printk(KERN_INFO "dcon_source_switch to CPU\n");
 		/* Enable the scanline interrupt bit */
 		if (dcon_write(dcon, DCON_REG_MODE,
 				dcon->disp_mode | MODE_SCAN_INT))
@@ -599,7 +598,7 @@ static int dcon_fb_notifier(struct notifier_block *self,
 	struct fb_event *evdata = data;
 	struct dcon_priv *dcon = container_of(self, struct dcon_priv,
 			fbevent_nb);
-	int *blank = (int *) evdata->data;
+	int *blank = (int *)evdata->data;
 	if (((event != FB_EVENT_BLANK) && (event != FB_EVENT_CONBLANK)) ||
 			dcon->ignore_fb_events)
 		return 0;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

