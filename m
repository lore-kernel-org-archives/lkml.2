Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0HWAhi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 20:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab0HWAhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 20:37:24 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Andreas Gruenbacher <agruen@suse.de>
Subject: [PATCH 1/4] fanotify: flush outstanding perm requests on group destroy
Date: Sun, 22 Aug 2010 20:37:07 -0400
Message-Id: <1282523830-27751-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an fanotify listener is closing it may cause a deadlock between the
listener and the original task doing an fs operation.  If the original task
is waiting for a permissions response it will be holding the srcu lock.  The
listener cannot clean up and exit until after that srcu lock is syncronized.
Thus deadlock.  The fix introduced here is to stop accepting new permissions
events when a listener is shutting down and to grant permission for all
outstanding events.  Thus the original task will eventually release the srcu
lock and the listener can complete shutdown.

Reported-by: Andreas Gruenbacher <agruen@suse.de>
Cc: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/fanotify/fanotify_user.c |   27 +++++++++++++++++++++++++++
 include/linux/fanotify.h           |    7 -------
 include/linux/fsnotify_backend.h   |    1 +
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 032b837..b966b72 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -195,6 +195,14 @@ static int prepare_for_access_response(struct fsnotify_group *group,
 	re->fd = fd;
 
 	mutex_lock(&group->fanotify_data.access_mutex);
+
+	if (group->fanotify_data.bypass_perm) {
+		mutex_unlock(&group->fanotify_data.access_mutex);
+		kmem_cache_free(fanotify_response_event_cache, re);
+		event->response = FAN_ALLOW;
+		return 0;
+	}
+		
 	list_add_tail(&re->list, &group->fanotify_data.access_list);
 	mutex_unlock(&group->fanotify_data.access_mutex);
 
@@ -364,9 +372,28 @@ static ssize_t fanotify_write(struct file *file, const char __user *buf, size_t
 static int fanotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
+	struct fanotify_response_event *re, *lre;
 
 	pr_debug("%s: file=%p group=%p\n", __func__, file, group);
 
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	mutex_lock(&group->fanotify_data.access_mutex);
+
+	group->fanotify_data.bypass_perm = true;
+
+	list_for_each_entry_safe(re, lre, &group->fanotify_data.access_list, list) {
+		pr_debug("%s: found group=%p re=%p event=%p\n", __func__, group,
+			 re, re->event);
+
+		list_del_init(&re->list);
+		re->event->response = FAN_ALLOW;
+
+		kmem_cache_free(fanotify_response_event_cache, re);
+	}
+	mutex_unlock(&group->fanotify_data.access_mutex);
+
+	wake_up(&group->fanotify_data.access_waitq);
+#endif
 	/* matches the fanotify_init->fsnotify_alloc_group */
 	fsnotify_put_group(group);
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index f0949a5..9854356 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -95,11 +95,4 @@ struct fanotify_response {
 				(long)(meta)->event_len >= (long)FAN_EVENT_METADATA_LEN && \
 				(long)(meta)->event_len <= (long)(len))
 
-#ifdef __KERNEL__
-
-struct fanotify_wait {
-	struct fsnotify_event *event;
-	__s32 fd;
-};
-#endif /* __KERNEL__ */
 #endif /* _LINUX_FANOTIFY_H */
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index ed36fb5..e40190d 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -156,6 +156,7 @@ struct fsnotify_group {
 			struct mutex access_mutex;
 			struct list_head access_list;
 			wait_queue_head_t access_waitq;
+			bool bypass_perm; /* protected by access_mutex */
 #endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
 			int f_flags;
 		} fanotify_data;
-- 
1.6.5.3

