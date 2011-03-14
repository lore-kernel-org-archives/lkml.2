Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1CNHwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 03:52:45 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44909 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab1CNHwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 03:52:43 -0400
Message-ID: <4D7DC949.3040902@kernel.dk>
Date: Mon, 14 Mar 2011 08:52:41 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Anton Altaparmakov <aia21@cam.ac.uk>, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        George Spelvin <linux@horizon.com>
Subject: Re: a major regression in recent kernels? - was: Re: Null pointer
  OOPS in sync_inodes_sb+0xa9/0x104
References: <20110302034417.4954.qmail@science.horizon.com> <023AB542-CCF0-4436-8594-51132FEA8070@cam.ac.uk> <AANLkTi=eWdUjgTB2iWOB7YxOtm9f9a9Ux2uCghR=KTgN@mail.gmail.com>
In-Reply-To: <AANLkTi=eWdUjgTB2iWOB7YxOtm9f9a9Ux2uCghR=KTgN@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George,

If you can reproduce this easily, can you try with this patch? When we
move the potential dirty list entries to the default_backing_dev_info,
reassign the sb->s_bdi as well. default_backing_dev_info will always be
around. I hope this can fix it up for 2.6.38 and we can add the proper
ref counting for .39.

diff --git a/fs/super.c b/fs/super.c
index 7e9dd4c..0d89e93 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -71,6 +71,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 #else
 		INIT_LIST_HEAD(&s->s_files);
 #endif
+		s->s_bdi = &default_backing_dev_info;
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
@@ -1003,6 +1004,7 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	}
 	BUG_ON(!mnt->mnt_sb);
 	WARN_ON(!mnt->mnt_sb->s_bdi);
+	WARN_ON(mnt->mnt_sb->s_bdi == &default_backing_dev_info);
 	mnt->mnt_sb->s_flags |= MS_BORN;
 
 	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
diff --git a/fs/sync.c b/fs/sync.c
index ba76b96..412dc89 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -33,7 +33,7 @@ static int __sync_filesystem(struct super_block *sb, int wait)
 	 * This should be safe, as we require bdi backing to actually
 	 * write out data in the first place
 	 */
-	if (!sb->s_bdi || sb->s_bdi == &noop_backing_dev_info)
+	if (sb->s_bdi == &noop_backing_dev_info)
 		return 0;
 
 	if (sb->s_qcop && sb->s_qcop->quota_sync)
@@ -79,7 +79,7 @@ EXPORT_SYMBOL_GPL(sync_filesystem);
 
 static void sync_one_sb(struct super_block *sb, void *arg)
 {
-	if (!(sb->s_flags & MS_RDONLY) && sb->s_bdi)
+	if (!(sb->s_flags & MS_RDONLY))
 		__sync_filesystem(sb, *(int *)arg);
 }
 /*
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 027100d..8e4ed88 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -604,7 +604,7 @@ static void bdi_prune_sb(struct backing_dev_info *bdi)
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (sb->s_bdi == bdi)
-			sb->s_bdi = NULL;
+			sb->s_bdi = &default_backing_dev_info;
 	}
 	spin_unlock(&sb_lock);
 }

-- 
Jens Axboe

