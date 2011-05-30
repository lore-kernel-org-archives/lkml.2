Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab1E3Mxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:53:40 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:42831 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1E3Mxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XJAYVVaBjwm0zv2Voyz9RG8N1ECCuPvJvIk+ATIa/7nGXVP4N9w0LEXVLgjkMcRS+0
         bF+XJ5DN2AuxKSRLdGxJIk/rfFCkaye7Ygomiq1Jv756vpqL2Ws6Mn7kA49wDUdrQm1k
         72KWg/TNusQpIstzIl3kyOFRhgosoZUDqASVo=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH] dm: use use proper little-endian bitops
Date: Mon, 30 May 2011 21:54:19 +0900
Message-Id: <1306760059-4219-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using __test_and_{set,clear}_bit_le() with ignoring its return value
can be replaced with __{set,clear}_bit_le().

This also removes unnecessary casts.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-log.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index a1f3218..56fe5fb 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -251,20 +251,20 @@ struct log_c {
  */
 static inline int log_test_bit(uint32_t *bs, unsigned bit)
 {
-	return test_bit_le(bit, (unsigned long *) bs) ? 1 : 0;
+	return test_bit_le(bit, bs) ? 1 : 0;
 }
 
 static inline void log_set_bit(struct log_c *l,
 			       uint32_t *bs, unsigned bit)
 {
-	__test_and_set_bit_le(bit, (unsigned long *) bs);
+	__set_bit_le(bit, bs);
 	l->touched_cleaned = 1;
 }
 
 static inline void log_clear_bit(struct log_c *l,
 				 uint32_t *bs, unsigned bit)
 {
-	__test_and_clear_bit_le(bit, (unsigned long *) bs);
+	__clear_bit_le(bit, bs);
 	l->touched_dirtied = 1;
 }
 
@@ -740,8 +740,7 @@ static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
 		return 0;
 
 	do {
-		*region = find_next_zero_bit_le(
-					     (unsigned long *) lc->sync_bits,
+		*region = find_next_zero_bit_le(lc->sync_bits,
 					     lc->region_count,
 					     lc->sync_search);
 		lc->sync_search = *region + 1;
-- 
1.7.4.4

