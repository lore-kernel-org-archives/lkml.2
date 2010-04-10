Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0DJDDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 23:03:51 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:40028 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab0DJDDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 23:03:50 -0400
X-Spam-Processed: digidescorp.com, Fri, 09 Apr 2010 22:03:49 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.144.234.3
X-Return-Path: prvs=1716912bc1=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] microblaze: Quiet section mismatch warnings
Date: Fri,  9 Apr 2010 22:03:37 -0500
Message-Id: <1270868617-16551-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_start is located in .text, which causes mismatch warnings with 
machine_early_init() and start_kernel() in .init.text.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/kernel/head.S b/arch/microblaze/kernel/head.S
--- a/arch/microblaze/kernel/head.S	2010-04-09 21:52:36.000000000 -0500
+++ b/arch/microblaze/kernel/head.S	2010-04-09 21:56:26.000000000 -0500
@@ -28,6 +28,7 @@
  * for more details.
  */
 
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/thread_info.h>
 #include <asm/page.h>
@@ -49,7 +50,7 @@ swapper_pg_dir:
 
 #endif /* CONFIG_MMU */
 
-	.text
+	__HEAD
 ENTRY(_start)
 #if CONFIG_KERNEL_BASE_ADDR == 0
 	brai	TOPHYS(real_start)
diff -uprN a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
--- a/arch/microblaze/kernel/vmlinux.lds.S	2010-04-09 21:52:36.000000000 -0500
+++ b/arch/microblaze/kernel/vmlinux.lds.S	2010-04-09 21:54:58.000000000 -0500
@@ -24,7 +24,8 @@ SECTIONS {
 	.text : AT(ADDR(.text) - LOAD_OFFSET) {
 		_text = . ;
 		_stext = . ;
-		*(.text .text.*)
+		HEAD_TEXT
+		TEXT_TEXT
 		*(.fixup)
 		EXIT_TEXT
 		EXIT_CALL

