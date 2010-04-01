Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab0DADS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:18:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab0DADSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:18:21 -0400
X-Authority-Analysis: v=1.1 cv=W8jVbnnOFeMnsvu+vJfVVAGaiNyfzTaRLlU2b8ifu+8= c=1 sm=0 a=AI6sVkWC08wA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=VHtyLDwaK_UBfKxO004A:9 a=EVTR0m0io2ump9tUJPp5ES_B7HYA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100401031819.822137328@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 31 Mar 2010 23:17:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/7] tracing: Fix compile error in module tracepoints when MODULE_UNLOAD not set
References: <20100401031735.683626160@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Fix-compile-error-in-module-tracepoints-when.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If modules are configured in the build but unloading of modules is not,
then the refcnt is not defined. Place the get/put module tracepoints
under CONFIG_MODULE_UNLOAD since it references this field in the module
structure.

As a side-effect, this patch also reduces the code when MODULE_UNLOAD
is not set, because these unused tracepoints are not created.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/module.h |    4 ++++
 kernel/module.c               |    5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index a585f81..f07b44a 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -51,6 +51,9 @@ TRACE_EVENT(module_free,
 	TP_printk("%s", __get_str(name))
 );
 
+#ifdef CONFIG_MODULE_UNLOAD
+/* trace_module_get/put are only used if CONFIG_MODULE_UNLOAD is defined */
+
 DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_PROTO(struct module *mod, unsigned long ip),
@@ -86,6 +89,7 @@ DEFINE_EVENT(module_refcnt, module_put,
 
 	TP_ARGS(mod, ip)
 );
+#endif /* CONFIG_MODULE_UNLOAD */
 
 TRACE_EVENT(module_request,
 
diff --git a/kernel/module.c b/kernel/module.c
index 21591ad..d9e2379 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -59,8 +59,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
 
-EXPORT_TRACEPOINT_SYMBOL(module_get);
-
 #if 0
 #define DEBUGP printk
 #else
@@ -467,6 +465,9 @@ MODINFO_ATTR(srcversion);
 static char last_unloaded_module[MODULE_NAME_LEN+1];
 
 #ifdef CONFIG_MODULE_UNLOAD
+
+EXPORT_TRACEPOINT_SYMBOL(module_get);
+
 /* Init the unload section of the module. */
 static void module_unload_init(struct module *mod)
 {
-- 
1.7.0


