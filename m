Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1IUV5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:57:40 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:36106 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1IUV4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:44 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 23/26] dynamic_debug: document pending queries, flags-filter, multiple queries
Date: Wed, 21 Sep 2011 15:55:12 -0600
Message-Id: <1316642115-20029-24-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Rework description of flags-spec into 3 parts; flags-filter, flags-change,
flags-values.  Add section on pending-queries.  Explain flags filtering
in detail.  Reflow some paragraphs.

Add example of a command-file which shows commenting,
multiple queries per line, and describes constraints.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |  336 ++++++++++++++++++++++-----------
 1 files changed, 222 insertions(+), 114 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index f959909..bf9037f 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -4,117 +4,134 @@ Introduction
 
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
+ * Simple query language allows turning on and off debugging statements
+   by matching any combination of 0 or 1 of:
 
    - source filename
    - function name
    - line number (including ranges of line numbers)
    - module name
    - format string
+   - current debugging flags
 
- * Provides a debugfs control file: <debugfs>/dynamic_debug/control which can be
-   read to display the complete list of known debug statements, to help guide you
+ * Provides a debugfs control file: <debugfs>/dynamic_debug/control
+   which can be read to display the complete list of known debug
+   statements, to help guide you.
 
 Controlling dynamic debug Behaviour
 ===================================
 
-The behaviour of pr_debug()/dev_dbg()s are controlled via writing to a
-control file in the 'debugfs' filesystem. Thus, you must first mount the debugfs
-filesystem, in order to make use of this feature. Subsequently, we refer to the
-control file as: <debugfs>/dynamic_debug/control. For example, if you want to
-enable printing from source file 'svcsock.c', line 1603 you simply do:
+The behaviour of pr_debug()/dev_dbg()/net_dbg()s are controlled via
+writing to a control file in the 'debugfs' filesystem. Thus, you must
+first mount the debugfs filesystem, in order to make use of this
+feature.  Subsequently, we refer to mount point as $DBGFS, and the
+control file as $CONTROL.  So if you want to enable printing from
+source file 'svcsock.c', line 1603 you simply do:
 
-nullarbor:~ # echo 'file svcsock.c line 1603 +p' >
-				<debugfs>/dynamic_debug/control
+nullarbor:~ # echo file svcsock.c line 1603 +p > $CONTROL
 
 If you make a mistake with the syntax, the write will fail thus:
 
-nullarbor:~ # echo 'file svcsock.c wtf 1 +p' >
-				<debugfs>/dynamic_debug/control
+nullarbor:~ # 'echo file svcsock.c wtf 1 +p' > $CONTROL
 -bash: echo: write error: Invalid argument
 
 Viewing Dynamic Debug Behaviour
-===========================
+===============================
 
-You can view the currently configured behaviour of all the debug statements
-via:
+You can view the currently configured behaviour by catting or grepping
+the $CONTROL file:
 
-nullarbor:~ # cat <debugfs>/dynamic_debug/control
+root@voyage:~# grep freezer $CONTROL
+kernel/freezer.c:128 [freezer]cancel_freezing =_ "  clean up: %s\012"
+kernel/freezer.c:60 [freezer]refrigerator =_ "%s left refrigerator\012"
+kernel/freezer.c:41 [freezer]refrigerator =_ "%s entered refrigerator\012"
+
+The third column shows the current flag settings for each debug
+statement callsite (menmonic: what they are equal to, see below for
+definitions of the flags).  The default value, with nothing enabled,
+is "=_".  So you can view all the debug statement callsites with any
+non-default flags:
+
+nullarbor:~ # grep -v "=_" $CONTROL
 # filename:lineno [module]function flags format
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup - "SVCRDMA Module Removed, deregister RPC RDMA transport\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init - "\011max_inline       : %d\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init - "\011sq_depth         : %d\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init - "\011max_requests     : %d\012"
-...
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send =p "svc_process: st_sendto returned %d\012"
+
+
+Command Language Reference
+==========================
 
+At the lexical level, a command comprises a sequence of words separated
+by whitespace characters.
 
-You can also apply standard Unix text manipulation filters to this
-data, e.g.
+nullarbor:~# echo file svcsock.c line 1603 +p > $CONTROL
 
-nullarbor:~ # grep -i rdma <debugfs>/dynamic_debug/control  | wc -l
-62
+nullarbor:~# echo 'file svcsock.c line 1603 +p' > $CONTROL
 
