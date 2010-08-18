Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab0HRQaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:30:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab0HRQaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:30:18 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 5/5] fanotify: flush outstanding perm requests on group destroy
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Aug 2010 12:30:17 -0400
Message-ID: <20100818163016.1080.18246.stgit@paris.rdu.redhat.com>
In-Reply-To: <20100818162954.1080.48055.stgit@paris.rdu.redhat.com>
References: <20100818162954.1080.48055.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify should flush (and allow) all outstanding permission requests when
the group is being torn down.  The most logical place for this flushing
was the fsnotify free_group_priv hook but that hook can't work.  When fanotify
is waiting on a permission response from userspace it is holding the
fsnotify mark srcu lock.  Group tear down to get to the free_group_priv hook
requires syncronizing the srcu lock.

The solution entered here is to add an atomic which is set on fanotify_release
which will prevent any further permissions actions from being taken.  We then
flush all outstanding permission events, which will cause the original side to
release the srcu lock.  The group destruction code then proceeds to sync the
srcu lock and finish cleaning up normally.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.c      |    3 +++
 fs/notify/fanotify/fanotify_user.c |   21 +++++++++++++++++++++
 include/linux/fanotify.h           |    7 -------
 include/linux/fsnotify_backend.h   |    1 +
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 756566f..fe7845e 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -92,6 +92,9 @@ static int fanotify_get_response_from_access(struct fsnotify_group *group,
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
+	if (unlikely(atomic_read(&group->fanotify_data.bypass_perm)))
+		return 0;
+
 	wait_event(group->fanotify_data.access_waitq, event->response);
 
 	/* userspace responded, convert to something usable */
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 032b837..425ec89 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -187,6 +187,9 @@ static int prepare_for_access_response(struct fsnotify_group *group,
 	if (!(event->mask & FAN_ALL_PERM_EVENTS))
 		return 0;
 
+	if (unlikely(atomic_read(&group->fanotify_data.bypass_perm)))
+		return 0;
+
 	re = kmem_cache_alloc(fanotify_response_event_cache, GFP_KERNEL);
 	if (!re)
 		return -ENOMEM;
@@ -364,9 +367,27 @@ static ssize_t fanotify_write(struct file *file, const char __user *buf, size_t
 static int fanotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
+	struct fanotify_response_event *re, *lre;
 
 	pr_debug("%s: file=%p group=%p\n", __func__, file, group);
 
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	atomic_inc(&group->fanotify_data.bypass_perm);
+
+	mutex_lock(&group->fanotify_data.access_mutex);
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
index ed36fb5..3d5b07c 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -156,6 +156,7 @@ struct fsnotify_group {
 			struct mutex access_mutex;
 			struct list_head access_list;
 			wait_queue_head_t access_waitq;
+			atomic_t bypass_perm;
 #endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
 			int f_flags;
 		} fanotify_data;

