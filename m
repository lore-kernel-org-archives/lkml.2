Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1LFTNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:13:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1LFTNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:13:11 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 23/25] dynamic_debug: update Documentation/kernel-parameters.txt, Kconfig.debug
Date: Tue,  6 Dec 2011 12:11:33 -0700
Message-Id: <1323198694-7186-24-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

In kernel-parameters.txt:

- update flags indicators in example output, from '-' to '=_'.
- add sentence on _ flag-char
- more info in Module Initialization section
  $module.dyndbg, *.dyndbg

In Kconfig.debug, note enabled-by-default effect of -DDEBUG
compilation.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |   52 ++++++++++++++++++++++-----------
 Documentation/kernel-parameters.txt   |    9 ++++++
 lib/Kconfig.debug                     |   15 ++++++----
 3 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 56e496a..2a9da50 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -49,10 +49,10 @@ via:
 
 nullarbor:~ # cat <debugfs>/dynamic_debug/control
 # filename:lineno [module]function flags format
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup - "SVCRDMA Module Removed, deregister RPC RDMA transport\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init - "\011max_inline       : %d\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init - "\011sq_depth         : %d\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init - "\011max_requests     : %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup =_ "SVCRDMA Module Removed, deregister RPC RDMA transport\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init =_ "\011max_inline       : %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init =_ "\011sq_depth         : %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init =_ "\011max_requests     : %d\012"
 ...
 
 
@@ -70,7 +70,7 @@ flags for each debug statement callsite (see below for definitions of the
 flags).  The default value, no extra behaviour enabled, is "-".  So
 you can view all the debug statement callsites with any non-default flags:
 
-nullarbor:~ # awk '$3 != "-"' <debugfs>/dynamic_debug/control
+nullarbor:~ # awk '$3 != "=_"' <debugfs>/dynamic_debug/control
 # filename:lineno [module]function flags format
 /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send p "svc_process: st_sendto returned %d\012"
 
@@ -213,10 +213,11 @@ p
     Causes a printk() message to be emitted to dmesg
 t
     Include thread ID in messages not generated from interrupt context
+_
+    No flags are set
 
-Note the regexp ^[-+=][flmpt]+$ matches a flags specification.
-Note also that there is no convenient syntax to remove all
-the flags at once, you need to use "-flmpt".
+Note the regexp ^[-+=][flmpt_]+$ matches a flags specification.
+To clear all flags at once, use "=_" or "-flmpt".
 
 
 Debug messages during Boot Process
@@ -237,6 +238,8 @@ your machine (typically a laptop) has an Embedded Controller.
 PCI (or other devices) initialization also is a hot candidate for using
 this boot parameter for debugging purposes.
 
+Note: ddebug_query= is supplanted by the feature in the next section,
+and will be deprecated later.
 
 Debug Messages at Module Initialization Time
 ============================================
@@ -258,10 +261,16 @@ lost.  Instead, a "dyndbg" module parameter can be passed:
 	  options module dyndbg=+pmflt
 	  options module dyndbg # defaults to +p
 
-The $modname.dyndbg="value" should exclude "module $modname", as the
+The $modname.dyndbg="value" must exclude "module $modname", as the
 $modname is taken from the param-name, and only 1 spec of each type is
 allowed.
 
+*.dyndbg="+p" can be used to enable all builtin (only) debug
+callsites, or to set print-format defaults (="+mf") for those enabled
+separately.  Loadable modules are not affected by wildcard rules, the
+module loader selects only boot options whose module name matches that
+being loaded.
+
 The dyndbg option is not implemented as an ordinary module parameter
 and thus will not show up in /sys/module/module_name/parameters/dyndbg
 The settings can be reverted later via the sysfs interface if the
@@ -273,9 +282,12 @@ $module.dyndbg="..." on boot-line works on built-in modules as well as
 those loaded by modprobe (from either early or normal userspace), and
 somewhat overlaps debug_query functionality.
 
