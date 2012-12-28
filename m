Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2L1QhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 11:37:20 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:39289 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2L1QhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 11:37:16 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: matt.fleming@intel.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Sat, 29 Dec 2012 00:26:39 +0800
Message-Id: <1356712001-12198-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeupTime() are also
supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.

This patch changed RTC_DRV_EFI configuration to depend on EFI but not just IA64. It
checks efi_enabled flag and efi-rtc driver should enabled.

Cc: Matt Fleming <matt.fleming@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/platform/efi/efi.c |   20 ++++++++++++++++++++
 drivers/rtc/Kconfig         |    2 +-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ad44391..f08d28b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -41,6 +41,9 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/bcd.h>
+#if (defined CONFIG_RTC_DRV_EFI || defined CONFIG_RTC_DRV_EFI_MODULE)
+#include <linux/platform_device.h>
+#endif
 
 #include <asm/setup.h>
 #include <asm/efi.h>
@@ -961,6 +964,23 @@ void __init efi_enter_virtual_mode(void)
 	kfree(new_memmap);
 }
 
+#if (defined CONFIG_RTC_DRV_EFI || defined CONFIG_RTC_DRV_EFI_MODULE)
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (efi_enabled && platform_device_register(&rtc_efi_dev) < 0)
+		pr_err("unable to register rtc-efi device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+arch_initcall(rtc_init);
+#endif
+
 /*
  * Convenience functions to obtain memory types and attributes
  */
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index d0cea02..7796f0a 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -621,7 +621,7 @@ config RTC_DRV_DA9055
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on IA64
+	depends on EFI
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
-- 
1.6.4.2

