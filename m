Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2EBWGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:06:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:16640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab2EBWGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:06:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="136332243"
Subject: [RFC, PATCH] Make memory reclaim from inodes and dentry cache more
 scalable
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 May 2012 15:06:22 -0700
Message-ID: <1335996382.3796.88.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch detects when inodes and dentries cache are really
low in free entries, and skip reclamation of memory from them when it is
futile to do so.  We only resume reclaiming memory from inodes and
dentries cache when we have a reasonable amount of memory there. 
This avoided us bottlenecking on sb_lock to do useless memory
reclamation.  

I assume that it is okay to check super block's number of free objects
content without sb_lock as we are holding shrinker list's read lock. The
shrinker is still registered so super block is not yet deactivated which
requires shrinker un-registration.  It will be great if Al can help to
comment on whether this assumption is okay.

In a test scenario where page cache is putting heavy pressure on memory
usage with large number of processes, we saw very heavy contention on
the sb_lock to get free pages as seen in the following profile. The
patch helped to reduce the runtime by almost a factor of 4.

    62.81%               cp  [kernel.kallsyms]           [k] _raw_spin_lock
                         |
                         --- _raw_spin_lock
                            |
                            |--45.19%-- grab_super_passive
                            |          prune_super
                            |          shrink_slab
                            |          do_try_to_free_pages
                            |          try_to_free_pages
                            |          __alloc_pages_nodemask
                            |          alloc_pages_current


Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
diff --git a/fs/super.c b/fs/super.c
index 8760fe1..e91c7506 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -38,6 +38,9 @@
 LIST_HEAD(super_blocks);
 DEFINE_SPINLOCK(sb_lock);
 
+int	sb_cache_himark = 100;
+int	sb_cache_lowmark = 5;
+
 /*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
@@ -60,6 +63,20 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 	if (sc->nr_to_scan && !(sc->gfp_mask & __GFP_FS))
 		return -1;
 
+	/* Don't do useless reclaim unless we have reasonable amount
+	 * of free objects to avoid sb_lock contention.
+	 * Should be okay to reference sb content without sb_lock as we are
+	 * holding shrinker list's read lock, which means shrinker is still
+	 * registered. So sb is not yet deactivated which requires shrinker
+	 * un-registration.
+	 */
+	if (sb->cache_low) {
+		total_objects = sb->s_nr_dentry_unused +
+				sb->s_nr_inodes_unused + fs_objects;
+		if (total_objects < sb_cache_himark)
+			return 0;
+	}
+
 	if (!grab_super_passive(sb))
 		return !sc->nr_to_scan ? 0 : -1;
 
@@ -69,6 +86,9 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 	total_objects = sb->s_nr_dentry_unused +
 			sb->s_nr_inodes_unused + fs_objects + 1;
 
+	if (!sb->cache_low && total_objects <= sb_cache_lowmark)
+		sb->cache_low = 1;
+
 	if (sc->nr_to_scan) {
 		int	dentries;
 		int	inodes;
@@ -96,6 +116,9 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 				sb->s_nr_inodes_unused + fs_objects;
 	}
 
+	if (sb->cache_low && total_objects > sb_cache_himark)
+		sb->cache_low = 0;
+
 	total_objects = (total_objects / 100) * sysctl_vfs_cache_pressure;
 	drop_super(sb);
 	return total_objects;
@@ -184,6 +207,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		s->s_shrink.seeks = DEFAULT_SEEKS;
 		s->s_shrink.shrink = prune_super;
 		s->s_shrink.batch = 1024;
+		s->cache_low = 0;
 	}
 out:
 	return s;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 386da09..c0465e3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1496,6 +1496,7 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+	int cache_low;
 };
 
 /* superblock cache pruning functions */


