Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab2BAHGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:06:14 -0500
Received: from ozlabs.org ([203.10.76.45]:48536 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab2BAHGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:06:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
In-Reply-To: <1328014230.5882.29.camel@gandalf.stny.rr.com>
References: <1327545664.22710.78.camel@gandalf.stny.rr.com> <20120126102836.GD3853@elte.hu> <1327585945.22710.87.camel@gandalf.stny.rr.com> <20120126135504.GA13107@elte.hu> <1327586669.22710.89.camel@gandalf.stny.rr.com> <1327588606.22710.100.camel@gandalf.stny.rr.com> <20120126183946.GA14709@elte.hu> <87ehuldf0m.fsf@rustcorp.com.au> <1327924333.22710.157.camel@gandalf.stny.rr.com> <87sjiwjzew.fsf@rustcorp.com.au> <20120131122016.GF32010@elte.hu> <1328014230.5882.29.camel@gandalf.stny.rr.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 01 Feb 2012 17:18:18 +1030
Message-ID: <87y5snhwwd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 07:50:30 -0500, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-01-31 at 13:20 +0100, Ingo Molnar wrote:
> 
> > > Saves only 400 bytes of text here, but I don't do preempt or 
> > > tracepoints.
> > 
> > Most distro kernels do tracepoints so I guess that's where the 
> > size delta comes from :-) In any case:
> 
> Yes, having tracepoints inlined causes a lot of bloat. But I still did
> get a 1799 bytes savings between moving the tracepoint out of line but
> keeping the if, and totally moving the entire functions out of line. Not
> sure what the discrepancy was there.
> 
> My last set of numbers came from the default 3.0.0 Debian config, which
> probably adds more things that call these functions into the kernel
> proper?

Here's the results I get, using the Ubuntu 3.0.0 config (minus
CONFIG_DEBUG_INFO, and rest with Enter held down).

Applied,
Rusty.

From: Steven Rostedt <rostedt@goodmis.org>
Subject: module: move __module_get and try_module_get() out of line.

With the preempt, tracepoint and everything, it's getting a bit
chubby.  For an Ubuntu-based config:

Before:
	$ size -t `find * -name '*.ko'` | grep TOTAL
	56199906        3870760	1606616	61677282	3ad1ee2	(TOTALS)
	$ size vmlinux
	   text	   data	    bss	    dec	    hex	filename
	8509342	 850368	3358720	12718430	 c2115e	vmlinux

After:
	$ size -t `find * -name '*.ko'` | grep TOTAL
	56183760	3867892	1606616	61658268	3acd49c	(TOTALS)
	$ size vmlinux
	   text	   data	    bss	    dec	    hex	filename
	8501842	 849088	3358720	12709650	 c1ef12	vmlinux

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (made all out-of-line)

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -21,8 +21,6 @@
 #include <linux/percpu.h>
 #include <asm/module.h>
 
-#include <trace/events/module.h>
-
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
@@ -452,33 +450,11 @@ void symbol_put_addr(void *addr);
 
 /* Sometimes we know we already have a refcount, and it's easier not
    to handle the error case (which only happens with rmmod --wait). */
-static inline void __module_get(struct module *module)
-{
-	if (module) {
-		preempt_disable();
-		__this_cpu_inc(module->refptr->incs);
-		trace_module_get(module, _THIS_IP_);
-		preempt_enable();
-	}
-}
+extern void __module_get(struct module *module);
 
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
+/* This is the Right Way to get a module: if it fails, it's being removed,
+ * so pretend it's not there. */
+extern bool try_module_get(struct module *module);
 
 extern void module_put(struct module *module);
 
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -903,6 +903,36 @@ static ssize_t show_refcnt(struct module
 static struct module_attribute modinfo_refcnt =
 	__ATTR(refcnt, 0444, show_refcnt, NULL);
 
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
+bool try_module_get(struct module *module)
+{
+	bool ret = true;
+
+	if (module) {
+		preempt_disable();
+
+		if (likely(module_is_live(module))) {
+			__this_cpu_inc(module->refptr->incs);
+			trace_module_get(module, _RET_IP_);
+		} else
+			ret = false;
+
+		preempt_enable();
+	}
+	return ret;
+}
+EXPORT_SYMBOL(try_module_get);
+
 void module_put(struct module *module)
 {
 	if (module) {
