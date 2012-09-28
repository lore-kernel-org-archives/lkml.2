Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031775Ab2I1T4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:56:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964836Ab2I1S4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [ 060/262] staging: zcache: fix cleancache race condition with shrinker
Date: Fri, 28 Sep 2012 11:49:49 -0700
Message-Id: <20120928183004.985018959@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Jennings <sjenning@linux.vnet.ibm.com>

commit 6d7d9798ad5c97ee4e911dd070dc12dc5ae55bd0 upstream.

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

This needs to be applied to stable trees as well.
zcache-main.c was named zcache.c before v3.1, so
I'm not sure how you want to handle trees earlier
than that.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zcache/zcache-main.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1259,13 +1259,12 @@ static int zcache_pampd_get_data_and_fre
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


