Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab0HLAIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:08:34 -0400
Received: from kroah.org ([198.145.64.141]:47837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920Ab0HLAI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:27 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:15 2010
Message-Id: <20100812000615.639235245@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [32/67] Fix sget() race with failing mount
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 7a4dec53897ecd3367efb1e12fe8a4edc47dc0e9 upstream.

If sget() finds a matching superblock being set up, it'll
grab an active reference to it and grab s_umount.  That's
fine - we'll wait for completion of foofs_get_sb() that way.
However, if said foofs_get_sb() fails we'll end up holding
the halfway-created superblock.  deactivate_locked_super()
called by foofs_get_sb() will just unlock the sucker since
we are holding another active reference to it.

What we need is a way to tell if superblock has been successfully
set up.  Unfortunately, neither ->s_root nor the check for
MS_ACTIVE quite fit.  Cheap and easy way, suitable for backport:
new flag set by the (only) caller of ->get_sb().  If that flag
isn't present by the time sget() grabbed s_umount on preexisting
superblock it has found, it's seeing a stillborn and should
just bury it with deactivate_locked_super() (and repeat the search).

Longer term we want to set that flag in ->get_sb() instances (and
check for it to distinguish between "sget() found us a live sb"
and "sget() has allocated an sb, we need to set it up" in there,
instead of checking ->s_root as we do now).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namespace.c     |    2 +-
 fs/super.c         |    6 ++++++
 include/linux/fs.h |    1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1984,7 +1984,7 @@ long do_mount(char *dev_name, char *dir_
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
 
-	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
+	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
 		   MS_STRICTATIME);
 
--- a/fs/super.c
+++ b/fs/super.c
@@ -305,8 +305,13 @@ retry:
 			if (s) {
 				up_write(&s->s_umount);
 				destroy_super(s);
+				s = NULL;
 			}
 			down_write(&old->s_umount);
+			if (unlikely(!(old->s_flags & MS_BORN))) {
+				deactivate_locked_super(old);
+				goto retry;
+			}
 			return old;
 		}
 	}
@@ -909,6 +914,7 @@ vfs_kern_mount(struct file_system_type *
 		goto out_free_secdata;
 	BUG_ON(!mnt->mnt_sb);
 	WARN_ON(!mnt->mnt_sb->s_bdi);
+	mnt->mnt_sb->s_flags |= MS_BORN;
 
 	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
 	if (error)
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -209,6 +209,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 


