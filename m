Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0KWNla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:41:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40522 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab0KWNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:40:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=APE71rJwdZWywZE2DLHO4uAfDVmhBtDoxNuN+/knFiN03Ms25Fkyl8M3kkACFu9Zc+
         7EKcWki7Wsaa9Bk4xOcgbJifDkcUTVzWThyA6jpYsOgjJgI3YIABPUCV+B8cUT6pRLVn
         y3xYt0XMqzt4QvaWSfqe51dEN8ep2aOZwODmk=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH v3 19/22] dm: use little-endian bit operations
Date: Tue, 23 Nov 2010 22:38:21 +0900
Message-Id: <1290519504-3958-20-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
References: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h. This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
No change from previous submission
 drivers/md/dm-log.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 33420e6..8ba6fd8 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -251,20 +251,20 @@ struct log_c {
  */
 static inline int log_test_bit(uint32_t *bs, unsigned bit)
 {
-	return ext2_test_bit(bit, (unsigned long *) bs) ? 1 : 0;
+	return test_le_bit(bit, (unsigned long *) bs) ? 1 : 0;
 }
 
 static inline void log_set_bit(struct log_c *l,
 			       uint32_t *bs, unsigned bit)
 {
-	ext2_set_bit(bit, (unsigned long *) bs);
+	__test_and_set_le_bit(bit, (unsigned long *) bs);
 	l->touched_cleaned = 1;
 }
 
 static inline void log_clear_bit(struct log_c *l,
 				 uint32_t *bs, unsigned bit)
 {
-	ext2_clear_bit(bit, (unsigned long *) bs);
+	__test_and_clear_le_bit(bit, (unsigned long *) bs);
 	l->touched_dirtied = 1;
 }
 
@@ -740,7 +740,7 @@ static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
 		return 0;
 
 	do {
-		*region = ext2_find_next_zero_bit(
+		*region = find_next_zero_le_bit(
 					     (unsigned long *) lc->sync_bits,
 					     lc->region_count,
 					     lc->sync_search);
-- 
1.7.3.2

