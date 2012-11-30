Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992600Ab2K3Szw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:55:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:57556 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031673Ab2K3Stf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 09/37] mwifiex: report error to MMC core if we cannot suspend
Date: Fri, 30 Nov 2012 10:45:56 -0800
Message-Id: <20121130183858.197277367@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit dd321acddc3be1371263b8c9e6c6f2af89f63d57 upstream.

When host_sleep_config command fails we should return error to
MMC core to indicate the failure for our device.

The misspelled variable is also removed as it's redundant.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/sdio.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -122,7 +122,6 @@ static int mwifiex_sdio_suspend(struct d
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
 	mmc_pm_flag_t pm_flag = 0;
-	int hs_actived = 0;
 	int i;
 	int ret = 0;
 
@@ -149,12 +148,14 @@ static int mwifiex_sdio_suspend(struct d
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
 


