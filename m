Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1K0FjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:39:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab1K0Fi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:38:57 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, devel@driverdev.osuosl.org
Subject: [PATCH 59/62] zcache: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:39 +0800
Message-Id: <1322371662-26166-60-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/staging/zcache/zcache-main.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 56c1f9c..487c4f3 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -422,13 +422,13 @@ static int zbud_decompress(struct page *page, struct zbud_hdr *zh)
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
@@ -677,13 +677,13 @@ static struct zv_hdr *zv_create(struct xv_pool *xvpool, uint32_t pool_id,
 		goto out;
 	zv_curr_dist_counts[chunks]++;
 	zv_cumul_dist_counts[chunks]++;
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
@@ -719,10 +719,10 @@ static void zv_decompress(struct page *page, struct zv_hdr *zv)
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
@@ -1301,12 +1301,12 @@ static int zcache_compress(struct page *from, void **out_va, size_t *out_len)
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
1.7.4.4

