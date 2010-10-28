Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376Ab0J1Vdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:33:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933741Ab0J1Vcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:32:54 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 13/20] fanotify: limit number of listeners per user
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:32:50 -0400
Message-ID: <20101028213249.24810.41480.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify currently has no limit on the number of listeners a given user can
have open.  This patch limits the total number of listeners per user to
128.  This is the same as the inotify default limit.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.c      |   11 ++++++++++-
 fs/notify/fanotify/fanotify_user.c |   11 +++++++++++
 include/linux/fsnotify_backend.h   |    1 +
 include/linux/sched.h              |    3 +++
 4 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 85366c7..60c11c3 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -200,10 +200,19 @@ static bool fanotify_should_send_event(struct fsnotify_group *group,
 	return false;
 }
 
+static void fanotify_free_group_priv(struct fsnotify_group *group)
+{
+	struct user_struct *user;
+
+	user = group->fanotify_data.user;
+	atomic_dec(&user->fanotify_listeners);
+	free_uid(user);
+}
+
 const struct fsnotify_ops fanotify_fsnotify_ops = {
 	.handle_event = fanotify_handle_event,
 	.should_send_event = fanotify_should_send_event,
-	.free_group_priv = NULL,
+	.free_group_priv = fanotify_free_group_priv,
 	.free_event_priv = NULL,
 	.freeing_mark = NULL,
 };
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index f921610..a7d9369 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -18,6 +18,7 @@
 
 #define FANOTIFY_DEFAULT_MAX_EVENTS	16384
 #define FANOTIFY_DEFAULT_MAX_MARKS	8192
+#define FANOTIFY_DEFAULT_MAX_LISTENERS	128
 
 extern const struct fsnotify_ops fanotify_fsnotify_ops;
 
@@ -656,6 +657,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 {
 	struct fsnotify_group *group;
 	int f_flags, fd;
+	struct user_struct *user;
 
 	pr_debug("%s: flags=%d event_f_flags=%d\n",
 		__func__, flags, event_f_flags);
@@ -666,6 +668,12 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	if (flags & ~FAN_ALL_INIT_FLAGS)
 		return -EINVAL;
 
+	user = get_current_user();
+	if (atomic_read(&user->fanotify_listeners) > FANOTIFY_DEFAULT_MAX_LISTENERS) {
+		free_uid(user);
+		return -EMFILE;
+	}
+
 	f_flags = O_RDWR | FMODE_NONOTIFY;
 	if (flags & FAN_CLOEXEC)
 		f_flags |= O_CLOEXEC;
@@ -677,6 +685,9 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
+	group->fanotify_data.user = user;
+	atomic_inc(&user->fanotify_listeners);
+
 	group->fanotify_data.f_flags = event_f_flags;
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	mutex_init(&group->fanotify_data.access_mutex);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 49ceed6..4366f45 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -170,6 +170,7 @@ struct fsnotify_group {
 #endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
 			int f_flags;
 			unsigned int max_marks;
+			struct user_struct *user;
 		} fanotify_data;
 #endif /* CONFIG_FANOTIFY */
 	};
diff --git a/include/linux/sched.h b/include/linux/sched.h
index be7adb7..6f420ba 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -672,6 +672,9 @@ struct user_struct {
 	atomic_t inotify_watches; /* How many inotify watches does this user have? */
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
 #endif
+#ifdef CONFIG_FANOTIFY
+	atomic_t fanotify_listeners;
+#endif
 #ifdef CONFIG_EPOLL
 	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
 #endif

