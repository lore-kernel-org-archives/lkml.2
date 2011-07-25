Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1GYVoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:44:00 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59236 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1GYVnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:55 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 23/25] dynamic_debug: document pending queries, flags-filter, multiple queries
Date: Mon, 25 Jul 2011 15:42:48 -0600
Message-Id: <1311630170-26057-24-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add section on pending-queries.  Rework flags description to include
flags-filter, rearrange docs into 3 parts for the 3 components of
the flags-spec.  Reflow some paragraphs.

Add example of a command-file which enables dynamic-debugging on
the dynamic debugging facility itself.  Example also shows commenting,
describes constraints.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |  221 ++++++++++++++++++++++-----------
 1 files changed, 147 insertions(+), 74 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index f959909..c1a4f42 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -4,15 +4,15 @@ Introduction
 
 This document describes how to use the dynamic debug (ddebug) feature.
 
-Dynamic debug is designed to allow you to dynamically enable/disable kernel
-code to obtain additional kernel information. Currently, if
-CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_dbg() calls can be
-dynamically enabled per-callsite.
+Dynamic debug is designed to allow you to dynamically enable/disable
+kernel code to obtain additional kernel information.  If kernel is
+built with CONFIG_DYNAMIC_DEBUG=y, then all pr_debug()/dev_dbg() calls
+can be dynamically enabled per-callsite.
 
 Dynamic debug has even more useful features:
 
- * Simple query language allows turning on and off debugging statements by
-   matching any combination of:
+ * Simple query language allows turning on and off debugging
+   statements by matching any combination of:
 
    - source filename
    - function name
@@ -20,25 +20,32 @@ Dynamic debug has even more useful features:
    - module name
    - format string
 
- * Provides a debugfs control file: <debugfs>/dynamic_debug/control which can be
-   read to display the complete list of known debug statements, to help guide you
+ * Provides a debugfs control file: <debugfs>/dynamic_debug/control
+   which can be read to display the complete list of known debug
+   statements, to help guide you.
 
 Controlling dynamic debug Behaviour
 ===================================
 
 The behaviour of pr_debug()/dev_dbg()s are controlled via writing to a
-control file in the 'debugfs' filesystem. Thus, you must first mount the debugfs
-filesystem, in order to make use of this feature. Subsequently, we refer to the
-control file as: <debugfs>/dynamic_debug/control. For example, if you want to
-enable printing from source file 'svcsock.c', line 1603 you simply do:
+control file in the 'debugfs' filesystem. Thus, you must first mount
+the debugfs filesystem, in order to make use of this feature.
+Subsequently, we refer to the control file as:
+$DEBUGFS/dynamic_debug/control.
 
-nullarbor:~ # echo 'file svcsock.c line 1603 +p' >
-				<debugfs>/dynamic_debug/control
+# a simple helper shell-function, to shorten examples
+function dbg_query() {
+	 echo "$*" > $DEBUGFS/dynamic_debug/control
+}
+
+For example, if you want to enable
+printing from source file 'svcsock.c', line 1603 you simply do:
+
+nullarbor:~ # dbg_query file svcsock.c line 1603 +p
 
 If you make a mistake with the syntax, the write will fail thus:
 
-nullarbor:~ # echo 'file svcsock.c wtf 1 +p' >
-				<debugfs>/dynamic_debug/control
+nullarbor:~ # dbg_query 'file svcsock.c wtf 1 +p'
 -bash: echo: write error: Invalid argument
 
 Viewing Dynamic Debug Behaviour
@@ -47,32 +54,33 @@ Viewing Dynamic Debug Behaviour
 You can view the currently configured behaviour of all the debug statements
 via:
 
-nullarbor:~ # cat <debugfs>/dynamic_debug/control
+nullarbor:~ # cat $DEBUGFS/dynamic_debug/control
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
 
 
 You can also apply standard Unix text manipulation filters to this
 data, e.g.
 
-nullarbor:~ # grep -i rdma <debugfs>/dynamic_debug/control  | wc -l
+nullarbor:~ # grep -i rdma $DEBUGFS/dynamic_debug/control  | wc -l
 62
 
-nullarbor:~ # grep -i tcp <debugfs>/dynamic_debug/control | wc -l
+nullarbor:~ # grep -i tcp $DEBUGFS/dynamic_debug/control | wc -l
 42
 
-Note in particular that the third column shows the enabled behaviour
-flags for each debug statement callsite (see below for definitions of the
-flags).  The default value, no extra behaviour enabled, is "-".  So
-you can view all the debug statement callsites with any non-default flags:
+The third column shows the current flag settings for each debug
+statement callsite (menmonic: what they equal to, see below for
+definitions of the flags).  The default value, no extra behaviour
+enabled, is "=_".  So you can view all the debug statement callsites
+with any non-default flags:
 
