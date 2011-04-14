Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960Ab1DNSgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:36:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:37266 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab1DNRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 011/209] Fix sget() race with failing mount
Date: Thu, 14 Apr 2011 13:40:41 -0400
Message-Id: <1302803039-9400-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/namespace.c     |    2 +-
 fs/super.c         |    6 ++++++
 include/linux/fs.h |    1 +
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f20cb57..bfe3f3e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1996,7 +1996,7 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
 
-	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
+	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
 		   MS_STRICTATIME);
 
diff --git a/fs/super.c b/fs/super.c
index 1527e6a..53040a6 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -356,6 +356,11 @@ retry:
 			if (s) {
 				up_write(&s->s_umount);
 				destroy_super(s);
+				s = NULL;
+			}
+			if (unlikely(!(old->s_flags & MS_BORN))) {
+				deactivate_locked_super(old);
+				goto retry;
 			}
 			return old;
 		}
@@ -957,6 +962,7 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 		goto out_free_secdata;
 	BUG_ON(!mnt->mnt_sb);
 	WARN_ON(!mnt->mnt_sb->s_bdi);
+	mnt->mnt_sb->s_flags |= MS_BORN;
 
 	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
 	if (error)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e93529d..8aa6bd9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -209,6 +209,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
-- 
1.7.4.4

