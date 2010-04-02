Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0DBTEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:04:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:47573 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab0DBTEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:04:48 -0400
Date: Fri, 2 Apr 2010 19:04:22 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mathieu.desnoyers@efficios.com, lizf@cn.fujitsu.com,
       randy.dunlap@oracle.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, randy.dunlap@oracle.com
In-Reply-To: <4BA97FA7.6040406@cn.fujitsu.com>
References: <4BA2B69D.3000309@oracle.com>,
	<4BA97FA7.6040406@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Remove side effect from module tracepoints that caused a GPF
Message-ID: <tip-ae832d1e03ac9bf09fb8a07fb37908ab40c7cd0e@git.kernel.org>
Git-Commit-ID: ae832d1e03ac9bf09fb8a07fb37908ab40c7cd0e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:04:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae832d1e03ac9bf09fb8a07fb37908ab40c7cd0e
Gitweb:     http://git.kernel.org/tip/ae832d1e03ac9bf09fb8a07fb37908ab40c7cd0e
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Mar 2010 10:57:43 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 31 Mar 2010 22:56:58 -0400

tracing: Remove side effect from module tracepoints that caused a GPF

Remove the @refcnt argument, because it has side-effects, and arguments with
side-effects are not skipped by the jump over disabled instrumentation and are
executed even when the tracepoint is disabled.

This was also causing a GPF as found by Randy Dunlap:

Subject: 2.6.33 GP fault only when built with tracing
LKML-Reference: <4BA2B69D.3000309@oracle.com>

Note, the current 2.6.34-rc has a fix for the actual cause of the GPF,
but this fixes one of its triggers.

Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BA97FA7.6040406@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/module.h        |    6 ++----
 include/trace/events/module.h |   14 +++++++-------
 kernel/module.c               |    3 +--
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 5e869ff..393ec39 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -460,8 +460,7 @@ static inline void __module_get(struct module *module)
 	if (module) {
 		preempt_disable();
 		__this_cpu_inc(module->refptr->count);
-		trace_module_get(module, _THIS_IP_,
-				 __this_cpu_read(module->refptr->count));
+		trace_module_get(module, _THIS_IP_);
 		preempt_enable();
 	}
 }
@@ -475,8 +474,7 @@ static inline int try_module_get(struct module *module)
 
 		if (likely(module_is_live(module))) {
 			__this_cpu_inc(module->refptr->count);
-			trace_module_get(module, _THIS_IP_,
-				__this_cpu_read(module->refptr->count));
+			trace_module_get(module, _THIS_IP_);
 		}
 		else
 			ret = 0;
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 4b0f48b..a585f81 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -53,9 +53,9 @@ TRACE_EVENT(module_free,
 
 DECLARE_EVENT_CLASS(module_refcnt,
 
-	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+	TP_PROTO(struct module *mod, unsigned long ip),
 
-	TP_ARGS(mod, ip, refcnt),
+	TP_ARGS(mod, ip),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	ip		)
@@ -65,7 +65,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_fast_assign(
 		__entry->ip	= ip;
-		__entry->refcnt	= refcnt;
+		__entry->refcnt	= __this_cpu_read(mod->refptr->count);
 		__assign_str(name, mod->name);
 	),
 
@@ -75,16 +75,16 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 DEFINE_EVENT(module_refcnt, module_get,
 
-	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+	TP_PROTO(struct module *mod, unsigned long ip),
 
-	TP_ARGS(mod, ip, refcnt)
+	TP_ARGS(mod, ip)
 );
 
 DEFINE_EVENT(module_refcnt, module_put,
 
-	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+	TP_PROTO(struct module *mod, unsigned long ip),
 
-	TP_ARGS(mod, ip, refcnt)
+	TP_ARGS(mod, ip)
 );
 
 TRACE_EVENT(module_request,
diff --git a/kernel/module.c b/kernel/module.c
index c968d36..21591ad 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -800,8 +800,7 @@ void module_put(struct module *module)
 		preempt_disable();
 		__this_cpu_dec(module->refptr->count);
 
-		trace_module_put(module, _RET_IP_,
-				 __this_cpu_read(module->refptr->count));
+		trace_module_put(module, _RET_IP_);
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
