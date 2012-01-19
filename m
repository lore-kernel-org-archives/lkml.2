Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2ASAWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:22:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:44776 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2ASAWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:22:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] dmatest: fix merge error resulting in incorrect count handling
Date: Wed, 18 Jan 2012 19:21:55 -0500
Message-Id: <1326932515-7293-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently see this warning:

  drivers/dma/dmatest.c: In function ‘dmatest_add_channel’:
  drivers/dma/dmatest.c:602:28: warning: the omitted middle operand
   in ?: will always be ‘true’, suggest explicit middle operand [-Wparentheses]

It happens because commit f1aef8b6e6abf32a3a269542f95a19e2cb319f6c

  "dmaengine: dmatest: correct thread_count while using multiple thread per channel"

fixed the only two instances of this issue in the code, but then the
commit 58691d64c44ae41ddf098ecb31e9a994026e3cff "dmatest: add pq support"
was based on the old (unfixed) code, and so it reintroduced an instance
of this error.  Using git describe, the baseline delta is apparent:

	dmatest: correct thread_count	v2.6.30-8-gf1aef8b
	dmatest: add pq support		v2.6.29-rc8-80-g58691d6

Inspection of f1aef8b and/or the surrounding code leads one to the
obvious fix.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Vinod Koul <vinod.koul@intel.com>

---

[After creating this patch, I noticed it came up before in the
 lkml archives, but a fix never got applied.  At least now the
 real root cause is documented in this commit log.]

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 2b8661b..24225f0 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -599,7 +599,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
 	}
 	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
 		cnt = dmatest_add_threads(dtc, DMA_PQ);
-		thread_count += cnt > 0 ?: 0;
+		thread_count += cnt > 0 ? cnt : 0;
 	}
 
 	pr_info("dmatest: Started %u threads using %s\n",
-- 
1.7.7.2

