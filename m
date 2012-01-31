Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2AaJ7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 04:59:13 -0500
Received: from ozlabs.org ([203.10.76.45]:44715 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab2AaJ7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 04:59:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
In-Reply-To: <1327924333.22710.157.camel@gandalf.stny.rr.com>
References: <1326807145.17534.26.camel@gandalf.stny.rr.com> <20120118120711.GB14863@elte.hu> <1326909412.17534.91.camel@gandalf.stny.rr.com> <877h0jgx80.fsf@rustcorp.com.au> <1327545664.22710.78.camel@gandalf.stny.rr.com> <20120126102836.GD3853@elte.hu> <1327585945.22710.87.camel@gandalf.stny.rr.com> <20120126135504.GA13107@elte.hu> <1327586669.22710.89.camel@gandalf.stny.rr.com> <1327588606.22710.100.camel@gandalf.stny.rr.com> <20120126183946.GA14709@elte.hu> <87ehuldf0m.fsf@rustcorp.com.au> <1327924333.22710.157.camel@gandalf.stny.rr.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 31 Jan 2012 14:28:47 +1030
Message-ID: <87sjiwjzew.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 06:52:13 -0500, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-01-27 at 13:32 +1030, Rusty Russell wrote:
> > On Thu, 26 Jan 2012 19:39:46 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> > > Ok, i like this one best. Rusty, does it look good to you too?
> > 
> > No, the if (module) test belongs in the inline wrapper (since gcc knows
> > that at compile time).
> 
> For some reason though it still adds 5K when we keep the code as a
> static inline. Note, my test config does have all the necessary modules
> to boot the box as compiled in (not as modules). If necessary, I could
> compile with a distro config and see what the differences are with that.
> 
> Rusty, the final decision is yours. If you believe that the added code
> size is worth having the static inlines, then I'll go back to the
> previous version that had that.

Wow, we're really bikeshedding this!

I was completely wrong with the "it's usually a constant" of course;
it's usually ->owner.

So let's just out-of-line the entire thing.  I changed the type to bool
and s/_THIS_IP_/_RET_IP_/ -- is that sufficient?

Doesn't save me much here, though.  What are your stats?


module: move __module_get and try_module_get() out of line.

With the preempt, tracepoint and everything, it's getting a bit
chubby.

Saves only 400 bytes of text here, but I don't do preempt or
tracepoints.

Before:
   text	   data	    bss	    dec	    hex	filename
5373459	 399532	2514944	8287935	 7e76bf	vmlinux

After:
   text	   data	    bss	    dec	    hex	filename
5373071	 399532	2514944	8287547	 7e753b	vmlinux

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
