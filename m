Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0HWBSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:18:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58790 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab0HWBSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:18:35 -0400
Message-ID: <4C71CD91.4050703@cn.fujitsu.com>
Date: Mon, 23 Aug 2010 09:23:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] btrfs: update stats when allocating from a cluster
References: <4C71CD4B.10606@cn.fujitsu.com>
In-Reply-To: <4C71CD4B.10606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating extent entry from a cluster, we should update
the free_space and free_extents fields of the block group.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 631e14f..20f3141 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1090,15 +1090,26 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 		entry->offset += bytes;
 		entry->bytes -= bytes;
 
-		if (entry->bytes == 0) {
+		if (entry->bytes == 0)
 			rb_erase(&entry->offset_index, &cluster->root);
-			kfree(entry);
-		}
 		break;
 	}
 out:
 	spin_unlock(&cluster->lock);
 
+	if (!ret)
+		return 0;
+
+	spin_lock(&block_group->tree_lock);
+
+	block_group->free_space -= bytes;
+	if (entry->bytes == 0) {
+		block_group->free_extents--;
+		kfree(entry);
+	}
+
+	spin_unlock(&block_group->tree_lock);
+
 	return ret;
 }
 
-- 
1.7.0.1