-Modprobed modules get dyndbg flags given on boot-line after those
-given via modprobe (either explicitly, or from /etc/modprobe.d/*).
-This can surprise if boot-line arg subtracts flags.
+When a module is loaded, dyndbg flags are applied in following order,
+with last having final say:
+
+  - as given in /etc/modprobe.d/*	system-wide settings
+  - as given on boot-line		kernel, boot-time specific
+  - as given in modprobe command	explicit at load
 
 Examples
 ========
@@ -304,13 +316,19 @@ nullarbor:~ # echo -n 'func svc_process -p' >
 nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
 				<debugfs>/dynamic_debug/control
 
+// enable all messages
+nullarbor:~ # echo -n '+p' > <debugfs>/dynamic_debug/control
+
+// add module, function to all enabled messages
+nullarbor:~ # echo -n '+mf' > <debugfs>/dynamic_debug/control
+
 // boot-args example, with newlines and comments
 Kernel command line: ... 
   ddebug_query="func i2c_del_adapter +p; func tboot_probe +p"
-  dynamic_debug.verbose=1 		// see whats going on
-  nouveau.dyndbg 			// implicit =+p
-  tsc_sync.dyndbg=+p 			// builtin on my kernel
-  i2c_core.dyndbg=+p			// loaded by udev
-  *.dyndbg="=_"				// wildcard applies to builtins
+  dynamic_debug.verbose=1 	// see whats going on
+  nouveau.dyndbg 		// implicit =+p
+  tsc_sync.dyndbg=+p 		// builtin on my kernel
+  i2c_core.dyndbg=+p		// loaded by udev
+  *.dyndbg="+mf"		// print module, function for enabled sites
   k10temp.dyndbg="+p # comment in query is stripped "
   pnp.dyndbg="func pnpacpi_get_resources +p; func pnp_assign_mem +p" # multi
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 81c27b1..387443d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -691,6 +691,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	dscc4.setup=	[NET]
 
+	$modulename.dyndbg[=string]
+			[KNL,DYNAMIC_DEBUG] Enable debug messages in
+		        $modulename for builtin or loadable modules.  Debug
+		        during module initialization is supported.
+		        These parameters are not exposed in
+		        /sys/module/${modnm}/parameters/dyndbg.
+			See Documentation/dynamic-debug-howto.txt for
+			details of allowed strings, etc.
+
 	earlycon=	[KNL] Output early console device and options.
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 82928f5..f6fbd92 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1184,8 +1184,11 @@ config DYNAMIC_DEBUG
 	  otherwise be available at runtime. These messages can then be
 	  enabled/disabled based on various levels of scope - per source file,
 	  function, module, format string, and line number. This mechanism
-	  implicitly enables all pr_debug() and dev_dbg() calls. The impact of
-	  this compile option is a larger kernel text size of about 2%.
+	  implicitly compiles in all pr_debug() and dev_dbg() calls, which
+	  enlarges the kernel text size by about 2%.
+
+	  If a source file is compiled with DEBUG flag set, any pr_debug()
+	  calls in it are enabled by default, but can be disabled as below.
 
 	  Usage:
 
@@ -1202,16 +1205,16 @@ config DYNAMIC_DEBUG
 	  lineno : line number of the debug statement
 	  module : module that contains the debug statement
 	  function : function that contains the debug statement
-          flags : 'p' means the line is turned 'on' for printing
+          flags : '=p' means the line is turned 'on' for printing
           format : the format used for the debug statement
 
 	  From a live system:
 
 		nullarbor:~ # cat <debugfs>/dynamic_debug/control
 		# filename:lineno [module]function flags format
-		fs/aio.c:222 [aio]__put_ioctx - "__put_ioctx:\040freeing\040%p\012"
-		fs/aio.c:248 [aio]ioctx_alloc - "ENOMEM:\040nr_events\040too\040high\012"
-		fs/aio.c:1770 [aio]sys_io_cancel - "calling\040cancel\012"
+		fs/aio.c:222 [aio]__put_ioctx =_ "__put_ioctx:\040freeing\040%p\012"
+		fs/aio.c:248 [aio]ioctx_alloc =_ "ENOMEM:\040nr_events\040too\040high\012"
+		fs/aio.c:1770 [aio]sys_io_cancel =_ "calling\040cancel\012"
 
 	  Example usage:
 
-- 
1.7.7.3

