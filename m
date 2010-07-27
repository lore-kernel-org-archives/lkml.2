Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0G0RrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:47:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50980 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab0G0RrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aNj/XDuAb1TFSD7jGUZYZVCfN3xBbMTNtH0Ev41h24ZVo5fgyobh0fm8/uDXcJUivC
         wWhfrCHTC6cdgAVE2IwD9CDkGrAqHwRhAlmrcsOXMBmpYBv4w79jxkRZ+f/fYlKOoW4r
         Vcb6qiAUA5+NiEt0tot+K0V0LsonD1oqhcURY=
Date: Tue, 27 Jul 2010 21:46:53 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: kernel-janitors@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Tejun Heo <tj@kernel.org>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] btrfs: set task state with
 schedule_timeout_uninterruptible()
Message-ID: <20100727174653.GA21048@albatros>
References: <1280132864-8266-1-git-send-email-segooon@gmail.com>
 <4C4E5560.9060905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4E5560.9060905@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedule_timeout() is used without setting state to
STATE_(UN)INTERRUPTIBLE. As it is called without checking of pending
signals, use schedule_timeout_uninterruptible() instead.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 fs/btrfs/async-thread.c |    2 +-
 fs/btrfs/extent-tree.c  |    6 +++---
 fs/btrfs/ordered-data.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7ec1409..54eb070 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -362,7 +362,7 @@ again:
 				 * worker->working is still 1, so nobody
 				 * is going to try and wake us up
 				 */
-				schedule_timeout(1);
+				schedule_timeout_uninterruptible(1);
 				smp_mb();
 				if (!list_empty(&worker->pending) ||
 				    !list_empty(&worker->prio_pending))
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 32d0940..5b55a20 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -365,7 +365,7 @@ again:
 			up_read(&fs_info->extent_commit_sem);
 			mutex_unlock(&caching_ctl->mutex);
 			if (btrfs_transaction_in_commit(fs_info))
-				schedule_timeout(1);
+				schedule_timeout_uninterruptible(1);
 			else
 				cond_resched();
 			goto again;
@@ -2237,7 +2237,7 @@ again:
 			node = rb_next(node);
 		}
 		spin_unlock(&delayed_refs->lock);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 		goto again;
 	}
 out:
@@ -3686,7 +3686,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	int ret;
 
 	if (btrfs_transaction_in_commit(root->fs_info))
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 again:
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e56c72b..9ff49e5 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -576,7 +576,7 @@ again:
 	}
 	if (found || test_range_bit(&BTRFS_I(inode)->io_tree, start, orig_end,
 			   EXTENT_DELALLOC, 0, NULL)) {
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 		goto again;
 	}
 	return 0;
-- 
1.7.0.4