-nullarbor:~ # awk '$3 != "-"' <debugfs>/dynamic_debug/control
+nullarbor:~ # grep -v "=_" $DEBUGFS/dynamic_debug/control
 # filename:lineno [module]function flags format
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send p "svc_process: st_sendto returned %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send =p "svc_process: st_sendto returned %d\012"
 
 
 Command Language Reference
@@ -84,16 +92,31 @@ separators and do *not* end a command or allow multiple commands to
 be done together.  So these are all equivalent:
 
 nullarbor:~ # echo -c 'file svcsock.c line 1603 +p' >
-				<debugfs>/dynamic_debug/control
+				$DEBUGFS/dynamic_debug/control
 nullarbor:~ # echo -c '  file   svcsock.c     line  1603 +p  ' >
-				<debugfs>/dynamic_debug/control
+				$DEBUGFS/dynamic_debug/control
 nullarbor:~ # echo -c 'file svcsock.c\nline 1603 +p' >
-				<debugfs>/dynamic_debug/control
+				$DEBUGFS/dynamic_debug/control
 nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
-				<debugfs>/dynamic_debug/control
+				$DEBUGFS/dynamic_debug/control
+
+Commands are bounded by a write() system call.  Subject to this limit
+(or 1024 for boot-line parameter) you can send multiple commands,
+separated by ';' or '\n'
+
+foo:~ # echo "module nsc_gpio +p ; module pc8736x_gpio +p ; " \
+      > $DEBUGFS/dynamic_debug/control
 
-Commands are bounded by a write() system call.  If you want to do
-multiple commands you need to do a separate "echo" for each, like:
+foo:~ # cat queries
+  module nsc_gpio +p ;
+  module pc8736x_gpio +p
+foo:~ # cat queries > $DEBUGFS/dynamic_debug/control
+
+Multiple commands are processed independently, this allows you to send
+commands which may fail, for example if a module is not present.  The
+last failing command returns its error.
+
+Or you can do an "echo" for each, like:
 
 nullarbor:~ # echo 'file svcsock.c line 1603 +p' > /proc/dprintk ;\
 > echo 'file svcsock.c line 1563 +p' > /proc/dprintk
@@ -110,11 +133,12 @@ specifications, followed by a flags change specification.
 
 command ::= match-spec* flags-spec
 
-The match-spec's are used to choose a subset of the known dprintk()
+The match-specs are used to choose a subset of the known dprintk()
 callsites to which to apply the flags-spec.  Think of them as a query
-with implicit ANDs between each pair.  Note that an empty list of
-match-specs is possible, but is not very useful because it will not
-match any debug statement callsites.
+with implicit ANDs between each pair.  This means that multiple specs
+of a given type are nonsense; a module cannot match A and B
+simultaneously.  Note that an empty list of match-specs matches all
+callsites.
 
 A match specification comprises a keyword, which controls the attribute
 of the callsite to be compared, and a value to compare against.  Possible
@@ -125,6 +149,7 @@ match-spec ::= 'func' string |
 	       'module' string |
 	       'format' string |
 	       'line' line-range
+Note: no wildcards or regexs are accepted
 
 line-range ::= lineno |
 	       '-'lineno |
@@ -190,36 +215,55 @@ line
     line -1605	    // the 1605 lines from line 1 to line 1605
     line 1600-	    // all lines from line 1600 to the end of the file
 
-The flags specification comprises a change operation followed
-by one or more flag characters.  The change operation is one
-of the characters:
-
--
-    remove the given flags
+The flags specification matches the regexp: ^[flmpta_]*[-+=][flmpta_]*$
+and has 3 parts:
 
-+
-    add the given flags
+flags filter (optional):
+    Constrains matching to thoses callsite with given flags set,
+    allows altering currently enabled callsites.
+      #> dbg_query pm+t		# add t to enabled sites which have m
+      #> dbg_query p+t		# add t to all enabled sites, both m and !m
+      #> dbg_query tmf-p	# disable sites with 'tmf'
+      #> dbg_query tmf+p	# re-enable those disabled sites
 
-=
-    set the flags to the given flags
+flags change operation:
+    '-' remove the given flags
+    '+' add the given flags
+    '=' set the flags to the given flags
 
 The flags are:
