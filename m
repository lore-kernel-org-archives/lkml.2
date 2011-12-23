Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab1LWNXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:23:04 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55411 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1LWNXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:23:02 -0500
MIME-Version: 1.0
Date: Fri, 23 Dec 2011 18:53:00 +0530
Message-ID: <CAB4K4y429TFcsZHPtJ=fdDNarj1r-eorpT16xHpdMycjQNUgbQ@mail.gmail.com>
Subject: [PATCH 2/2] Squashfs: Its safe to unlock cache after wake_up*
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 21d714543579c20d9b01dc958d0af80b14b390cf Mon Sep 17 00:00:00 2001
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date: Fri, 23 Dec 2011 18:02:32 +0530
Subject: [PATCH 2/2] Squashfs: Its safe to unlock cache after wake_up*

wake_up* calls are non sleeping varients, its safe to
call spin_unlock(cache->lock) after them.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 fs/squashfs/cache.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 88d986a..1f5a685 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -131,11 +131,10 @@ struct squashfs_cache_entry
*squashfs_cache_get(struct super_block *sb,
 			 * have looked it up in the cache, and have slept
 			 * waiting for it to become available.
 			 */
-			if (entry->num_waiters) {
-				spin_unlock(&cache->lock);
+			if (entry->num_waiters)
 				wake_up_all(&entry->wait_queue);
-			} else
-				spin_unlock(&cache->lock);
+
+			spin_unlock(&cache->lock);

 			goto out;
 		}
@@ -191,11 +190,8 @@ void squashfs_cache_put(struct squashfs_cache_entry *entry)
 		 * If there's any processes waiting for a block to become
 		 * available, wake one up.
 		 */
-		if (cache->num_waiters) {
-			spin_unlock(&cache->lock);
+		if (cache->num_waiters)
 			wake_up(&cache->wait_queue);
-			return;
-		}
 	}
 	spin_unlock(&cache->lock);
 }
-- 
1.6.0.3
