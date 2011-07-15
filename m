Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1GOEZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 00:25:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:59432 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab1GOEZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 00:25:25 -0400
Date: Fri, 15 Jul 2011 04:25:09 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-574c44fa8fa6262ffd5939789ef51a6e98ed62d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, johnstul@us.ibm.com, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        clemens@ladisch.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, johnstul@us.ibm.com, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        clemens@ladisch.de
In-Reply-To: <d31de0ee0842a0e322fb6441571c2b0adb323fa2.1310563276.git.luto@mit.edu>
References: <d31de0ee0842a0e322fb6441571c2b0adb323fa2.1310563276.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] ia64: Replace clocksource.fsys_mmio with generic arch data
Git-Commit-ID: 574c44fa8fa6262ffd5939789ef51a6e98ed62d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jul 2011 04:25:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  574c44fa8fa6262ffd5939789ef51a6e98ed62d7
Gitweb:     http://git.kernel.org/tip/574c44fa8fa6262ffd5939789ef51a6e98ed62d7
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Wed, 13 Jul 2011 09:24:15 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 17:57:09 -0700

ia64: Replace clocksource.fsys_mmio with generic arch data

Now that clocksource.archdata is available, use it for ia64-specific
code.

Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-ia64@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/d31de0ee0842a0e322fb6441571c2b0adb323fa2.1310563276.git.luto@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/ia64/include/asm/clocksource.h |   12 ++++++++++++
 arch/ia64/kernel/cyclone.c          |    2 +-
 arch/ia64/kernel/time.c             |    2 +-
 arch/ia64/sn/kernel/sn2/timer.c     |    2 +-
 drivers/char/hpet.c                 |    2 +-
 include/linux/clocksource.h         |    7 -------
 6 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/include/asm/clocksource.h b/arch/ia64/include/asm/clocksource.h
new file mode 100644
index 0000000..00eb549
--- /dev/null
+++ b/arch/ia64/include/asm/clocksource.h
@@ -0,0 +1,12 @@
+/* IA64-specific clocksource additions */
+
+#ifndef _ASM_IA64_CLOCKSOURCE_H
+#define _ASM_IA64_CLOCKSOURCE_H
+
+#define __ARCH_HAS_CLOCKSOURCE_DATA
+
+struct arch_clocksource_data {
+	void *fsys_mmio;        /* used by fsyscall asm code */
+};
+
+#endif /* _ASM_IA64_CLOCKSOURCE_H */
diff --git a/arch/ia64/kernel/cyclone.c b/arch/ia64/kernel/cyclone.c
index f64097b..4826ff9 100644
--- a/arch/ia64/kernel/cyclone.c
+++ b/arch/ia64/kernel/cyclone.c
@@ -115,7 +115,7 @@ int __init init_cyclone_clock(void)
 	}
 	/* initialize last tick */
 	cyclone_mc = cyclone_timer;
-	clocksource_cyclone.fsys_mmio = cyclone_timer;
+	clocksource_cyclone.archdata.fsys_mmio = cyclone_timer;
 	clocksource_register_hz(&clocksource_cyclone, CYCLONE_TIMER_FREQ);
 
 	return 0;
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 85118df..43920de 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -468,7 +468,7 @@ void update_vsyscall(struct timespec *wall, struct timespec *wtm,
         fsyscall_gtod_data.clk_mask = c->mask;
         fsyscall_gtod_data.clk_mult = mult;
         fsyscall_gtod_data.clk_shift = c->shift;
-        fsyscall_gtod_data.clk_fsys_mmio = c->fsys_mmio;
+        fsyscall_gtod_data.clk_fsys_mmio = c->archdata.fsys_mmio;
         fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
 
 	/* copy kernel time structures */
diff --git a/arch/ia64/sn/kernel/sn2/timer.c b/arch/ia64/sn/kernel/sn2/timer.c
index c34efda..0f8844e 100644
--- a/arch/ia64/sn/kernel/sn2/timer.c
+++ b/arch/ia64/sn/kernel/sn2/timer.c
@@ -54,7 +54,7 @@ ia64_sn_udelay (unsigned long usecs)
 
 void __init sn_timer_init(void)
 {
-	clocksource_sn2.fsys_mmio = RTC_COUNTER_ADDR;
+	clocksource_sn2.archdata.fsys_mmio = RTC_COUNTER_ADDR;
 	clocksource_register_hz(&clocksource_sn2, sn_rtc_cycles_per_second);
 
 	ia64_udelay = &ia64_sn_udelay;
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 051474c..0557651 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -931,7 +931,7 @@ int hpet_alloc(struct hpet_data *hdp)
 #ifdef CONFIG_IA64
 	if (!hpet_clocksource) {
 		hpet_mctr = (void __iomem *)&hpetp->hp_hpet->hpet_mc;
-		CLKSRC_FSYS_MMIO_SET(clocksource_hpet.fsys_mmio, hpet_mctr);
+		clocksource_hpet.archdata.fsys_mmio = hpet_mctr;
 		clocksource_register_hz(&clocksource_hpet, hpetp->hp_tick_freq);
 		hpetp->hp_clocksource = &clocksource_hpet;
 		hpet_clocksource = &clocksource_hpet;
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 0fb83c2..6bb6970 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -171,13 +171,6 @@ struct clocksource {
 	u32 shift;
 	u64 max_idle_ns;
 
-#ifdef CONFIG_IA64
-	void *fsys_mmio;        /* used by fsyscall asm code */
-#define CLKSRC_FSYS_MMIO_SET(mmio, addr)      ((mmio) = (addr))
-#else
-#define CLKSRC_FSYS_MMIO_SET(mmio, addr)      do { } while (0)
-#endif
-
 #ifdef __ARCH_HAS_CLOCKSOURCE_DATA
 	struct arch_clocksource_data archdata;
 #endif
