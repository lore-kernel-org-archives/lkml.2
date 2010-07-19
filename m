Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966336Ab0GSSki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:40:38 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:14919 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966089Ab0GSSkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:31 -0400
Subject: [PATCH 16/26] cciss: factor out cciss_wait_for_mode_change_ack()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:01 -0500
Message-ID: <20100719184601.7908.1774.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: factor out cciss_wait_for_mode_change_ack()

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 37bc091..ee7cfde 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3816,9 +3816,22 @@ static void  calc_bucket_map(int bucket[], int num_buckets,
 	}
 }
 
+static void __devinit cciss_wait_for_mode_change_ack(ctlr_info_t *h)
+{
+	int i;
+
+	/* under certain very rare conditions, this can take awhile.
+	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
+	 * as we enter this code.) */
+	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
+		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
+			break;
+		msleep(10);
+	}
+}
+
 static void __devinit cciss_put_controller_into_performant_mode(ctlr_info_t *h)
 {
-	int l = 0;
 	__u32 trans_support;
 	__u32 trans_offset;
 			/*
@@ -3895,17 +3908,7 @@ static void __devinit cciss_put_controller_into_performant_mode(ctlr_info_t *h)
 
 	h->transMethod = CFGTBL_Trans_Performant;
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
-	/* under certain very rare conditions, this can take awhile.
-	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
-	 * as we enter this code.) */
-	for (l = 0; l < MAX_CONFIG_WAIT; l++) {
-		register_value = readl(h->vaddr + SA5_DOORBELL);
-		if (!(register_value & CFGTBL_ChangeReq))
-			break;
-		/* delay and try again */
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(10);
-	}
+	cciss_wait_for_mode_change_ack(h);
 	register_value = readl(&(h->cfgtable->TransportActive));
 	if (!(register_value & CFGTBL_Trans_Performant)) {
 		printk(KERN_WARNING "cciss: unable to get board into"

