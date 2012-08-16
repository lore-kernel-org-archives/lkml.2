Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab2HPRqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:46:01 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52285 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab2HPRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:45:33 -0400
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH -v2 1/4] trace events: Interface to add files to debugfs
Date: Thu, 16 Aug 2012 19:45:20 +0200
Message-Id: <1345139123-15212-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1345139123-15212-1-git-send-email-bp@amd64.org>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This generic interface is supposed to be used to add files to
(debugfs)/tracing/events/<subsys>/<event_name>/ which are supposed to
export additional events functionality to users.

For example, the file descriptor of a persistent event can be exported
like this in the 'pers' node:

/mnt/dbg/tracing/events/mce/mce_record/
|-- enable
|-- filter
|-- format
|-- id
`-- persistent

So that userspace tools can read it out and map it directly.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/ftrace_event.h |  3 +++
 kernel/trace/trace.c         |  4 ++++
 kernel/trace/trace.h         |  1 +
 kernel/trace/trace_events.c  | 35 +++++++++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 642928cf57b4..f4f283954cbf 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -265,6 +265,9 @@ extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      int is_signed, int filter_type);
 extern int trace_add_event_call(struct ftrace_event_call *call);
 extern void trace_remove_event_call(struct ftrace_event_call *call);
+extern struct dentry *
+trace_add_file(const char *dir_name, const char *fname, umode_t mode,
+		void *data, const struct file_operations *fops);
 
 #define is_signed_type(type)	(((type)(-1)) < 0)
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c38c81496ce..e45479572328 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4641,6 +4641,10 @@ struct dentry *trace_create_file(const char *name,
 	return ret;
 }
 
+void trace_remove_file(struct dentry *d)
+{
+	return debugfs_remove(d);
+}
 
 static struct dentry *trace_options_init_dentry(void)
 {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 55e1f7f0db12..fd639f45c425 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -338,6 +338,7 @@ struct dentry *trace_create_file(const char *name,
 				 struct dentry *parent,
 				 void *data,
 				 const struct file_operations *fops);
+void trace_remove_file(struct dentry *d);
 
 struct dentry *tracing_init_dentry(void);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29111da1d100..5eda4f584380 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1199,6 +1199,41 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	return 0;
 }
 
+static struct dentry *__trace_add_file(struct ftrace_event_call *call,
+				       const char *fname, umode_t mode,
+				       void *data,
+				       const struct file_operations *fops)
+{
+	struct dentry *ret;
+
+	mutex_lock(&event_mutex);
+	ret = trace_create_file(fname, mode, call->dir, data, fops);
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+/*
+ * Assumptions:
+ * - event debugfs dir is already initialized
+ * - trace event is not declared in a module
+ */
+struct dentry *trace_add_file(const char *dir_name, const char *fname,
+			      umode_t mode, void *data,
+			      const struct file_operations *fops)
+{
+	struct ftrace_event_call *call;
+
+	if (!strlen(fname))
+		return NULL;
+
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (!strncmp(call->name, dir_name, strlen(dir_name)))
+			return __trace_add_file(call, fname, mode, data, fops);
+	}
+	return NULL;
+}
+
 static int
 __trace_add_event_call(struct ftrace_event_call *call, struct module *mod,
 		       const struct file_operations *id,
-- 
1.7.11.rc1

