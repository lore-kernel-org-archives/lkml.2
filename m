Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab0GVLpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:45:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:56739 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab0GVLp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:45:28 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: JBottomley@novell.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -mm 1/2] 53c700: remove dma_is_consistent usage
Date: Thu, 22 Jul 2010 20:40:10 +0900
Message-Id: <1279798811-21304-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 22 Jul 2010 20:45:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is the only user of dma_is_consistent(). We plan to remove
this API.

The driver uses the API in the following way:

BUG_ON(!dma_is_consistent(hostdata->dev, pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());

The above code tries to see if L1_CACHE_BYTES is greater than
dma_get_cache_alignment() on sysmtes that can not allocate coherent
memory (some old systems can't).

James Bottomley exmplained that this is necesary because the driver
packs the set of mailboxes into a single coherent area and separates
the different usages by a L1 cache stride. So it's fatal if the dma
coherence stride is greater than the L1 cache size.

He also pointed out that we can kill this checking because we don't
hit this BUG_ON on all architectures that actually use the driver.

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

