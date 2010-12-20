Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab0LTWUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 17:20:54 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33070 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab0LTWUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 17:20:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67616908"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv4 3/4] ARM: Implement a timer based __delay() loop
Date: Mon, 20 Dec 2010 14:20:32 -0800
Message-Id: <1292883633-19553-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.4.516.g15368e
In-Reply-To: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org>
References: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

udelay() can be incorrect on SMP machines that scale their CPU
frequencies independently of one another (as pointed out here
http://article.gmane.org/gmane.linux.kernel/977567). The delay
loop can either be too fast or too slow depending on which CPU the
loops_per_jiffy counter is calibrated on and which CPU the delay
loop is running on. udelay() can also be incorrect if the
CPU frequency switches during the __delay() loop, causing the loop
to either terminate too early, or too late.

Forcing udelay() to run on one CPU is unreasonable and taking the
penalty of a rather large loops_per_jiffy in udelay() when the
CPU is actually running slower is bad for performance. Solve the
problem by adding a timer based__delay() loop unaffected by CPU
frequency scaling. Machines should set this loop as their
__delay() implementation by calling set_timer_fn() during their
timer initialization.

The kernel is already prepared for a timer based approach
(evident by the read_current_timer() function). If an arch
implements read_current_timer(), calibrate_delay() will use
calibrate_delay_direct() to calculate loops_per_jiffy (in which
case loops_per_jiffy should really be renamed to
timer_ticks_per_jiffy). Since the loops_per_jiffy will be based
on timer ticks, __delay() should be implemented as a loop around
read_current_timer().

Doing this makes the expensive loops_per_jiffy calculation go
away (saving ~150ms on boot time on my machine) and fixes
udelay() by making it safe in the face of independently scaling
CPUs. The only prerequisite is that read_current_timer() is
monotonically increasing across calls (and doesn't overflow
within ~2000us).

There is a downside to this approach though. BogoMIPS is no
longer "accurate" in that it reflects the BogoMIPS of the timer
and not the CPU. On most SoC's the timer isn't running anywhere
near as fast as the CPU so BogoMIPS will be ridiculously low (my
timer runs at 4.8 MHz and thus my BogoMIPS is 9.6 compared to my
CPU's 800). This shouldn't be too much of a concern though since
BogoMIPS are bogus anyway (hence the name).

This loop is pretty much a copy of AVR's version.

Reported-and-reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/delay.h |    2 ++
 arch/arm/lib/delay.c         |   17 +++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/delay.h b/arch/arm/include/asm/delay.h
index 82ef82a..91063a3 100644
--- a/arch/arm/include/asm/delay.h
+++ b/arch/arm/include/asm/delay.h
@@ -47,5 +47,7 @@ static inline void set_delay_fn(void (*fn)(unsigned long))
 	delay_fn = fn;
 }
 
+extern void read_current_timer_delay_loop(unsigned long loops);
+
 #endif /* defined(_ARM_DELAY_H) */
 
diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index 7468bc6..f24c956 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -9,6 +9,7 @@
  */
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/timex.h>
 
 /*
  * Oh, if only we had a cycle counter...
@@ -23,6 +24,22 @@ static void delay_loop(unsigned long loops)
 	);
 }
 
+#ifdef ARCH_HAS_READ_CURRENT_TIMER
+/*
+ * Assumes read_current_timer() is monotonically increasing
+ * across calls and wraps at most once within MAX_UDELAY_MS.
+ */
+void read_current_timer_delay_loop(unsigned long loops)
+{
+	unsigned long bclock, now;
+
+	read_current_timer(&bclock);
+	do {
+		read_current_timer(&now);
+	} while ((now - bclock) < loops);
+}
+#endif
+
 void (*delay_fn)(unsigned long) = delay_loop;
 
 /*
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

