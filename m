Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab0GTHNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:13:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34417 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822Ab0GTHNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:13:20 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] tracing/documentation: document dynamic ftracer internals
Date: Tue, 20 Jul 2010 03:13:35 -0400
Message-Id: <1279610015-10250-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
your presentations helped to clarify a bit more what the dynamic code
actually was doing.  the ifdef mess and multiple runtime patching locs
were throwing me off before.

after experimenting with the Blackfin dynamic ftrace port under a simulator,
this is what i think ive figured out.  please double check my assumptions.

btw, nice presentation at ols.  hope i didnt harass you too much ;).

 Documentation/trace/ftrace-design.txt |  153 +++++++++++++++++++++++++++++++-
 include/linux/ftrace.h                |    5 +
 2 files changed, 153 insertions(+), 5 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index f1f81af..c50bfb4 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -13,6 +13,9 @@ Note that this focuses on architecture implementation details only.  If you
 want more explanation of a feature in terms of common code, review the common
 ftrace.txt file.
 
+Ideally, everyone who wishes to retain performance while supporting tracing in
+their kernel should make it all the way to dynamic ftrace support.
+
 
 Prerequisites
 -------------
@@ -215,7 +218,7 @@ An arch may pass in a unique value (frame pointer) to both the entering and
 exiting of a function.  On exit, the value is compared and if it does not
 match, then it will panic the kernel.  This is largely a sanity check for bad
 code generation with gcc.  If gcc for your port sanely updates the frame
-pointer under different opitmization levels, then ignore this option.
+pointer under different optimization levels, then ignore this option.
 
 However, adding support for it isn't terribly difficult.  In your assembly code
 that calls prepare_ftrace_return(), pass the frame pointer as the 3rd argument.
@@ -234,7 +237,7 @@ If you can't trace NMI functions, then skip this option.
 
 
 HAVE_SYSCALL_TRACEPOINTS
----------------------
+------------------------
 
 You need very few things to get the syscalls tracing in an arch.
 
@@ -250,12 +253,152 @@ You need very few things to get the syscalls tracing in an arch.
 HAVE_FTRACE_MCOUNT_RECORD
 -------------------------
 
-See scripts/recordmcount.pl for more info.
+See scripts/recordmcount.pl for more info.  Just fill in the arch-specific
+details for how to locate the addresses of mcount call sites via objdump.
+This option doesn't make much sense without also implementing dynamic ftrace.
 
+
+HAVE_DYNAMIC_FTRACE
+-------------------
+
+You will first need HAVE_FTRACE_MCOUNT_RECORD and HAVE_FUNCTION_TRACER, so
+scroll your reader back up if you got over eager.
+
+Once those are out of the way, you will need to implement:
+	- asm/ftrace.h:
+		- MCOUNT_ADDR
+		- ftrace_call_adjust()
+		- struct dyn_arch_ftrace{}
+	- asm code:
+		- mcount() (new stub)
+		- ftrace_caller()
+		- ftrace_call()
+		- ftrace_stub()
+	- C code:
+		- ftrace_dyn_arch_init()
+		- ftrace_make_nop()
+		- ftrace_make_call()
+		- ftrace_update_ftrace_func()
+
+First you will need to fill out some arch details in your asm/ftrace.h.
+
+Define MCOUNT_ADDR as the address of your mcount symbol similar to:
+	#define MCOUNT_ADDR ((unsigned long)mcount)
+Since no one else will have a decl for that function, you will need to:
+	extern void mcount(void);
+
+You will also need the helper function ftrace_call_adjust().  Most people
+will be able to stub it out like so:
+	static inline unsigned long ftrace_call_adjust(unsigned long addr)
+	{
+		return addr;
+	}
 <details to be filled>
 
+Lastly you will need the custom dyn_arch_ftrace structure.  If you need
+some extra state when runtime patching arbitrary call sites, this is the
+place.  For now though, create an empty struct:
+	struct dyn_arch_ftrace {
+		/* No extra data needed */
+	};
+
+With the header out of the way, we can fill out the assembly code.  While we
+did already create a mcount() function earlier, dynamic ftrace only wants a
+stub function.  This is because the mcount() will only be used during boot
+and then all references to it will be patched out never to return.  Instead,
+the guts of the old mcount() will be used to create a new ftrace_caller()
+function.  Because the two are hard to merge, it will most likely be a lot
+easier to have two separate definitions split up by #ifdefs.  Same goes for
+the ftrace_stub() as that will now be inlined in ftrace_caller().
+
+Before we get confused anymore, let's check out some pseudo code so you can
+implement your own stuff in assembly:
 
