Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab0KSJ76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 04:59:58 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:43541 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752506Ab0KSJ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 04:59:56 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX19UCehBDEJUEf7rVNFpg2fXfMtHM4ymHbSjWpu4k0
	pufDzkEe5HKPhG
Date: Fri, 19 Nov 2010 10:58:07 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, agruen@suse.de,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] fanotify: on group destroy allow all waiters to bypass
	permission check
Message-ID: <20101119095807.GB22377@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



When fanotify_release() is called, there may still be processes waiting for
access permission. Currently only processes for which an event has already been
queued into the groups access list will be woken up.  Processes for which no
event has been queued will continue to sleep and thus cause a deadlock when
fsnotify_put_group() is called.
Furthermore there is a race allowing further processes to be waiting on the
access wait queue after wake_up (if they arrive before clear_marks_by_group()
is called).
This patch corrects this by setting a flag to inform processes that the group
is about to be destroyed and thus not to wait for access permission.
Beside this it removes the unnecessary check for the bypass_perm flag in
prepare_for_access_response(), since this function cant be called any more at
the time release() is called and the flag is set.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify.c      |    8 +++++++-
 fs/notify/fanotify/fanotify_user.c |   14 +++-----------
 include/linux/fsnotify_backend.h   |    2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

This patch applies against commit 3aa13e3ff6700929c0e3a1a4cdc51c82139707e4 of
branch 'origin/for-next' from git.infradead.org/users/eparis/notify.git
CC'ed Andreas Gruenbacher since he originally reported this problem.

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index cb576b8..94438db 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -91,8 +91,14 @@ static int fanotify_get_response_from_access(struct fsnotify_group *group,
 	int ret;
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
+	if (atomic_read(&group->fanotify_data.bypass_perm))
+		return 0;
 
-	wait_event(group->fanotify_data.access_waitq, event->response);
+	wait_event(group->fanotify_data.access_waitq, event->response ||
+				atomic_read(&group->fanotify_data.bypass_perm));
+
+	if (!event->response) /* bypass_perm set */
+		return 0;
 
 	/* userspace responded, convert to something usable */
 	spin_lock(&event->lock);
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index ae36c73..342d22e 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -210,14 +210,6 @@ static int prepare_for_access_response(struct fsnotify_group *group,
 	re->fd = fd;
 
 	mutex_lock(&group->fanotify_data.access_mutex);
-
-	if (group->fanotify_data.bypass_perm) {
-		mutex_unlock(&group->fanotify_data.access_mutex);
-		kmem_cache_free(fanotify_response_event_cache, re);
-		event->response = FAN_ALLOW;
-		return 0;
-	}
-		
 	list_add_tail(&re->list, &group->fanotify_data.access_list);
 	mutex_unlock(&group->fanotify_data.access_mutex);
 
@@ -399,10 +391,9 @@ static int fanotify_release(struct inode *ignored, struct file *file)
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	struct fanotify_response_event *re, *lre;
 
-	mutex_lock(&group->fanotify_data.access_mutex);
-
-	group->fanotify_data.bypass_perm = true;
+	atomic_inc(&group->fanotify_data.bypass_perm);
 
+	mutex_lock(&group->fanotify_data.access_mutex);
 	list_for_each_entry_safe(re, lre, &group->fanotify_data.access_list, list) {
 		pr_debug("%s: found group=%p re=%p event=%p\n", __func__, group,
 			 re, re->event);
@@ -706,6 +697,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
+	atomic_set(&group->fanotify_data.bypass_perm, 0);
 	group->fanotify_data.user = user;
 	atomic_inc(&user->fanotify_listeners);
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index d010f70..add1351 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -166,7 +166,7 @@ struct fsnotify_group {
 			struct mutex access_mutex;
 			struct list_head access_list;
 			wait_queue_head_t access_waitq;
-			bool bypass_perm; /* protected by access_mutex */
+			atomic_t bypass_perm;
 #endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
 			bool readonly_fallback;
 			int f_flags;
-- 
1.5.6.5

