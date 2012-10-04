Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab2JDVQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:16:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63596 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab2JDVQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:16:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mike Thompson <mpthompson@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 03/56] usb: otg: mxs-phy: Fix mx23 operation
Date: Thu,  4 Oct 2012 14:15:24 -0700
Message-Id: <20121004211152.495075619@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Thompson <mpthompson@gmail.com>

commit 363366cf61c544ea476f3d220f43a95cb03014f5 upstream.

Currently mx23 fails to enumerate a USB device:

[ 1.300000] hub 1-0:1.0: unable to enumerate USB device on port 1
[ 1.520000] hub 1-0:1.0: unable to enumerate USB device on port 1
[ 1.740000] hub 1-0:1.0: unable to enumerate USB device on port 1
[ 1.960000] hub 1-0:1.0: unable to enumerate USB device on port 1
[ 2.180000] hub 1-0:1.0: unable to enumerate USB device on port 1

Use a kernel workqueue to asynchronously delay the setting of
ENHOSTDISCONDETECT bit until after higher level hub connect/reset processing
is complete.  Prematurely setting the bit prevents the connection
processing from completing and not setting it prevents disconnect from being
detected. No delay is needed for clearing of ENHOSTDISCONDETECT.

Successfully tested on mx23-olinuxino (micro, mini and maxi variants) and mx28evk.

Signed-off-by: Mike Thompson <mpthompson@gmail.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/otg/mxs-phy.c |   38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

--- a/drivers/usb/otg/mxs-phy.c
+++ b/drivers/usb/otg/mxs-phy.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/workqueue.h>
 
 #define DRIVER_NAME "mxs_phy"
 
@@ -34,9 +35,16 @@
 #define BM_USBPHY_CTRL_ENUTMILEVEL2		BIT(14)
 #define BM_USBPHY_CTRL_ENHOSTDISCONDETECT	BIT(1)
 
+/*
+ * Amount of delay in miliseconds to safely enable ENHOSTDISCONDETECT bit
+ * so that connection and reset processing can be completed for the root hub.
+ */
+#define MXY_PHY_ENHOSTDISCONDETECT_DELAY	250
+
 struct mxs_phy {
 	struct usb_phy phy;
 	struct clk *clk;
+	struct delayed_work enhostdiscondetect_work;
 };
 
 #define to_mxs_phy(p) container_of((p), struct mxs_phy, phy)
@@ -62,6 +70,7 @@ static int mxs_phy_init(struct usb_phy *
 
 	clk_prepare_enable(mxs_phy->clk);
 	mxs_phy_hw_init(mxs_phy);
+	INIT_DELAYED_WORK(&mxs_phy->enhostdiscondetect_work, NULL);
 
 	return 0;
 }
@@ -76,13 +85,34 @@ static void mxs_phy_shutdown(struct usb_
 	clk_disable_unprepare(mxs_phy->clk);
 }
 
+static void mxs_phy_enhostdiscondetect_delay(struct work_struct *ws)
+{
+	struct mxs_phy *mxs_phy = container_of(ws, struct mxs_phy,
+						enhostdiscondetect_work.work);
+
+	/* Enable HOSTDISCONDETECT after delay. */
+	dev_dbg(mxs_phy->phy.dev, "Setting ENHOSTDISCONDETECT\n");
+	writel_relaxed(BM_USBPHY_CTRL_ENHOSTDISCONDETECT,
+				mxs_phy->phy.io_priv + HW_USBPHY_CTRL_SET);
+}
+
 static int mxs_phy_on_connect(struct usb_phy *phy, int port)
 {
+	struct mxs_phy *mxs_phy = to_mxs_phy(phy);
+
 	dev_dbg(phy->dev, "Connect on port %d\n", port);
 
-	mxs_phy_hw_init(to_mxs_phy(phy));
-	writel_relaxed(BM_USBPHY_CTRL_ENHOSTDISCONDETECT,
-			phy->io_priv + HW_USBPHY_CTRL_SET);
+	mxs_phy_hw_init(mxs_phy);
+
+	/*
+	 * Delay enabling ENHOSTDISCONDETECT so that connection and
+	 * reset processing can be completed for the root hub.
+	 */
+	dev_dbg(phy->dev, "Delaying setting ENHOSTDISCONDETECT\n");
+	PREPARE_DELAYED_WORK(&mxs_phy->enhostdiscondetect_work,
+			mxs_phy_enhostdiscondetect_delay);
+	schedule_delayed_work(&mxs_phy->enhostdiscondetect_work,
+			msecs_to_jiffies(MXY_PHY_ENHOSTDISCONDETECT_DELAY));
 
 	return 0;
 }
@@ -91,6 +121,8 @@ static int mxs_phy_on_disconnect(struct
 {
 	dev_dbg(phy->dev, "Disconnect on port %d\n", port);
 
+	/* No need to delay before clearing ENHOSTDISCONDETECT. */
+	dev_dbg(phy->dev, "Clearing ENHOSTDISCONDETECT\n");
 	writel_relaxed(BM_USBPHY_CTRL_ENHOSTDISCONDETECT,
 			phy->io_priv + HW_USBPHY_CTRL_CLR);
 


