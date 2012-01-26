Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab2AZOgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:36:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62785 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2AZOgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:36:48 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0LOP1KteNnsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Hz4akIxjdHNGw6nKXq8A:9 a=fNs4jbZlN5ANUMrETLAA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327588606.22710.100.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Thu, 26 Jan 2012 09:36:46 -0500
In-Reply-To: <1327586669.22710.89.camel@gandalf.stny.rr.com>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>
	 <20120117095418.GG10397@elte.hu>
	 <1326807145.17534.26.camel@gandalf.stny.rr.com>
	 <20120118120711.GB14863@elte.hu>
	 <1326909412.17534.91.camel@gandalf.stny.rr.com>
	 <877h0jgx80.fsf@rustcorp.com.au>
	 <1327545664.22710.78.camel@gandalf.stny.rr.com>
	 <20120126102836.GD3853@elte.hu>
	 <1327585945.22710.87.camel@gandalf.stny.rr.com>
	 <20120126135504.GA13107@elte.hu>
	 <1327586669.22710.89.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 09:04 -0500, Steven Rostedt wrote:
> [ Added Li who added the original tracepoint ]
> 
> On Thu, 2012-01-26 at 14:55 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Thu, 2012-01-26 at 11:28 +0100, Ingo Molnar wrote:
> > > 
> > > > How much more do we save if we move all of try_module_get() out 
> > > > of line? It still seems a rather thick inline function with 
> > > > preempt section and all. I'd *really* suggest that it should all 
> > > > be uninlined.
> > > > 
> > > 
> > > Here's the #'s
> > > 
> > >    text	   data	    bss	    dec	    hex	filename
> > > 7489488	2249584	9719808	19458880	128eb40	vmlinux-prepatch
> > >    text	   data	    bss	    dec	    hex	filename
> > > 7482458	2248048	9719808	19450314	128c9ca	vmlinux-postpatch
> > >    text	   data	    bss	    dec	    hex	filename
> > > 7477393	2248080	9719808	19445281	128b621	vmlinux-updatedpatch


New numbers:

   text	   data	    bss	    dec	    hex	filename
7476509	2248048	9719808	19444365	128b28d	vmlinux-updatedpatch2

Just 916 bytes savings more. But gets rid of the hot path changes.

New patch below: (and the IP still works)

-- Steve

diff --git a/include/linux/module.h b/include/linux/module.h
index 3cb7839..ef928b9 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -21,8 +21,6 @@
 #include <linux/percpu.h>
 #include <asm/module.h>
 
-#include <trace/events/module.h>
-
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
@@ -439,36 +437,8 @@ void __symbol_put(const char *symbol);
 #define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x)
 void symbol_put_addr(void *addr);
 
-/* Sometimes we know we already have a refcount, and it's easier not
-   to handle the error case (which only happens with rmmod --wait). */
-static inline void __module_get(struct module *module)
-{
-	if (module) {
-		preempt_disable();
-		__this_cpu_inc(module->refptr->incs);
-		trace_module_get(module, _THIS_IP_);
-		preempt_enable();
-	}
-}
-
-static inline int try_module_get(struct module *module)
-{
-	int ret = 1;
-
-	if (module) {
-		preempt_disable();
-
-		if (likely(module_is_live(module))) {
-			__this_cpu_inc(module->refptr->incs);
-			trace_module_get(module, _THIS_IP_);
-		} else
-			ret = 0;
-
-		preempt_enable();
-	}
-	return ret;
-}
-
+extern void __module_get(struct module *module);
+extern int try_module_get(struct module *module);
 extern void module_put(struct module *module);
 
 #else /*!CONFIG_MODULE_UNLOAD*/
diff --git a/kernel/module.c b/kernel/module.c
index 178333c..c3dca5c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -928,6 +928,38 @@ void module_put(struct module *module)
 }
 EXPORT_SYMBOL(module_put);
 
+/* Sometimes we know we already have a refcount, and it's easier not
+   to handle the error case (which only happens with rmmod --wait). */
+void __module_get(struct module *module)
+{
+	if (module) {
+		preempt_disable();
+		__this_cpu_inc(module->refptr->incs);
+		trace_module_get(module, _RET_IP_);
+		preempt_enable();
+	}
+}
+EXPORT_SYMBOL(__module_get);
+
+int try_module_get(struct module *module)
+{
+	int ret = 1;
+
+	if (module) {
+		preempt_disable();
+
+		if (likely(module_is_live(module))) {
+			__this_cpu_inc(module->refptr->incs);
+			trace_module_get(module, _RET_IP_);
+		} else
+			ret = 0;
+
+		preempt_enable();
+	}
+	return ret;
+}
+EXPORT_SYMBOL(try_module_get);
+
 #else /* !CONFIG_MODULE_UNLOAD */
 static inline void print_unload_info(struct seq_file *m, struct module *mod)
 {


