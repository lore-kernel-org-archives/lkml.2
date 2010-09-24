Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0IXJAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 05:00:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:33795 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab0IXJAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 05:00:39 -0400
Date: Fri, 24 Sep 2010 09:00:24 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <a9ba2056e2c9cf332c3c300b577463ce66ff23a8.1284733808.git.jbaron@redhat.com>
References: <a9ba2056e2c9cf332c3c300b577463ce66ff23a8.1284733808.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Tracepoint support for jump labels
Message-ID: <tip-8f7b50c514206211cc282a4247f7b12f18dee674@git.kernel.org>
Git-Commit-ID: 8f7b50c514206211cc282a4247f7b12f18dee674
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 24 Sep 2010 09:00:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f7b50c514206211cc282a4247f7b12f18dee674
Gitweb:     http://git.kernel.org/tip/8f7b50c514206211cc282a4247f7b12f18dee674
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Fri, 17 Sep 2010 11:09:13 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 22 Sep 2010 16:31:01 -0400

jump label: Tracepoint support for jump labels

Make use of the jump label infrastructure for tracepoints.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <a9ba2056e2c9cf332c3c300b577463ce66ff23a8.1284733808.git.jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |    5 ++++-
 kernel/tracepoint.c        |   14 ++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 103d1b6..a4a90b6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/rcupdate.h>
+#include <linux/jump_label.h>
 
 struct module;
 struct tracepoint;
@@ -145,7 +146,9 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		if (unlikely(__tracepoint_##name.state))		\
+		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
+		return;							\
+do_trace:								\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args));			\
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index c77f3ec..d6073a5 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/jump_label.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
@@ -263,7 +264,13 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
-	elem->state = active;
+	if (!elem->state && active) {
+		enable_jump_label(&elem->state);
+		elem->state = active;
+	} else if (elem->state && !active) {
+		disable_jump_label(&elem->state);
+		elem->state = active;
+	}
 }
 
 /*
@@ -277,7 +284,10 @@ static void disable_tracepoint(struct tracepoint *elem)
 	if (elem->unregfunc && elem->state)
 		elem->unregfunc();
 
-	elem->state = 0;
+	if (elem->state) {
+		disable_jump_label(&elem->state);
+		elem->state = 0;
+	}
 	rcu_assign_pointer(elem->funcs, NULL);
 }
 
