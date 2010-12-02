Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab0LBNjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 08:39:18 -0500
Received: from www.tglx.de ([62.245.132.106]:45425 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab0LBNjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 08:39:16 -0500
Date: Thu, 2 Dec 2010 14:38:50 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, rtc-linux@googlegroups.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/rtc: don't register rtc if we have an OF node for it
Message-ID: <20101202133850.GB10365@www.tglx.de>
References: <20101201101756.GA31624@www.tglx.de> <AANLkTinF8GVv-HwKWCRx2jJoCZVWwNzBou3shi8OJj3S@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <AANLkTinF8GVv-HwKWCRx2jJoCZVWwNzBou3shi8OJj3S@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

or the rtc driver will probe for two devices: the static platform device
the OF device.

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