-nullarbor:~ # grep -i tcp <debugfs>/dynamic_debug/control | wc -l
-42
+nullarbor:~# echo -n '  file   svcsock.c     line  1603 +p  ' > $CONTROL
 
-Note in particular that the third column shows the enabled behaviour
-flags for each debug statement callsite (see below for definitions of the
-flags).  The default value, no extra behaviour enabled, is "-".  So
-you can view all the debug statement callsites with any non-default flags:
+nullarbor:~# echo -n 'file svcsock.c line 1603 +p' > $CONTROL
 
-nullarbor:~ # awk '$3 != "-"' <debugfs>/dynamic_debug/control
-# filename:lineno [module]function flags format
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send p "svc_process: st_sendto returned %d\012"
+Multiple query/commands
+=======================
 
+Commands are bounded by a write() system call.  Subject to this limit
+(or 1024 for boot-line parameter) you can send multiple commands,
+separated by ';' or '\n'
 
-Command Language Reference
-==========================
+voyage:~# echo   "func cancel_freezing +p ; func refrigerator +p; " > $CONTROL
+voyage:~# printf "func cancel_freezing +p \n func refrigerator +p; " > $CONTROL
 
-At the lexical level, a command comprises a sequence of words separated
-by whitespace characters.  Note that newlines are treated as word
-separators and do *not* end a command or allow multiple commands to
-be done together.  So these are all equivalent:
+voyage:~# cat dyndbg-cmdfile
 
-nullarbor:~ # echo -c 'file svcsock.c line 1603 +p' >
-				<debugfs>/dynamic_debug/control
-nullarbor:~ # echo -c '  file   svcsock.c     line  1603 +p  ' >
-				<debugfs>/dynamic_debug/control
-nullarbor:~ # echo -c 'file svcsock.c\nline 1603 +p' >
-				<debugfs>/dynamic_debug/control
-nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
-				<debugfs>/dynamic_debug/control
+  # comments and blank lines ok, but cannot contain semicolon
+  # multiple cmds per line, 1st must be terminated by semicolon
+  func foo p=_	; func buzz p=_
+  func bar p=_	; func bum  p=_
+  func yak p=_	; # trailing comment, requires semicolon to terminate cmd
 
-Commands are bounded by a write() system call.  If you want to do
-multiple commands you need to do a separate "echo" for each, like:
+  # heres the oddity: semicolon terminates comment, so this works
+  func foo +p ; # comment ; func bar +p
+  # allowing this keeps parsing simple
 
-nullarbor:~ # echo 'file svcsock.c line 1603 +p' > /proc/dprintk ;\
-> echo 'file svcsock.c line 1563 +p' > /proc/dprintk
+voyage:~# cat dyndbg-cmdfile > $CONTROL
+dynamic_debug:ddebug_exec_queries: processed 7 queries, with 0 errs
+
+Multiple commands are processed independently, this allows you to send
+commands which may fail, for example if a module is not present.  The
+last failing command returns its error.
+
+Or you can do an "echo" for each, like:
+
+nullarbor:~ # echo 'file svcsock.c line 1603 +p' > $CONTROL; \
+> echo 'file svcsock.c line 1563 +p' > $CONTROL
 
 or even like:
 
 nullarbor:~ # (
 > echo 'file svcsock.c line 1603 +p' ;\
 > echo 'file svcsock.c line 1563 +p' ;\
-> ) > /proc/dprintk
+> ) > $CONTROL
 
-At the syntactical level, a command comprises a sequence of match
+Query/command syntax
+====================
+
+At the syntactic level, a command comprises a sequence of match
 specifications, followed by a flags change specification.
 
 command ::= match-spec* flags-spec
 
-The match-spec's are used to choose a subset of the known dprintk()
-callsites to which to apply the flags-spec.  Think of them as a query
-with implicit ANDs between each pair.  Note that an empty list of
-match-specs is possible, but is not very useful because it will not
-match any debug statement callsites.
+The match-specs are used to choose a subset of the known callsites to
+which to apply the flags-spec.  Think of them as a query with implicit
+ANDs between each pair.  This means that multiple specs of a given
+type are nonsense; a module cannot match A and B simultaneously.  Note
+that an empty list of match-specs matches all callsites.
 
 A match specification comprises a keyword, which controls the attribute
 of the callsite to be compared, and a value to compare against.  Possible
@@ -125,12 +142,13 @@ match-spec ::= 'func' string |
 	       'module' string |
 	       'format' string |
 	       'line' line-range
