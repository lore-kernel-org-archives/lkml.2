Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab1CGViK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:38:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab1CGViI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:38:08 -0500
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, jwjstone@fastmail.fm,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/2 v2] watchdog, nmi:  Allow hardlockup to panic by default
Date: Mon,  7 Mar 2011 16:37:39 -0500
Message-Id: <1299533860-1642-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a Kconfig option to allow users to set the hardlockup to panic
by default.  Also add in a 'nmi_watchdog=nopanic' to override this.

v2:
  clean up a typo

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 Documentation/kernel-parameters.txt |    5 +++--
 kernel/watchdog.c                   |    5 ++++-
 lib/Kconfig.debug                   |   17 +++++++++++++++++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 89835a4..ae0b499 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1577,11 +1577,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: [state][,regs][,debounce][,die]
 
 	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
-			Format: [panic,][num]
+			Format: [panic,][nopanic,][num]
 			Valid num: 0
 			0 - turn nmi_watchdog off
 			When panic is specified, panic when an NMI watchdog
-			timeout occurs.
+			timeout occurs (or 'nopanic' to override the opposite
+			default).
 			This is useful when you use a panic=... timeout and
 			need the box quickly up again.
 
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 18bb157..f7c0272 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -48,12 +48,15 @@ static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
  * Should we panic when a soft-lockup or hard-lockup occurs:
  */
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
-static int hardlockup_panic;
+static int hardlockup_panic = 
+			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
 
 static int __init hardlockup_panic_setup(char *str)
 {
 	if (!strncmp(str, "panic", 5))
 		hardlockup_panic = 1;
+	else if (!strncmp(str, "nopanic", 5))
+		hardlockup_panic = 0;
 	else if (!strncmp(str, "0", 1))
 		watchdog_enabled = 0;
 	return 1;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2b97418..8769533 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -176,6 +176,23 @@ config HARDLOCKUP_DETECTOR
 	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
 		 !ARCH_HAS_NMI_WATCHDOG
 
+config BOOTPARAM_HARDLOCKUP_PANIC
+	bool "Panic (Reboot) On Hard Lockups"
+	depends on LOCKUP_DETECTOR
+	help
+	  Say Y here to enable the kernel to panic on "hard lockups",
+	  which are bugs that cause the kernel to loop in kernel
+	  mode with interrupts disabled for more than 60 seconds.
+
+	  Say N if unsure.
+
+config BOOTPARAM_HARDLOCKUP_PANIC_VALUE
+	int
+	depends on LOCKUP_DETECTOR
+	range 0 1
+	default 0 if !BOOTPARAM_HARDLOCKUP_PANIC
+	default 1 if BOOTPARAM_HARDLOCKUP_PANIC
+
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
 	depends on LOCKUP_DETECTOR
-- 
1.7.3.5

