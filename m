Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0GTNr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 09:47:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:58291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0GTNrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 09:47:31 -0400
Message-Id: <20100720134729.906231600@ett.arch.suse.de>
User-Agent: quilt/0.47-15.10
Date: Tue, 20 Jul 2010 15:44:49 +0200
From: trenn@suse.de
To: jbaron@redhat.com
Cc: trenn@suse.de, linux-kernel@vger.kernel.org, yehuda@hq.newdream.net
Subject: [patch 2/3] Dynamic Debug: Introduce ddebug_query= boot parameter
References: <20100720134447.983521886@ett.arch.suse.de>
Content-Disposition: inline; filename=patches.drivers/dynamic_debug_boot_param_enhance.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic debug lacks the ability to enable debug messages at boot time.
One could patch initramfs or service startup scripts to write to
/sys/../dynamic_debug/control, but this sucks.

This patch makes it possible to pass a query in the same format one can
write to /sys/../dynamic_debug/control via boot param.
When dynamic debug gets initialized, this query will automatically be
applied.


Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: jbaron@redhat.com
CC: linux-kernel@vger.kernel.org
CC: yehuda@hq.newdream.net

---
 Documentation/dynamic-debug-howto.txt |   22 +++++++++++++++++++++-
 Documentation/kernel-parameters.txt   |    7 ++++++-
 lib/dynamic_debug.c                   |   25 +++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)

Index: linux-2.6.34-master/lib/dynamic_debug.c
===================================================================
--- linux-2.6.34-master.orig/lib/dynamic_debug.c
+++ linux-2.6.34-master/lib/dynamic_debug.c
@@ -450,6 +450,19 @@ static int ddebug_exec_query(char *query
 	return 0;
 }
 
+static __initdata char ddebug_setup_string[1024];
+static __init int ddebug_setup_query(char *str)
+{
+	if (strlen(str) >= 1024) {
+		pr_warning("ddebug boot param string too large\n");
+		return 0;
+	}
+	strcpy(ddebug_setup_string, str);
+	return 1;
+}
+
+__setup("ddebug_query=", ddebug_setup_query);
+
 /*
  * File_ops->write method for <debugfs>/dynamic_debug/conrol.  Gathers the
  * command text from userspace, parses and executes it.
@@ -769,6 +782,18 @@ static int __init dynamic_debug_init(voi
 		}
 		ret = ddebug_add_module(iter_start, n, modname);
 	}
+
+	/* ddebug_query boot param got passed -> set it up */
+	if (ddebug_setup_string[0] != '\0') {
+		ret = ddebug_exec_query(ddebug_setup_string);
+		if (ret)
+			pr_warning("Invalid ddebug boot param %s",
+				   ddebug_setup_string);
+		else
+			pr_info("ddebug initialized with string %s",
+				ddebug_setup_string);
+	}
+
 out_free:
 	if (ret) {
 		ddebug_remove_all_tables();
Index: linux-2.6.34-master/Documentation/dynamic-debug-howto.txt
===================================================================
--- linux-2.6.34-master.orig/Documentation/dynamic-debug-howto.txt
+++ linux-2.6.34-master/Documentation/dynamic-debug-howto.txt
@@ -24,7 +24,7 @@ Dynamic debug has even more useful featu
    read to display the complete list of known debug statements, to help guide you
 
 Controlling dynamic debug Behaviour
-===============================
+===================================
 
 The behaviour of pr_debug()/dev_debug()s are controlled via writing to a
 control file in the 'debugfs' filesystem. Thus, you must first mount the debugfs
@@ -212,6 +212,26 @@ Note the regexp ^[-+=][scp]+$ matches a
 Note also that there is no convenient syntax to remove all
 the flags at once, you need to use "-psc".
 
+
+Debug messages during boot process
+==================================
+
+To be able to activate debug messages during the boot process,
+even before userspace and debugfs exists, use the boot parameter:
+ddebug_query="QUERY"
+
+QUERY follows the syntax described above, but must not exceed 1023
+characters. The enablement of debug messages is done as an arch_initcall.
+Thus you can enable debug messages in all code processed after this
+arch_initcall via this boot parameter.
+On an x86 system for example ACPI enablement is a subsys_initcall and
+ddebug_query="file ec.c +p"
+will show early Embedded Controller transactions during ACPI setup if
+your machine (typically a laptop) has an Embedded Controller.
+PCI (or other devices) initialization also is a hot candidate for using
+this boot parameter for debugging purposes.
+
+
 Examples
 ========
 
Index: linux-2.6.34-master/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.34-master.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.34-master/Documentation/kernel-parameters.txt
@@ -43,10 +43,11 @@ parameter is applicable:
 	AVR32	AVR32 architecture is enabled.
 	AX25	Appropriate AX.25 support is enabled.
 	BLACKFIN Blackfin architecture is enabled.
-	DRM	Direct Rendering Management support is enabled.
 	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
 	EFI	EFI Partitioning (GPT) is enabled
 	EIDE	EIDE/ATAPI support is enabled.
+	DRM	Direct Rendering Management support is enabled.
+	DYNAMIC_DEBUG Build in debug messages and enable them at runtime
 	FB	The frame buffer device is enabled.
 	GCOV	GCOV profiling is enabled.
 	HW	Appropriate hardware is enabled.
@@ -601,6 +602,10 @@ and is between 256 and 4096 characters.
 			Format: <port#>,<type>
 			See also Documentation/input/joystick-parport.txt
 
+	ddebug_query=   [KNL,DYNAMIC_DEBUG] Enable debug messages at early boot
+			time. See Documentation/dynamic-debug-howto.txt for
+			details.
+
 	debug		[KNL] Enable kernel debugging (events log level).
 
 	debug_locks_verbose=

