Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab0GOPNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:13:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60029 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933421Ab0GOPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:13:10 -0400
Subject: [PATCH 2/3] kmemleak: Introduce a default off mode for kmemleak
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jason Baron <jbaron@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Date: Thu, 15 Jul 2010 16:09:07 +0100
Message-ID: <20100715150907.21793.63966.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100715150703.21793.94815.stgit@e102109-lin.cambridge.arm.com>
References: <20100715150703.21793.94815.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2010 15:09:07.0846 (UTC) FILETIME=[AC080260:01CB242F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Introduce a new DEBUG_KMEMLEAK_DEFAULT_OFF config parameter that allows
kmemleak to be disabled by default, but enabled on the command line
via: kmemleak=on. Although a reboot is required to turn it on, its still
useful to not require a re-compile.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 lib/Kconfig.debug |    7 +++++++
 mm/kmemleak.c     |   14 +++++++++++++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..95ab402 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -400,6 +400,13 @@ config DEBUG_KMEMLEAK_TEST
 
 	  If unsure, say N.
 
+config DEBUG_KMEMLEAK_DEFAULT_OFF
+	bool "Default kmemleak to off"
+	depends on DEBUG_KMEMLEAK
+	help
+	  Say Y here to disable kmemleak by default. It can then be enabled
+	  on the command line via kmemleak=on.
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && TRACE_IRQFLAGS_SUPPORT
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index c2c9feb..d33e990 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -211,6 +211,9 @@ static signed long jiffies_scan_wait;
 static int kmemleak_stack_scan = 1;
 /* protects the memory scanning, parameters and debug/kmemleak file access */
 static DEFINE_MUTEX(scan_mutex);
+/* setting kmemleak=on, will set this var, skipping the disable */
+static int kmemleak_skip_disable;
+
 
 /*
  * Early object allocation/freeing logging. Kmemleak is initialized after the
@@ -1604,7 +1607,9 @@ static int kmemleak_boot_config(char *str)
 		return -EINVAL;
 	if (strcmp(str, "off") == 0)
 		kmemleak_disable();
-	else if (strcmp(str, "on") != 0)
+	else if (strcmp(str, "on") == 0)
+		kmemleak_skip_disable = 1;
+	else
 		return -EINVAL;
 	return 0;
 }
@@ -1618,6 +1623,13 @@ void __init kmemleak_init(void)
 	int i;
 	unsigned long flags;
 
+#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
+	if (!kmemleak_skip_disable) {
+		kmemleak_disable();
+		return;
+	}
+#endif
+
 	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 

