Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2KSSbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:31:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46127 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab2KSSbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:31:37 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 10/11] ARM: remove struct sys_timer suspend and resume fields
Date: Mon, 19 Nov 2012 11:31:06 -0700
Message-Id: <1353349867-28494-11-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org>
References: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

These fields duplicate e.g. struct clock_event_device's suspend and
resume fields, so remove them now that nothing is using them. The aim
is to remove all fields from struct sys_timer except .init, then replace
the ARM machine descriptor's .timer field with a .init_time function
instead, and delete struct sys_timer.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/include/asm/mach/time.h |   11 -----------
 arch/arm/kernel/time.c           |   34 ----------------------------------
 2 files changed, 45 deletions(-)

diff --git a/arch/arm/include/asm/mach/time.h b/arch/arm/include/asm/mach/time.h
index cac8d9c..d316d76 100644
--- a/arch/arm/include/asm/mach/time.h
+++ b/arch/arm/include/asm/mach/time.h
@@ -17,15 +17,6 @@
  *   Initialise the kernels jiffy timer source, claim interrupt
  *   using setup_irq.  This is called early on during initialisation
  *   while interrupts are still disabled on the local CPU.
- * - suspend
- *   Suspend the kernel jiffy timer source, if necessary.  This
- *   is called with interrupts disabled, after all normal devices
- *   have been suspended.  If no action is required, set this to
- *   NULL.
- * - resume
- *   Resume the kernel jiffy timer source, if necessary.  This
- *   is called with interrupts disabled before any normal devices
- *   are resumed.  If no action is required, set this to NULL.
  * - offset
  *   Return the timer offset in microseconds since the last timer
  *   interrupt.  Note: this must take account of any unprocessed
@@ -33,8 +24,6 @@
  */
 struct sys_timer {
 	void			(*init)(void);
-	void			(*suspend)(void);
-	void			(*resume)(void);
 };
 
 extern void timer_tick(void);
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index ea36bfa..0b51a7c 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -21,7 +21,6 @@
 #include <linux/timex.h>
 #include <linux/errno.h>
 #include <linux/profile.h>
-#include <linux/syscore_ops.h>
 #include <linux/timer.h>
 #include <linux/irq.h>
 
@@ -119,39 +118,6 @@ int __init register_persistent_clock(clock_access_fn read_boot,
 	return -EINVAL;
 }
 
-#if defined(CONFIG_PM) && !defined(CONFIG_GENERIC_CLOCKEVENTS)
-static int timer_suspend(void)
-{
-	if (system_timer->suspend)
-		system_timer->suspend();
-
-	return 0;
-}
-
-static void timer_resume(void)
-{
-	if (system_timer->resume)
-		system_timer->resume();
-}
-#else
-#define timer_suspend NULL
-#define timer_resume NULL
-#endif
-
-static struct syscore_ops timer_syscore_ops = {
-	.suspend	= timer_suspend,
-	.resume		= timer_resume,
-};
-
-static int __init timer_init_syscore_ops(void)
-{
-	register_syscore_ops(&timer_syscore_ops);
-
-	return 0;
-}
-
-device_initcall(timer_init_syscore_ops);
-
 void __init time_init(void)
 {
 	system_timer = machine_desc->timer;
-- 
1.7.10.4

