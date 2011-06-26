Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab1FZF5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 01:57:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49791 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1FZF4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 01:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Gy8qxusqWV0C0Mv0asHv8Pv/pTBy2sI5ywVtqanoVpIcBz7ovj5MRuQjsBxJX/bu1J
         BPqcVl9XRBxxQ2RWEw7GwwRjhnX6RZf9bkKpUD5BoH1jG7KfkMZkDH92wW7nzUJXC0bm
         UIl9yndGcqs9BtfpFXcRsc5feEgMW/ghfxFeQ=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH resend 2/6] dm: use use proper little-endian bitops
Date: Sun, 26 Jun 2011 14:57:52 +0900
Message-Id: <1309067876-3537-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
References: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
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
index 948e3f4..2ef7e6e 100644
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
 
@@ -739,8 +739,7 @@ static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
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

