Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1DLOwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:52:12 -0400
Received: from kroah.org ([198.145.64.141]:57586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267Ab1DLOiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:52 2011
Message-Id: <20110412143552.865034023@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>
Subject: [046/105] inotify: fix double free/corruption of stuct user
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit d0de4dc584ec6aa3b26fffea320a8457827768fc upstream.

On an error path in inotify_init1 a normal user can trigger a double
free of struct user.  This is a regression introduced by a2ae4cc9a16e
("inotify: stop kernel memory leak on file creation failure").

We fix this by making sure that if a group exists the user reference is
dropped when the group is cleaned up.  We should not explictly drop the
reference on error and also drop the reference when the group is cleaned
up.

The new lifetime rules are that an inotify group lives from
inotify_new_group to the last fsnotify_put_group.  Since the struct user
and inotify_devs are directly tied to this lifetime they are only
changed/updated in those two locations.  We get rid of all special
casing of struct user or user->inotify_devs.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/inotify/inotify_fsnotify.c |    1 
 fs/notify/inotify/inotify_user.c     |   39 +++++++++++------------------------
 2 files changed, 14 insertions(+), 26 deletions(-)

--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -198,6 +198,7 @@ static void inotify_free_group_priv(stru
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
 	idr_remove_all(&group->inotify_data.idr);
 	idr_destroy(&group->inotify_data.idr);
+	atomic_dec(&group->inotify_data.user->inotify_devs);
 	free_uid(group->inotify_data.user);
 }
 
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -290,7 +290,6 @@ static int inotify_fasync(int fd, struct
 static int inotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
-	struct user_struct *user = group->inotify_data.user;
 
 	pr_debug("%s: group=%p\n", __func__, group);
 
@@ -299,8 +298,6 @@ static int inotify_release(struct inode
 	/* free this group, matching get was inotify_init->fsnotify_obtain_group */
 	fsnotify_put_group(group);
 
-	atomic_dec(&user->inotify_devs);
-
 	return 0;
 }
 
@@ -697,7 +694,7 @@ retry:
 	return ret;
 }
 
-static struct fsnotify_group *inotify_new_group(struct user_struct *user, unsigned int max_events)
+static struct fsnotify_group *inotify_new_group(unsigned int max_events)
 {
 	struct fsnotify_group *group;
 
@@ -710,8 +707,14 @@ static struct fsnotify_group *inotify_ne
 	spin_lock_init(&group->inotify_data.idr_lock);
 	idr_init(&group->inotify_data.idr);
 	group->inotify_data.last_wd = 0;
-	group->inotify_data.user = user;
 	group->inotify_data.fa = NULL;
+	group->inotify_data.user = get_current_user();
+
+	if (atomic_inc_return(&group->inotify_data.user->inotify_devs) >
+	    inotify_max_user_instances) {
+		fsnotify_put_group(group);
+		return ERR_PTR(-EMFILE);
+	}
 
 	return group;
 }
@@ -721,7 +724,6 @@ static struct fsnotify_group *inotify_ne
 SYSCALL_DEFINE1(inotify_init1, int, flags)
 {
 	struct fsnotify_group *group;
-	struct user_struct *user;
 	int ret;
 
 	/* Check the IN_* constants for consistency.  */
@@ -731,31 +733,16 @@ SYSCALL_DEFINE1(inotify_init1, int, flag
 	if (flags & ~(IN_CLOEXEC | IN_NONBLOCK))
 		return -EINVAL;
 
-	user = get_current_user();
-	if (unlikely(atomic_read(&user->inotify_devs) >=
-			inotify_max_user_instances)) {
-		ret = -EMFILE;
-		goto out_free_uid;
-	}
-
 	/* fsnotify_obtain_group took a reference to group, we put this when we kill the file in the end */
-	group = inotify_new_group(user, inotify_max_queued_events);
-	if (IS_ERR(group)) {
-		ret = PTR_ERR(group);
-		goto out_free_uid;
-	}
-
-	atomic_inc(&user->inotify_devs);
+	group = inotify_new_group(inotify_max_queued_events);
+	if (IS_ERR(group))
+		return PTR_ERR(group);
 
 	ret = anon_inode_getfd("inotify", &inotify_fops, group,
 				  O_RDONLY | flags);
-	if (ret >= 0)
-		return ret;
+	if (ret < 0)
+		fsnotify_put_group(group);
 
-	fsnotify_put_group(group);
-	atomic_dec(&user->inotify_devs);
-out_free_uid:
-	free_uid(user);
 	return ret;
 }
 


