Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab1CZAFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:05:46 -0400
Received: from kroah.org ([198.145.64.141]:41896 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566Ab1CYXxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:43 2011
Message-Id: <20110325234843.411105098@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [42/55] fs: assign sb->s_bdi to default_backing_dev_info if the bdi is going away
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Axboe <jaxboe@fusionio.com>

commit 95f28604a65b1c40b6c6cd95e58439cd7ded3add upstream.

We don't have proper reference counting for this yet, so we run into
cases where the device is pulled and we OOPS on flushing the fs data.
This happens even though the dirty inodes have already been
migrated to the default_backing_dev_info.

Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Tested-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/super.c       |    2 ++
 fs/sync.c        |    4 ++--
 mm/backing-dev.c |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -70,6 +70,7 @@ static struct super_block *alloc_super(s
 #else
 		INIT_LIST_HEAD(&s->s_files);
 #endif
+		s->s_bdi = &default_backing_dev_info;
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
@@ -996,6 +997,7 @@ vfs_kern_mount(struct file_system_type *
 	}
 	BUG_ON(!mnt->mnt_sb);
 	WARN_ON(!mnt->mnt_sb->s_bdi);
+	WARN_ON(mnt->mnt_sb->s_bdi == &default_backing_dev_info);
 	mnt->mnt_sb->s_flags |= MS_BORN;
 
 	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -33,7 +33,7 @@ static int __sync_filesystem(struct supe
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
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -604,7 +604,7 @@ static void bdi_prune_sb(struct backing_
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (sb->s_bdi == bdi)
-			sb->s_bdi = NULL;
+			sb->s_bdi = &default_backing_dev_info;
 	}
 	spin_unlock(&sb_lock);
 }


