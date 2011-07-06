Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1GFVVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:21:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab1GFVVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:21:18 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=nkgXCSwfxt8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=izLXe2WDPD5iQPRItNwA:9 a=4Xnnxe047lxMr34T7-sA:7 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110706212015.344830666@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 17:19:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] tracing: Have enable system events use the subsystem_open routine
References: <20110706211931.764277374@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Have-enable-system-events-use-the-subsystem_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As the system name can be freed when a module is removed, the reference
to the system name that is passed to the enable routines to enable
events at a system level can point to arbitrary memory. This value is
only read, but it will just read garbage.

Change the system event enabling to use the subsystem_open routines
like the system filter routines do.

Cc: <stable@kernel.org>
Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ffc5b28..3e2a7c9 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -557,7 +557,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
 	const char set_to_char[4] = { '?', '0', '1', 'X' };
-	const char *system = filp->private_data;
+	struct event_subsystem *system = filp->private_data;
 	struct ftrace_event_call *call;
 	char buf[2];
 	int set = 0;
@@ -568,7 +568,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		if (!call->name || !call->class || !call->class->reg)
 			continue;
 
-		if (system && strcmp(call->class->system, system) != 0)
+		if (system && strcmp(call->class->system, system->name) != 0)
 			continue;
 
 		/*
@@ -598,7 +598,8 @@ static ssize_t
 system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		    loff_t *ppos)
 {
-	const char *system = filp->private_data;
+	struct event_subsystem *system = filp->private_data;
+	const char *name = NULL;
 	unsigned long val;
 	char buf[64];
 	ssize_t ret;
@@ -622,7 +623,14 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
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
 
@@ -862,6 +870,9 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	struct event_subsystem *system = NULL;
 	int ret;
 
+	if (!inode->i_private)
+		goto skip_search;
+
 	/* Make sure the system still exists */
 	mutex_lock(&event_mutex);
 	list_for_each_entry(system, &event_subsystems, list) {
@@ -880,8 +891,9 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	if (system != inode->i_private)
 		return -ENODEV;
 
+ skip_search:
 	ret = tracing_open_generic(inode, filp);
-	if (ret < 0)
+	if (ret < 0 && system)
 		put_system(system);
 
 	return ret;
@@ -891,7 +903,8 @@ static int subsystem_release(struct inode *inode, struct file *file)
 {
 	struct event_subsystem *system = inode->i_private;
 
-	put_system(system);
+	if (system)
+		put_system(system);
 
 	return 0;
 }
@@ -1041,10 +1054,11 @@ static const struct file_operations ftrace_subsystem_filter_fops = {
 };
 
 static const struct file_operations ftrace_system_enable_fops = {
-	.open = tracing_open_generic,
+	.open = subsystem_open,
 	.read = system_enable_read,
 	.write = system_enable_write,
 	.llseek = default_llseek,
+	.release = subsystem_release,
 };
 
 static const struct file_operations ftrace_show_header_fops = {
@@ -1133,8 +1147,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 			   "'%s/filter' entry\n", name);
 	}
 
-	trace_create_file("enable", 0644, system->entry,
-			  (void *)system->name,
+	trace_create_file("enable", 0644, system->entry, system,
 			  &ftrace_system_enable_fops);
 
 	return system->entry;
-- 
1.7.5.4