+// Note: no wildcards, regexs are accepted
 
 line-range ::= lineno |
 	       '-'lineno |
 	       lineno'-' |
 	       lineno'-'lineno
-// Note: line-range cannot contain space, e.g.
+// Note: line-range cannot contain a space, e.g.
 // "1-30" is valid range but "1 - 30" is not.
 
 lineno ::= unsigned-int
@@ -144,11 +162,12 @@ func
     func svc_tcp_accept
 
 file
-    The given string is compared against either the full
-    pathname or the basename of the source file of each
-    callsite.  Examples:
+    The given string is compared against either the full pathname,
+    relative path from kernel source dir, or the basename of the
+    source file of each callsite.  Examples:
 
     file svcsock.c
+    file kernel/freezer.c
     file /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c
 
 module
@@ -157,7 +176,7 @@ module
     seen in "lsmod", i.e. without the directory or the .ko
     suffix and with '-' changed to '_'.  Examples:
 
-    module sunrpc
+    module ide_pci_generic
     module nfsd
 
 format
@@ -190,79 +209,168 @@ line
     line -1605	    // the 1605 lines from line 1 to line 1605
     line 1600-	    // all lines from line 1600 to the end of the file
 
-The flags specification comprises a change operation followed
-by one or more flag characters.  The change operation is one
-of the characters:
-
--
-    remove the given flags
-
-+
-    add the given flags
+flags specification
+===================
 
-=
-    set the flags to the given flags
+The flags specification matches the regexp: ^[flmpta_]*[-+=][flmpta_]*$
+and has 3 parts:
 
-The flags are:
+flags filter (optional):
+    The filter precedes the operation [-+=], and constrains matching
+    to thoses callsite with given flags set.  This allows altering
+    flags on callsites with filtered flag values
 
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
+      pm+t	# add t to enabled sites which have m
+      p+t	# add t to all enabled sites, both m and !m
+      tmf-p	# disable sites with 'tmf'
+      tmf+p	# re-enable those disabled sites
 
-Note the regexp ^[-+=][flmpt]+$ matches a flags specification.
-Note also that there is no convenient syntax to remove all
-the flags at once, you need to use "-flmpt".
+flags change operation:
+    '-' remove the given flags
+    '+' add the given flags
+    '=' set the flags to the given flags
 
