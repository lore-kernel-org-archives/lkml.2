Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab2IEPOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:14:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33309 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838Ab2IEPOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:14:06 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org
Subject: [RFC PATCH 3/3] target: try satisfying memory requests with contiguous blocks
Date: Wed,  5 Sep 2012 17:13:45 +0200
Message-Id: <1346858025-10459-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1346858025-10459-1-git-send-email-pbonzini@redhat.com>
References: <1346858025-10459-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

transport_generic_get_mem's strategy of allocating pages one-by-one
for the data scatterlist may fail for even not-so-big data transfers
if the underlying device poses a small limit on the number of segments.

This patch fixes this problem by trying to allocate pages in relatively
large groups (at most 512 pages right now, equivalent to 2 MB per
allocation), but still without any slack.  The remainder is then
satisfied with subsequent smaller allocations.  For example, if the
data to be transferred is 132 KB, the new algorithm will attempt
a single 128 KB allocation, followed by a 4 KB allocation.
In case a contiguous block cannot be found, it will fall back to
a progressively smaller order.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/target_core_transport.c |   58 +++++++++++++++++++++++++++-----
 1 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 09028af..6e90e2c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2058,7 +2058,7 @@ static inline void transport_free_sgl(struct scatterlist *sgl, int nents)
 	int count;
 
 	for_each_sg(sgl, sg, nents, count)
-		__free_page(sg_page(sg));
+		__free_pages(sg_page(sg), get_order(sg->length));
 
 	kfree(sgl);
 }
@@ -2229,41 +2229,81 @@ void transport_kunmap_data_sg(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(transport_kunmap_data_sg);
 
+#define TRANSPORT_MAX_ORDER	9
+
+static inline int
+get_order_no_slack(u32 length)
+{
+	/*
+	 * get_order gives the smallest order that length fits in.
+	 * We want instead the largest order that does not give
+	 * any slack.
+	 *
+	 * Example (with PAGE_SIZE = 4096, PAGE_SHIFT = 12):
+	 * 	get_order_no_slack(0x1000) = fls(0) = 0, get_order(0x1000) = 0
+	 * 	get_order_no_slack(0x1001) = fls(0) = 0, get_order(0x1001) = 1
+	 * 	get_order_no_slack(0x1fff) = fls(0) = 0, get_order(0x1fff) = 1
+	 * 	get_order_no_slack(0x2000) = fls(1) = 1, get_order(0x2000) = 1
+	 * 	get_order_no_slack(0x3000) = fls(1) = 1, get_order(0x3000) = 2
+	 * 	get_order_no_slack(0x4000) = fls(2) = 2, get_order(0x4000) = 2
+	 * 	get_order_no_slack(0x8000) = fls(4) = 3, get_order(0x8000) = 3
+	 */
+	length >>= PAGE_SHIFT + 1;
+	return fls(length);
+}
+
 static int
 transport_generic_get_mem(struct se_cmd *cmd)
 {
 	u32 length = cmd->data_length;
+	u32 page_len;
 	unsigned int nents;
 	struct page *page;
 	gfp_t zero_flag;
 	int i = 0;
+	int order, max_order;
 
 	nents = DIV_ROUND_UP(length, PAGE_SIZE);
 	cmd->t_data_sg = kmalloc(sizeof(struct scatterlist) * nents, GFP_KERNEL);
 	if (!cmd->t_data_sg)
 		return -ENOMEM;
 
-	cmd->t_data_nents = nents;
 	sg_init_table(cmd->t_data_sg, nents);
 
 	zero_flag = cmd->se_cmd_flags & SCF_SCSI_DATA_CDB ? 0 : __GFP_ZERO;
 
+	max_order = TRANSPORT_MAX_ORDER;
 	while (length) {
-		u32 page_len = min_t(u32, length, PAGE_SIZE);
-		page = alloc_page(GFP_KERNEL | zero_flag);
-		if (!page)
-			goto out;
+		order = get_order_no_slack(length);
+		for (;;) {
+			order = min(order, max_order);
+			page_len = min_t(u32, length, PAGE_SIZE << order);
+			page = alloc_pages(GFP_KERNEL | zero_flag, order);
+			if (page)
+				break;
+
+			if (!order)
+				goto out;
+
+			/*
+			 * Allocation failed, only try with a smaller order
+			 * from this point.
+			 */
+			max_order = order - 1;
+		}
 
 		sg_set_page(&cmd->t_data_sg[i], page, page_len, 0);
 		length -= page_len;
 		i++;
 	}
+	cmd->t_data_nents = i;
+	sg_mark_end(&cmd->t_data_sg[i - 1]);
 	return 0;
 
 out:
-	while (i > 0) {
-		i--;
-		__free_page(sg_page(&cmd->t_data_sg[i]));
+	while (i-- > 0) {
+		struct scatterlist *sg = &cmd->t_data_sg[i];
+		__free_pages(sg_page(sg), get_order(sg->length));
 	}
 	kfree(cmd->t_data_sg);
 	cmd->t_data_sg = NULL;
-- 
1.7.1

