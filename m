Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab1G1Xo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:62194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab1G1Xoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552540"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: srostedt@redhat.com, rostedt@goodmis.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [39/50] tracing: Fix bug when reading system filters on module
Message-Id: <20110728234444.027402403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Steven Rostedt <srostedt@redhat.com>

[ upstream commit e9dbfae53eeb9fc3d4bb7da3df87fa9875f5da02 ]
 removal

The event system is freed when its nr_events is set to zero. This happens
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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/kernel/trace/trace.h
===================================================================
--- linux-2.6.35.y.orig/kernel/trace/trace.h
+++ linux-2.6.35.y/kernel/trace/trace.h
@@ -731,6 +731,7 @@ struct event_subsystem {
 	struct dentry		*entry;
 	struct event_filter	*filter;
 	int			nr_events;
+	int			ref_count;
 };
 
 struct filter_pred;
Index: linux-2.6.35.y/kernel/trace/trace_events.c
===================================================================
--- linux-2.6.35.y.orig/kernel/trace/trace_events.c
+++ linux-2.6.35.y/kernel/trace/trace_events.c
@@ -182,6 +182,35 @@ static void ftrace_clear_events(void)
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
@@ -704,6 +733,47 @@ event_filter_write(struct file *filp, co
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
@@ -836,9 +906,10 @@ static const struct file_operations ftra
 };
 
 static const struct file_operations ftrace_subsystem_filter_fops = {
-	.open = tracing_open_generic,
+	.open = subsystem_open,
 	.read = subsystem_filter_read,
 	.write = subsystem_filter_write,
+	.release = subsystem_release,
 };
 
 static const struct file_operations ftrace_system_enable_fops = {
@@ -872,8 +943,6 @@ static struct dentry *event_trace_events
 	return d_events;
 }
 
-static LIST_HEAD(event_subsystems);
-
 static struct dentry *
 event_subsystem_dir(const char *name, struct dentry *d_events)
 {
@@ -883,6 +952,7 @@ event_subsystem_dir(const char *name, st
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
 		if (strcmp(system->name, name) == 0) {
+			__get_system(system);
 			system->nr_events++;
 			return system->entry;
 		}
@@ -905,6 +975,7 @@ event_subsystem_dir(const char *name, st
 	}
 
 	system->nr_events = 1;
+	system->ref_count = 1;
 	system->name = kstrdup(name, GFP_KERNEL);
 	if (!system->name) {
 		debugfs_remove(system->entry);
@@ -1050,16 +1121,9 @@ static void remove_subsystem_dir(const c
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
Index: linux-2.6.35.y/kernel/trace/trace_events_filter.c
===================================================================
--- linux-2.6.35.y.orig/kernel/trace/trace_events_filter.c
+++ linux-2.6.35.y/kernel/trace/trace_events_filter.c
@@ -1340,6 +1340,12 @@ int apply_subsystem_event_filter(struct 
 	if (err)
 		goto out_unlock;
 
+	/* Make sure the system still has events */
+	if (!system->nr_events) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_free_subsystem_preds(system);
 		remove_filter_string(system->filter);
