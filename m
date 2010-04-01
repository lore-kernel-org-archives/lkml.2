Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab0DADTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:19:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54680 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0DADSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:18:22 -0400
X-Authority-Analysis: v=1.1 cv=8Rq9yliVGc3GxcN10kx+g7e/eWPAtZnInWtRlahw0rA= c=1 sm=0 a=0gIT-FL2ZLwA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=yPCof4ZbAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=FlerQWWHZ_R_z0m4vUcA:9 a=Gjc20_UEkHwm2-o8WnYA:7 a=it0Fzhhu7bD9oSl3f3d-AP_vPR4A:4 a=7DSvI1NPTFQA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100401031819.565320794@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 31 Mar 2010 23:17:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/7] tracing: Remove side effect from module tracepoints that caused a GPF
References: <20100401031735.683626160@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Remove-side-effect-from-module-tracepoints-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Remove the @refcnt argument, because it has side-effects, and arguments with
side-effects are not skipped by the jump over disabled instrumentation and are
executed even when the tracepoint is disabled.

This was also causing a GPF as found by Randy Dunlap:

Subject: [PATCH 3/7] 2.6.33 GP fault only when built with tracing
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
-- 
1.7.0


