Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0EaHAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:00:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:38178 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922Ab0EaHAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:00:48 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: jens.axboe@oracle.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -mm 1/3] aha1532: remove ISA_DMA_THRESHOLD usage
Date: Mon, 31 May 2010 15:59:02 +0900
Message-Id: <1275289144-28782-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1275289144-28782-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1275289144-28782-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 31 May 2010 16:00:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can safely remove ISA_DMA_THRESHOLD usage in aha1532. aha1532 uses
ISA_DMA_THRESHOLD to see if:

- the buffers in scatter/list are below 16MB.
- scsi_host is below 16MB.

Both checkings were added in the ancient times but aren't necessary
nowadays since we properly bounce the buffers and allocate scsi_host
below 16MB with non-zero unchecked_isa_dma.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aha1542.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 2a8cf13..f6175ed 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -691,8 +691,6 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 		}
 		scsi_for_each_sg(SCpnt, sg, sg_count, i) {
 			any2scsi(cptr[i].dataptr, SCSI_SG_PA(sg));
-			if (SCSI_SG_PA(sg) + sg->length - 1 > ISA_DMA_THRESHOLD)
-				BAD_SG_DMA(SCpnt, scsi_sglist(SCpnt), sg_count, i);
 			any2scsi(cptr[i].datalen, sg->length);
 		};
 		any2scsi(ccb[mbo].datalen, sg_count * sizeof(struct chain));
@@ -1133,16 +1131,9 @@ static int __init aha1542_detect(struct scsi_host_template * tpnt)
 				release_region(bases[indx], 4);
 				continue;
 			}
-			/* For now we do this - until kmalloc is more intelligent
-			   we are resigned to stupid hacks like this */
-			if (SCSI_BUF_PA(shpnt) >= ISA_DMA_THRESHOLD) {
-				printk(KERN_ERR "Invalid address for shpnt with 1542.\n");
-				goto unregister;
-			}
 			if (!aha1542_test_port(bases[indx], shpnt))
 				goto unregister;
 
-
 			base_io = bases[indx];
 
 			/* Set the Bus on/off-times as not to ruin floppy performance */
-- 
1.6.5

