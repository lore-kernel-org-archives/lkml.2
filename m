Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0LHEjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:39:35 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12999 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab0LHEiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:38:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6190"; a="65700307"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>
Subject: [PATCHv3 3/4] ARM: Implement a timer based __delay() loop
Date: Tue,  7 Dec 2010 20:38:47 -0800
Message-Id: <1291783128-27520-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1291783128-27520-1-git-send-email-sboyd@codeaurora.org>
References: <1291783128-27520-1-git-send-email-sboyd@codeaurora.org>
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

Reported-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
---
 arch/arm/include/asm/delay.h |    1 +
 arch/arm/lib/delay.c         |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/delay.h b/arch/arm/include/asm/delay.h
index 7c732b5..5c6b9a3 100644
--- a/arch/arm/include/asm/delay.h
+++ b/arch/arm/include/asm/delay.h
@@ -41,6 +41,7 @@ extern void __const_udelay(unsigned long);
 	  __udelay(n))
 
 extern void set_delay_fn(void (*fn)(unsigned long));
+extern void read_current_timer_delay_loop(unsigned long loops);
 
 #endif /* defined(_ARM_DELAY_H) */
 
diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index b38f7c0..c590b8a 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -9,6 +9,7 @@
  */
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/timex.h>
 
 /*
  * Oh, if only we had a cycle counter...
@@ -23,6 +24,22 @@ void delay_loop(unsigned long loops)
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
 static void (*delay_fn)(unsigned long) = delay_loop;
 
 void set_delay_fn(void (*fn)(unsigned long))
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

