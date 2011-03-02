Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1CBIi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:38:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51180 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1CBIi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rk/hGuq5+5MbP7HUjhMb9WiICWh7IDvmZ7R+HWbduINBBVUKn+q5DtMNSt8qjg3MUb
         yh7F5cBa1WbEDJD95cWQAtQD61/0IJQIC/NaxhCXHqGWIX14gMhthiNhCkdpat+L5kYq
         c2qCujlxNr4rqh8NSxsM7Bp5prh7OlMxqhemk=
From: Liu Yuan <namei.unix@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com
Subject: [RFC PATCH 2/5] block: Add functions and data types for Page Cache Accounting
Date: Wed,  2 Mar 2011 16:38:07 +0800
Message-Id: <1299055090-23976-2-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <no>
References: <no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

These functions and data types are based on the percpu
disk stats infrastructure.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 include/linux/genhd.h |   56 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index c0d5f69..4f0257c 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -86,6 +86,11 @@ struct disk_stats {
 	unsigned long ticks[2];
 	unsigned long io_ticks;
 	unsigned long time_in_queue;
+#ifdef CONFIG_PAGE_CACHE_ACCT
+	unsigned long page_cache_readpages;
+	unsigned long page_cache_hit[2];
+	unsigned long page_cache_missed[2];
+#endif
 };
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
@@ -400,6 +405,57 @@ static inline void free_part_info(struct hd_struct *part)
 	kfree(part->info);
 }
 
+#ifdef CONFIG_PAGE_CACHE_ACCT
+static inline void page_cache_acct_readpages(struct super_block *sb, int nr_pages)
+{
+	struct block_device *bdev = sb->s_bdev;
+	struct hd_struct *part;
+	int cpu;
+	if (likely(bdev) && likely(part = bdev->bd_part)) {
+		cpu = part_stat_lock();
+		part_stat_add(cpu, part, page_cache_readpages, nr_pages);
+		part_stat_unlock();
+	}
+}
+static inline void page_cache_acct_hit(struct super_block *sb, int rw)
+{
+	struct block_device *bdev = sb->s_bdev;
+	struct hd_struct *part;
+	int cpu;
+	if (likely(bdev) && likely(part = bdev->bd_part)) {
+		cpu = part_stat_lock();
+		part_stat_inc(cpu, part, page_cache_hit[rw]);
+		part_stat_unlock();
+	}
+}
+
+static inline void page_cache_acct_missed(struct super_block *sb, int rw)
+{
+	struct block_device *bdev = sb->s_bdev;
+	struct hd_struct *part;
+	int cpu;
+	if (likely(bdev) && likely(part = bdev->bd_part)) {
+		cpu = part_stat_lock();
+		part_stat_inc(cpu, part, page_cache_missed[rw]);
+		part_stat_unlock();
+	}
+}
+
+#else /* !CONFIG_PAGE_CACHE_ACCT */
+static inline void page_cache_acct_readpages(struct super_block *sb, int nr_pages)
+{
+}
+
+static inline void page_cache_acct_hit(struct super_block *sb, int rw)
+{
+}
+
+static inline void page_cache_acct_missed(struct super_block *sb, int rw)
+{
+}
+
+#endif /* CONFIG_PAGE_CACHE_ACCT */
+
 /* block/blk-core.c */
 extern void part_round_stats(int cpu, struct hd_struct *part);
 
-- 
1.7.0.4

