Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2LCOqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:46:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43829 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932353Ab2LCOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:39 -0500
Message-Id: <20121203143155.440884739@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:43 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 57/89] mwifiex: report error to MMC core if we cannot suspend
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit dd321acddc3be1371263b8c9e6c6f2af89f63d57 upstream.

When host_sleep_config command fails we should return error to
MMC core to indicate the failure for our device.

The misspelled variable is also removed as it's redundant.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/sdio.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index fc8a9bf..82cf0fa 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -161,7 +161,6 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
 	mmc_pm_flag_t pm_flag = 0;
-	int hs_actived = 0;
 	int i;
 	int ret = 0;
 
@@ -188,12 +187,14 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	adapter = card->adapter;
 
 	/* Enable the Host Sleep */
-	hs_actived = mwifiex_enable_hs(adapter);
-	if (hs_actived) {
-		pr_debug("cmd: suspend with MMC_PM_KEEP_POWER\n");
-		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	if (!mwifiex_enable_hs(adapter)) {
+		dev_err(adapter->dev, "cmd: failed to suspend\n");
+		return -EFAULT;
 	}
 
+	dev_dbg(adapter->dev, "cmd: suspend with MMC_PM_KEEP_POWER\n");
+	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+
 	/* Indicate device suspended */
 	adapter->is_suspended = true;
 


