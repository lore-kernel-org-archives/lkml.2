Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab2B1WDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:03:17 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:43737 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab2B1WDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:03:16 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: zcache: fix memory corruption bug
Date: Tue, 28 Feb 2012 16:02:23 -0600
Message-Id: <1330466543-24503-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022822-7408-0000-0000-0000030DA147
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug where the zv code writes before the allocated
buffer, resulting in system memory corruption. This was introduced
during the switch from xvmalloc to zsmalloc.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 46c7c04..7073465 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -701,7 +701,6 @@ static struct zv_hdr *zv_create(struct zs_pool *pool, uint32_t pool_id,
 	u32 size = clen + sizeof(struct zv_hdr);
 	int chunks = (size + (CHUNK_SIZE - 1)) >> CHUNK_SHIFT;
 	void *handle = NULL;
-	char *buf;
 
 	BUG_ON(!irqs_disabled());
 	BUG_ON(chunks >= NCHUNKS);
@@ -710,14 +709,13 @@ static struct zv_hdr *zv_create(struct zs_pool *pool, uint32_t pool_id,
 		goto out;
 	atomic_inc(&zv_curr_dist_counts[chunks]);
 	atomic_inc(&zv_cumul_dist_counts[chunks]);
-	zv = (struct zv_hdr *)((char *)cdata - sizeof(*zv));
+	zv = zs_map_object(pool, handle);
 	zv->index = index;
 	zv->oid = *oid;
 	zv->pool_id = pool_id;
 	zv->size = clen;
 	SET_SENTINEL(zv, ZVH);
-	buf = zs_map_object(pool, handle);
-	memcpy(buf, zv, clen + sizeof(*zv));
+	memcpy((char *)zv + sizeof(struct zv_hdr), cdata, clen);
 	zs_unmap_object(pool, handle);
 out:
 	return handle;
-- 
1.7.5.4