+The flags are:
+  'p' Causes a printk() message to be emitted to dmesg
+      other flags can thus be left on, and used in filters.
+  'm' Include module name in the printed message
+  'f' Include the function name in the printed message
+  'l' Include line number in the printed message
+  't' Include thread ID in messages not generated from interrupt context
+  'a' Also add query to pending queries, for later (re)application
+  '_' default/null flag.
+      Primarily for display, so grep "=_" can avoid " = " in format strings.
+      Also usable (but not required) to clear all flags.
+
+Pending queries
+===============
+
+Queries submitted with 'a' are applied to current callsites as above,
+but are also added to a pending list.  When a module is loaded later,
+pending queries are applied to the module in the order given.
+
+This is done before the module_init() routine is run, so pr_debug()s
+can be active during initialization.  To better support module
+debugging, pending queries remain on the list through modprobe-rmmod
+cycles.
+
+You can review currently pending queries by catting or grepping
+$DEBUFS/dynamic_debug/pending.  To simplify removal via
+cut-paste-edit, its format is similar to the query syntax:
+
+  root@voyage:~# cat /dbg/dynamic_debug/pending
+  # func file module format line flags mask
+  ...
+   func a299 line 0-0 =pa
+   func a300 line 0-0 =pa
+
+To remove a pending query, resubmit it with 'a' in filter-spec
+and zeroed flag-specs:
+
+  # a simple helper shell-function, to shorten examples
+  DBGFS=${DBGFS:=/dbg}
+  CONTROL=$DBGFS/dynamic_debug/control
+  function dbg_query() {
+        echo "$*" > $CONTROL
+        # see relevant settings, effects of the query/command
+        grep $2 $DBGFS/dynamic_debug/*
+  }
+
+  voyage:~# dbg_query module foo +apt	# original pending query
+  voyage:~# dbg_query module foo a=	# zero 'a' flag to remove query
+  voyage:~# dbg_query module foo a-a	# zero 'a', remove query
+  voyage:~# dbg_query module foo a-ap	# zero 'a', also disable callsites
+
+Deleting or altering a pending query requires an exact match on most
+of the match-spec; the same string specs must be given, but 'line 0-0'
+matches with '' and vice-versa.  The filter-spec is ignored for
+pending-list changes.
+
+  voyage:~# dbg_query module foo +apt	# add PQ-1 before each of following..
+
+  # will not remove PQ-1 (mismatch on lines)
+  voyage:~# dbg_query module foo line 100-200 ap=
+
+  # removes PQ-1 (exact match with PQ-1), disables active callsites (if any)
+  voyage:~# dbg_query module foo line 0-0 ap=
+
+  # delete PQ-1, leave callsites active (none of 'ptmfl' subtracted)
+  voyage:~# dbg_query module foo a-a
+
+  # delete PQ-1, disable callsites (all flags zeroed)
+  voyage:~# dbg_query module foo a=_
+
+  # delete PQ-1, leave callsites active (no 'm' on active callsites)
+  voyage:~# dbg_query module foo am=_
+
+  # del PQ-1, and disable callsites (-p), leaving 't'
+  voyage:~# dbg_query module foo a-ap
+
+  # del PQ-1, disable and clear callsites (-pt removes flags set by PQ-1)
+  voyage:~# dbg_query module foo a-apt
+
+  # del PQ-1, disable callsites with 'pt', leave 't'
+  voyage:~# dbg_query module foo apt-ap
+
+  # reactivate foo's callsites marked with 't' (see "flags filter" above)
+  voyage:~# dbg_query module foo t+p
+
+  # add 'm' to foo's callsites with 't', add new pending query with 'pm'
+  voyage:~# dbg_query module foo at+pm
+
+Altering a pending query ('a' in filter) will also alter the callsites
+that it applies to (subject to filter match), but changing the active
+callsites (using a query without the 'a') does not change the pending
+query that applied it.
 
 Debug messages during boot process
 ==================================
 
-To be able to activate debug messages during the boot process,
-even before userspace and debugfs exists, use the boot parameter:
-ddebug_query="QUERY"
+To be able to activate debug messages during the boot process, even
+before userspace and debugfs exists, use the boot parameter:
+ddebug_query="QUERY".
 
 QUERY follows the syntax described above, but must not exceed 1023
-characters. The enablement of debug messages is done as an arch_initcall.
-Thus you can enable debug messages in all code processed after this
+characters.  It may contain multiple commands separated by ';'
+('\n' seems to be eaten by my bootloader).
+
+The enablement of debug messages is done as an arch_initcall.  Thus
+you can enable debug messages in all code processed after this
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
-nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
-				<debugfs>/dynamic_debug/control
+nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' > $CONTROL
 
 // enable all the messages in file svcsock.c
-nullarbor:~ # echo -n 'file svcsock.c +p' >
-				<debugfs>/dynamic_debug/control
+nullarbor:~ # echo -n 'file svcsock.c +p' > $CONTROL
 
 // enable all the messages in the NFS server module
-nullarbor:~ # echo -n 'module nfsd +p' >
-				<debugfs>/dynamic_debug/control
+nullarbor:~ # echo -n 'module nfsd +p' > $CONTROL
 
 // enable all 12 messages in the function svc_process()
-nullarbor:~ # echo -n 'func svc_process +p' >
-				<debugfs>/dynamic_debug/control
+nullarbor:~ # echo -n 'func svc_process +p' > $CONTROL
 
 // disable all 12 messages in the function svc_process()
-nullarbor:~ # echo -n 'func svc_process -p' >
-				<debugfs>/dynamic_debug/control
+nullarbor:~ # echo -n 'func svc_process -p' > $CONTROL
 
 // enable messages for NFS calls READ, READLINK, READDIR and READDIR+.
-nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
-				<debugfs>/dynamic_debug/control
+nullarbor:~ # echo -n 'format "nfsd: READ" +p' > $CONTROL
+
+// send query-command file to control
+root@voyage:~# cat dyndbg-cmdfile > $CONTROL
+dynamic_debug:ddebug_proc_open: called
+dynamic_debug:ddebug_proc_write: read 500 bytes from userspace
+dynamic_debug:ddebug_exec_queries: query 0: "func foo p=_	"
+dynamic_debug:ddebug_tokenize: split into words: "func" "foo" "p=_"
+dynamic_debug:ddebug_parse_query: parsed func="foo" file="" module="" format="" lineno=0-0
+...
-- 
1.7.4.4

