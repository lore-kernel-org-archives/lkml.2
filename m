Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2IHU4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:56:52 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:59599 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab2IHU4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:56:50 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Sep 2012 16:56:50 EDT
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 01/10] Makefile: Add option CONFIG_DISABLE_GCC_AUTOMATIC_INLINING
Date: Sat,  8 Sep 2012 17:47:50 -0300
Message-Id: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As its name suggest this option prevents gcc from auto inlining
small functions. This is very important if one wants to obtain
traces with accurate call sites.

Without this option, gcc will collapse some small functions,
even when not marked as 'inline' thus making impossible to
correlate the trace caller address to the real function it belongs.

Of course, the resultant kernel is slower and slightly smaller,
but that's not an issue if the focus is on tracing accuracy.

Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 Makefile          |    4 ++++
 lib/Kconfig.debug |   11 +++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index ddf5be9..df6045a 100644
--- a/Makefile
+++ b/Makefile
@@ -561,6 +561,10 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+ifdef CONFIG_DISABLE_GCC_AUTOMATIC_INLINING
+KBUILD_CFLAGS	+= -fno-inline-small-functions
+endif
+
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifdef CONFIG_READABLE_ASM
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2403a63..c8fd50f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1265,6 +1265,17 @@ config LATENCYTOP
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
+config DISABLE_GCC_AUTOMATIC_INLINING
+	bool "Disable gcc automatic inlining"
+	depends on TRACING
+	help
+	  This option tells gcc he's not allowed to inline functions automatically,
+	  when they are not marked as 'inline'.
+	  In turn, this enables to trace an event with an accurate call site.
+	  Of course, the resultant kernel is slower and slightly smaller.
+
+	  Select this option only if you want to trace call sites accurately.
+
 config PROVIDE_OHCI1394_DMA_INIT
 	bool "Remote debugging over FireWire early on boot"
 	depends on PCI && X86
-- 
1.7.8.6

