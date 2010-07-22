Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0GVAyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:54:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40177 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab0GVAyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=wRoZNIzZJuaZ8l3fF0kDftAjp2MMQDbmHUuPrFh1/t6jlzGgbgTFvGioNPDOCq2eSs
         DObTWFIf9fcPkjG7uAIeTo10yfyf7PzMr9jZ07o+vBL9GNaIlokaUGz1uucW7HNVTeqM
         F6GrazXXNSvuP/W5Gh+tXrf3qF7rYodmnvywA=
Message-ID: <4C4796CE.6080306@gmail.com>
Date: Thu, 22 Jul 2010 08:54:38 +0800
From: Wang Sheng-Hui <crosslonelyover@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, agruen@suse.de, hch@infradead.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: re: [PATCH] fix return value for mb_cache_shrink_fn when nr_to_scan
 > 0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, missed that. Regerated and passed checkpatch.pl check. 
Please check it.


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 fs/mbcache.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index ec88ff3..603170e 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -201,21 +201,14 @@ mb_cache_shrink_fn(int nr_to_scan, gfp_t gfp_mask)
 {
 	LIST_HEAD(free_list);
 	struct list_head *l, *ltmp;
+	struct mb_cache *cache;
 	int count = 0;
 
-	spin_lock(&mb_cache_spinlock);
-	list_for_each(l, &mb_cache_list) {
-		struct mb_cache *cache =
-			list_entry(l, struct mb_cache, c_cache_list);
-		mb_debug("cache %s (%d)", cache->c_name,
-			  atomic_read(&cache->c_entry_count));
-		count += atomic_read(&cache->c_entry_count);
-	}
 	mb_debug("trying to free %d entries", nr_to_scan);
-	if (nr_to_scan == 0) {
-		spin_unlock(&mb_cache_spinlock);
+	if (nr_to_scan == 0)
 		goto out;
-	}
+
+	spin_lock(&mb_cache_spinlock);
 	while (nr_to_scan-- && !list_empty(&mb_cache_lru_list)) {
 		struct mb_cache_entry *ce =
 			list_entry(mb_cache_lru_list.next,
@@ -229,6 +222,14 @@ mb_cache_shrink_fn(int nr_to_scan, gfp_t gfp_mask)
 						   e_lru_list), gfp_mask);
 	}
 out:
+	spin_lock(&mb_cache_spinlock);
+	list_for_each_entry(cache, &mb_cache_list, c_cache_list) {
+		mb_debug("cache %s (%d)", cache->c_name,
+			  atomic_read(&cache->c_entry_count));
+		count += atomic_read(&cache->c_entry_count);
+	}
+	spin_unlock(&mb_cache_spinlock);
+
 	return (count / 100) * sysctl_vfs_cache_pressure;
 }
 
-- 
1.6.3.3
