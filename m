Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2H2V71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 17:59:27 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33797 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab2H2V70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 17:59:26 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: zcache: fix cleancache race condition with shrinker
Date: Wed, 29 Aug 2012 16:58:45 -0500
Message-Id: <1346277525-22062-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082921-5112-0000-0000-00000B9F0EA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a race condition that results in memory
corruption when using cleancache.

The race exists between the zcache shrinker handler,
shrink_zcache_memory() and cleancache_get_page().

In most cases, the shrinker will both evict a zbpg
from its buddy list and flush it from tmem before a
cleancache_get_page() occurs on that page. A subsequent
cleancache_get_page() will fail in the tmem layer.

In the rare case that two occur together and the
cleancache_get_page() path gets through the tmem
layer before the shrinker path can flush tmem,
zbud_decompress() does a check to see if the zbpg is a
"zombie", i.e. not on a buddy list, which means the shrinker
is in the process of reclaiming it. If the zbpg is a zombie,
zbud_decompress() returns -EINVAL.

However, this return code is being ignored by the caller,
zcache_pampd_get_data_and_free(), which results in the
caller of cleancache_get_page() thinking that the page has
been properly retrieved when it has not.

This patch modifies zcache_pampd_get_data_and_free() to
convey the failure up the stack so that the caller of
cleancache_get_page() knows the page retrieval failed.

---
Based on v3.6-rc3.

This needs to be applied to stable trees as well.
zcache-main.c was named zcache.c before v3.1, so
I'm not sure how you want to handle trees earlier
than that.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index c214977..52b43b7 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1251,13 +1251,12 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *bufsize, bool raw,
 					void *pampd, struct tmem_pool *pool,
 					struct tmem_oid *oid, uint32_t index)
 {
-	int ret = 0;
-
 	BUG_ON(!is_ephemeral(pool));
-	zbud_decompress((struct page *)(data), pampd);
+	if (zbud_decompress((struct page *)(data), pampd) < 0)
+		return -EINVAL;
 	zbud_free_and_delist((struct zbud_hdr *)pampd);
 	atomic_dec(&zcache_curr_eph_pampd_count);
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.7.9.5

