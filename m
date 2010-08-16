Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0HPO0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:26:24 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:6909 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0HPO0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:26:21 -0400
Subject: [PATCH] cciss: fix botched tag masking for scsi tape commands
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 16 Aug 2010 09:32:16 -0500
Message-ID: <20100816143216.9826.15970.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

In process_non_indexed_cmd() we were only masking off the
low two bits when comparing tags vs. busaddr, and not taking
into account the fact that in "performant" mode, three bits of
block fetch table indexes were stuffed into the tag, and
needed to be masked out for the comparison to work.  This
resulted in spurious "bad tag" messages, and command
completions getting ignored for any scsi tape i/o and any i/o
coming through CCISS_BIG_PASSTHRU which required more than
one scatter gather entry (fewer than two worked because in
such cases the 3 bits we failed to mask off happened to be
zero anyway.)

I also noticed we were repeatedly masking the bits off the tag
in a loop when doing it once at the top of the loop would have
sufficed, so I fixed that as well.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index fdf1b79..39083e6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3179,10 +3179,13 @@ static inline u32 cciss_tag_to_index(u32 tag)
 	return tag >> DIRECT_LOOKUP_SHIFT;
 }
 
-static inline u32 cciss_tag_discard_error_bits(u32 tag)
+static inline u32 cciss_tag_discard_error_bits(ctlr_info_t *h, u32 tag)
 {
-#define CCISS_ERROR_BITS 0x03
-	return tag & ~CCISS_ERROR_BITS;
+#define CCISS_PERF_ERROR_BITS ((1 << DIRECT_LOOKUP_SHIFT) - 1)
+#define CCISS_SIMPLE_ERROR_BITS 0x03
+	if (likely(h->transMethod == CFGTBL_Trans_Performant))
+		return tag & ~CCISS_PERF_ERROR_BITS;
+	return tag & ~CCISS_SIMPLE_ERROR_BITS;
 }
 
 static inline void cciss_mark_tag_indexed(u32 *tag)
@@ -3443,15 +3446,13 @@ static inline u32 process_indexed_cmd(ctlr_info_t *h, u32 raw_tag)
 /* process completion of a non-indexed command */
 static inline u32 process_nonindexed_cmd(ctlr_info_t *h, u32 raw_tag)
 {
-	u32 tag;
 	CommandList_struct *c = NULL;
 	struct hlist_node *tmp;
 	__u32 busaddr_masked, tag_masked;
 
-	tag = cciss_tag_discard_error_bits(raw_tag);
+	tag_masked = cciss_tag_discard_error_bits(h, raw_tag);
 	hlist_for_each_entry(c, tmp, &h->cmpQ, list) {
-		busaddr_masked = cciss_tag_discard_error_bits(c->busaddr);
-		tag_masked = cciss_tag_discard_error_bits(tag);
+		busaddr_masked = cciss_tag_discard_error_bits(h, c->busaddr);
 		if (busaddr_masked == tag_masked) {
 			finish_cmd(h, c, raw_tag);
 			return next_command(h);

