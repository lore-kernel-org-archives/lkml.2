Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab1BPB24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:28:56 -0500
Received: from kroah.org ([198.145.64.141]:39418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab1BPAV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:38 2011
Message-Id: <20110216001438.524201583@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [135/272] ext4: make grpinfo slab cache names static
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 2892c15ddda6a76dc10b7499e56c0f3b892e5a69 upstream.

In 2.6.37 I was running into oopses with repeated module
loads & unloads.  I tracked this down to:

fb1813f4 ext4: use dedicated slab caches for group_info structures

(this was in addition to the features advert unload problem)

The kstrdup & subsequent kfree of the cache name was causing
a double free.  In slub, at least, if I read it right it allocates
& frees the name itself, slab seems to do something different...
so in slub I think we were leaking -our- cachep->name, and double
freeing the one allocated by slub.

After getting lost in slab/slub/slob a bit, I just looked at other
sized-caches that get allocated.  jbd2, biovec, sgpool all do it
more or less the way jbd2 does.  Below patch follows the jbd2
method of dynamically allocating a cache at mount time from
a list of static names.

(This might also possibly fix a race creating the caches with
parallel mounts running).

[Folded in a fix from Dan Carpenter which fixed an off-by-one error in
the original patch]

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |  100 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 40 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -342,10 +342,15 @@ static struct kmem_cache *ext4_free_ext_
 /* We create slab caches for groupinfo data structures based on the
  * superblock block size.  There will be one per mounted filesystem for
  * each unique s_blocksize_bits */
-#define NR_GRPINFO_CACHES	\
-	(EXT4_MAX_BLOCK_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE + 1)
+#define NR_GRPINFO_CACHES 8
 static struct kmem_cache *ext4_groupinfo_caches[NR_GRPINFO_CACHES];
 
+static const char *ext4_groupinfo_slab_names[NR_GRPINFO_CACHES] = {
+	"ext4_groupinfo_1k", "ext4_groupinfo_2k", "ext4_groupinfo_4k",
+	"ext4_groupinfo_8k", "ext4_groupinfo_16k", "ext4_groupinfo_32k",
+	"ext4_groupinfo_64k", "ext4_groupinfo_128k"
+};
+
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
 static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
@@ -2414,6 +2419,55 @@ err_freesgi:
 	return -ENOMEM;
 }
 
+static void ext4_groupinfo_destroy_slabs(void)
+{
+	int i;
+
+	for (i = 0; i < NR_GRPINFO_CACHES; i++) {
+		if (ext4_groupinfo_caches[i])
+			kmem_cache_destroy(ext4_groupinfo_caches[i]);
+		ext4_groupinfo_caches[i] = NULL;
+	}
+}
+
+static int ext4_groupinfo_create_slab(size_t size)
+{
+	static DEFINE_MUTEX(ext4_grpinfo_slab_create_mutex);
+	int slab_size;
+	int blocksize_bits = order_base_2(size);
+	int cache_index = blocksize_bits - EXT4_MIN_BLOCK_LOG_SIZE;
+	struct kmem_cache *cachep;
+
+	if (cache_index >= NR_GRPINFO_CACHES)
+		return -EINVAL;
+
+	if (unlikely(cache_index < 0))
+		cache_index = 0;
+
+	mutex_lock(&ext4_grpinfo_slab_create_mutex);
+	if (ext4_groupinfo_caches[cache_index]) {
+		mutex_unlock(&ext4_grpinfo_slab_create_mutex);
+		return 0;	/* Already created */
+	}
+
+	slab_size = offsetof(struct ext4_group_info,
+				bb_counters[blocksize_bits + 2]);
+
+	cachep = kmem_cache_create(ext4_groupinfo_slab_names[cache_index],
+					slab_size, 0, SLAB_RECLAIM_ACCOUNT,
+					NULL);
+
+	mutex_unlock(&ext4_grpinfo_slab_create_mutex);
+	if (!cachep) {
+		printk(KERN_EMERG "EXT4: no memory for groupinfo slab cache\n");
+		return -ENOMEM;
+	}
+
+	ext4_groupinfo_caches[cache_index] = cachep;
+
+	return 0;
+}
+
 int ext4_mb_init(struct super_block *sb, int needs_recovery)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -2421,9 +2475,6 @@ int ext4_mb_init(struct super_block *sb,
 	unsigned offset;
 	unsigned max;
 	int ret;
-	int cache_index;
-	struct kmem_cache *cachep;
-	char *namep = NULL;
 
 	i = (sb->s_blocksize_bits + 2) * sizeof(*sbi->s_mb_offsets);
 
@@ -2440,30 +2491,9 @@ int ext4_mb_init(struct super_block *sb,
 		goto out;
 	}
 
-	cache_index = sb->s_blocksize_bits - EXT4_MIN_BLOCK_LOG_SIZE;
-	cachep = ext4_groupinfo_caches[cache_index];
-	if (!cachep) {
-		char name[32];
-		int len = offsetof(struct ext4_group_info,
-					bb_counters[sb->s_blocksize_bits + 2]);
-
-		sprintf(name, "ext4_groupinfo_%d", sb->s_blocksize_bits);
-		namep = kstrdup(name, GFP_KERNEL);
-		if (!namep) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		/* Need to free the kmem_cache_name() when we
-		 * destroy the slab */
-		cachep = kmem_cache_create(namep, len, 0,
-					     SLAB_RECLAIM_ACCOUNT, NULL);
-		if (!cachep) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		ext4_groupinfo_caches[cache_index] = cachep;
-	}
+	ret = ext4_groupinfo_create_slab(sb->s_blocksize);
+	if (ret < 0)
+		goto out;
 
 	/* order 0 is regular bitmap */
 	sbi->s_mb_maxs[0] = sb->s_blocksize << 3;
@@ -2520,7 +2550,6 @@ out:
 	if (ret) {
 		kfree(sbi->s_mb_offsets);
 		kfree(sbi->s_mb_maxs);
-		kfree(namep);
 	}
 	return ret;
 }
@@ -2734,7 +2763,6 @@ int __init ext4_init_mballoc(void)
 
 void ext4_exit_mballoc(void)
 {
-	int i;
 	/*
 	 * Wait for completion of call_rcu()'s on ext4_pspace_cachep
 	 * before destroying the slab cache.
@@ -2743,15 +2771,7 @@ void ext4_exit_mballoc(void)
 	kmem_cache_destroy(ext4_pspace_cachep);
 	kmem_cache_destroy(ext4_ac_cachep);
 	kmem_cache_destroy(ext4_free_ext_cachep);
-
-	for (i = 0; i < NR_GRPINFO_CACHES; i++) {
-		struct kmem_cache *cachep = ext4_groupinfo_caches[i];
-		if (cachep) {
-			char *name = (char *)kmem_cache_name(cachep);
-			kmem_cache_destroy(cachep);
-			kfree(name);
-		}
-	}
+	ext4_groupinfo_destroy_slabs();
 	ext4_remove_debugfs_entry();
 }
 


