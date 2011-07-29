Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1G2NpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:45:14 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:6109 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab1G2NpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:45:08 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        David Chinner <david@fromorbit.com>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 3/4] dcache set size
Date: Fri, 29 Jul 2011 17:44:18 +0400
Message-Id: <1311947059-17209-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311947059-17209-1-git-send-email-glommer@parallels.com>
References: <1311947059-17209-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple patch that provides a function allowing its caller to set
the maximum number of dentries that can exist at the same time
at a given super block. Will be used in a later patch.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Dave Chinner <david@fromorbit.com>
---
 fs/dcache.c            |   12 ++++++++++++
 include/linux/dcache.h |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 3bdb106..4369aa2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1202,6 +1202,18 @@ static int dcache_mem_check(struct super_block *sb)
 	return -ENOMEM;
 }
 
+int vfs_set_dcache_size(struct super_block *sb, int size)
+{
+	unsigned long dr = percpu_counter_sum_positive(&sb->s_nr_dentry); 
+
+	if (size != sb->s_nr_dentry_max)
+		prune_dcache_sb(sb, dr - size);
+
+	sb->s_nr_dentry_max = size;
+
+	return 0;
+}
+
 /**
  * __d_alloc	-	allocate a dcache entry
  * @sb: filesystem it will belong to
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index d37d2a7..cd1ab71 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -251,6 +251,7 @@ extern int d_invalidate(struct dentry *);
 
 /* only used at mount-time */
 extern struct dentry * d_alloc_root(struct inode *);
+extern int vfs_set_dcache_size(struct super_block *sb, int size);
 
 /* <clickety>-<click> the ramfs-type tree */
 extern void d_genocide(struct dentry *);
-- 
1.7.6

