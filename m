Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab0GMUbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:31:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab0GMUbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:31:34 -0400
Date: Tue, 13 Jul 2010 16:31:17 -0400
From: Jason Baron <jbaron@redhat.com>
To: catalin.marinas@arm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] introduce a default off mode for kmemleak
Message-ID: <20100713203116.GA25784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kmemleak can be very useful in figuring out where a kernel leak is
suspected, but I've run into issues it which makes it hard to enable 
by default - reports false positives, oom kills on low memory systems (512 MB).
Although these can be addressed, there is still the memory footprint,
and runtime overhead, so I think it might make sense to create mode
where it is disabled by default, but can still be enabled on the command
line via: kmemleak=on.

thanks,

-Jason

Introduce a new DEBUG_KMEMLEAK_DEFAULT_OFF config parameter that allows
kmemleak to be disabled by default, but enabled on the command line via:
kmemleak=on. Although a reboot is required to turn it on, its still
useful to not require a re-compile.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/Kconfig.debug |    7 +++++++
 mm/kmemleak.c     |   26 +++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletions(-)

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
index 2c0d032..1006267 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -211,6 +211,11 @@ static signed long jiffies_scan_wait;
 static int kmemleak_stack_scan = 1;
 /* protects the memory scanning, parameters and debug/kmemleak file access */
 static DEFINE_MUTEX(scan_mutex);
+#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
+/* setting kmemleak=on, will set this var, skipping the disable */
+static int kmemleak_skip_disable;
+#endif
+
 
 /*
  * Early object allocation/freeing logging. Kmemleak is initialized after the
@@ -1600,10 +1605,22 @@ static int kmemleak_boot_config(char *str)
 {
 	if (!str)
 		return -EINVAL;
+
 	if (strcmp(str, "off") == 0)
+#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
+		return -EINVAL;
+#else
 		kmemleak_disable();
-	else if (strcmp(str, "on") != 0)
+#endif
+	else if (strcmp(str, "on") == 0)
+#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
+		kmemleak_skip_disable = 1;
+#else
+		return -EINVAL;
+#endif
+	else
 		return -EINVAL;
+
 	return 0;
 }
 early_param("kmemleak", kmemleak_boot_config);
@@ -1616,6 +1633,13 @@ void __init kmemleak_init(void)
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
 
-- 
1.7.1

