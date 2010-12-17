Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0LQPev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:34:51 -0500
Received: from www.tglx.de ([62.245.132.106]:60848 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab0LQPeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:34:50 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org, dirk.brandewie@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 13/15] x86/rtc: don't register rtc if we have an OF node for it
Date: Fri, 17 Dec 2010 16:33:51 +0100
Message-Id: <1292600033-12271-14-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

or we end up with two of those things.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/rtc.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 1cfbbfc..382c6cb 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -6,6 +6,7 @@
 #include <linux/acpi.h>
 #include <linux/bcd.h>
 #include <linux/pnp.h>
+#include <linux/of.h>
 
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
@@ -218,6 +219,25 @@ static struct platform_device rtc_device = {
 	.num_resources	= ARRAY_SIZE(rtc_resources),
 };
 
+#ifdef CONFIG_OF
+static __init int have_rtc_of_node(void)
+{
+	struct device_node *n;
+
+	n = of_find_compatible_node(NULL, NULL, "motorola,mc146818");
+	if (n) {
+		of_node_put(n);
+		return 1;
+	}
+	return 0;
+}
+#else
+static inline int have_rtc_of_node(void)
+{
+	return 0;
+}
+#endif
+
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
@@ -237,6 +257,9 @@ static __init int add_rtc_cmos(void)
 	}
 #endif
 
+	if (have_rtc_of_node())
+		return 0;
+
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");
-- 
1.7.3.2

