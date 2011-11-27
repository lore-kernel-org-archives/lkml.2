Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1K0Dl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 22:41:58 -0500
Received: from d1.icnet.pl ([212.160.220.21]:56327 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab1K0Dl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 22:41:56 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: [PATCH 4/5] init/calibrate.c: allow for recalibration of loops per jiffy
Date: Sun, 27 Nov 2011 04:32:30 +0100
Message-Id: <1322364751-29980-5-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required on ARM OMAP1 platform, after DPLL reprogramming has
been fixed by moving it from setup_arch() to kernel_init().

Created against linux-3.2-rc2.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sameer Nanda <snanda@chromium.org>
---
 include/linux/delay.h |    4 +++-
 init/calibrate.c      |    6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index a6ecb34..ed0fbbe 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -42,7 +42,9 @@ static inline void ndelay(unsigned long x)
 #endif
 
 extern unsigned long lpj_fine;
-void calibrate_delay(void);
+void _calibrate_delay(bool redo);
+#define calibrate_delay() _calibrate_delay(0)
+#define recalibrate_delay() _calibrate_delay(1)
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
 void usleep_range(unsigned long min, unsigned long max);
diff --git a/init/calibrate.c b/init/calibrate.c
index 24df797..f7c1593 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -246,13 +246,15 @@ recalibrate:
 
 static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
 
-void __cpuinit calibrate_delay(void)
+void __cpuinit _calibrate_delay(bool redo)
 {
 	unsigned long lpj;
 	static bool printed;
 	int this_cpu = smp_processor_id();
 
-	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
+	if (redo)
+		printed = 0;
+	if (!redo && per_cpu(cpu_loops_per_jiffy, this_cpu)) {
 		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
 		pr_info("Calibrating delay loop (skipped) "
 				"already calibrated this CPU");
-- 
1.7.3.4

