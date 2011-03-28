Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1C1HwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:52:14 -0400
Received: from relay.parallels.com ([195.214.232.42]:53782 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1C1HwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:52:13 -0400
Subject: [PATCH v2 typo-fixed] initcall: add config option for compiling
 initcall_debug
To: <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 28 Mar 2011 11:51:31 +0400
Message-ID: <20110328075131.25063.93957.stgit@localhost6>
In-Reply-To: <20110327115506.14008.17733.stgit@localhost6>
References: <20110327115506.14008.17733.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds bool config option CONFIG_INITCALL_DEBUG for
compiling initcalls debuging, it on by default to keep current behaviour.

With CONFIG_INITCALL_DEBUG=n bloat-o-meter shows:

add/remove: 0/7 grow/shrink: 3/10 up/down: 88/-1448 (-1360)
function                                     old     new   delta
device_resume                                350     404     +54
__device_suspend                             331     363     +32
device_resume_noirq                          230     232      +2
kernel_init                                  355     354      -1
initcall_debug                                 4       -      -4
__param_str_initcall_debug                    15       -     -15
dpm_suspend                                  431     415     -16
syscore_suspend                              280     250     -30
syscore_shutdown                             123      93     -30
__param_initcall_debug                        32       -     -32
syscore_resume                               215     173     -42
static.initcall_debug_start                   71       -     -71
static.initcall_debug_report                 102       -    -102
legacy_resume                                129       -    -129
async_synchronize_cookie_domain              286     152    -134
legacy_suspend                               135       -    -135
async_run_entry_fn                           348     188    -160
do_one_initcall                              364     197    -167
pm_op                                        536     366    -170
pm_noirq_op                                  576     366    -210

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 Documentation/kernel-parameters.txt |    3 ++-
 include/linux/init.h                |    4 ++++
 init/main.c                         |    2 ++
 kernel/async.c                      |    4 +---
 lib/Kconfig.debug                   |    7 +++++++
 5 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c357a31..a6417e5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -970,7 +970,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	initcall_debug	[KNL] Trace initcalls as they are executed.  Useful
 			for working out where the kernel is dying during
-			startup.
+			startup. This depends on the CONFIG_INITCALL_DEBUG
+			option.
 
 	initrd=		[BOOT] Specify the location of the initial ramdisk
 
diff --git a/include/linux/init.h b/include/linux/init.h
index 577671c..e2005ab 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -156,7 +156,11 @@ void prepare_namespace(void);
 
 extern void (*late_time_init)(void);
 
+#ifdef CONFIG_INITCALL_DEBUG
 extern int initcall_debug;
+#else
+# define initcall_debug	0
+#endif
 
 #endif
   
diff --git a/init/main.c b/init/main.c
index 4a9479e..0902999 100644
--- a/init/main.c
+++ b/init/main.c
@@ -636,8 +636,10 @@ static void __init do_ctors(void)
 #endif
 }
 
+#ifdef CONFIG_INITCALL_DEBUG
 int initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
+#endif
 
 static char msgbuf[64];
 
diff --git a/kernel/async.c b/kernel/async.c
index 3d8220a..8801e1e 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -48,6 +48,7 @@ asynchronous and synchronous parts of the kernel.
 
 */
 
+#include <linux/init.h>
 #include <linux/async.h>
 #include <linux/module.h>
 #include <linux/wait.h>
@@ -77,9 +78,6 @@ static DECLARE_WAIT_QUEUE_HEAD(async_done);
 
 static atomic_t entry_count;
 
-extern int initcall_debug;
-
-
 /*
  * MUST be called with the lock held!
  */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index df9234c..f6e6c17 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -807,6 +807,13 @@ config DEBUG_CREDENTIALS
 
 	  If unsure, say N.
 
+config INITCALL_DEBUG
+	bool "Debug kernel initcalls"
+	default y
+	help
+	  This build option allows you to trace initcalls by
+	  adding "initcall_debug" to the kernel command line.
+
 #
 # Select this config option from the architecture Kconfig, if it
 # it is preferred to always offer frame pointers as a config

