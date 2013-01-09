Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3AIIRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:17:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:18877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab3AIIRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:17:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="269725910"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [resend][PATCH 04/16] dma: at_hdmac: check direction properly for cyclic transfers
Date: Wed,  9 Jan 2013 10:17:03 +0200
Message-Id: <1357719435-29955-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_transfer_direction is a normal enum. It means we can't usually use the
values as bit fields. Let's adjust this check and move it above the usage of
the direction parameter, due to the nature of the following usage of it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 13a02f4..997ae54 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -778,7 +778,7 @@ err:
  */
 static int
 atc_dma_cyclic_check_values(unsigned int reg_width, dma_addr_t buf_addr,
-		size_t period_len, enum dma_transfer_direction direction)
+		size_t period_len)
 {
 	if (period_len > (ATC_BTSIZE_MAX << reg_width))
 		goto err_out;
@@ -786,8 +786,6 @@ atc_dma_cyclic_check_values(unsigned int reg_width, dma_addr_t buf_addr,
 		goto err_out;
 	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
 		goto err_out;
-	if (unlikely(!(direction & (DMA_DEV_TO_MEM | DMA_MEM_TO_DEV))))
-		goto err_out;
 
 	return 0;
 
@@ -886,14 +884,16 @@ atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		return NULL;
 	}
 
+	if (unlikely(!is_slave_xfer(direction)))
+		goto err_out;
+
 	if (sconfig->direction == DMA_MEM_TO_DEV)
 		reg_width = convert_buswidth(sconfig->dst_addr_width);
 	else
 		reg_width = convert_buswidth(sconfig->src_addr_width);
 
 	/* Check for too big/unaligned periods and unaligned DMA buffer */
-	if (atc_dma_cyclic_check_values(reg_width, buf_addr,
-					period_len, direction))
+	if (atc_dma_cyclic_check_values(reg_width, buf_addr, period_len))
 		goto err_out;
 
 	/* build cyclic linked list */
-- 
1.7.10.4

