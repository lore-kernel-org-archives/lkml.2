Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1CQVEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:04:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755196Ab1CQVES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:04:18 -0400
Date: Thu, 17 Mar 2011 14:04:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q? "Andreas_Bie=DFmann" ?= 
	<andreas.devel@googlemail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Anton Altaparmakov <aia21@cantab.net>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in
 __mark_inode_dirty
Message-Id: <20110317140401.4f06793e.akpm@linux-foundation.org>
In-Reply-To: <4D6E016B.50600@gmail.com>
References: <1298906733-31427-1-git-send-email-biessmann@corscience.de>
	<20110228154314.GA4675@swordfish.minsk.epam.com>
	<4D6BC666.4010603@gmail.com>
	<20110228162909.GB4675@swordfish.minsk.epam.com>
	<AANLkTimARkrtmBBgtXmNA=MOD94FWQ8x-qcmLJ8mdQ6o@mail.gmail.com>
	<4D6E016B.50600@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Mar 2011 09:35:55 +0100
"Andreas Bie__mann" <andreas.devel@googlemail.com> wrote:

> Dear Jason A. Donenfeld,
> 
> Am 01.03.2011 10:00, schrieb Jason A. Donenfeld:
> > Can you make an isolated test case to trigger this bug?
> 
> in my case it is easily reproduceable. I have an SD-card in our embedded
> device (AVR32 AP7000). Some random data is continuously written to an
> FAT filesystem on that device. When you pull the card out of the slot
> you trigger that NULL pointer dereference.
> 
> I will try to reproduce that error on my workstation but this will need
> some time. Maybe I can not hit that race on my quad core workstation but
> I will give it a try.
> 

afaik this regression didn't get fixed.  Jens put out a patch for
George to test but there hasn't been any feedback on that yet.  Could
you guys please give it a spin?

From: Jens Axboe <axboe@kernel.dk>

When we move the potential dirty list entries to the
default_backing_dev_info, reassign the sb->s_bdi as well. 
default_backing_dev_info will always be around.  I hope this can fix it up
for 2.6.38 and we can add the proper ref counting for .39.

Cc: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: George Spelvin <linux@horizon.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andreas Biemann <biessmann@corscience.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Tested-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Cc: <stable@kernel.org>		[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c       |    2 ++
 fs/sync.c        |    4 ++--
 mm/backing-dev.c |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/super.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb fs/super.c
--- a/fs/super.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb
+++ a/fs/super.c
@@ -72,6 +72,7 @@ static struct super_block *alloc_super(s
 #else
 		INIT_LIST_HEAD(&s->s_files);
 #endif
+		s->s_bdi = &default_backing_dev_info;
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
@@ -1006,6 +1007,7 @@ vfs_kern_mount(struct file_system_type *
 	}
 	BUG_ON(!mnt->mnt_sb);
 	WARN_ON(!mnt->mnt_sb->s_bdi);
+	WARN_ON(mnt->mnt_sb->s_bdi == &default_backing_dev_info);
 	mnt->mnt_sb->s_flags |= MS_BORN;
 
 	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
diff -puN fs/sync.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb fs/sync.c
--- a/fs/sync.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb
+++ a/fs/sync.c
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
diff -puN mm/backing-dev.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb mm/backing-dev.c
--- a/mm/backing-dev.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb
+++ a/mm/backing-dev.c
@@ -598,7 +598,7 @@ static void bdi_prune_sb(struct backing_
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (sb->s_bdi == bdi)
-			sb->s_bdi = NULL;
+			sb->s_bdi = &default_backing_dev_info;
 	}
 	spin_unlock(&sb_lock);
 }
_


btw, Christoph: would this not have been be a less hacky hack?

--- a/fs/fs-writeback.c~a
+++ a/fs/fs-writeback.c
@@ -73,7 +73,7 @@ static inline struct backing_dev_info *i
 {
 	struct super_block *sb = inode->i_sb;
 
-	if (strcmp(sb->s_type->name, "bdev") == 0)
+	if (sb == blockdev_superblock)
 		return inode->i_mapping->backing_dev_info;
 
 	return sb->s_bdi;
_

