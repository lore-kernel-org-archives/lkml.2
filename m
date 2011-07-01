Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab1GAQ41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:56:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62813 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab1GAQ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:56:21 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>
Cc: Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v9 02/12] omap_hsmmc: add support for pre_req and post_req
Date: Fri,  1 Jul 2011 18:55:23 +0200
Message-Id: <1309539333-2606-3-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309539333-2606-1-git-send-email-per.forlin@linaro.org>
References: <1309539333-2606-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pre_req() runs dma_map_sg(), post_req() runs dma_unmap_sg.
If not calling pre_req() before omap_hsmmc_request()
dma_map_sg will be issued before starting the transfer.
It is optional to use pre_req(). If issuing pre_req()
post_req() must be to be called as well.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Reviewed-by: Venkatraman S <svenkatr@ti.com>
Tested-by: Sourav Poddar<sourav.poddar@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c |   87 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index cd317af..b29ca90 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -141,6 +141,11 @@
 #define OMAP_HSMMC_WRITE(base, reg, val) \
 	__raw_writel((val), (base) + OMAP_HSMMC_##reg)
 
+struct omap_hsmmc_next {
+	unsigned int	dma_len;
+	s32		cookie;
+};
+
 struct omap_hsmmc_host {
 	struct	device		*dev;
 	struct	mmc_host	*mmc;
@@ -184,6 +189,7 @@ struct omap_hsmmc_host {
 	int			reqs_blocked;
 	int			use_reg;
 	int			req_in_progress;
+	struct omap_hsmmc_next	next_data;
 
 	struct	omap_mmc_platform_data	*pdata;
 };
@@ -1343,8 +1349,9 @@ static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *cb_data)
 		return;
 	}
 
-	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
-		omap_hsmmc_get_dma_dir(host, data));
+	if (!data->host_cookie)
+		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
+			     omap_hsmmc_get_dma_dir(host, data));
 
 	req_in_progress = host->req_in_progress;
 	dma_ch = host->dma_ch;
@@ -1362,6 +1369,45 @@ static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *cb_data)
 	}
 }
 
+static int omap_hsmmc_pre_dma_transfer(struct omap_hsmmc_host *host,
+				       struct mmc_data *data,
+				       struct omap_hsmmc_next *next)
+{
+	int dma_len;
+
+	if (!next && data->host_cookie &&
+	    data->host_cookie != host->next_data.cookie) {
+		printk(KERN_WARNING "[%s] invalid cookie: data->host_cookie %d"
+		       " host->next_data.cookie %d\n",
+		       __func__, data->host_cookie, host->next_data.cookie);
+		data->host_cookie = 0;
+	}
+
+	/* Check if next job is already prepared */
+	if (next ||
+	    (!next && data->host_cookie != host->next_data.cookie)) {
+		dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg,
+				     data->sg_len,
+				     omap_hsmmc_get_dma_dir(host, data));
+
+	} else {
+		dma_len = host->next_data.dma_len;
+		host->next_data.dma_len = 0;
+	}
+
+
+	if (dma_len == 0)
+		return -EINVAL;
+
+	if (next) {
+		next->dma_len = dma_len;
+		data->host_cookie = ++next->cookie < 0 ? 1 : next->cookie;
+	} else
+		host->dma_len = dma_len;
+
+	return 0;
+}
+
 /*
  * Routine to configure and start DMA for the MMC card
  */
@@ -1395,9 +1441,10 @@ static int omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host,
 			mmc_hostname(host->mmc), ret);
 		return ret;
 	}
+	ret = omap_hsmmc_pre_dma_transfer(host, data, NULL);
+	if (ret)
+		return ret;
 
-	host->dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg,
-			data->sg_len, omap_hsmmc_get_dma_dir(host, data));
 	host->dma_ch = dma_ch;
 	host->dma_sg_idx = 0;
 
@@ -1477,6 +1524,35 @@ omap_hsmmc_prepare_data(struct omap_hsmmc_host *host, struct mmc_request *req)
 	return 0;
 }
 
+static void omap_hsmmc_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
+				int err)
+{
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
+	struct mmc_data *data = mrq->data;
+
+	if (host->use_dma) {
+		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
+			     omap_hsmmc_get_dma_dir(host, data));
+		data->host_cookie = 0;
+	}
+}
+
+static void omap_hsmmc_pre_req(struct mmc_host *mmc, struct mmc_request *mrq,
+			       bool is_first_req)
+{
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
+
+	if (mrq->data->host_cookie) {
+		mrq->data->host_cookie = 0;
+		return ;
+	}
+
+	if (host->use_dma)
+		if (omap_hsmmc_pre_dma_transfer(host, mrq->data,
+						&host->next_data))
+			mrq->data->host_cookie = 0;
+}
+
 /*
  * Request function. for read/write operation
  */
@@ -1925,6 +2001,8 @@ static int omap_hsmmc_disable_fclk(struct mmc_host *mmc, int lazy)
 static const struct mmc_host_ops omap_hsmmc_ops = {
 	.enable = omap_hsmmc_enable_fclk,
 	.disable = omap_hsmmc_disable_fclk,
+	.post_req = omap_hsmmc_post_req,
+	.pre_req = omap_hsmmc_pre_req,
 	.request = omap_hsmmc_request,
 	.set_ios = omap_hsmmc_set_ios,
 	.get_cd = omap_hsmmc_get_cd,
@@ -2074,6 +2152,7 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
 	host->mapbase	= res->start;
 	host->base	= ioremap(host->mapbase, SZ_4K);
 	host->power_mode = MMC_POWER_OFF;
+	host->next_data.cookie = 1;
 
 	platform_set_drvdata(pdev, host);
 	INIT_WORK(&host->mmc_carddetect_work, omap_hsmmc_detect);
-- 
1.7.4.1

