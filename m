Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965614Ab2FBNl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 09:41:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58159 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933324Ab2FBNkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 09:40:52 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH v2 04/10] dm: use memweight()
Date: Sat,  2 Jun 2012 22:40:10 +0900
Message-Id: <1338644416-11417-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memweight() to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---

v2: change patch title s/dm-log:/dm:/

 drivers/md/dm-log.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 65ebaeb..627d191 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -571,16 +571,6 @@ static void disk_dtr(struct dm_dirty_log *log)
 	destroy_log_context(lc);
 }
 
-static int count_bits32(uint32_t *addr, unsigned size)
-{
-	int count = 0, i;
-
-	for (i = 0; i < size; i++) {
-		count += hweight32(*(addr+i));
-	}
-	return count;
-}
-
 static void fail_log_device(struct log_c *lc)
 {
 	if (lc->log_dev_failed)
@@ -629,7 +619,8 @@ static int disk_resume(struct dm_dirty_log *log)
 
 	/* copy clean across to sync */
 	memcpy(lc->sync_bits, lc->clean_bits, size);
-	lc->sync_count = count_bits32(lc->clean_bits, lc->bitset_uint32_count);
+	lc->sync_count = memweight(lc->clean_bits,
+				lc->bitset_uint32_count * sizeof(uint32_t));
 	lc->sync_search = 0;
 
 	/* set the correct number of regions in the header */
-- 
1.7.7.6

