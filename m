Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1HQPr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 11:47:56 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:29012 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1HQPrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 11:47:53 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Aug 2011 11:47:53 EDT
From: "Cisneros, Jorge (George)" <jorge.cisneros@hp.com>
To: "syslinux@zytor.com" <syslinux@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [patch 1/1] syslinux: add suport for com32 entries in the menu
Thread-Topic: [patch 1/1] syslinux: add suport for com32 entries in the menu
Thread-Index: Acxc85sUEgDKrJtJQgOYruVm3pB89Q==
Date: Wed, 17 Aug 2011 15:37:46 +0000
Message-ID: <E78CE97B1F363A40BABB9C077B911FB001B50F@G9W0339.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jorge D Cisneros <jorge.cisneros@hp.com>

Problem: The actual code only check for entries with kernel or linux, so this example will not work, this patch is to add support to gfxboot to detect the entry COM32 and use  any module, in this case the module is chain.c32
Version: Syslinux 4.04

Example:
UI gfxboot.c32

LABEL boot_hd0
MENU LABEL Boot from first hard drive
COM32 chain.c32
APPEND hd0

Signed-off-by: Jorge D Cisneros <jorge.cisneros@hp.com>

--

--- com32/gfxboot/gfxboot.c.orig        2011-08-17 10:04:44.000000000 -0500
+++ com32/gfxboot/gfxboot.c     2011-08-17 10:07:34.000000000 -0500
@@ -125,6 +125,7 @@ typedef struct menu_s {
   char *alt_kernel;    // alternative name in case user has replaced it
   char *linux;         // de facto an alias for 'kernel'
   char *localboot;     // boot from local disk
+  char *com32;         // boot other com32 modules
   char *initrd;                // initrd as separate line (instead of as part of 'append')
   char *append;                // kernel args
   char *ipappend;      // append special pxelinux args (see doc)
@@ -374,6 +375,11 @@ int read_config_file(const char *filenam
       continue;
     }

+    if(!strcasecmp(s, "com32") && menu_ptr) {
+      menu_ptr->com32 = strdup(t);
+      continue;
+    }
+
     if(!strcasecmp(s, "initrd") && menu_ptr) {
       menu_ptr->initrd = strdup(t);
       continue;
@@ -866,7 +872,13 @@ void boot_entry(menu_t *menu_ptr, char *
   if(menu_ptr->localboot) {
     gfx_done();
     syslinux_local_boot(strtol(menu_ptr->localboot, NULL, 0));
+    return;
+  }

+  if(menu_ptr->com32) {
+    gfx_done();
+    asprintf(&cmd_buf, "%s %s", menu_ptr->com32, arg);
+    syslinux_run_command(cmd_buf);
     return;
   }

