Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab2AZClJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 21:41:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52762 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2AZClH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 21:41:07 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Wnwe2f1YncwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=f98NDL8C9SIdlBfhQesA:9 a=jZUqmYfAOtuDxY5dxJMA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327545664.22710.78.camel@gandalf.stny.rr.com>
Subject: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 25 Jan 2012 21:41:04 -0500
In-Reply-To: <877h0jgx80.fsf@rustcorp.com.au>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>
	 <20120117095418.GG10397@elte.hu>
	 <1326807145.17534.26.camel@gandalf.stny.rr.com>
	 <20120118120711.GB14863@elte.hu>
	 <1326909412.17534.91.camel@gandalf.stny.rr.com>
	 <877h0jgx80.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 09:29 +1030, Rusty Russell wrote:
> > could just move the "if" part out.
> 
> Agreed.  Since GCC should be able to eliminate that branch in almost all
> cases, since it's usually a literal NULL or address of a (non-weak)
> symbol.
> 
> Be interesting to see the before/after sizes with this out-of-line.

Using my default test config I got:

   text	   data	    bss	    dec	    hex	filename
7489488	2249584	9719808	19458880	128eb40	vmlinux-prepatch
7482458	2248048	9719808	19450314	128c9ca	vmlinux-postpatch

An 8k savings!

Rusty,

Can you give my your Acked-by for this patch?

Thanks!

-- Steve

diff --git a/include/linux/module.h b/include/linux/module.h
index 3cb7839..b83a687 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -21,8 +21,6 @@
 #include <linux/percpu.h>
 #include <asm/module.h>
 
-#include <trace/events/module.h>
-
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
@@ -438,6 +436,7 @@ unsigned int module_refcount(struct module *mod);
 void __symbol_put(const char *symbol);
 #define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x)
 void symbol_put_addr(void *addr);
+void inc_module(struct module *module, unsigned long ip);
 
 /* Sometimes we know we already have a refcount, and it's easier not
    to handle the error case (which only happens with rmmod --wait). */
@@ -445,8 +444,7 @@ static inline void __module_get(struct module *module)
 {
 	if (module) {
 		preempt_disable();
-		__this_cpu_inc(module->refptr->incs);
-		trace_module_get(module, _THIS_IP_);
+		inc_module(module, _THIS_IP_);
 		preempt_enable();
 	}
 }
@@ -458,10 +456,9 @@ static inline int try_module_get(struct module *module)
 	if (module) {
 		preempt_disable();
 
-		if (likely(module_is_live(module))) {
-			__this_cpu_inc(module->refptr->incs);
-			trace_module_get(module, _THIS_IP_);
-		} else
+		if (likely(module_is_live(module)))
+			inc_module(module, _THIS_IP_);
+		else
 			ret = 0;
 
 		preempt_enable();
diff --git a/kernel/module.c b/kernel/module.c
index 178333c..83c22409 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -928,6 +928,13 @@ void module_put(struct module *module)
 }
 EXPORT_SYMBOL(module_put);
 
+void inc_module(struct module *module, unsigned long ip)
+{
+	__this_cpu_inc(module->refptr->incs);
+	trace_module_get(module, ip);
+}
+EXPORT_SYMBOL(inc_module);
+
 #else /* !CONFIG_MODULE_UNLOAD */
 static inline void print_unload_info(struct seq_file *m, struct module *mod)
 {



