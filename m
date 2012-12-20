Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2LTWjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:39:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab2LTWjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:39:00 -0500
Message-ID: <1356043138.2592.10.camel@localhost>
Subject: [GIT PULL] notification tree changes for 3.8
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 20 Dec 2012 17:38:58 -0500
Content-Type: multipart/mixed; boundary="=-4Q87NPg5zknaB8l44uNI"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4Q87NPg5zknaB8l44uNI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

I believe you would get a build failure after this pull due to the
addition of procfs information for *notify fds.  The attached patch from
sfr should be applied during the merge to change the spin_lock in that
patch to the mutex in this patch.

This pull mostly is about locking changes in the fsnotify system.  By
switching the group lock from a spin_lock() to a mutex() we can now hold
the lock across things like iput().  This fixes a problem involving
unmounting a fs and having inodes be busy, first pointed out by FAT, but
reproducible with tmpfs.

This also restores signal driven I/O for inotify, which has been broken
since about 2.6.32.

$ git request-pull v3.6 git://git.infradead.org/users/eparis/notify.git
The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

  Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-next

for you to fetch changes up to 1ca39ab9d21ac93f94b9e3eb364ea9a5cf2aba06:

  inotify: automatically restart syscalls (2012-12-11 13:44:37 -0500)

----------------------------------------------------------------
Eric Paris (2):
      fsnotify: make fasync generic for both inotify and fanotify
      inotify: automatically restart syscalls

Lino Sanfilippo (12):
      inotify, fanotify: replace fsnotify_put_group() with fsnotify_destroy_group()
      fsnotify: introduce fsnotify_get_group()
      fsnotify: use reference counting for groups
      fsnotify: take groups mark_lock before mark lock
      fanotify: add an extra flag to mark_remove_from_mask that indicates wheather a mark should be destroyed
      fsnotify: use a mutex instead of a spinlock to protect a groups mark list
      fsnotify: pass group to fsnotify_destroy_mark()
      fsnotify: introduce locked versions of fsnotify_add_mark() and fsnotify_remove_mark()
      fsnotify: dont put marks on temporary list when clearing marks by group
      fsnotify: change locking order
      fanotify: dont merge permission events
      inotify: dont skip removal of watch descriptor if creation of ignored event failed

 fs/notify/dnotify/dnotify.c          |  4 ++--
 fs/notify/fanotify/fanotify.c        |  6 ++++++
 fs/notify/fanotify/fanotify_user.c   | 37 +++++++++++++++++++++++++------------
 fs/notify/group.c                    | 47 +++++++++++++++++++++++++++--------------------
 fs/notify/inode_mark.c               | 14 +++++++++++---
 fs/notify/inotify/inotify_fsnotify.c |  4 +++-
 fs/notify/inotify/inotify_user.c     | 34 ++++++++++++++--------------------
 fs/notify/mark.c                     | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------
 fs/notify/notification.c             |  1 +
 fs/notify/vfsmount_mark.c            | 14 +++++++++++---
 include/linux/fsnotify_backend.h     | 31 +++++++++++++++++++++----------
 kernel/audit_tree.c                  | 10 +++++-----
 kernel/audit_watch.c                 |  4 ++--
 13 files changed, 178 insertions(+), 119 deletions(-)

--=-4Q87NPg5zknaB8l44uNI
Content-Disposition: attachment; filename="tmp.patch"
Content-Type: text/x-patch; name="tmp.patch"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 19 Dec 2012 11:53:20 +1100
Subject: [PATCH] fsnotify: cope with change from spinlock to mutex

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/notify/fdinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 514c4b8..238a593 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -27,13 +27,13 @@ static int show_fdinfo(struct seq_file *m, struct file *f,
 	struct fsnotify_mark *mark;
 	int ret = 0;
 
-	spin_lock(&group->mark_lock);
+	mutex_lock(&group->mark_mutex);
 	list_for_each_entry(mark, &group->marks_list, g_list) {
 		ret = show(m, mark);
 		if (ret)
 			break;
 	}
-	spin_unlock(&group->mark_lock);
+	mutex_unlock(&group->mark_mutex);
 	return ret;
 }
 

--=-4Q87NPg5zknaB8l44uNI--

