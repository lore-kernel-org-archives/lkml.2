Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab1LFBX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:23:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57335 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab1LFBX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:23:26 -0500
MIME-Version: 1.0
Date: Tue, 6 Dec 2011 09:23:25 +0800
Message-ID: <CAE8kqZJO_YZ855g2P3803-3ptExDeKX108x-Q_2Rz7rgz1iUew@mail.gmail.com>
Subject: [PATCH] fanotify: to differ file access event from different threads
From: boyd yang <boyd.yang@gmail.com>
To: eparis@redhat.com, xiyou.wangcong@gmail.com,
        Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify: to differ file access event from different threads
When fanotify is monitoring the whole mount point "/", and multiple
threads iterate the same direcotry, some thread will hang.
This patch let fanotify to differ access events from different
threads, prevent fanotify from merging access events from different
threads.
It also hide overflow events to reach user space.
Signed-off-by: Boyd Yang <boyd.yang@gmail.com>

diff -r -u linux-3.1-rc4_orig/fs/notify/fanotify/fanotify.c
linux-3.1-rc4/fs/notify/fanotify/fanotify.c
--- linux-3.1-rc4_orig/fs/notify/fanotify/fanotify.c	2011-08-29
12:16:01.000000000 +0800
+++ linux-3.1-rc4/fs/notify/fanotify/fanotify.c	2011-10-14
14:17:53.055958000 +0800
@@ -15,7 +15,8 @@

 	if (old->to_tell == new->to_tell &&
 	    old->data_type == new->data_type &&
-	    old->tgid == new->tgid) {
+	    old->tgid == new->tgid &&
+	    old->pid == new->pid) {
 		switch (old->data_type) {
 		case (FSNOTIFY_EVENT_PATH):
 			if ((old->path.mnt == new->path.mnt) &&
@@ -144,11 +145,16 @@
 		return PTR_ERR(notify_event);

 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (event->mask & FAN_ALL_PERM_EVENTS) {
-		/* if we merged we need to wait on the new event */
-		if (notify_event)
-			event = notify_event;
-		ret = fanotify_get_response_from_access(group, event);
+	/*if overflow, do not wait for response*/
+	if (event->mask&FS_Q_OVERFLOW) {
+		pr_debug("fanotify overflow!\n");
+	}	else {
+		if (event->mask & FAN_ALL_PERM_EVENTS) {
+			/* if we merged we need to wait on the new event */
+			if (notify_event)
+				event = notify_event;
+			ret = fanotify_get_response_from_access(group, event);
+		}
 	}
 #endif

diff -r -u linux-3.1-rc4_orig/fs/notify/notification.c
linux-3.1-rc4/fs/notify/notification.c
--- linux-3.1-rc4_orig/fs/notify/notification.c	2011-08-29
12:16:01.000000000 +0800
+++ linux-3.1-rc4/fs/notify/notification.c	2011-10-14 13:52:36.946608000 +0800
@@ -95,6 +95,7 @@
 		BUG_ON(!list_empty(&event->private_data_list));

 		kfree(event->file_name);
+		put_pid(event->pid);
 		put_pid(event->tgid);
 		kmem_cache_free(fsnotify_event_cachep, event);
 	}
@@ -374,6 +375,7 @@
 			return NULL;
 		}
 	}
+	event->pid = get_pid(old_event->pid);
 	event->tgid = get_pid(old_event->tgid);
 	if (event->data_type == FSNOTIFY_EVENT_PATH)
 		path_get(&event->path);
@@ -417,6 +419,7 @@
 		event->name_len = strlen(event->file_name);
 	}

+	event->pid = get_pid(task_pid(current));
 	event->tgid = get_pid(task_tgid(current));
 	event->sync_cookie = cookie;
 	event->to_tell = to_tell;
diff -r -u linux-3.1-rc4_orig/include/linux/fsnotify_backend.h
linux-3.1-rc4/include/linux/fsnotify_backend.h
--- linux-3.1-rc4_orig/include/linux/fsnotify_backend.h	2011-08-29
12:16:01.000000000 +0800
+++ linux-3.1-rc4/include/linux/fsnotify_backend.h	2011-10-14
13:51:50.380168000 +0800
@@ -238,6 +238,7 @@
 	u32 sync_cookie;	/* used to corrolate events, namely inotify mv events */
 	const unsigned char *file_name;
 	size_t name_len;
+	struct pid *pid;
 	struct pid *tgid;

 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
