Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1LLXOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:14:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33902 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1LLXNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:48 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 22/25] dynamic_debug: update Documentation/*, Kconfig.debug
Date: Mon, 12 Dec 2011 16:12:48 -0700
Message-Id: <1323731569-20644-22-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

In dynamic-debug-howto.txt:

- add section: Debug Messages at Module Initialization Time
- update flags indicators in example outputs, from '-' to '=_'.
- make flags descriptions tabular
- add item on '_' flag-char
- add *.dyndbg, boot-args examples

In kernel-parameters.txt, add item on $modulename.dyndbg.

In Kconfig.debug, note that compiling with -DDEBUG enables all
pr_debug()s in that code.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |  126 ++++++++++++++++++++++++--------
 Documentation/kernel-parameters.txt   |    9 +++
 lib/Kconfig.debug                     |   17 +++--
 3 files changed, 114 insertions(+), 38 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 74e6c77..bba071d 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -2,7 +2,7 @@
 Introduction
 ============
 
-This document describes how to use the dynamic debug (ddebug) feature.
+This document describes how to use the dynamic debug (dyndbg) feature.
 
 Dynamic debug is designed to allow you to dynamically enable/disable kernel
 code to obtain additional kernel information. Currently, if
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
 
 
@@ -65,12 +65,12 @@ nullarbor:~ # grep -i rdma <debugfs>/dynamic_debug/control  | wc -l
 nullarbor:~ # grep -i tcp <debugfs>/dynamic_debug/control | wc -l
 42
 
-Note in particular that the third column shows the enabled behaviour
-flags for each debug statement callsite (see below for definitions of the
-flags).  The default value, no extra behaviour enabled, is "-".  So
-you can view all the debug statement callsites with any non-default flags:
+The third column shows the enabled behaviour flags for each debug
+statement callsite (see below for definitions of the flags).  The
+default value, no extra behaviour enabled, is "=_".  So you can view
+all the debug statement callsites with any non-default flags:
 
-nullarbor:~ # awk '$3 != "-"' <debugfs>/dynamic_debug/control
+nullarbor:~ # awk '$3 != "=_"' <debugfs>/dynamic_debug/control
 # filename:lineno [module]function flags format
 /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send p "svc_process: st_sendto returned %d\012"
 
@@ -188,34 +188,27 @@ The flags specification comprises a change operation followed
 by one or more flag characters.  The change operation is one
 of the characters:
 
--
-    remove the given flags
-
-+
-    add the given flags
-
-=
-    set the flags to the given flags
+  -    remove the given flags
+  +    add the given flags
+  =    set the flags to the given flags
 
 The flags are:
 
-f
-    Include the function name in the printed message
-l
-    Include line number in the printed message
-m
-    Include module name in the printed message
-p
-    Causes a printk() message to be emitted to dmesg
-t
-    Include thread ID in messages not generated from interrupt context
+  f    Include the function name in the printed message
+  l    Include line number in the printed message
+  m    Include module name in the printed message
+  p    Causes a printk() message to be emitted to dmesg
+  t    Include thread ID in messages not generated from interrupt context
+  _    No flags are set. (Or'd with others on input)
+
+For display, the flags are preceded by '='
+(mnemonic: what the flags are currently equal to).
 
-Note the regexp ^[-+=][flmpt]+$ matches a flags specification.
-Note also that there is no convenient syntax to remove all
-the flags at once, you need to use "-flmpt".
+Note the regexp ^[-+=][flmpt_]+$ matches a flags specification.
+To clear all flags at once, use "=_" or "-flmpt".
 
 
-Debug messages during boot process
+Debug messages during Boot Process
 ==================================
 
 To be able to activate debug messages during the boot process,
@@ -233,6 +226,56 @@ your machine (typically a laptop) has an Embedded Controller.
 PCI (or other devices) initialization also is a hot candidate for using
 this boot parameter for debugging purposes.
 
+Note: ddebug_query= works only on builtin modules, a more general
+approach follows.
+
+
+Debug Messages at Module Initialization Time
+============================================
+
+Enabling a module's debug messages via debug control file only works
+once the module is loaded; too late for callsites in init functions.
+And when module is unloaded, debug flag settings for the module are
+lost.  Instead, a "dyndbg" module parameter can be passed:
+
+1. # the parameter can be used permanently via modprobe.conf(.local)
+   options module dyndbg=+pmflt
+   options module dyndbg # defaults to +p
+
+2. # added via kernel boot parameter: (this form works on built-ins too)
+   module.dyndbg=+mfp
+   module.dyndbg	# defaults to +p
+
+3. # as an ordinary module parameter via modprobe
+   modprobe module dyndbg=+pmfl
+   modprobe module dyndbg # defaults to +p
+
+Dyndbg flags are applied in above order, with last having final say.
+This lets modprobe args supplement (dyndbg=+tfl) or override
+(dyndbg="=p_") previous settings.
+
+The $modname.dyndbg="value" must exclude "module $modname", as the
+$modname is taken from the param-name, and only 1 spec of each type is
+allowed.
+
+$module.dyndbg="..." on boot-line works on built-in modules as well as
+those loaded by modprobe (from either early or normal userspace), and
+overlaps debug_query functionality.
+
+
+*.dyndbg="+p" can be used to enable all debug callsites in builtin
+modules, or to set print-format defaults (="+mf") for those enabled
+separately.  Loadable modules are not affected by wildcard rules, only
+$module.dyndbg boot options are applied to them.
+
+The dyndbg option is not implemented as an ordinary module parameter
+and thus will not show up in /sys/module/module_name/parameters/dyndbg
+
+Any settings given at boot-time (or by -DDEBUG flag during
+compilation) can be reverted later via the sysfs interface if the
+debug messages are no longer needed:
+
+      echo "module module_name -p" > <debugfs>/dynamic_debug/control
 
 Examples
 ========
@@ -260,3 +303,22 @@ nullarbor:~ # echo -n 'func svc_process -p' >
 // enable messages for NFS calls READ, READLINK, READDIR and READDIR+.
 nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
 				<debugfs>/dynamic_debug/control
+
+// enable all messages
+nullarbor:~ # echo -n '+p' > <debugfs>/dynamic_debug/control
+
+// add module, function to all enabled messages
+nullarbor:~ # echo -n '+mf' > <debugfs>/dynamic_debug/control
+
+// boot-args example, with newlines and comments
+Kernel command line: ...
+  ddebug_query="func i2c_del_adapter +p; func tboot_probe +p"
+  dynamic_debug.verbose=1 	// see whats going on
+  nouveau.dyndbg 		// implicit =+p
+  tsc_sync.dyndbg=+p 		// builtin on my kernel
+  i2c_core.dyndbg=+p		// loaded by udev
+  *.dyndbg="+mf"		// print module, func for enabled callsites
+  				// in builtin modules
+  // multiple queries per module
+  k10temp.dyndbg="+p # comment in query is stripped "
+  pnp.dyndbg="func pnpacpi_get_resources +p; func pnp_assign_mem +p"
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
index 82928f5..0228b80 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1184,8 +1184,13 @@ config DYNAMIC_DEBUG
 	  otherwise be available at runtime. These messages can then be
 	  enabled/disabled based on various levels of scope - per source file,
 	  function, module, format string, and line number. This mechanism
-	  implicitly enables all pr_debug() and dev_dbg() calls. The impact of
-	  this compile option is a larger kernel text size of about 2%.
+	  implicitly compiles in all pr_debug() and dev_dbg() calls, which
+	  enlarges the kernel text size by about 2%.
+
+	  If a source file is compiled with DEBUG flag set, any
+	  pr_debug() calls in it are enabled by default, but can be
+	  disabled at runtime as below.  Note that DEBUG flag is
+	  turned on by many CONFIG_*DEBUG* options.
 
 	  Usage:
 
@@ -1202,16 +1207,16 @@ config DYNAMIC_DEBUG
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

