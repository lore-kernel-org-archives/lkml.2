Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab1GFVUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:20:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab1GFVUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:20:17 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=D2S7XnFLHK0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=ZZAtcv22ZjYf6feQmoYA:9 a=V72bd4AXSYCzK4V1SyIA:7 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110706212015.040511546@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 17:19:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] tracing: Add ref_count to event systems for freeing
References: <20110706211931.764277374@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-ref_count-to-event-systems-for-freeing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The system is freed when its nr_events is set to zero. This happens
when a module created an event system and then later the module is
removed. Modules may share systems, so the system is allocated when
it is created and freed when the modules are unloaded and all the
events under the system are removed (nr_events set to zero).

The problem arises when a task opened the "filter" file for the
system. If the module is unloaded and it removed the last event for
that system, the system structure is freed. If the task that opened
the filter file accesses the "filter" file after the system has
been freed, the system will access an invalid pointer.

By adding a ref_count, and using it to keep track of what
is using the event system, we can free it after all users
are finished with the event system.

Cc: <stable@kernel.org>
Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |    1 +
 kernel/trace/trace_events.c        |   86 +++++++++++++++++++++++++++++++-----
 kernel/trace/trace_events_filter.c |    6 +++
 3 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 229f859..f807407 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -677,6 +677,7 @@ struct event_subsystem {
 	struct dentry		*entry;
 	struct event_filter	*filter;
 	int			nr_events;
+	int			ref_count;
 };
 
 #define FILTER_PRED_INVALID	((unsigned short)-1)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 686ec39..ffc5b28 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -244,6 +244,35 @@ static void ftrace_clear_events(void)
 	mutex_unlock(&event_mutex);
 }
 
+static void __put_system(struct event_subsystem *system)
+{
+	struct event_filter *filter = system->filter;
+
+	WARN_ON_ONCE(system->ref_count == 0);
+	if (--system->ref_count)
+		return;
+
+	if (filter) {
+		kfree(filter->filter_string);
+		kfree(filter);
+	}
+	kfree(system->name);
+	kfree(system);
+}
+
+static void __get_system(struct event_subsystem *system)
+{
+	WARN_ON_ONCE(system->ref_count == 0);
+	system->ref_count++;
+}
+
+static void put_system(struct event_subsystem *system)
+{
+	mutex_lock(&event_mutex);
+	__put_system(system);
+	mutex_unlock(&event_mutex);
+}
+
 /*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
@@ -826,6 +855,47 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
+static LIST_HEAD(event_subsystems);
+
+static int subsystem_open(struct inode *inode, struct file *filp)
+{
+	struct event_subsystem *system = NULL;
+	int ret;
+
+	/* Make sure the system still exists */
+	mutex_lock(&event_mutex);
+	list_for_each_entry(system, &event_subsystems, list) {
+		if (system == inode->i_private) {
+			/* Don't open systems with no events */
+			if (!system->nr_events) {
+				system = NULL;
+				break;
+			}
+			__get_system(system);
+			break;
+		}
+	}
+	mutex_unlock(&event_mutex);
+
+	if (system != inode->i_private)
+		return -ENODEV;
+
+	ret = tracing_open_generic(inode, filp);
+	if (ret < 0)
+		put_system(system);
+
+	return ret;
+}
+
+static int subsystem_release(struct inode *inode, struct file *file)
+{
+	struct event_subsystem *system = inode->i_private;
+
+	put_system(system);
+
+	return 0;
+}
+
 static ssize_t
 subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		      loff_t *ppos)
@@ -963,10 +1033,11 @@ static const struct file_operations ftrace_event_filter_fops = {
 };
 
 static const struct file_operations ftrace_subsystem_filter_fops = {
-	.open = tracing_open_generic,
+	.open = subsystem_open,
 	.read = subsystem_filter_read,
 	.write = subsystem_filter_write,
 	.llseek = default_llseek,
+	.release = subsystem_release,
 };
 
 static const struct file_operations ftrace_system_enable_fops = {
@@ -1002,8 +1073,6 @@ static struct dentry *event_trace_events_dir(void)
 	return d_events;
 }
 
-static LIST_HEAD(event_subsystems);
-
 static struct dentry *
 event_subsystem_dir(const char *name, struct dentry *d_events)
 {
@@ -1013,6 +1082,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
 		if (strcmp(system->name, name) == 0) {
+			__get_system(system);
 			system->nr_events++;
 			return system->entry;
 		}
@@ -1035,6 +1105,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	}
 
 	system->nr_events = 1;
+	system->ref_count = 1;
 	system->name = kstrdup(name, GFP_KERNEL);
 	if (!system->name) {
 		debugfs_remove(system->entry);
@@ -1184,16 +1255,9 @@ static void remove_subsystem_dir(const char *name)
 	list_for_each_entry(system, &event_subsystems, list) {
 		if (strcmp(system->name, name) == 0) {
 			if (!--system->nr_events) {
-				struct event_filter *filter = system->filter;
-
 				debugfs_remove_recursive(system->entry);
 				list_del(&system->list);
-				if (filter) {
-					kfree(filter->filter_string);
-					kfree(filter);
-				}
-				kfree(system->name);
-				kfree(system);
+				__put_system(system);
 			}
 			break;
 		}
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8008ddc..256764e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1886,6 +1886,12 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 
 	mutex_lock(&event_mutex);
 
+	/* Make sure the system still has events */
+	if (!system->nr_events) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_free_subsystem_preds(system);
 		remove_filter_string(system->filter);
-- 
1.7.5.4


