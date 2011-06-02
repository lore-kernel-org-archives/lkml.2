Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab1FBHB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:01:56 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:27367 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933015Ab1FBHBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:01:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlcFAAky5015LCoegWdsb2JhbABTmBiOGBUBARYmJcdQhiEEoCk
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com
Subject: [PATCH 11/12] vfs: increase shrinker batch size
Date: Thu,  2 Jun 2011 17:01:06 +1000
Message-Id: <1306998067-27659-12-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1306998067-27659-1-git-send-email-david@fromorbit.com>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the per-sb shrinker is responsible for shrinking 2 or more
caches, increase the batch size to keep econmies of scale for
shrinking each cache.  Increase the shrinker batch size to 1024
objects.

To allow for a large increase in batch size, add a conditional
reschedule to prune_icache_sb() so that we don't hold the LRU spin
lock for too long. This mirrors the behaviour of the
__shrink_dcache_sb(), and allows us to increase the batch size
without needing to worry about problems caused by long lock hold
times.

To ensure that filesystems using the per-sb shrinker callouts don't
cause problems, document that the object freeing method must
reschedule appropriately inside loops.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Documentation/filesystems/vfs.txt |    5 +++++
 fs/super.c                        |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index dc732d2..2e26973 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -317,6 +317,11 @@ or bottom half).
 	the VM is trying to reclaim under GFP_NOFS conditions, hence this
 	method does not need to handle that situation itself.
 
+	Implementations must include conditional reschedule calls inside any
+	scanning loop that is done. This allows the VFS to determine
+	appropriate scan batch sizes without having to worry about whether
+	implementations will cause holdoff problems due ot large batch sizes.
+
 Whoever sets up the inode is responsible for filling in the "i_op" field. This
 is a pointer to a "struct inode_operations" which describes the methods that
 can be performed on individual inodes.
diff --git a/fs/super.c b/fs/super.c
index b55f968..323a63e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -184,6 +184,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 
 		s->s_shrink.seeks = DEFAULT_SEEKS;
 		s->s_shrink.shrink = prune_super;
+		s->s_shrink.batch = 1024;
 	}
 out:
 	return s;
-- 
1.7.5.1

