Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1BOOJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:09:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48187 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1BOOJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:09:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=idXZXL/4DqXBK1CsanWyHSAX2aZ/2rjpF41UF02H/6tHsdlZ6f2yWiBzZcDexc1D27
         MFpjQA7Bf6BJyO4tmKMU+2DIuFaZ7G/FFwPcERGNEeufJ3Il7pwZqIBbKZovuNkzvl3U
         mnberLdOiYJsAcJcDGXyS+CkImNkFHPuL2yis=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] debug-pagealloc: fix kconfig dependency warning
Date: Tue, 15 Feb 2011 23:10:25 +0900
Message-Id: <1297779025-2956-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kconfig dependency warning to satisfy dependencies:

warning: (PAGE_POISONING) selects DEBUG_PAGEALLOC which has unmet
direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC &&
(!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/Kconfig.debug |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index af7cfb4..8b1a477 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -1,27 +1,24 @@
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	depends on !HIBERNATION || !PPC && !SPARC
+	depends on DEBUG_KERNEL
+	depends on !HIBERNATION || ARCH_SUPPORTS_DEBUG_PAGEALLOC && !PPC && !SPARC
 	depends on !KMEMCHECK
+	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	---help---
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
 	  of memory corruption.
 
+	  For architectures which don't enable ARCH_SUPPORTS_DEBUG_PAGEALLOC,
+	  fill the pages with poison patterns after free_pages() and verify
+	  the patterns before alloc_pages().  Additionally,
+	  this option cannot be enabled in combination with hibernation as
+	  that would result in incorrect warnings of memory corruption after
+	  a resume because free pages are not saved to the suspend image.
+
 config WANT_PAGE_DEBUG_FLAGS
 	bool
 
 config PAGE_POISONING
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	depends on !HIBERNATION
-	select DEBUG_PAGEALLOC
+	bool
 	select WANT_PAGE_DEBUG_FLAGS
-	---help---
-	   Fill the pages with poison patterns after free_pages() and verify
-	   the patterns before alloc_pages(). This results in a large slowdown,
-	   but helps to find certain types of memory corruption.
-
-	   This option cannot be enabled in combination with hibernation as
-	   that would result in incorrect warnings of memory corruption after
-	   a resume because free pages are not saved to the suspend image.
-- 
1.7.4

