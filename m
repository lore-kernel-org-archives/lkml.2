Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0CXC4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:56:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63641 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab0CXC4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:56:44 -0400
Message-ID: <4BA97FA7.6040406@cn.fujitsu.com>
Date: Wed, 24 Mar 2010 10:57:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing: Reduce overhead of module tracepoints
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the @refcnt argument, because it has side-effects, and
arguments with side-effects are not skipped by the jump over
disabled instrumentation, so it adds overhead even when the
tracepoints are disabled.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.6.3

