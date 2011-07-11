Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab1GKHts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:49:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964806Ab1GKHrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:35 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 12/21] dynamic_debug: document use of pending queries at boot-time
Date: Mon, 11 Jul 2011 01:46:47 -0600
Message-Id: <1310370416-6322-13-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add paragraph that pending-queries are checked when modules are loaded,
so debug statements can be used in module_init functions.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |   34 +++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index f959909..49b75b81 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -92,8 +92,18 @@ nullarbor:~ # echo -c 'file svcsock.c\nline 1603 +p' >
 nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
 				<debugfs>/dynamic_debug/control
 
-Commands are bounded by a write() system call.  If you want to do
-multiple commands you need to do a separate "echo" for each, like:
+Commands are bounded by a write() system call.  Subject to this limit
+(or 1024 for boot-line parameter) you can send multiple commands,
+separated by ';'
+
+foo:~ # echo "module nsc_gpio +p ; module pc8736x_gpio +p ; " \
+ "module scx200_gpio +p " > /dbg/dynamic_debug/control
+
+Multiple commands are processed independently, this allows you to send
+commands which may fail, for example if a module is not present.  The
+last failing command returns its error.
+
+Or you can do an "echo" for each, like:
 
 nullarbor:~ # echo 'file svcsock.c line 1603 +p' > /proc/dprintk ;\
 > echo 'file svcsock.c line 1563 +p' > /proc/dprintk
@@ -110,11 +120,12 @@ specifications, followed by a flags change specification.
 
 command ::= match-spec* flags-spec
 
-The match-spec's are used to choose a subset of the known dprintk()
+The match-specs are used to choose a subset of the known dprintk()
 callsites to which to apply the flags-spec.  Think of them as a query
-with implicit ANDs between each pair.  Note that an empty list of
-match-specs is possible, but is not very useful because it will not
-match any debug statement callsites.
+with implicit ANDs between each pair.  This means that multiple specs
+of a given type are nonsense; a module cannot match A and B
+simultaneously.  Note that an empty list of match-specs is legal but
+pointless, it will not match any debug statement callsites.
 
 A match specification comprises a keyword, which controls the attribute
 of the callsite to be compared, and a value to compare against.  Possible
@@ -232,13 +243,20 @@ QUERY follows the syntax described above, but must not exceed 1023
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
 
+You can also give queries for modules which are not yet loaded, but
+will be, via udev or /etc/modules.  These queries are saved to a
+pending-queries list, and are applied when the module is loaded, and
+before the module's init function is invoked.  Note that modules which
+have no debug messages do not trigger this, so queries for them will
+remain on the pending-list until reboot.
 
 Examples
 ========
-- 
1.7.4.1

