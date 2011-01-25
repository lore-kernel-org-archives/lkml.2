Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1AYKWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:22:34 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:48612 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157Ab1AYKTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:45 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 22/32] dma40: combine duplicated code in log_sg_to_dev
Date: Tue, 25 Jan 2011 11:18:25 +0100
Message-ID: <1295950715-22340-23-git-send-email-linus.walleij@stericsson.com>
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
 drivers/dma/ste_dma40_ll.c |   52 +++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index fd75251..fa6c3ab 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -385,40 +385,34 @@ int d40_log_sg_to_dev(struct scatterlist *sg,
 	struct d40_log_lli *lli_dst = lli->dst;
 
 	for_each_sg(sg, current_sg, sg_len, i) {
-		total_size += sg_dma_len(current_sg);
+		dma_addr_t sg_addr = sg_dma_address(current_sg);
+		unsigned int len = sg_dma_len(current_sg);
+		dma_addr_t src;
+		dma_addr_t dst;
+
+		total_size += len;
 
 		if (direction == DMA_TO_DEVICE) {
-			lli_src =
-				d40_log_buf_to_lli(lli_src,
-						   sg_dma_address(current_sg),
-						   sg_dma_len(current_sg),
-						   lcsp->lcsp1, src_data_width,
-						   dst_data_width,
-						   true);
-			lli_dst =
-				d40_log_buf_to_lli(lli_dst,
-						   dev_addr,
-						   sg_dma_len(current_sg),
-						   lcsp->lcsp3, dst_data_width,
-						   src_data_width,
-						   false);
+			src = sg_addr;
+			dst = dev_addr;
 		} else {
-			lli_dst =
-				d40_log_buf_to_lli(lli_dst,
-						   sg_dma_address(current_sg),
-						   sg_dma_len(current_sg),
-						   lcsp->lcsp3, dst_data_width,
-						   src_data_width,
-						   true);
-			lli_src =
-				d40_log_buf_to_lli(lli_src,
-						   dev_addr,
-						   sg_dma_len(current_sg),
-						   lcsp->lcsp1, src_data_width,
-						   dst_data_width,
-						   false);
+			src = dev_addr;
+			dst = sg_addr;
 		}
+
+		lli_src = d40_log_buf_to_lli(lli_src, src, len,
+					     lcsp->lcsp1,
+					     src_data_width,
+					     dst_data_width,
+					     src == sg_addr);
+
+		lli_dst = d40_log_buf_to_lli(lli_dst, dst, len,
+					     lcsp->lcsp3,
+					     dst_data_width,
+					     src_data_width,
+					     dst == sg_addr);
 	}
+
 	return total_size;
 }
 
-- 
1.7.3.2

