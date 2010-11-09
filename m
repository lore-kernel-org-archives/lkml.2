Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0KIJMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:12:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:16772 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab0KIJMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:12:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="855641155"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        chris@chris-wilson.co.uk, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 2/4] tracing: introduce trace_set_clr_module_event
Date: Tue,  9 Nov 2010 17:12:45 +0800
Message-Id: <1289293967-31761-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace events belong to a module does exist only when that module is
loaded. While, when the module loaded, we may miss some trace event
happened at the module load time.

This is so true for gpu driver: when X(or shell) is started, you would
be going to miss lots of events. This would be worse when the KMS is
failed.

So, introduce trace_set_clr_module_event function, and do export it.
Trace event then can be enabled on module load by doing something like
follows at your module init function:

char *xxx_trace = NULL;
module_param_named(trace, xxx_trace, charp, 0400);

xxx_init()
{
	....
	if (xxx_trace)
		ret = trace_set_clr_module_event(THIS_MODULE, xxx_trace, 1);
	....
}

where, xxx_trace is a comm separated event list, * for all event in that
module, NO subsystem is needed.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 include/linux/ftrace_event.h |    3 ++
 kernel/trace/trace_events.c  |   45 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 8beabb9..8fbdbbd 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -226,6 +226,9 @@ extern void trace_remove_event_call(struct ftrace_event_call *call);
 
 int trace_set_clr_event(const char *system, const char *event, int set);
 
+int trace_set_clr_module_event(struct module *mod, 
+			       const char *event_list, int set);
+
 /*
  * The double __builtin_constant_p is because gcc will give us an error
  * if we try to allocate the static variable to fmt if it is not a
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index fe15b7c..711a1d1 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1353,6 +1353,51 @@ static int trace_module_notify(struct notifier_block *self,
 
 	return 0;
 }
+
+/**
+ * trace_set_clr_module_event - enable or disable events for specified module
+ * @mod: the module, the caller should mostly pass by THIS_MODULE
+ * @event_list: the event list, separated by comma.
+ * @set: 1 to enable, 0 to disable
+ *
+ * This function is used by a module to enable or disable events belong to that 
+ * module. This is a way for module to enable some events on module loading.
+ */
+int trace_set_clr_module_event(struct module *mod, 
+				const char *event_list, int set)
+{
+	struct ftrace_event_call *call, *start, *end;
+	char *buf, *p;
+	char *token;
+
+	start = mod->trace_events;
+	end = mod->trace_events + mod->num_trace_events;
+	if (start == end)
+		return 0;
+	
+	if (!event_list)
+		return 0;
+	buf = p = kstrdup(event_list, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for_each_token(token, p) {
+		for_each_event(call, start, end) {
+			if (strcmp(token, "*") == 0 ||
+			    strcmp(token, call->name) == 0) 
+				ftrace_event_enable_disable(call, set);
+			else
+				pr_warning("Failed to find trace event: %s "
+					   "in module %s\n", token, mod->name);
+		
+		}
+	}
+	kfree(buf);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(trace_set_clr_module_event);
+
+
 #else
 static int trace_module_notify(struct notifier_block *self,
 			       unsigned long val, void *data)
-- 
1.7.2.3