-
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
-
-Note the regexp ^[-+=][flmpt]+$ matches a flags specification.
-Note also that there is no convenient syntax to remove all
-the flags at once, you need to use "-flmpt".
-
+  'f'  Include the function name in the printed message
+  'l'  Include line number in the printed message
+  'm'  Include module name in the printed message
+  'p'  Causes a printk() message to be emitted to dmesg
+  't'  Include thread ID in messages not generated from interrupt context
+  'a'  Add query to pending queries if not directly applicable
+  '_'  default/null flag.
+       Primarily for display, so grep "=_" can avoid " = " in format strings.
+       Also usable (but not required) to clear all flags.
+
+Pending queries
+===============
+
+Queries submitted with 'a' are added to a pending list IFF they don't
+match against current callsites.  This allows you to add queries for
+modules before they're loaded, which enables pr_debug()s used in
+initialization.  To better support module debugging, pending queries
+remain on the list through modprobe-rmmod cycles.  To remove a pending query, resubmit it with zeroed flags:
+
+#> dbg_query module foo +apt	# original pending query
+#> dbg_query module foo a=	# zero pending query to remove
+#> dbg_query module foo a-a	# also zeros, removes
+#> dbg_query module foo a-ap	# zeros already 0-flag, removes
+
+There are a few subtleties; removing or altering a pending query
+requires an exact match on the query-spec, but not on the flags
+filter.  So 2nd query does not clear 1st.
+
+#> dbg_query module foo line 100-200 +ap
+#> dbg_query module foo ap=
+
+TBR. some issues remain..
 
 Debug messages during boot process
 ==================================
@@ -232,37 +276,66 @@ QUERY follows the syntax described above, but must not exceed 1023
 characters. The enablement of debug messages is done as an arch_initcall.
 Thus you can enable debug messages in all code processed after this
 arch_initcall via this boot parameter.
-On an x86 system for example ACPI enablement is a subsys_initcall and
-ddebug_query="file ec.c +p"
+
+On an x86 system for example ACPI enablement is a subsys_initcall, so
+  ddebug_query="file ec.c +p"
 will show early Embedded Controller transactions during ACPI setup if
 your machine (typically a laptop) has an Embedded Controller.
 PCI (or other devices) initialization also is a hot candidate for using
 this boot parameter for debugging purposes.
 
-
 Examples
 ========
 
 // enable the message at line 1603 of file svcsock.c
 nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
-				<debugfs>/dynamic_debug/control
+				$DEBUGFS/dynamic_debug/control
 
 // enable all the messages in file svcsock.c
 nullarbor:~ # echo -n 'file svcsock.c +p' >
-				<debugfs>/dynamic_debug/control
+				$DEBUGFS/dynamic_debug/control
 
 // enable all the messages in the NFS server module
 nullarbor:~ # echo -n 'module nfsd +p' >
-				<debugfs>/dynamic_debug/control
+				$DEBUGFS/dynamic_debug/control
 
 // enable all 12 messages in the function svc_process()
 nullarbor:~ # echo -n 'func svc_process +p' >
-				<debugfs>/dynamic_debug/control
+				$DEBUGFS/dynamic_debug/control
 
 // disable all 12 messages in the function svc_process()
 nullarbor:~ # echo -n 'func svc_process -p' >
-				<debugfs>/dynamic_debug/control
+				$DEBUGFS/dynamic_debug/control
 
 // enable messages for NFS calls READ, READLINK, READDIR and READDIR+.
 nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
-				<debugfs>/dynamic_debug/control
+				$DEBUGFS/dynamic_debug/control
+
+// enable dynamic-debugging on dynamic-debugging facility
+root@voyage:~# cat debugfs-file
+
+  # blank lines ok
+  module dynamic_debug +p		; # turn on self-debugging
+  # these are quite noisy when grepping
+  # $DEBUGFS/dynamic_debug/{control,pending}
+    # silence them (also, leading spaces allowed in comments)
+  func ddebug_proc_show -p
+  func ddebug_proc_next -p	; # trailing comments need cmd terminator
+  func pending_proc_show -p
+  func pending_proc_next -p
+
+root@voyage:~# cat debugfs-file > /dbg/dynamic_debug/control
+split into words: "module" "dynamic_debug" "+p"
+changed $srcroot/lib/dynamic_debug.c:223 [dynamic_debug]ddebug_change =p
+changed $srcroot/lib/dynamic_debug.c:576 [dynamic_debug]ddebug_save_pending =p
+....
+nfound 23 on func="" file="" module="dynamic_debug" format="" lineno=0-0
+query 1: "func ddebug_proc_show -p	"
+split into words: "func" "ddebug_proc_show" "-p"
+parsed func="ddebug_proc_show" file="" module="" format="" lineno=0-0
+filter=0x0 op='-' flags=0x1 *flagsp=0x0 *maskp=0xfffffffe
+changed $srcroot/lib/dynamic_debug.c:881 [dynamic_debug]ddebug_proc_show =_
+nfound 1 on func="ddebug_proc_show" file="" module="" format="" lineno=0-0
+query 2: "func ddebug_proc_next -p"
+...
+
-- 
1.7.4.1

