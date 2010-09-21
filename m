Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0IUACn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:02:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab0IUACl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:02:41 -0400
Date: Mon, 20 Sep 2010 20:02:15 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH -1/34] VFS: Add hard read-only users count to superblock
Message-ID: <20100921000215.GA9032@shell>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 03:11:51PM -0700, Valerie Aurora wrote:
> 
> Against 2.6.35.  The rest of the series (whiteouts, fallthrus,
> soon-to-be-obsolete copyup, etc.) is in branch "split_lookup"
> in:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/val/linux-2.6.git

I left out the first patch in this part of the series (there are
patches before and after this one in the branch git repo).  Here is
patch -1 in the queue:

Subject: VFS: Add hard read-only users count to superblock

While we can check if a file system is currently read-only, we can't
guarantee that it will stay read-only.  The file system can be mounted
or remounted read-write at any time.  This is a problem for union
mounts, which require the underlying file system be read-only for the
entire duration of the union mount.

Add a hard read-only users count to the superblock.  When this count
is non-zero, don't allow any read-write mounts of this super, or any
read-write remounts of existing mounts.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>


---
 fs/super.c         |    8 ++++++++
 include/linux/fs.h |    7 +++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 938119a..3f2df09 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -108,6 +108,7 @@ out:
  */
 static inline void destroy_super(struct super_block *s)
 {
+	BUG_ON(s->s_hard_readonly_users);
 	security_sb_free(s);
 	kfree(s->s_subtype);
 	kfree(s->s_options);
@@ -550,6 +551,9 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 			return -EBUSY;
 	}
 
+	if (!(flags & MS_RDONLY) && sb->s_hard_readonly_users)
+		return -EROFS;
+
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
 		if (retval)
@@ -924,6 +928,10 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	WARN((mnt->mnt_sb->s_maxbytes < 0), "%s set sb->s_maxbytes to "
 		"negative value (%lld)\n", type->name, mnt->mnt_sb->s_maxbytes);
 
+	error = -EROFS;
+	if (!(flags & MS_RDONLY) && mnt->mnt_sb->s_hard_readonly_users)
+		goto out_sb;
+
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	mnt->mnt_parent = mnt;
 	up_write(&mnt->mnt_sb->s_umount);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1ed7fe8..7dcb95b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1389,6 +1389,13 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+
+	/*
+	 * Number of mounts requiring that the underlying file system
+	 * never transition to read-write.  Protected by s_umount.
+	 * Decremented by free_vfsmnt() if MNT_HARD_READONLY is set.
+	 */
+	int s_hard_readonly_users;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
-- 
1.6.3.3

