Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1L2Kf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 05:35:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50639 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab1L2Kf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 05:35:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAB4K4y5K=su0PkvJhmskvaKQzv13V4nKb6XR92-+GynheeDSSA@mail.gmail.com>
References: <CAB4K4y5K=su0PkvJhmskvaKQzv13V4nKb6XR92-+GynheeDSSA@mail.gmail.com>
Date: Thu, 29 Dec 2011 16:05:55 +0530
Message-ID: <CAB4K4y7tkuXZQ=fAubWKVdbCZS4Zp0aYd0FK-Q6rzovjk0YUeg@mail.gmail.com>
Subject: Re: [PATCH] Squashfs: wake all waiting for unused cache entry
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4c7393143e4c2dfa7b5af87afc0e41842e8aba73 Mon Sep 17 00:00:00 2001
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date: Thu, 29 Dec 2011 16:04:45 +0530
Subject: [PATCH] Squashfs: wake all waiting for unused cache entry

Current implementation considers the case where different
blocks are waiting for unused cache entry, but it does not
consider the case where all / most of the waits are for the
same block, in that case, its good to wait for only one entry
and allow all other waits to use the newly allocated cache
entry.
While debugging we found that the wait is mostly for the same
block, hence its good to use wake_up_all().

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 fs/squashfs/cache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 30111a2..f035415 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -191,10 +191,10 @@ void squashfs_cache_put(struct
squashfs_cache_entry *entry)
                cache->unused++;
                /*
                 * If there's any processes waiting for a block to become
-                * available, wake one up.
+                * available, wake them.
                 */
                if (cache->num_waiters)
-                       wake_up(&cache->wait_queue);
+                       wake_up_all(&cache->wait_queue);
        }
        spin_unlock(&cache->lock);
 }
-- 
1.6.0.3
