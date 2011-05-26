Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1EZJUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:20:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26277 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab1EZJUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:20:34 -0400
Date: Thu, 26 May 2011 11:12:53 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-watchdog@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Robert Richter <robert.richter@amd.com>,
        Donald Johnson <donald.k.johnson@intel.com>
Subject: [PATCH] Intel SCU Watchdog: Fix build failure and duplicate
 include
Message-ID: <alpine.LNX.2.00.1105261057130.17400@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1577101167-1306401173=:17400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1577101167-1306401173=:17400
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Trying to build the Intel SCU Watchdog fails for me with gcc 4.6.0 -
$ gcc --version | head -n 1
gcc (GCC) 4.6.0 20110513 (prerelease)

like this :
  CC      drivers/watchdog/intel_scu_watchdog.o
In file included from drivers/watchdog/intel_scu_watchdog.c:49:0:
/home/jj/src/linux-2.6/arch/x86/include/asm/apb_timer.h: In function ¡apbt_time_init¢:
/home/jj/src/linux-2.6/arch/x86/include/asm/apb_timer.h:65:42: warning: ¡return¢ with a value, in function returning void [enabled by default]
drivers/watchdog/intel_scu_watchdog.c: In function ¡intel_scu_watchdog_init¢:
drivers/watchdog/intel_scu_watchdog.c:468:2: error: implicit declaration of function ¡sfi_get_mtmr¢ [-Werror=implicit-function-declaration]
drivers/watchdog/intel_scu_watchdog.c:468:32: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors

make[1]: *** [drivers/watchdog/intel_scu_watchdog.o] Error 1
make: *** [drivers/watchdog/intel_scu_watchdog.o] Error 2

Additionally, linux/types.h is needlessly being included twice in 
drivers/watchdog/intel_scu_watchdog.c

This patch fixes it all and I can now build the code.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/x86/include/asm/apb_timer.h      |    2 +-
 drivers/watchdog/intel_scu_watchdog.c |    1 -
 drivers/watchdog/intel_scu_watchdog.h |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

 Patch has been compile tested only.

diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
index 2fefa50..af60d8a 100644
--- a/arch/x86/include/asm/apb_timer.h
+++ b/arch/x86/include/asm/apb_timer.h
@@ -62,7 +62,7 @@ extern int sfi_mtimer_num;
 #else /* CONFIG_APB_TIMER */
 
 static inline unsigned long apbt_quick_calibrate(void) {return 0; }
-static inline void apbt_time_init(void) {return 0; }
+static inline void apbt_time_init(void) { }
 
 #endif
 #endif /* ASM_X86_APBT_H */
diff --git a/drivers/watchdog/intel_scu_watchdog.c b/drivers/watchdog/intel_scu_watchdog.c
index 919bdd1..ba43860 100644
--- a/drivers/watchdog/intel_scu_watchdog.c
+++ b/drivers/watchdog/intel_scu_watchdog.c
@@ -42,7 +42,6 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/sfi.h>
-#include <linux/types.h>
 #include <asm/irq.h>
 #include <asm/atomic.h>
 #include <asm/intel_scu_ipc.h>
diff --git a/drivers/watchdog/intel_scu_watchdog.h b/drivers/watchdog/intel_scu_watchdog.h
index d2b074a..a9ca0d7 100644
--- a/drivers/watchdog/intel_scu_watchdog.h
+++ b/drivers/watchdog/intel_scu_watchdog.h
@@ -62,5 +62,5 @@ struct intel_scu_watchdog_dev {
 
 extern int sfi_mtimer_num;
 
-/* extern struct sfi_timer_table_entry *sfi_get_mtmr(int hint); */
+extern struct sfi_timer_table_entry *sfi_get_mtmr(int hint);
 #endif /* __INTEL_SCU_WATCHDOG_H */


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1577101167-1306401173=:17400--
