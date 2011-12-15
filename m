Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1LODZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:25:29 -0500
Received: from ozlabs.org ([203.10.76.45]:58511 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758669Ab1LODXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:23:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 10/15] module_param: make bool parameters really bool (core code)
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 15 Dec 2011 13:43:24 +1030
Message-ID: <87k45ysf1n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_param(bool) used to counter-intuitively take an int.  In
fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
trick.

It's time to remove the int/unsigned int option.  For this version
it'll simply give a warning, but it'll break next kernel version.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/init.h   |    3 ++-
 init/main.c            |    2 +-
 kernel/irq/internals.h |    2 +-
 kernel/irq/spurious.c  |    2 +-
 kernel/printk.c        |    8 ++++----
 kernel/rcutorture.c    |    4 ++--
 6 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -2,6 +2,7 @@
 #define _LINUX_INIT_H
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 
 /* These macros are used to mark some functions or 
  * initialized data (doesn't apply to uninitialized data)
@@ -156,7 +157,7 @@ void prepare_namespace(void);
 
 extern void (*late_time_init)(void);
 
-extern int initcall_debug;
+extern bool initcall_debug;
 
 #endif
   
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -654,7 +654,7 @@ static void __init do_ctors(void)
 #endif
 }
 
-int initcall_debug;
+bool initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
 static char msgbuf[64];
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -15,7 +15,7 @@
 
 #define istate core_internal_state__do_not_mess_with_it
 
-extern int noirqdebug;
+extern bool noirqdebug;
 
 /*
  * Bits used by threaded handlers:
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -325,7 +325,7 @@ void note_interrupt(unsigned int irq, st
 	desc->irqs_unhandled = 0;
 }
 
-int noirqdebug __read_mostly;
+bool noirqdebug __read_mostly;
 
 int noirqdebug_setup(char *str)
 {
diff --git a/kernel/printk.c b/kernel/printk.c
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -521,7 +521,7 @@ static void __call_console_drivers(unsig
 	}
 }
 
-static int __read_mostly ignore_loglevel;
+static bool __read_mostly ignore_loglevel;
 
 static int __init ignore_loglevel_setup(char *str)
 {
@@ -695,9 +695,9 @@ static void zap_locks(void)
 }
 
 #if defined(CONFIG_PRINTK_TIME)
-static int printk_time = 1;
+static bool printk_time = 1;
 #else
-static int printk_time = 0;
+static bool printk_time = 0;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
@@ -1099,7 +1099,7 @@ int update_console_cmdline(char *name, i
 	return -1;
 }
 
-int console_suspend_enabled = 1;
+bool console_suspend_enabled = 1;
 EXPORT_SYMBOL(console_suspend_enabled);
 
 static int __init console_suspend_disable(char *str)
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -56,8 +56,8 @@ static int nreaders = -1;	/* # reader th
 static int nfakewriters = 4;	/* # fake writer threads */
 static int stat_interval;	/* Interval between stats, in seconds. */
 				/*  Defaults to "only at end of test". */
-static int verbose;		/* Print more debug info. */
-static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
+static bool verbose;		/* Print more debug info. */
+static bool test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
 static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
 static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static int irqreader = 1;	/* RCU readers from irq (timers). */
