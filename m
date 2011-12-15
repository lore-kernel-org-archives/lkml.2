Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1LOIQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:16:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34606 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1LOIQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:16:49 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Shawn Guo <shawn.guo@freescale.com>
Cc: kernel@pengutronix.de, Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jason Liu <jason.hui@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] serial/imx: let probing fail for the dt case without a valid alias
Date: Thu, 15 Dec 2011 09:16:34 +0100
Message-Id: <1323936994-2250-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20111215021046.GD3259@S2101-09.ap.freescale.net>
References: <20111215021046.GD3259@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the uart device is instantiated by dt but dt doesn't provide an
alias then better let probing fail instead of falling back to an
unrelated device id used for the line number and no platform data.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/tty/serial/imx.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 75c159a..1c94218 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1287,6 +1287,10 @@ static int serial_imx_resume(struct platform_device *dev)
 }
 
 #ifdef CONFIG_OF
+/*
+ * This function returns 1 iff pdev isn't a device instatiated by dt, 0 iff it
+ * could successfully get all information from dt or a negative errno.
+ */
 static int serial_imx_probe_dt(struct imx_port *sport,
 		struct platform_device *pdev)
 {
@@ -1296,7 +1300,8 @@ static int serial_imx_probe_dt(struct imx_port *sport,
 	int ret;
 
 	if (!np)
-		return -ENODEV;
+		/* no device tree device */
+		return 1;
 
 	ret = of_alias_get_id(np, "serial");
 	if (ret < 0) {
@@ -1319,7 +1324,7 @@ static int serial_imx_probe_dt(struct imx_port *sport,
 static inline int serial_imx_probe_dt(struct imx_port *sport,
 		struct platform_device *pdev)
 {
-	return -ENODEV;
+	return 1;
 }
 #endif
 
@@ -1354,8 +1359,10 @@ static int serial_imx_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ret = serial_imx_probe_dt(sport, pdev);
-	if (ret == -ENODEV)
+	if (ret > 0)
 		serial_imx_probe_pdata(sport, pdev);
+	else if (ret < 0)
+		goto free;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-- 
1.7.7.3

