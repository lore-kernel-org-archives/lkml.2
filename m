Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab2FAJPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:15:01 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15619 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340Ab2FAJOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:14:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 01 Jun 2012 02:14:03 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <olof@lixom.net>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <herbert@gondor.hengli.com.au>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 9/9] crypto: add clk_prepare/clk_unprepare
Date: Fri, 1 Jun 2012 14:42:48 +0530
Message-ID: <1338541968-7961-10-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
References: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clk_prepare/clk_unprepare as required by the generic clk framework.

This patch should go through Tegra tree since other patches to port Tegra
to generic clock framework are dependent on it. Posting here to get ack from
the maintainers.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/crypto/tegra-aes.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 422a976..ac236f6 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -572,7 +572,7 @@ static void aes_workqueue_handler(struct work_struct *work)
 	struct tegra_aes_dev *dd = aes_dev;
 	int ret;
 
-	ret = clk_enable(dd->aes_clk);
+	ret = clk_prepare_enable(dd->aes_clk);
 	if (ret)
 		BUG_ON("clock enable failed");
 
@@ -581,7 +581,7 @@ static void aes_workqueue_handler(struct work_struct *work)
 		ret = tegra_aes_handle_req(dd);
 	} while (!ret);
 
-	clk_disable(dd->aes_clk);
+	clk_disable_unprepare(dd->aes_clk);
 }
 
 static irqreturn_t aes_irq(int irq, void *dev_id)
@@ -673,7 +673,7 @@ static int tegra_aes_get_random(struct crypto_rng *tfm, u8 *rdata,
 	/* take mutex to access the aes hw */
 	mutex_lock(&aes_lock);
 
-	ret = clk_enable(dd->aes_clk);
+	ret = clk_prepare_enable(dd->aes_clk);
 	if (ret)
 		return ret;
 
@@ -700,7 +700,7 @@ static int tegra_aes_get_random(struct crypto_rng *tfm, u8 *rdata,
 	}
 
 out:
-	clk_disable(dd->aes_clk);
+	clk_disable_unprepare(dd->aes_clk);
 	mutex_unlock(&aes_lock);
 
 	dev_dbg(dd->dev, "%s: done\n", __func__);
@@ -758,7 +758,7 @@ static int tegra_aes_rng_reset(struct crypto_rng *tfm, u8 *seed,
 
 	dd->flags = FLAGS_ENCRYPT | FLAGS_RNG;
 
-	ret = clk_enable(dd->aes_clk);
+	ret = clk_prepare_enable(dd->aes_clk);
 	if (ret)
 		return ret;
 
@@ -788,7 +788,7 @@ static int tegra_aes_rng_reset(struct crypto_rng *tfm, u8 *seed,
 	memcpy(dd->dt, dt, DEFAULT_RNG_BLK_SZ);
 
 out:
-	clk_disable(dd->aes_clk);
+	clk_disable_unprepare(dd->aes_clk);
 	mutex_unlock(&aes_lock);
 
 	dev_dbg(dd->dev, "%s: done\n", __func__);
-- 
1.7.4.1

