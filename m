Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab2BJFsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:48:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932751Ab2BJFsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:48:08 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 57/60] zcache: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:40:18 +0800
Message-Id: <1328852421-19678-58-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/staging/zcache/zcache-main.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index ef7c52b..f0843e8a 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -421,13 +421,13 @@ static int zbud_decompress(struct page *page, struct zbud_hdr *zh)
 	}
 	ASSERT_SENTINEL(zh, ZBH);
 	BUG_ON(zh->size == 0 || zh->size > zbud_max_buddy_size());
-	to_va = kmap_atomic(page, KM_USER0);
+	to_va = kmap_atomic(page);
 	size = zh->size;
 	from_va = zbud_data(zh, size);
 	ret = lzo1x_decompress_safe(from_va, size, to_va, &out_len);
 	BUG_ON(ret != LZO_E_OK);
 	BUG_ON(out_len != PAGE_SIZE);
-	kunmap_atomic(to_va, KM_USER0);
+	kunmap_atomic(to_va);
 out:
 	spin_unlock(&zbpg->lock);
 	return ret;
@@ -676,13 +676,13 @@ static struct zv_hdr *zv_create(struct xv_pool *xvpool, uint32_t pool_id,
 		goto out;
 	atomic_inc(&zv_curr_dist_counts[chunks]);
 	atomic_inc(&zv_cumul_dist_counts[chunks]);
-	zv = kmap_atomic(page, KM_USER0) + offset;
+	zv = kmap_atomic(page) + offset;
 	zv->index = index;
 	zv->oid = *oid;
 	zv->pool_id = pool_id;
 	SET_SENTINEL(zv, ZVH);
 	memcpy((char *)zv + sizeof(struct zv_hdr), cdata, clen);
-	kunmap_atomic(zv, KM_USER0);
+	kunmap_atomic(zv);
 out:
 	return zv;
 }
@@ -718,10 +718,10 @@ static void zv_decompress(struct page *page, struct zv_hdr *zv)
 	ASSERT_SENTINEL(zv, ZVH);
 	size = xv_get_object_size(zv) - sizeof(*zv);
 	BUG_ON(size == 0);
-	to_va = kmap_atomic(page, KM_USER0);
+	to_va = kmap_atomic(page);
 	ret = lzo1x_decompress_safe((char *)zv + sizeof(*zv),
 					size, to_va, &clen);
-	kunmap_atomic(to_va, KM_USER0);
+	kunmap_atomic(to_va);
 	BUG_ON(ret != LZO_E_OK);
 	BUG_ON(clen != PAGE_SIZE);
 }
@@ -1300,12 +1300,12 @@ static int zcache_compress(struct page *from, void **out_va, size_t *out_len)
 	BUG_ON(!irqs_disabled());
 	if (unlikely(dmem == NULL || wmem == NULL))
 		goto out;  /* no buffer, so can't compress */
-	from_va = kmap_atomic(from, KM_USER0);
+	from_va = kmap_atomic(from);
 	mb();
 	ret = lzo1x_1_compress(from_va, PAGE_SIZE, dmem, out_len, wmem);
 	BUG_ON(ret != LZO_E_OK);
 	*out_va = dmem;
-	kunmap_atomic(from_va, KM_USER0);
+	kunmap_atomic(from_va);
 	ret = 1;
 out:
 	return ret;
-- 
1.7.7.6

