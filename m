Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1HCXa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:30:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206Ab1HCXaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:50 2011
Message-Id: <20110803221250.158324848@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [061/102] tracing: Have "enable" file use refcounts like the "filter" file
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 40ee4dffff061399eb9358e0c8fcfbaf8de4c8fe upstream.

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

Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace_events.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -557,7 +557,7 @@ system_enable_read(struct file *filp, ch
 		   loff_t *ppos)
 {
 	const char set_to_char[4] = { '?', '0', '1', 'X' };
-	const char *system = filp->private_data;
+	struct event_subsystem *system = filp->private_data;
 	struct ftrace_event_call *call;
 	char buf[2];
 	int set = 0;
@@ -568,7 +568,7 @@ system_enable_read(struct file *filp, ch
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
@@ -622,7 +623,14 @@ system_enable_write(struct file *filp, c
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
 
@@ -862,6 +870,9 @@ static int subsystem_open(struct inode *
 	struct event_subsystem *system = NULL;
 	int ret;
 
+	if (!inode->i_private)
+		goto skip_search;
+
 	/* Make sure the system still exists */
 	mutex_lock(&event_mutex);
 	list_for_each_entry(system, &event_subsystems, list) {
@@ -880,8 +891,9 @@ static int subsystem_open(struct inode *
 	if (system != inode->i_private)
 		return -ENODEV;
 
+ skip_search:
 	ret = tracing_open_generic(inode, filp);
-	if (ret < 0)
+	if (ret < 0 && system)
 		put_system(system);
 
 	return ret;
@@ -891,7 +903,8 @@ static int subsystem_release(struct inod
 {
 	struct event_subsystem *system = inode->i_private;
 
-	put_system(system);
+	if (system)
+		put_system(system);
 
 	return 0;
 }
@@ -1041,10 +1054,11 @@ static const struct file_operations ftra
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
@@ -1133,8 +1147,7 @@ event_subsystem_dir(const char *name, st
 			   "'%s/filter' entry\n", name);
 	}
 
-	trace_create_file("enable", 0644, system->entry,
-			  (void *)system->name,
+	trace_create_file("enable", 0644, system->entry, system,
 			  &ftrace_system_enable_fops);
 
 	return system->entry;


