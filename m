Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1AYKT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:58 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:55457 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187Ab1AYKTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:55 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 28/32] dma40: extract lcla code into separate function
Date: Tue, 25 Jan 2011 11:18:31 +0100
Message-ID: <1295950715-22340-29-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   94 +++++++++++++++++++++++++---------------------
 1 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index d9dfda2..4ec96ac 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -521,54 +521,62 @@ static void d40_phy_lli_load(struct d40_chan *chan, struct d40_desc *desc)
 	writel(lli_dst->reg_lnk, base + D40_CHAN_REG_SDLNK);
 }
 
-static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
-{
-	int curr_lcla = -EINVAL, next_lcla;
-
-	if (chan_is_physical(d40c)) {
-		d40_phy_lli_load(d40c, d40d);
-		d40d->lli_current = d40d->lli_len;
-	} else {
-
-		if ((d40d->lli_len - d40d->lli_current) > 1)
-			curr_lcla = d40_lcla_alloc_one(d40c, d40d);
-
-		d40_log_lli_lcpa_write(d40c->lcpa,
-				       &d40d->lli_log.dst[d40d->lli_current],
-				       &d40d->lli_log.src[d40d->lli_current],
-				       curr_lcla);
-
-		d40d->lli_current++;
-		for (; d40d->lli_current < d40d->lli_len; d40d->lli_current++) {
-			unsigned int lcla_offset = d40c->phy_chan->num * 1024 +
-						   8 * curr_lcla * 2;
-			struct d40_lcla_pool *pool = &d40c->base->lcla_pool;
-			struct d40_log_lli *lcla = pool->base + lcla_offset;
-
-			if (d40d->lli_current + 1 < d40d->lli_len)
-				next_lcla = d40_lcla_alloc_one(d40c, d40d);
-			else
-				next_lcla = -EINVAL;
-
-			d40_log_lli_lcla_write(lcla,
-					       &d40d->lli_log.dst[d40d->lli_current],
-					       &d40d->lli_log.src[d40d->lli_current],
-					       next_lcla);
+static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
+{
+	struct d40_lcla_pool *pool = &chan->base->lcla_pool;
+	struct d40_log_lli_bidir *lli = &desc->lli_log;
+	int lli_current = desc->lli_current;
+	int lli_len = desc->lli_len;
+	int curr_lcla = -EINVAL;
+
+	if (lli_len - lli_current > 1)
+		curr_lcla = d40_lcla_alloc_one(chan, desc);
+
+	d40_log_lli_lcpa_write(chan->lcpa,
+			       &lli->dst[lli_current],
+			       &lli->src[lli_current],
+			       curr_lcla);
+
+	lli_current++;
+	for (; lli_current < lli_len; lli_current++) {
+		unsigned int lcla_offset = chan->phy_chan->num * 1024 +
+					   8 * curr_lcla * 2;
+		struct d40_log_lli *lcla = pool->base + lcla_offset;
+		int next_lcla;
+
+		if (lli_current + 1 < lli_len)
+			next_lcla = d40_lcla_alloc_one(chan, desc);
+		else
+			next_lcla = -EINVAL;
 
-			dma_sync_single_range_for_device(d40c->base->dev,
-						pool->dma_addr, lcla_offset,
-						2 * sizeof(struct d40_log_lli),
-						DMA_TO_DEVICE);
+		d40_log_lli_lcla_write(lcla,
+				       &lli->dst[lli_current],
+				       &lli->src[lli_current],
+				       next_lcla);
 
-			curr_lcla = next_lcla;
+		dma_sync_single_range_for_device(chan->base->dev,
+					pool->dma_addr, lcla_offset,
+					2 * sizeof(struct d40_log_lli),
+					DMA_TO_DEVICE);
 
-			if (curr_lcla == -EINVAL) {
-				d40d->lli_current++;
-				break;
-			}
+		curr_lcla = next_lcla;
 
+		if (curr_lcla == -EINVAL) {
+			lli_current++;
+			break;
 		}
 	}
+
+	desc->lli_current = lli_current;
+}
+
+static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
+{
+	if (chan_is_physical(d40c)) {
+		d40_phy_lli_load(d40c, d40d);
+		d40d->lli_current = d40d->lli_len;
+	} else
+		d40_log_lli_to_lcxa(d40c, d40d);
 }
 
 static struct d40_desc *d40_first_active_get(struct d40_chan *d40c)
-- 
1.7.3.2

