Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1L2K3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 05:29:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51967 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1L2K3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 05:29:22 -0500
MIME-Version: 1.0
Date: Thu, 29 Dec 2011 15:59:21 +0530
Message-ID: <CAB4K4y5K=su0PkvJhmskvaKQzv13V4nKb6XR92-+GynheeDSSA@mail.gmail.com>
Subject: [PATCH] Squashfs: wake all waiting for unused cache entry
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From aedb5bd99c423945699fa82d592f62ad928bf943 Mon Sep 17 00:00:00 2001
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date: Thu, 29 Dec 2011 15:45:58 +0530
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
 fs/squashfs/cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 30111a2..44ceecf 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -194,7 +194,7 @@ void squashfs_cache_put(struct squashfs_cache_entry *entry)
                 * available, wake one up.
                 */
                if (cache->num_waiters)
-                       wake_up(&cache->wait_queue);
+                       wake_up_all(&cache->wait_queue);
        }
        spin_unlock(&cache->lock);
 }
-- 
1.6.0.3
