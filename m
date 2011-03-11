Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1CKU7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:59:14 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:16313 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1CKU7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:59:08 -0500
Subject: [PATCH 2/7] cciss: Inform controller we are using 32-bit tags.
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Fri, 11 Mar 2011 14:55:40 -0600
Message-ID: <20110311205540.2211.44012.stgit@beardog.cce.hp.com>
In-Reply-To: <20110311205306.2211.53569.stgit@beardog.cce.hp.com>
References: <20110311205306.2211.53569.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Controller will DMA only 32-bits of the tag per command
on completion if it knows we are only using 32-bit tags.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c     |   25 +++++++++++++++----------
 drivers/block/cciss_cmd.h |    1 +
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8c88944..66363f0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -231,7 +231,7 @@ static const struct block_device_operations cciss_fops = {
  */
 static void set_performant_mode(ctlr_info_t *h, CommandList_struct *c)
 {
-	if (likely(h->transMethod == CFGTBL_Trans_Performant))
+	if (likely(h->transMethod & CFGTBL_Trans_Performant))
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
 }
 
@@ -3136,10 +3136,13 @@ static inline u32 cciss_tag_to_index(u32 tag)
 	return tag >> DIRECT_LOOKUP_SHIFT;
 }
 
-static inline u32 cciss_tag_discard_error_bits(u32 tag)
+static inline u32 cciss_tag_discard_error_bits(ctlr_info_t *h, u32 tag)
 {
-#define CCISS_ERROR_BITS 0x03
-	return tag & ~CCISS_ERROR_BITS;
+#define CCISS_PERF_ERROR_BITS ((1 << DIRECT_LOOKUP_SHIFT) - 1)
+#define CCISS_SIMPLE_ERROR_BITS 0x03
+	if (likely(h->transMethod & CFGTBL_Trans_Performant))
+		return tag & ~CCISS_PERF_ERROR_BITS;
+	return tag & ~CCISS_SIMPLE_ERROR_BITS;
 }
 
 static inline void cciss_mark_tag_indexed(u32 *tag)
@@ -3359,7 +3362,7 @@ static inline u32 next_command(ctlr_info_t *h)
 {
 	u32 a;
 
-	if (unlikely(h->transMethod != CFGTBL_Trans_Performant))
+	if (unlikely(!(h->transMethod & CFGTBL_Trans_Performant)))
 		return h->access.command_completed(h);
 
 	if ((*(h->reply_pool_head) & 1) == (h->reply_pool_wraparound)) {
@@ -3397,9 +3400,9 @@ static inline u32 process_nonindexed_cmd(ctlr_info_t *h, u32 raw_tag)
 	CommandList_struct *c = NULL;
 	__u32 busaddr_masked, tag_masked;
 
-	tag_masked = cciss_tag_discard_error_bits(raw_tag);
+	tag_masked = cciss_tag_discard_error_bits(h, raw_tag);
 	list_for_each_entry(c, &h->cmpQ, list) {
-		busaddr_masked = cciss_tag_discard_error_bits(c->busaddr);
+		busaddr_masked = cciss_tag_discard_error_bits(h, c->busaddr);
 		if (busaddr_masked == tag_masked) {
 			finish_cmd(h, c, raw_tag);
 			return next_command(h);
@@ -3751,7 +3754,8 @@ static void __devinit cciss_wait_for_mode_change_ack(ctlr_info_t *h)
 	}
 }
 
-static __devinit void cciss_enter_performant_mode(ctlr_info_t *h)
+static __devinit void cciss_enter_performant_mode(ctlr_info_t *h,
+	u32 use_short_tags)
 {
 	/* This is a bit complicated.  There are 8 registers on
 	 * the controller which we write to to tell it 8 different
@@ -3806,7 +3810,7 @@ static __devinit void cciss_enter_performant_mode(ctlr_info_t *h)
 	writel(0, &h->transtable->RepQCtrAddrHigh32);
 	writel(h->reply_pool_dhandle, &h->transtable->RepQAddr0Low32);
 	writel(0, &h->transtable->RepQAddr0High32);
-	writel(CFGTBL_Trans_Performant,
+	writel(CFGTBL_Trans_Performant | use_short_tags,
 			&(h->cfgtable->HostWrite.TransportRequest));
 
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
@@ -3853,7 +3857,8 @@ static void __devinit cciss_put_controller_into_performant_mode(ctlr_info_t *h)
 	if ((h->reply_pool == NULL) || (h->blockFetchTable == NULL))
 		goto clean_up;
 
-	cciss_enter_performant_mode(h);
+	cciss_enter_performant_mode(h,
+		trans_support & CFGTBL_Trans_use_short_tags);
 
 	/* Change the access methods to the performant access methods */
 	h->access = SA5_performant_access;
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index 35463d2..cd441be 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -56,6 +56,7 @@
 
 #define CFGTBL_Trans_Simple     0x00000002l
 #define CFGTBL_Trans_Performant 0x00000004l
+#define CFGTBL_Trans_use_short_tags 0x20000000l
 
 #define CFGTBL_BusType_Ultra2   0x00000001l
 #define CFGTBL_BusType_Ultra3   0x00000002l

