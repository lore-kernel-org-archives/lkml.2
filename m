Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1G1Xr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:47:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:29735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab1G1Xop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33352112"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: srostedt@redhat.com, rostedt@goodmis.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [40/50] tracing: Have "enable" file use refcounts like the "filter"
Message-Id: <20110728234445.06FC52403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Steven Rostedt <srostedt@redhat.com>

[ upstream commit 40ee4dffff061399eb9358e0c8fcfbaf8de4c8fe ]
 file

The "enable" file for the event system can be removed when a module
is unloaded and the event system only has events from that module.
As the event system nr_events count goes to zero, it may be freed
if its ref_count is also set to zero.

Like the "filter" file, the "enable" file may be opened by a task and
referenced later, after a module has been unloaded and the events for
that event system have been removed.

Although the "filter" file referenced the event system structure,
the "enable" file only references a pointer to the event system
name. Since the name is freed when the event system is removed,
it is possible that an access to the "enable" file may reference
a freed pointer.

Update the "enable" file to use the subsystem_open() routine that
the "filter" file uses, to keep a reference to the event system
structure while the "enable" file is opened.

Cc: <stable@kernel.org>
Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/kernel/trace/trace_events.c
===================================================================
--- linux-2.6.35.y.orig/kernel/trace/trace_events.c
+++ linux-2.6.35.y/kernel/trace/trace_events.c
@@ -495,7 +495,7 @@ system_enable_read(struct file *filp, ch
 		   loff_t *ppos)
 {
 	const char set_to_char[4] = { '?', '0', '1', 'X' };
-	const char *system = filp->private_data;
+	struct event_subsystem *system = filp->private_data;
 	struct ftrace_event_call *call;
 	char buf[2];
 	int set = 0;
@@ -507,7 +507,7 @@ system_enable_read(struct file *filp, ch
 		    (!call->class->probe && !call->class->reg))
 			continue;
 
-		if (system && strcmp(call->class->system, system) != 0)
+		if (system && strcmp(call->class->system, system->name) != 0)
 			continue;
 
 		/*
@@ -537,7 +537,8 @@ static ssize_t
 system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		    loff_t *ppos)
 {
-	const char *system = filp->private_data;
+	struct event_subsystem *system = filp->private_data;
+	const char *name = NULL;
 	unsigned long val;
 	char buf[64];
 	ssize_t ret;
@@ -561,7 +562,14 @@ system_enable_write(struct file *filp, c
 	if (val != 0 && val != 1)
 		return -EINVAL;
 
-	ret = __ftrace_set_clr_event(NULL, system, NULL, val);
+	/*
+	 * Opening of "enable" adds a ref count to system,
+	 * so the name is safe to use.
+	 */
+	if (system)
+		name = system->name;
+
+	ret = __ftrace_set_clr_event(NULL, name, NULL, val);
 	if (ret)
 		goto out;
 
@@ -740,6 +748,9 @@ static int subsystem_open(struct inode *
 	struct event_subsystem *system = NULL;
 	int ret;
 
+	if (!inode->i_private)
+		goto skip_search;
+
 	/* Make sure the system still exists */
 	mutex_lock(&event_mutex);
 	list_for_each_entry(system, &event_subsystems, list) {
@@ -758,8 +769,9 @@ static int subsystem_open(struct inode *
 	if (system != inode->i_private)
 		return -ENODEV;
 
+ skip_search:
 	ret = tracing_open_generic(inode, filp);
-	if (ret < 0)
+	if (ret < 0 && system)
 		put_system(system);
 
 	return ret;
@@ -769,7 +781,8 @@ static int subsystem_release(struct inod
 {
 	struct event_subsystem *system = inode->i_private;
 
-	put_system(system);
+	if (system)
+		put_system(system);
 
 	return 0;
 }
@@ -913,9 +926,10 @@ static const struct file_operations ftra
 };
 
 static const struct file_operations ftrace_system_enable_fops = {
-	.open = tracing_open_generic,
+	.open = subsystem_open,
 	.read = system_enable_read,
 	.write = system_enable_write,
+	.release = subsystem_release,
 };
 
 static const struct file_operations ftrace_show_header_fops = {
@@ -1003,8 +1017,7 @@ event_subsystem_dir(const char *name, st
 			   "'%s/filter' entry\n", name);
 	}
 
-	trace_create_file("enable", 0644, system->entry,
-			  (void *)system->name,
+	trace_create_file("enable", 0644, system->entry, system,
 			  &ftrace_system_enable_fops);
 
 	return system->entry;
