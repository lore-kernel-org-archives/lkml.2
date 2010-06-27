Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0F0KOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 06:14:04 -0400
Received: from sh.osrg.net ([192.16.179.4]:50128 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab0F0KOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 06:14:01 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: grundler@parisc-linux.org, lethal@linux-sh.org, JBottomley@novell.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -mm 1/2] scsi: remove dma_is_consistent usage in 53c700
Date: Sun, 27 Jun 2010 19:10:22 +0900
Message-Id: <1277633423-5700-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 27 Jun 2010 19:13:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

53c700 is the only user of dma_is_consistent():

BUG_ON(!dma_is_consistent(hostdata->dev, pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());

The above code tries to see if the system can allocate coherent memory
or not. It's for some old systems that can't allocate coherent memory
at all (e.g some parisc systems).

I think that we can safely remove the above usage:

- such old systems haven't triger the above checking for long.

- the above condition is important for systems that can't allocate
  coherent memory if these systems do DMA. So probably it would be
  better to have such checking in arch's DMA initialization code
  instead of a driver.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/53c700.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 80dc3ac..89fc1c8 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -309,9 +309,6 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	hostdata->msgin = memory + MSGIN_OFFSET;
 	hostdata->msgout = memory + MSGOUT_OFFSET;
 	hostdata->status = memory + STATUS_OFFSET;
-	/* all of these offsets are L1_CACHE_BYTES separated.  It is fatal
-	 * if this isn't sufficient separation to avoid dma flushing issues */
-	BUG_ON(!dma_is_consistent(hostdata->dev, pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());
 	hostdata->slots = (struct NCR_700_command_slot *)(memory + SLOTS_OFFSET);
 	hostdata->dev = dev;
 
-- 
1.6.5

