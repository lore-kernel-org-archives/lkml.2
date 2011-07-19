Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1GSSsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:48:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1GSSsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:48:00 -0400
Date: Tue, 19 Jul 2011 20:45:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [may-be-patch?] introduce MODULE_USE_UNEXPORTED()
Message-ID: <20110719184536.GA27224@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

>From time to time I need to write a module for debugging purposes,
and it is a bit annoying I can't simply use, say, put_task_struct().

Can't we do something like the simple patch below? Of course, it
is very unsafe to use kallsyms_lookup_name() by many reasons. But
it looks handy for the testing/debugging.

Yes, I am not saying this feature is terribly useful, so I agree
in advance with the "go away, we don't need this hack" nack.

Still, what do you think?

Oleg.

 include/linux/module.h |    2 ++
 include/linux/kernel.h |    1 +
 kernel/module.c        |   13 +++++++++++++
 kernel/panic.c         |    2 ++
 4 files changed, 18 insertions(+)

--- x/include/linux/module.h~MODSYM	2011-05-20 18:35:10.000000000 +0200
+++ x/include/linux/module.h	2011-07-19 19:59:22.000000000 +0200
@@ -139,6 +139,8 @@ extern struct module __this_module;
  */
 #define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
 
+#define MODULE_USE_UNEXPORTED()	MODULE_INFO(use_unexported, "")
+
 /*
  * Author(s), use "Name <email>" or just "Name", for multiple
  * authors use multiple MODULE_AUTHOR() statements/lines.
--- x/include/linux/kernel.h~MODSYM	2011-06-16 20:16:04.000000000 +0200
+++ x/include/linux/kernel.h	2011-07-19 19:59:45.000000000 +0200
@@ -361,6 +361,7 @@ extern enum system_states {
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
 #define TAINT_FIRMWARE_WORKAROUND	11
+#define TAINT_USE_UNEXPORTED		12
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
--- x/kernel/module.c~MODSYM	2011-05-24 18:51:32.000000000 +0200
+++ x/kernel/module.c	2011-07-19 20:01:08.000000000 +0200
@@ -1791,6 +1791,8 @@ static int verify_export_symbols(struct 
 	return 0;
 }
 
+static char *get_modinfo(struct load_info *info, const char *tag);
+
 /* Change all symbols so that st_value encodes the pointer directly. */
 static int simplify_symbols(struct module *mod, const struct load_info *info)
 {
@@ -1832,6 +1834,17 @@ static int simplify_symbols(struct modul
 			if (!ksym && ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
 				break;
 
+			if (!ksym && get_modinfo(info, "use_unexported")) {
+				unsigned long addr = kallsyms_lookup_name(name);
+				if (addr) {
+					sym[i].st_value = addr;
+					if (!test_taint(TAINT_USE_UNEXPORTED))
+						printk(KERN_WARNING "bla bla bla\n");
+					add_taint_module(mod, TAINT_USE_UNEXPORTED);
+					break;
+				}
+			}
+
 			printk(KERN_WARNING "%s: Unknown symbol %s (err %li)\n",
 			       mod->name, name, PTR_ERR(ksym));
 			ret = PTR_ERR(ksym) ?: -ENOENT;
--- x/kernel/panic.c~MODSYM	2011-04-06 21:33:50.000000000 +0200
+++ x/kernel/panic.c	2011-07-19 20:00:06.000000000 +0200
@@ -175,6 +175,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_WARN,			'W', ' ' },
 	{ TAINT_CRAP,			'C', ' ' },
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
+	{ TAINT_USE_UNEXPORTED,		'X', ' ' },
 };
 
 /**
@@ -192,6 +193,7 @@ static const struct tnt tnts[] = {
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
  *  'I' - Working around severe firmware bug.
+ *  'X' - Module uses unexported symbol.
  *
  *	The string is overwritten by the next call to print_tainted().
  */

