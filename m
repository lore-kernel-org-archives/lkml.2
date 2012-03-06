Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031405Ab2CFUw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:52:26 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44939 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031366Ab2CFUvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:51:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.152.128.163 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: leonid.moiseichuk@nokia.com, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH] vmevent: Use 'struct vmevent_attr' for vmevent_fd() ABI
Date: Tue,  6 Mar 2012 22:51:19 +0200
Message-Id: <1331067079-2163-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces 'struct vmevent_attr' and converts the vmevent_fd() ABI
to use it which makes the ABI much more flexible.

Originally-by: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 include/linux/vmevent.h              |   66 +++++++++----
 mm/vmevent.c                         |  186 +++++++++++++++++++++++-----------
 tools/testing/vmevent/vmevent-test.c |   54 +++++++---
 3 files changed, 212 insertions(+), 94 deletions(-)

diff --git a/include/linux/vmevent.h b/include/linux/vmevent.h
index 4f577ee..64357e4 100644
--- a/include/linux/vmevent.h
+++ b/include/linux/vmevent.h
@@ -3,53 +3,83 @@
 
 #include <linux/types.h>
 
+/*
+ * Types of memory attributes which could be monitored through vmevent API
+ */
 enum {
-	VMEVENT_TYPE_FREE_THRESHOLD	= 1ULL << 0,
-	VMEVENT_TYPE_SAMPLE		= 1ULL << 1,
+	VMEVENT_ATTR_NR_AVAIL_PAGES	= 1UL,
+	VMEVENT_ATTR_NR_FREE_PAGES	= 2UL,
+	VMEVENT_ATTR_NR_SWAP_PAGES	= 3UL,
+
+	VMEVENT_ATTR_MAX		/* non-ABI */
 };
 
+/*
+ * Attribute state bits for threshold
+ */
 enum {
-	VMEVENT_EATTR_NR_AVAIL_PAGES	= 1ULL << 0,
-	VMEVENT_EATTR_NR_FREE_PAGES	= 1ULL << 1,
-	VMEVENT_EATTR_NR_SWAP_PAGES	= 1ULL << 2,
+	/*
+	 * Sample value is less than user-specified value
+	 */
+	VMEVENT_ATTR_STATE_VALUE_LT	= (1UL << 0),
 };
 
