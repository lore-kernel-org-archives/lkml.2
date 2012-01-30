Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2A3R2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:28:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53252 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2A3R2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:28:19 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0LOP1KteNnsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=-YcWuDbUsBXGCsgVjWwA:9 a=MozaWfuTXnCftFLJD6MA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327944496.22710.191.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Mon, 30 Jan 2012 12:28:16 -0500
In-Reply-To: <1327924333.22710.157.camel@gandalf.stny.rr.com>
References: <1326807145.17534.26.camel@gandalf.stny.rr.com>
	 <20120118120711.GB14863@elte.hu>
	 <1326909412.17534.91.camel@gandalf.stny.rr.com>
	 <877h0jgx80.fsf@rustcorp.com.au>
	 <1327545664.22710.78.camel@gandalf.stny.rr.com>
	 <20120126102836.GD3853@elte.hu>
	 <1327585945.22710.87.camel@gandalf.stny.rr.com>
	 <20120126135504.GA13107@elte.hu>
	 <1327586669.22710.89.camel@gandalf.stny.rr.com>
	 <1327588606.22710.100.camel@gandalf.stny.rr.com>
	 <20120126183946.GA14709@elte.hu> <87ehuldf0m.fsf@rustcorp.com.au>
	 <1327924333.22710.157.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 06:52 -0500, Steven Rostedt wrote:
> On Fri, 2012-01-27 at 13:32 +1030, Rusty Russell wrote:
> > On Thu, 26 Jan 2012 19:39:46 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> > > Ok, i like this one best. Rusty, does it look good to you too?
> > 
> > No, the if (module) test belongs in the inline wrapper (since gcc knows
> > that at compile time).
> 

> I'll compile with a distro config, and then take a look at the
> differences of the vmlinux.
> 

I just finished, and here's my results:

I used the debian config config-3.0.0-1-amd64 against v3.2 kernel and
gcc 4.6.0.

   text	   data	    bss	    dec	    hex	filename
11124685	2028416	2510848	15663949	 ef034d	vmlinux.orig
11119568	2028416	2510848	15658832	 eeef50	vmlinux.if
11117769	2028416	2510848	15657033	 eee849	vmlinux.func

The first (.orig) is the current method.

The second (.if) is the functions still there, but the contents of the
if statement moved out of line into its own inc_module() function that
is put in module.c

The last (.func) is the entire function moved out of module.h into
module.c.

Savings of the inc_module() patch: 5117 bytes

Savings of the full out of line patch: 6916 bytes

That's another 1799 bytes in savings moving the functions out of inline.

I looked at why this was the case. I searched around, and it seems
mostly due to try_module_get() and not __module_get(). Because
try_module_get() is usually called with a pointer and not a constant:

fs/anon_inodes.c: anon_inode_getfile()

	if (fops->owner && !try_module_get(fops->owner))
		return ERR_PTR(-ENOENT);

To test this, I moved only try_module_get() from being inlined to a
function:

   text	   data	    bss	    dec	    hex	filename
11117895	2028416	2510848	15657159	 eee8c7	vmlinux.if-func

This one has a savings of 6790 bytes (a differences of 126 bytes from
the full out-of-line version).

The extra 126 bytes came from:

fs/exec.c:set_binfmt(),
fs/filesystems.c:get_filesystem(),
drivers/dma/dmaengine.c:balance_ref_count(),
drivers/dma/dmaengine.c:dma_chan_get(),
drivers/tty/vt/vt.c:visual_init(),
drivers/tty/vt/vt.c:bind_con_driver(),
net/socket.c:sys_accept4(), net/socket.c:kernel_accept(),
net/ipv4/inet_timewait_sock.c:inet_twsk_alloc(),
net/sunrpc/svc.c:svc_set_num_threads(),
net/sunrpc/svc_xprt.c:svc_recv(),
 and
net/sunrpc/auth_gss/gss_mech_switch.c:gss_mech_get()

All these call __module_get() from a pointer:

struct gss_api_mech *
gss_mech_get(struct gss_api_mech *gm)
{
	__module_get(gm->gm_owner);
	return gm;
}


where gcc can not optimize the if (module) out.

Rusty, which version do you want me to use?

Full out-of-line (which you don't seem to like).
Move just the contents of the if (module) out.
Move the contents of __module_get() if out, but out-of-line try_module_get()?

Below is the patch that moves the if (module) out of __module_get() and
makes try_module_get() into a normal function call (last choice above):

diff --git a/include/linux/module.h b/include/linux/module.h
index 3cb7839..41840be 100644
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
@@ -445,30 +444,12 @@ static inline void __module_get(struct module
*module)
 {
 	if (module) {
 		preempt_disable();
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
+		inc_module(module, _THIS_IP_);
 		preempt_enable();
 	}
-	return ret;
 }
 
+extern int try_module_get(struct module *module);
 extern void module_put(struct module *module);
 
 #else /*!CONFIG_MODULE_UNLOAD*/
diff --git a/kernel/module.c b/kernel/module.c
index 178333c..ca94dc9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -928,6 +928,31 @@ void module_put(struct module *module)
 }
 EXPORT_SYMBOL(module_put);
 
+void inc_module(struct module *module, unsigned long ip)
+{
+	__this_cpu_inc(module->refptr->incs);
+	trace_module_get(module, ip);
+}
+EXPORT_SYMBOL(inc_module);
+
+int try_module_get(struct module *module)
+{
+	int ret = 1;
+
+	if (module) {
+		preempt_disable();
+
+		if (likely(module_is_live(module)))
+			inc_module(module, _RET_IP_);
+		else
+			ret = 0;
+
+		preempt_enable();
+	}
+	return ret;
+}
+EXPORT_SYMBOL(try_module_get);
+
 #else /* !CONFIG_MODULE_UNLOAD */
 static inline void print_unload_info(struct seq_file *m, struct module
*mod)
 {


