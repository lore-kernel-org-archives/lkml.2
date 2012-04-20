Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab2DTPKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:10:04 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:45341 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665Ab2DTPHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:07:12 -0400
Subject: [PATCH 10/17] hpsa: factor out tail calls to next_command() in
	process_(non)indexed_cmd()
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Fri, 20 Apr 2012 10:07:11 -0500
Message-ID: <20120420150711.10596.96628.stgit@beardog.cce.hp.com>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is in order to smooth the way for upcoming changes to allow use of
multiple reply queues for command completions.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Matt Gates <matthew.gates@hp.com>
---
 drivers/scsi/hpsa.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c657642..96d07d4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3371,22 +3371,21 @@ static inline u32 hpsa_tag_discard_error_bits(struct ctlr_info *h, u32 tag)
 }
 
 /* process completion of an indexed ("direct lookup") command */
-static inline u32 process_indexed_cmd(struct ctlr_info *h,
+static inline void process_indexed_cmd(struct ctlr_info *h,
 	u32 raw_tag)
 {
 	u32 tag_index;
 	struct CommandList *c;
 
 	tag_index = hpsa_tag_to_index(raw_tag);
-	if (bad_tag(h, tag_index, raw_tag))
-		return next_command(h);
-	c = h->cmd_pool + tag_index;
-	finish_cmd(c);
-	return next_command(h);
+	if (!bad_tag(h, tag_index, raw_tag)) {
+		c = h->cmd_pool + tag_index;
+		finish_cmd(c);
+	}
 }
 
 /* process completion of a non-indexed command */
-static inline u32 process_nonindexed_cmd(struct ctlr_info *h,
+static inline void process_nonindexed_cmd(struct ctlr_info *h,
 	u32 raw_tag)
 {
 	u32 tag;
@@ -3396,11 +3395,10 @@ static inline u32 process_nonindexed_cmd(struct ctlr_info *h,
 	list_for_each_entry(c, &h->cmpQ, list) {
 		if ((c->busaddr & 0xFFFFFFE0) == (tag & 0xFFFFFFE0)) {
 			finish_cmd(c);
-			return next_command(h);
+			return;
 		}
 	}
 	bad_tag(h, h->nr_cmds + 1, raw_tag);
-	return next_command(h);
 }
 
 /* Some controllers, like p400, will give us one interrupt
@@ -3475,10 +3473,11 @@ static irqreturn_t do_hpsa_intr_intx(int irq, void *dev_id)
 	while (interrupt_pending(h)) {
 		raw_tag = get_next_completion(h);
 		while (raw_tag != FIFO_EMPTY) {
-			if (hpsa_tag_contains_index(raw_tag))
-				raw_tag = process_indexed_cmd(h, raw_tag);
+			if (likely(hpsa_tag_contains_index(raw_tag)))
+				process_indexed_cmd(h, raw_tag);
 			else
-				raw_tag = process_nonindexed_cmd(h, raw_tag);
+				process_nonindexed_cmd(h, raw_tag);
+			raw_tag = next_command(h);
 		}
 	}
 	spin_unlock_irqrestore(&h->lock, flags);
@@ -3495,10 +3494,11 @@ static irqreturn_t do_hpsa_intr_msi(int irq, void *dev_id)
 	h->last_intr_timestamp = get_jiffies_64();
 	raw_tag = get_next_completion(h);
 	while (raw_tag != FIFO_EMPTY) {
-		if (hpsa_tag_contains_index(raw_tag))
-			raw_tag = process_indexed_cmd(h, raw_tag);
+		if (likely(hpsa_tag_contains_index(raw_tag)))
+			process_indexed_cmd(h, raw_tag);
 		else
-			raw_tag = process_nonindexed_cmd(h, raw_tag);
+			process_nonindexed_cmd(h, raw_tag);
+		raw_tag = next_command(h);
 	}
 	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;

