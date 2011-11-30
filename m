Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1K3T6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:58:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46897 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1K3T6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:58:12 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 21/25] dynamic_debug: handle $module.dyndbg="+mfp" boot-line args
Date: Wed, 30 Nov 2011 12:56:50 -0700
Message-Id: <1322683014-13285-22-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Handle explicit flag-arg given on boot-line, defaulting to "+p"
otherwize.  Note that the operator char is required in the flag-arg,
so these are legal, and the same (the latter being slightly odd):

  $module.dyndbg="=p"	# set p flag, clear others
  $module.dyndbg==p	# same

Note that modprobed modules will receive flag-args from the boot-line
*after* those given in /etc/modprobe.d/*.  This may be surprising;
boot-line args can alter previous flag settings, but is defensible, as
former are invocation specific, whereas latter are system-wide.
Options given on modprobe invocation are last, and correctly override
all previous flag settings.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |   11 ++++++-----
 lib/dynamic_debug.c                   |    6 ++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 8363a56..56e496a 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -250,8 +250,9 @@ lost.  Instead, a "dyndbg" module parameter can be passed:
 	  module.dyndbg=+mfp
 	  module.dyndbg	# defaults to +p
 
-	- as an ordinary module parameter via modprobe modprobe module
-	  $> modprobe module dyndbg +pmfl # defaults to +p
+	- as an ordinary module parameter via modprobe
+	  modprobe module dyndbg=+pmfl
+	  modprobe module dyndbg # defaults to +p
 
 	- or the parameter can be used permanently via modprobe.conf(.local)
 	  options module dyndbg=+pmflt
@@ -261,8 +262,8 @@ The $modname.dyndbg="value" should exclude "module $modname", as the
 $modname is taken from the param-name, and only 1 spec of each type is
 allowed.
 
-The ddebug option is not implemented as an ordinary module parameter
-and thus will not show up in /sys/module/module_name/parameters/ddebug
+The dyndbg option is not implemented as an ordinary module parameter
+and thus will not show up in /sys/module/module_name/parameters/dyndbg
 The settings can be reverted later via the sysfs interface if the
 debug messages are no longer needed:
 
@@ -272,7 +273,7 @@ $module.dyndbg="..." on boot-line works on built-in modules as well as
 those loaded by modprobe (from either early or normal userspace), and
 somewhat overlaps debug_query functionality.
 
-Modprobed modules get ddebug flags given on boot-line after those
+Modprobed modules get dyndbg flags given on boot-line after those
 given via modprobe (either explicitly, or from /etc/modprobe.d/*).
 This can surprise if boot-line arg subtracts flags.
 
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index afc9bd3..9dcbb61 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -913,7 +913,8 @@ void ddebug_module_parse_args(const char *modname, char* modargs,
 		if (verbose)
 			pr_info("Param: %s, val: %s\n", param, val);
 
-		snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s +p", modname);
+		snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s %s",
+			modname, (val ? val : "+p"));
 		ddebug_exec_queries(ddebug);
 	}
 	kfree(arg_dup_ptr);
@@ -944,7 +945,8 @@ static __init void ddebug_boot_parse_args(void)
 		if (verbose)
 			pr_info("Param: %s, val: %s\n", param, val);
 
-		snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s +p", module);
+		snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s %s",
+			module, (val ? val : "+p"));
 		ddebug_exec_queries(ddebug);
 	}
 }
-- 
1.7.7.3

