Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0GZNkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 09:40:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab0GZNkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 09:40:24 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] Dynamic Debug: Introduce global fake module param module.ddebug
Date: Mon, 26 Jul 2010 15:42:32 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: yehuda@hq.newdream.net, LKML <linux-kernel@vger.kernel.org>
References: <201007261414.30718.trenn@suse.de>
In-Reply-To: <201007261414.30718.trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261542.32811.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 July 2010 14:14:30 Thomas Renninger wrote:
> This patch is based on 2.6.35-rc5 + this patchset I posted recently:                                                           
> [patch 0/3] Dynamic Debug providing early boot debug messages via boot parameter
> 
> It would be great to see these getting merged into 2.6.36...
and this time with some Documentation added...
Please use this patch instead of my first post.

Thanks,

         Thomas

----------

Dynamic Debug: Introduce global fake module param module.ddebug

Dynamic Debug allows enabling of pr_debug or KERN_DEBUG messages at runtime.
This is controlled via /sys/kernel/debug/dynamic_debug/control.
One major drawback is that the whole initialization of a module cannot be
tracked, because ddebug is only aware of debug strings of loaded modules.
But this is the most interesting part...

This patch introduces a fake module parameter module.ddebug(not shown in
/sys/module/*/parameters, thus it does not use any resources/memory).

If a module passes ddebug as a module parameter (e.g. via module.ddebug
kernel boot param or via "modprobe module ddebug"), all debug strings of this
module get activated by issuing "module module_name +p" internally
(not via sysfs) when the module gets loaded.

Possible enhancements for the future if ddebug might get extended with
further flags:
module.ddebug=flags
Then module.ddebug="p" would be the same as module.ddebug, but if there
is a "x" ddebug flag added, one could pass:
module.ddebug="xp"
which would result in such a dynamic debug query:
module module_name +xp

One not handled side-effect of this patch:
Modules must not use "ddebug" module parameter or it will get ignored.
I tried to find a compile time check, but I could not see how that
is possible. Possibly a run-time check or at least documentation (where?)
should get added, that "ddebug" must not get used as a module parameter.

Tested with:
options hp-wmi ddebug
in modprobe.conf
-> works and pr_debug messages issued at module initialization time show
up. Also "p" flag gets set for the whole hp-wmi module:
grep hp-wmi /sys/../dynamic_debug/control

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 Documentation/dynamic-debug-howto.txt |   28 +++++++++++++++++++++++++++-
 include/linux/dynamic_debug.h         |    5 +++++
 kernel/params.c                       |    9 ++++++++-
 lib/dynamic_debug.c                   |    2 +-
 4 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 58ea64a..ebbbbdd 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -213,7 +213,7 @@ Note also that there is no convenient syntax to remove all
 the flags at once, you need to use "-psc".
 
 
-Debug messages during boot process
+Debug Messages during Boot Process
 ==================================
 
 To be able to activate debug messages during the boot process,
@@ -232,6 +232,32 @@ PCI (or other devices) initialization also is a hot candidate for using
 this boot parameter for debugging purposes.
 
 
+Debug Messages at Module Initialization Time
+============================================
+
+Enabling debug messages inside a module is only possible if the module itself
+is loaded already. If you unload a module, the dynamic debug flags associated
+to its debug messages are lost.
+Therefore, enabling debug messages that get processed at module initialization
+time through the <debugfs>/dynamic_debug/control interface is not possible.
+Instead, a "ddebug" module paramter can be passed:
+
+	- via kernel boot parameter:
+	  module.ddebug
+
+	- as an ordinary module parameter via modprobe
+	  modprobe module ddebug
+
+	- or the parameter can be used permanently via modprobe.conf(.local)
+	  options module ddebug
+
+The ddebug option is not implemented as an ordinary module parameter and thus
+will not show up in /sys/module/module_name/parameters/ddebug
+The settings can get reverted through the sysfs interface again when the
+module got loaded as soon as debug messages are not needed anymore:
+echo "module module_name -p" > <debugfs>/dynamic_debug/control
+as described in the "Command Language Reference" chapter above.
+
 Examples
 ========
 
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 52c0da4..095adf6 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -41,6 +41,7 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 
 #if defined(CONFIG_DYNAMIC_DEBUG)
 extern int ddebug_remove_module(const char *mod_name);
+extern int ddebug_exec_query(char *query_string);
 
 #define __dynamic_dbg_enabled(dd)  ({	     \
 	int __ret = 0;							     \
@@ -77,6 +78,10 @@ static inline int ddebug_remove_module(const char *mod)
 {
 	return 0;
 }
+static inline int ddebug_exec_query(char *query_string)
+{
+	return 0;
+}
 
 #define dynamic_pr_debug(fmt, ...)					\
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
diff --git a/kernel/params.c b/kernel/params.c
index 0b30ecd..85d58e9 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/dynamic_debug.h>
 
 #if 0
 #define DEBUGP printk
@@ -132,7 +133,7 @@ int parse_args(const char *name,
 	       unsigned num,
 	       int (*unknown)(char *param, char *val))
 {
-	char *param, *val;
+	char *param, *val, ddebug[1024];
 
 	DEBUGP("Parsing ARGS: %s\n", args);
 
@@ -144,6 +145,12 @@ int parse_args(const char *name,
 		int irq_was_disabled;
 
 		args = next_arg(args, &param, &val);
+		if (parameq(param, "ddebug")) {
+			sprintf(ddebug, "module %s +p", name);
+			ddebug_exec_query(ddebug);
+			continue;
+		}
+
 		irq_was_disabled = irqs_disabled();
 		ret = parse_one(param, val, params, num, unknown);
 		if (irq_was_disabled && !irqs_disabled()) {
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index a687d90..7f8ba5f 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -429,7 +429,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
-static int ddebug_exec_query(char *query_string)
+int ddebug_exec_query(char *query_string)
 {
 	unsigned int flags = 0, mask = 0;
 	struct ddebug_query query;