-HAVE_DYNAMIC_FTRACE
----------------------
+void mcount(void)
+{
+	return;
+}
+
+void ftrace_caller(void)
+{
+	/* implement HAVE_FUNCTION_TRACE_MCOUNT_TEST if you desire */
+
+	/* save all state needed by the ABI (see paragraph above) */
+
+	unsigned long frompc = ...;
+	unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;
+
+ftrace_call:
+	ftrace_stub(frompc, selfpc);
+
+	/* restore all state needed by the ABI */
+
+ftrace_stub:
+	return;
+}
+
+This might look a little odd at first, but keep in mind that we will be runtime
+patching multiple things.  First, only functions that we actually want to trace
+will be patched to call ftrace_caller().  Second, since we only have one tracer
+active at a time, we will patch the ftrace_caller() function itself to call the
+specific tracer in question.  That is the point of the ftrace_call label.
+
+With that in mind, let's move on to the C code that will actually be doing the
+runtime patching.  You'll need a little knowledge of your arch's opcodes in
+order to make it through the next section.
+
+Every arch has an init callback function.  If you need to do something early on
+to initialize some state, this is the time to do that.  Otherwise, this simple
+function below should be sufficient for most people:
+
+int __init ftrace_dyn_arch_init(void *data)
+{
+	/* return value is done indirectly via data */
+	*(unsigned long *)data = 0;
+
+	return 0;
+}
+
+There are two functions that are used to do runtime patching of arbitrary
+functions.  The first is used to turn the mcount call site into a nop (which
+is what helps us retain runtime performance when not tracing).  The second is
+used to turn the mcount call site into a call to an arbitrary location (but
+typically that is ftracer_caller()).  See the general function definition in
+linux/ftrace.h for the functions:
+	ftrace_make_nop()
+	ftrace_make_call()
+The rec->ip value is the address of the mcount call site that was collected
+by the scripts/recordmcount.pl during build time.
+
+The last function is used to do runtime patching of the active tracer.  This
+will be modifying the assembly code at the location of the ftrace_call symbol
+inside of the ftrace_caller() function.  So you should have sufficient padding
+at that location to support the new function calls you'll be inserting.  Some
+people will be using a "call" type instruction while others will be sing a
+"branch" type instruction.  Specifically, the function is:
+	ftrace_update_ftrace_func()
+
+
+HAVE_DYNAMIC_FTRACE + HAVE_FUNCTION_GRAPH_TRACER
+------------------------------------------------
+
+The function grapher needs a few tweaks in order to work with dynamic ftrace.
+Basically, you will need to:
+	- update:
+		- ftrace_caller()
+		- ftrace_graph_call()
+		- ftrace_graph_caller()
+	- implement:
+		- ftrace_enable_ftrace_graph_caller()
+		- ftrace_disable_ftrace_graph_caller()
 
 <details to be filled>
+Quick notes:
+	- add a nop stub after the ftrace_call location named ftrace_graph_call;
+	  stub needs to be large enough to support a call to ftrace_graph_caller()
+	- update ftrace_graph_caller() to work with being called by the new
+	  ftrace_caller() since some semantics may have changed
+	- ftrace_enable_ftrace_graph_caller() will runtime patch the
+	  ftrace_graph_call location with a call to ftrace_graph_caller()
+	- ftrace_disable_ftrace_graph_caller() will runtime patch the
+	  ftrace_graph_call location with nops
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 41e4633..dcd6a7c 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -1,3 +1,8 @@
+/*
+ * Ftrace header.  For implementation details beyond the random comments
+ * scattered below, see: Documentation/trace/ftrace-design.txt
+ */
+
 #ifndef _LINUX_FTRACE_H
 #define _LINUX_FTRACE_H
 
-- 
1.7.1.1

