Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0KVAfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:35:54 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46861 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab0KVAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:35:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=gqJPyMXsefj4ZM2qD2/8ZMf3MxXYqg+l4Yxtc1NK9IugPm1DZ6wiv4R54LwyEMGx6j
         H3eC7FH8cAE+sduvUq//6v+qUR9jpWKYyT319Nu1/zuhPNEE3JM3rq52WYtqUM325W9s
         sVRZkB93m9nCAEUCoEDD0z5mRhE3vqFEPqXvM=
Subject: [PATCH 4/4] fanotify: Expose the file changes to the user
To: Eric Paris <eparis@redhat.com>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Scott Hassan <hassan@dotfunk.com>, Jan Kara <jack@suse.cz>,
        agruen@linbit.com, linux-kernel@vger.kernel.org, stefan@buettcher.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Date: Mon, 22 Nov 2010 00:37:21 +0000
Message-ID: <20101122003357.13674.30341.stgit@zaytsev.su>
In-Reply-To: <20101122002747.13674.69384.stgit@zaytsev.su>
References: <20101122002747.13674.69384.stgit@zaytsev.su>
User-Agent: StGit/0.15-97-g9680
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And revamp the event passing interface in the process.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 fs/notify/fanotify/fanotify.c      |   19 +++++
 fs/notify/fanotify/fanotify_user.c |  132 +++++++++++++++++++++++++++++++-----
 include/linux/fanotify.h           |   85 ++++++++++++++++++++---
 3 files changed, 206 insertions(+), 30 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index b04f88e..1dced4f 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -53,9 +53,15 @@ static struct fsnotify_event *fanotify_merge(struct list_head *list,
 
 	fsnotify_get_event(test_event);
 
-	/* if they are exactly the same we are done */
-	if (test_event->mask == event->mask)
+
+	/*
+	 * Event masks are the same, and the event does not
+	 * carry any optional data
+	 */
+	if (test_event->mask == event->mask &&
+		!(event->mask & (FS_MODIFY | FS_CLOSE_WRITE))) {
 		return test_event;
+	}
 
 	/*
 	 * if the refcnt == 2 this is the only queue
@@ -64,6 +70,13 @@ static struct fsnotify_event *fanotify_merge(struct list_head *list,
 	 */
 	if (atomic_read(&test_event->refcnt) == 2) {
 		test_event->mask |= event->mask;
+		/*
+		 * Update the event's ranges, works even if
+		 * the event does not carry any ranges, so don't
+		 * bother checking.
+		 */
+		fsnotify_update_range(&test_event->mod_range, &event->mod_range);
+		fsnotify_update_range(&test_event->cw_range, &event->cw_range);
 		return test_event;
 	}
 
@@ -78,6 +91,8 @@ static struct fsnotify_event *fanotify_merge(struct list_head *list,
 
 	/* build new event and replace it on the list */
 	new_event->mask = (test_event->mask | event->mask);
+	fsnotify_update_range(&new_event->mod_range, &event->mod_range);
+	fsnotify_update_range(&new_event->cw_range, &event->cw_range);
 	fsnotify_replace_event(test_holder, new_event);
 
 	/* we hold a reference on new_event from clone_event */
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 0632248..5774552 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -31,6 +31,57 @@ struct fanotify_response_event {
 	struct fsnotify_event *event;
 };
 
+#ifdef DEBUG
+static inline void dump_event(const char *str, void *buf)
+{
+	struct fanotify_event_metadata *meta = buf;
+	struct fanotify_opt_hdr *tmp;
+
+	pr_debug("%s: event_len=%d vers=%d mask=0x%lld fd=%d pid=%d\n", str,
+		meta->event_len, meta->vers, meta->mask, meta->fd, meta->pid);
+
+	FAN_FOR_EACH_OPTION(meta, tmp) {
+		/* Hope gcc does a good job here. */
+		struct fan_modify_option *m_opt = FAN_OPT_PAYLOAD(tmp);
+		struct fan_close_write_option *cw_opt = FAN_OPT_PAYLOAD(tmp);
+		switch(tmp->type) {
+
+		case FAN_OPT_MODIFY:
+			pr_debug("\tOption: type = %d, len = %d, range {%lld, %lld}\n",
+					tmp->type, tmp->len, m_opt->start, m_opt->end);
+			break;
+
+		case FAN_OPT_CLOSE_WRITE:
+			pr_debug("\tOption: type = %d, len = %d, range {%lld, %lld}\n",
+					tmp->type, tmp->len, cw_opt->start, cw_opt->end);
+			break;
+
+		default:
+			/* Don't forget to add new options here. */
+			WARN_ON_ONCE(1);
+		}
+	}
+}
+#else
+static inline void dump_event(const char *str, void *buf)
+{
+}
+#endif
+
+static inline int fanotify_event_len(struct fsnotify_event *event)
+{
+	int len = sizeof(struct fanotify_event_metadata);
+	u32 mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
+
+	if (mask & FAN_MODIFY)
+		len += (sizeof(struct fanotify_opt_hdr)
+				+ sizeof(struct fan_modify_option));
+	if (mask & FAN_CLOSE_WRITE)
+		len += (sizeof(struct fanotify_opt_hdr)
+				+ sizeof(struct fan_close_write_option));
+	return len;
+}
+
 /*
  * Get an fsnotify notification event if one exists and is small
  * enough to fit in "count". Return an error pointer if the count
@@ -41,6 +92,7 @@ struct fanotify_response_event {
 static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 					    size_t count)
 {
+	struct fsnotify_event *event;
 	BUG_ON(!mutex_is_locked(&group->notification_mutex));
 
 	pr_debug("%s: group=%p count=%zd\n", __func__, group, count);
@@ -48,7 +100,8 @@ static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 	if (fsnotify_notify_queue_is_empty(group))
 		return NULL;
 
-	if (FAN_EVENT_METADATA_LEN > count)
+	event = fsnotify_peek_notify_event(group);
+	if (fanotify_event_len(event) > count)
 		return ERR_PTR(-EINVAL);
 
 	/* held the notification_mutex the whole time, so this is the
@@ -106,20 +159,58 @@ static int create_fd(struct fsnotify_group *group, struct fsnotify_event *event)
 	return client_fd;
 }
 
-static ssize_t fill_event_metadata(struct fsnotify_group *group,
-				   struct fanotify_event_metadata *metadata,
+static int fill_event_metadata(struct fsnotify_group *group,
+				   char *event_buffer, int len,
 				   struct fsnotify_event *event)
 {
-	pr_debug("%s: group=%p metadata=%p event=%p\n", __func__,
-		 group, metadata, event);
+	struct fanotify_event_metadata *meta =
+		(struct fanotify_event_metadata *) event_buffer;
+
+	struct fanotify_opt_hdr *opt_hdr = (struct fanotify_opt_hdr *)(meta + 1);
+	int meta_len = sizeof(struct fanotify_event_metadata);
+
+	pr_debug("%s: group=%p meta=%p event=%p\n", __func__,
+		 group, meta, event);
+
+	if (event->mask & FS_MODIFY) {
+		struct fan_modify_option *opt =
+			(struct fan_modify_option *) (opt_hdr + 1);
+		int opt_len = sizeof(struct fanotify_opt_hdr) +
+			sizeof(struct fan_modify_option);
 
-	metadata->event_len = FAN_EVENT_METADATA_LEN;
-	metadata->vers = FANOTIFY_METADATA_VERSION;
-	metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
-	metadata->pid = pid_vnr(event->tgid);
-	metadata->fd = create_fd(group, event);
+		meta_len += opt_len;
+		opt_hdr->type = FAN_OPT_MODIFY;
+		opt_hdr->len = opt_len;
+		opt->start = event->mod_range.start;
+		opt->end = event->mod_range.end;
 
-	return metadata->fd;
+		opt_hdr = (struct fanotify_opt_hdr *) (((char *) opt_hdr) + opt_len);
+	}
+	if (event->mask & FS_CLOSE_WRITE) {
+		struct fan_close_write_option *opt =
+			(struct fan_close_write_option *) (opt_hdr + 1);
+		int opt_len = sizeof(struct fanotify_opt_hdr) +
+			sizeof(struct fan_close_write_option);
+
+		meta_len += opt_len;
+		opt_hdr->type = FAN_OPT_CLOSE_WRITE;
+		opt_hdr->len = opt_len;
+		opt->start = event->cw_range.start;
+		opt->end = event->cw_range.end;
+
+		opt_hdr = (struct fanotify_opt_hdr *) (((char *) opt_hdr) + opt_len);
+	}
+
+	WARN_ON_ONCE(len != meta_len);
+
+	meta->event_len = meta_len;
+	meta->vers = FANOTIFY_METADATA_VERSION;
+	meta->options_offset = sizeof(struct fanotify_event_metadata);
+	meta->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
+	meta->pid = pid_vnr(event->tgid);
+	meta->fd = create_fd(group, event);
+
+	return meta->fd;
 }
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
@@ -248,16 +339,17 @@ static void remove_access_response(struct fsnotify_group *group,
 }
 #endif
 
-static ssize_t copy_event_to_user(struct fsnotify_group *group,
+static int copy_event_to_user(struct fsnotify_group *group,
 				  struct fsnotify_event *event,
 				  char __user *buf)
 {
-	struct fanotify_event_metadata fanotify_event_metadata;
+	int len = fanotify_event_len(event);
+	char fanotify_event_buf[len];
 	int fd, ret;
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
-	fd = fill_event_metadata(group, &fanotify_event_metadata, event);
+	fd = fill_event_metadata(group, fanotify_event_buf, len, event);
 	if (fd < 0)
 		return fd;
 
@@ -266,10 +358,12 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 		goto out_close_fd;
 
 	ret = -EFAULT;
-	if (copy_to_user(buf, &fanotify_event_metadata, FAN_EVENT_METADATA_LEN))
+	if (copy_to_user(buf, fanotify_event_buf, len))
 		goto out_kill_access_response;
 
-	return FAN_EVENT_METADATA_LEN;
+	dump_event(__func__, fanotify_event_buf);
+
+	return len;
 
 out_kill_access_response:
 	remove_access_response(group, event, fd);
@@ -418,8 +512,10 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	switch (cmd) {
 	case FIONREAD:
 		mutex_lock(&group->notification_mutex);
-		list_for_each_entry(holder, &group->notification_list, event_list)
-			send_len += FAN_EVENT_METADATA_LEN;
+		list_for_each_entry(holder, &group->notification_list, event_list) {
+			struct fsnotify_event *event = holder->event;
+			send_len += fanotify_event_len(event);
+		}
 		mutex_unlock(&group->notification_mutex);
 		ret = put_user(send_len, (int __user *) p);
 		break;
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 9a7986f..87dfe36 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -83,17 +83,50 @@
 				 FAN_ALL_PERM_EVENTS |\
 				 FAN_Q_OVERFLOW)
 
-#define FANOTIFY_METADATA_VERSION	2
+/* Option types, mirror the event mask, but we can pack them into u8.  */
+enum fanotify_opt_type {
+	FAN_OPT_NONE = 0,
+	FAN_OPT_ACCESS,
+	FAN_OPT_MODIFY,
+	FAN_OPT_CLOSE_WRITE,
+	FAN_OPT_CLOSE_NOWRITE,
+	FAN_OPT_OPEN,
+	FAN_OPT_Q_OVERFLOW,
+	FAN_OPT_OPEN_PERM,
+	FAN_OPT_ACCESS_PERM,
+};
+
+struct fanotify_opt_hdr {
+	__u8 type;
+	__u8 reserved;
+	__u16 len;
+	/* Payload goes here. */
+};
+
+#define FANOTIFY_METADATA_VERSION	3
 
 struct fanotify_event_metadata {
-	__u16 event_len;
+	__u16 event_len; /* Including the options */
 	__u8 vers;
-	__u8 reserved;
+	__u8 options_offset; /* Aka header length */
 	__s32 fd;
 	__aligned_u64 mask;
 	__s32 pid;
+	/* Options go here. */
 };
 
+struct fan_modify_option {
+	__aligned_u64 start; /* Start of the modification. */
+	__aligned_u64 end; /* The position right after the modification. */
+};
+
+struct fan_close_write_option {
+	__aligned_u64 start; /* Start of the modifications. */
+	__aligned_u64 end; /* The position right after the modifications. */
+};
+
+/* Update fanotify_event_len() when you add more options. */
+
 struct fanotify_response {
 	__s32 fd;
 	__u32 response;
@@ -103,15 +136,47 @@ struct fanotify_response {
 #define FAN_ALLOW	0x01
 #define FAN_DENY	0x02
 
-/* Helper functions to deal with fanotify_event_metadata buffers */
-#define FAN_EVENT_METADATA_LEN (sizeof(struct fanotify_event_metadata))
-
 #define FAN_EVENT_NEXT(meta, len) ((len) -= (meta)->event_len, \
 				   (struct fanotify_event_metadata*)(((char *)(meta)) + \
 				   (meta)->event_len))
 
-#define FAN_EVENT_OK(meta, len)	((long)(len) >= (long)FAN_EVENT_METADATA_LEN && \
-				(long)(meta)->event_len >= (long)FAN_EVENT_METADATA_LEN && \
-				(long)(meta)->event_len <= (long)(len))
-
+static inline int FAN_EVENT_OK(struct fanotify_event_metadata *meta, size_t len)
+{
+	return (len >= sizeof(struct fanotify_event_metadata) &&
+		meta->event_len >= sizeof(struct fanotify_event_metadata) &&
+		meta->event_len <= len);
+}
+
+#define FAN_FOR_EACH_EVENT(meta, buf, len) \
+	for (meta = (struct fanotify_event_metadata *) buf; \
+			FAN_EVENT_OK(meta, len); \
+			meta = FAN_EVENT_NEXT(meta, len))
+
+
+static inline struct fanotify_opt_hdr *FAN_OPTION_FIRST(
+		struct fanotify_event_metadata *meta)
+{
+	return (struct fanotify_opt_hdr *) (((char *) meta) + meta->options_offset);
+}
+static inline struct fanotify_opt_hdr *FAN_OPTION_NEXT(
+		struct fanotify_opt_hdr *opt)
+{
+	return (struct fanotify_opt_hdr *) (((char *) opt) + opt->len);
+}
+
+static inline int FAN_OPTION_OK(struct fanotify_event_metadata *meta,
+		struct fanotify_opt_hdr *opt)
+{
+	return ((char *) opt) < (((char *)meta) + meta->event_len);
+}
+
+#define FAN_FOR_EACH_OPTION(meta, tmp) \
+	for (tmp = FAN_OPTION_FIRST(meta); \
+		FAN_OPTION_OK(meta, tmp); \
+		tmp = FAN_OPTION_NEXT(tmp))
+
+static inline void *FAN_OPT_PAYLOAD(struct fanotify_opt_hdr *opt)
+{
+	return (opt + 1);
+}
 #endif /* _LINUX_FANOTIFY_H */

