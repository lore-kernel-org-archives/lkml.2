Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072Ab1HZKhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:37:38 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52908 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1HZKhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:37:38 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86: rtc: Don't register a platform RTC device for Intel MID
 platforms
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:32:41 +0100
Message-ID: <20110826103218.17229.75.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

Intel MID x86 platforms have a memory mapped virtual RTC instead.
No MID platform have the default ports (and accessing them may do weird stuff)

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/include/asm/mrst.h |    9 +++++++++
 arch/x86/kernel/rtc.c       |    5 +++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 719f00b..2f21864 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -31,11 +31,20 @@ enum mrst_cpu_type {
 };
 
 extern enum mrst_cpu_type __mrst_cpu_chip;
+
+#ifdef CONFIG_X86_INTEL_MID
+
 static inline enum mrst_cpu_type mrst_identify_cpu(void)
 {
 	return __mrst_cpu_chip;
 }
 
+#else /* !CONFIG_X86_INTEL_MID */
+
+#define mrst_identify_cpu()    (0)
+
+#endif /* !CONFIG_X86_INTEL_MID */
+
 enum mrst_timer_options {
 	MRST_TIMER_DEFAULT,
 	MRST_TIMER_APBT_ONLY,
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index f16557a..e31866f 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -12,6 +12,7 @@
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
 #include <asm/time.h>
+#include <asm/mrst.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -241,6 +242,10 @@ static __init int add_rtc_cmos(void)
 	if (of_have_populated_dt())
 		return 0;
 
+	/* Intel MID platforms don't have ioport rtc */
+	if (mrst_identify_cpu())
+		return -ENODEV;
+
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");

