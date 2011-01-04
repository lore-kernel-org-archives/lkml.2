Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab1ADN2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:28:54 -0500
Received: from www.tglx.de ([62.245.132.106]:40034 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab1ADN2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:28:53 -0500
Date: Tue, 4 Jan 2011 14:28:46 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        dirk.brandewie@gmail.com
Subject: [PATCH v2 13/15] x86/rtc: don't register rtc if we the DT blob
Message-ID: <20110104132846.GC21359@www.tglx.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-14-git-send-email-bigeasy@linutronix.de> <20101230085940.GG11721@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101230085940.GG11721@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

or we might end up with two device nodes for the same hardware.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/rtc.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 1cfbbfc..0cfa138 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -6,6 +6,7 @@
 #include <linux/acpi.h>
 #include <linux/bcd.h>
 #include <linux/pnp.h>
+#include <linux/of.h>
 
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
@@ -218,6 +219,20 @@ static struct platform_device rtc_device = {
 	.num_resources	= ARRAY_SIZE(rtc_resources),
 };
 
+#ifdef CONFIG_OF
+static __init int have_DTB(void)
+{
+	if (initial_boot_params)
+		return 1;
+	return 0;
+}
+#else
+static inline int have_DTB(void)
+{
+	return 0;
+}
+#endif
+
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
@@ -237,6 +252,9 @@ static __init int add_rtc_cmos(void)
 	}
 #endif
 
+	if (have_DTB())
+		return 0;
+
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");
-- 
1.7.3.2

