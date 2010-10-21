Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab0JUOpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:45:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48175 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362Ab0JUOo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iZaYBYUo5GyhXxIuKaq/tUZC+19yIgS5Cy7OvPa/lfIfqEw1/6hD5C8/CwSS8IMfbC
         JhttB/rnzhrGeGUQ2znbFkWpyduXErTQJgdSmaHAWaX1E2Op5x7yMD801anprWhEj2J1
         +R+n17NPrS1oWeppsDCxtNTJJPEntQZvFwbEo=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH v2 19/22] dm: use little-endian bit operations
Date: Thu, 21 Oct 2010 23:41:14 +0900
Message-Id: <1287672077-5797-20-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
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
index 5a08be0..9a61fbc 100644
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
1.7.1.231.gd0b16

