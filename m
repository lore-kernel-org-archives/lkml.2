Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab2IKR24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:28:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16858 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab2IKR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:28:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="235380270"
From: Laura Abbott <lauraa@codeaurora.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-msm@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: [RFC][PATCH] fs/buffer.c: Revoke LRU when trying to drop buffers
Date: Tue, 11 Sep 2012 10:28:49 -0700
Message-Id: <1347384529-5862-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a buffer is added to the LRU list, a reference is taken which is
not dropped until the buffer is evicted from the LRU list. This is the
correct behavior, however this LRU reference will prevent the buffer
from being dropped. This means that the buffer can't actually be dropped
until it is selected for eviction. There's no bound on the time spent
on the LRU list, which means that the buffer may be undroppable for
very long periods of time. Given that migration involves dropping
buffers, the associated page is now unmigratible for long periods of
time as well. CMA relies on being able to migrate a specific range
of pages, so these these types of failures make CMA significantly
less reliable, especially under high filesystem usage.

Rather than waiting for the LRU algorithm to eventually kick out
the buffer, explicitly remove the buffer from the LRU list when trying
to drop it. There is still the possibility that the buffer
could be added back on the list, but that indicates the buffer is
still in use and would probably have other 'in use' indicates to
prevent dropping.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 fs/buffer.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index ad5938c..daa0c3d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1399,12 +1399,49 @@ static bool has_bh_in_lru(int cpu, void *dummy)
 	return 0;
 }
 
+static void __evict_bh_lru(void *arg)
+{
+	struct bh_lru *b = &get_cpu_var(bh_lrus);
+	struct buffer_head *bh = arg;
+	int i;
+
+	for (i = 0; i < BH_LRU_SIZE; i++) {
+		if (b->bhs[i] == bh) {
+			brelse(b->bhs[i]);
+			b->bhs[i] = NULL;
+			goto out;
+		}
+	}
+out:
+	put_cpu_var(bh_lrus);
+}
+
+static bool bh_exists_in_lru(int cpu, void *arg)
+{
+	struct bh_lru *b = per_cpu_ptr(&bh_lrus, cpu);
+	struct buffer_head *bh = arg;
+	int i;
+
+	for (i = 0; i < BH_LRU_SIZE; i++) {
+		if (b->bhs[i] == bh)
+			return 1;
+	}
+
+	return 0;
+
+}
 void invalidate_bh_lrus(void)
 {
 	on_each_cpu_cond(has_bh_in_lru, invalidate_bh_lru, NULL, 1, GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(invalidate_bh_lrus);
 
+void evict_bh_lrus(struct buffer_head *bh)
+{
+	on_each_cpu_cond(bh_exists_in_lru, __evict_bh_lru, bh, 1, GFP_ATOMIC);
+}
+EXPORT_SYMBOL_GPL(evict_bh_lrus);
+
 void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset)
 {
@@ -3052,6 +3089,7 @@ drop_buffers(struct page *page, struct buffer_head **buffers_to_free)
 
 	bh = head;
 	do {
+		evict_bh_lrus(bh);
 		if (buffer_write_io_error(bh) && page->mapping)
 			set_bit(AS_EIO, &page->mapping->flags);
 		if (buffer_busy(bh))
-- 
1.7.11.3

