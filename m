Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0K2WIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:08:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab0K2WH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:07:56 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: fweisbec@gmail.com, gorcunov@openvz.org, yinghai@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/2] lockup detector:  Compile fixes from removing the old x86 nmi watchdog
Date: Mon, 29 Nov 2010 17:07:16 -0500
Message-Id: <1291068437-5331-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1291068437-5331-1-git-send-email-dzickus@redhat.com>
References: <1291068437-5331-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My patch that removed the old x86 nmi watchdog broke other arches.  This
change reverts a piece of that patch and puts the change in the correct spot.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |    9 ++++++++-
 include/linux/nmi.h           |    4 +++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a0e71cb..d13081e 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -24,11 +24,18 @@ u64 hw_nmi_get_sample_period(void)
 }
 #endif
 
+#ifndef CONFIG_HARDLOCKUP_DETECTOR
+void touch_nmi_watchdog(void)
+{
+	touch_softlockup_watchdog();
+}
+EXPORT_SYMBOL(touch_nmi_watchdog);
+#endif
 
+#ifdef arch_trigger_all_cpu_backtrace
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 
-#ifdef arch_trigger_all_cpu_backtrace
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 1c451e6..17ccf44 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -16,7 +16,8 @@
  */
 #ifdef ARCH_HAS_NMI_WATCHDOG
 #include <asm/nmi.h>
-#endif
+extern void touch_nmi_watchdog(void);
+#else
 #ifndef CONFIG_HARDLOCKUP_DETECTOR
 static inline void touch_nmi_watchdog(void)
 {
@@ -25,6 +26,7 @@ static inline void touch_nmi_watchdog(void)
 #else
 extern void touch_nmi_watchdog(void);
 #endif
+#endif
 
 /*
  * Create trigger_all_cpu_backtrace() out of the arch-provided
-- 
1.7.3.2