-struct vmevent_config {
+struct vmevent_attr {
 	/*
-	 * Size of the struct for ABI extensibility.
+	 * Value in pages delivered with pointed attribute
 	 */
-	__u32			size;
+	__u64			value;
 
 	/*
-	 * Notification type bitmask
+	 * Type of profiled attribute from VMEVENT_ATTR_XXX
 	 */
-	__u64			type;
+	__u32			type;
+
+        /*
+	 * Bitmask of current attribute value (see VMEVENT_ATTR_STATE_XXX)
+	*/
+	__u32			state;
+};
 
+#define VMEVENT_CONFIG_MAX_ATTRS	32
+
+/*
+ * Configuration structure to get notifications and attributes values
+ */
+struct vmevent_config {
 	/*
-	 * Attributes that are delivered as part of events.
+	 * Size of the struct for ABI extensibility.
 	 */
-	__u64			event_attrs;
+	__u32			size;
 
 	/*
-	 * Threshold of free pages in the system.
+	 * Counter of number monitored attributes
 	 */
-	__u32			free_pages_threshold;
+	__u32			counter;
 
 	/*
 	 * Sample period in nanoseconds
 	 */
 	__u64			sample_period_ns;
+
+	/*
+	 * Attributes that are monitored and delivered as part of events
+	 */
+	struct vmevent_attr	attrs[VMEVENT_CONFIG_MAX_ATTRS];
 };
 
 struct vmevent_event {
 	/*
-	 * Size of the struct for ABI extensibility.
+	 * Counter of attributes in this VM event
 	 */
-	__u32			size;
+	__u32			counter;
 
-	__u64			attrs;
+	__u32			padding;
 
-	__u64			attr_values[];
+	/*
+	 * Attributes for this VM event
+	 */
+	struct vmevent_attr	attrs[];
 };
 
 #endif /* _LINUX_VMEVENT_H */
diff --git a/mm/vmevent.c b/mm/vmevent.c
index 37d2c5f..ab6a043 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -24,10 +24,10 @@ struct vmevent_watch {
 	bool				pending;
 
 	/*
- 	 * Attributes
- 	 */
+	 * Attributes that are exported as part of delivered VM events.
+	 */
 	unsigned long			nr_attrs;
-	u64				attr_values[64];
+	struct vmevent_attr		*sample_attrs;
 
 	/* sampling */
 	struct hrtimer			timer;
@@ -36,54 +36,87 @@ struct vmevent_watch {
 	wait_queue_head_t		waitq;
 };
 
-static bool vmevent_match(struct vmevent_watch *watch,
-			   struct vmevent_watch_event *event)
+typedef u64 (*vmevent_attr_sample_fn)(struct vmevent_watch *watch);
+
+static u64 vmevent_attr_swap_pages(struct vmevent_watch *watch)
 {
-	if (watch->config.type & VMEVENT_TYPE_FREE_THRESHOLD) {
-		if (event->nr_free_pages > watch->config.free_pages_threshold)
-			return false;
-	}
+#ifdef CONFIG_SWAP
+	struct sysinfo si;
+
+	si_swapinfo(&si);
 
-	return true;
+	return si.totalswap;
+#else
+	return 0;
+#endif
 }
 
-static void vmevent_sample(struct vmevent_watch *watch)
+static u64 vmevent_attr_free_pages(struct vmevent_watch *watch)
+{
+	return global_page_state(NR_FREE_PAGES);
+}
+
+static u64 vmevent_attr_avail_pages(struct vmevent_watch *watch)
 {
-	struct vmevent_watch_event event;
 	struct sysinfo si;
-	int n = 0;
 
-	memset(&event, 0, sizeof(event));
+	si_meminfo(&si);
 
-	event.nr_free_pages	= global_page_state(NR_FREE_PAGES);
+	return si.totalram;
+}
 
-	si_meminfo(&si);
-	event.nr_avail_pages	= si.totalram;
+static vmevent_attr_sample_fn attr_samplers[] = {
+	[VMEVENT_ATTR_NR_AVAIL_PAGES]   = vmevent_attr_avail_pages,
+	[VMEVENT_ATTR_NR_FREE_PAGES]    = vmevent_attr_free_pages,
+	[VMEVENT_ATTR_NR_SWAP_PAGES]    = vmevent_attr_swap_pages,
+};
 
-#ifdef CONFIG_SWAP
-	if (watch->config.event_attrs & VMEVENT_EATTR_NR_SWAP_PAGES) {
-		si_swapinfo(&si);
-		event.nr_swap_pages	= si.totalswap;
+static u64 vmevent_sample_attr(struct vmevent_watch *watch, struct vmevent_attr *attr)
+{
+	vmevent_attr_sample_fn fn = attr_samplers[attr->type];
+
+	return fn(watch);
+}
+
+static bool vmevent_match(struct vmevent_watch *watch)
+{
+	struct vmevent_config *config = &watch->config;
+	int i;
+
+	for (i = 0; i < config->counter; i++) {
+		struct vmevent_attr *attr = &config->attrs[i];
+		u64 value;
+
+		if (!attr->state)
+			continue;
+
+		value = vmevent_sample_attr(watch, attr);
+
+		if (attr->state & VMEVENT_ATTR_STATE_VALUE_LT) {
+			if (value < attr->value)
+				return true;
+		}
 	}
-#endif
 
-	if (!vmevent_match(watch, &event))
+	return false;
+}
+
+static void vmevent_sample(struct vmevent_watch *watch)
+{
+	int i;
+
+	if (!vmevent_match(watch))
 		return;
 
 	mutex_lock(&watch->mutex);
 
 	watch->pending = true;
 
-	if (watch->config.event_attrs & VMEVENT_EATTR_NR_AVAIL_PAGES)
-		watch->attr_values[n++] = event.nr_avail_pages;
-
-	if (watch->config.event_attrs & VMEVENT_EATTR_NR_FREE_PAGES)
-		watch->attr_values[n++] = event.nr_free_pages;
-
-	if (watch->config.event_attrs & VMEVENT_EATTR_NR_SWAP_PAGES)
-		watch->attr_values[n++] = event.nr_swap_pages;
+	for (i = 0; i < watch->nr_attrs; i++) {
+		struct vmevent_attr *attr = &watch->sample_attrs[i];
 
-	watch->nr_attrs = n;
+		attr->value = vmevent_sample_attr(watch, attr);
+	}
 
 	mutex_unlock(&watch->mutex);
 }
@@ -132,43 +165,45 @@ static unsigned int vmevent_poll(struct file *file, poll_table *wait)
 static ssize_t vmevent_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	struct vmevent_watch *watch = file->private_data;
-	struct vmevent_event event;
+	struct vmevent_event *event;
 	ssize_t ret = 0;
-	u64 attr_size;
-
-	mutex_lock(&watch->mutex);
+	u32 size;
+	int i;
 
-	if (!watch->pending)
-		goto out_unlock;
+	size = sizeof(*event) + watch->nr_attrs * sizeof(struct vmevent_attr);
 
-	attr_size = watch->nr_attrs * sizeof(u64);
+	if (count < size)
+		return -EINVAL;
 
-	memset(&event, 0, sizeof(event));
-	event.size	= sizeof(struct vmevent_event) + attr_size;
-	event.attrs	= watch->config.event_attrs;
+	mutex_lock(&watch->mutex);
 
-	if (count < sizeof(event))
+	if (!watch->pending)
 		goto out_unlock;
 
-	if (copy_to_user(buf, &event, sizeof(event))) {
-		ret = -EFAULT;
+	event = kmalloc(size, GFP_KERNEL);
+	if (!event) {
+		ret = -ENOMEM;
 		goto out_unlock;
 	}
 
-	count -= sizeof(event);
+	for (i = 0; i < watch->nr_attrs; i++) {
+		memcpy(&event->attrs[i], &watch->sample_attrs[i], sizeof(struct vmevent_attr));
+	}
 
-	if (count > attr_size)
-		count = attr_size;
+	event->counter = watch->nr_attrs;
 
-	if (copy_to_user(buf + sizeof(event), watch->attr_values, count)) {
+	if (copy_to_user(buf, event, size)) {
 		ret = -EFAULT;
-		goto out_unlock;
+		goto out_free;
 	}
 
 	ret = count;
 
 	watch->pending = false;
 
+out_free:
+	kfree(event);
+
 out_unlock:
 	mutex_unlock(&watch->mutex);
 
@@ -207,6 +242,42 @@ static struct vmevent_watch *vmevent_watch_alloc(void)
 	return watch;
 }
 
+static int vmevent_setup_watch(struct vmevent_watch *watch)
+{
+	struct vmevent_config *config = &watch->config;
+	struct vmevent_attr *attrs = NULL;
+	unsigned long nr;
+	int i;
+
+	nr = 0;
+
+	for (i = 0; i < config->counter; i++) {
+		struct vmevent_attr *attr = &config->attrs[i];
+		size_t size;
+		void *new;
+
+		if (attr->type >= VMEVENT_ATTR_MAX)
+			continue;
+
+		size = sizeof(struct vmevent_attr) * (nr + 1);
+
+		new = krealloc(attrs, size, GFP_KERNEL);
+		if (!new) {
+			kfree(attrs);
+			return -ENOMEM;
+		}
+
+		attrs = new;
+
+		attrs[nr++].type = attr->type;
+	}
+
+	watch->sample_attrs	= attrs;
+	watch->nr_attrs		= nr;
+
+	return 0;
+}
+
 static int vmevent_copy_config(struct vmevent_config __user *uconfig,
 				struct vmevent_config *config)
 {
@@ -216,14 +287,6 @@ static int vmevent_copy_config(struct vmevent_config __user *uconfig,
 	if (ret)
 		return -EFAULT;
 
-	if (!config->type)
-		return -EINVAL;
-
-	if (config->type & VMEVENT_TYPE_SAMPLE) {
-		if (config->sample_period_ns < NSEC_PER_MSEC)
-			return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -243,6 +306,10 @@ SYSCALL_DEFINE1(vmevent_fd,
 	if (err)
 		goto err_free;
 
+	err = vmevent_setup_watch(watch);
+	if (err)
+		goto err_free;
+
 	fd = get_unused_fd_flags(O_RDONLY);
 	if (fd < 0) {
 		err = fd;
@@ -257,8 +324,7 @@ SYSCALL_DEFINE1(vmevent_fd,
 
 	fd_install(fd, file);
 
-	if (watch->config.type & VMEVENT_TYPE_SAMPLE)
-		vmevent_start_timer(watch);
+	vmevent_start_timer(watch);
 
 	return fd;
 
diff --git a/tools/testing/vmevent/vmevent-test.c b/tools/testing/vmevent/vmevent-test.c
index f268034..534f827 100644
--- a/tools/testing/vmevent/vmevent-test.c
+++ b/tools/testing/vmevent/vmevent-test.c
@@ -32,12 +32,24 @@ int main(int argc, char *argv[])
 	printf("Physical pages: %ld\n", phys_pages);
 
 	config = (struct vmevent_config) {
-		.type			= VMEVENT_TYPE_SAMPLE | VMEVENT_TYPE_FREE_THRESHOLD,
-		.event_attrs		= VMEVENT_EATTR_NR_AVAIL_PAGES
-					| VMEVENT_EATTR_NR_FREE_PAGES
-					| VMEVENT_EATTR_NR_SWAP_PAGES,
 		.sample_period_ns	= 1000000000L,
-		.free_pages_threshold	= phys_pages,
+		.counter		= 4,
+		.attrs			= {
+			[0]			= {
+				.type	= VMEVENT_ATTR_NR_FREE_PAGES,
+				.state	= VMEVENT_ATTR_STATE_VALUE_LT,
+				.value	= phys_pages,
+			},
+			[1]			= {
+				.type	= VMEVENT_ATTR_NR_AVAIL_PAGES,
+			},
+			[2]			= {
+				.type	= VMEVENT_ATTR_NR_SWAP_PAGES,
+			},
+			[3]			= {
+				.type	= 0xffff, /* invalid */
+			},
+		},
 	};
 
 	fd = sys_vmevent_fd(&config);
@@ -47,9 +59,10 @@ int main(int argc, char *argv[])
 	}
 
 	for (i = 0; i < 10; i++) {
-		char buffer[sizeof(struct vmevent_event) + 3 * sizeof(uint64_t)];
+		char buffer[sizeof(struct vmevent_event) + 4 * sizeof(struct vmevent_attr)];
 		struct vmevent_event *event;
 		int n = 0;
+		int idx;
 
 		pollfd.fd		= fd;
 		pollfd.events		= POLLIN;
@@ -68,16 +81,25 @@ int main(int argc, char *argv[])
 
 		event = (void *) buffer;
 
-		printf("VM event (%Lu bytes):\n", event->size);
-
-		if (event->attrs & VMEVENT_EATTR_NR_AVAIL_PAGES)
-			printf("  VMEVENT_EATTR_NR_AVAIL_PAGES: %Lu\n", event->attr_values[n++]);
-
-		if (event->attrs & VMEVENT_EATTR_NR_FREE_PAGES)
-			printf("  VMEVENT_EATTR_NR_FREE_PAGES : %Lu\n", event->attr_values[n++]);
-
-		if (event->attrs & VMEVENT_EATTR_NR_SWAP_PAGES)
-			printf("  VMEVENT_EATTR_NR_SWAP_PAGES : %Lu\n", event->attr_values[n++]);
+		printf("VM event (%u attributes):\n", event->counter);
+
+		for (idx = 0; idx < event->counter; idx++) {
+			struct vmevent_attr *attr = &event->attrs[idx];
+
+			switch (attr->type) {
+			case VMEVENT_ATTR_NR_AVAIL_PAGES:
+				printf("  VMEVENT_ATTR_NR_AVAIL_PAGES: %Lu\n", attr->value);
+				break;
+			case VMEVENT_ATTR_NR_FREE_PAGES:
+				printf("  VMEVENT_ATTR_NR_FREE_PAGES: %Lu\n", attr->value);
+				break;
+			case VMEVENT_ATTR_NR_SWAP_PAGES:
+				printf("  VMEVENT_ATTR_NR_SWAP_PAGES: %Lu\n", attr->value);
+				break;
+			default:
+				printf("  Unknown attribute: %Lu\n", attr->value);
+			}
+		}
 	}
 	if (close(fd) < 0) {
 		perror("close failed");
-- 
1.7.6.5

