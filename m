Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2EOMHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:07:55 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:46414 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2EOMHy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 15 May 2012 08:07:54 -0400
Message-Id: <4FB263560200007800083CB0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 15 May 2012 13:08:22 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <dannf@dannf.org>, <matt.fleming@linux.intel.com>, <mjg@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86: enable rtc-efi
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides a Kconfig change this just requires creating a corresponding
platform device.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: dann frazier <dannf@dannf.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>

---
 arch/x86/platform/efi/efi.c |   19 +++++++++++++++++++
 drivers/rtc/Kconfig         |    2 +-
 2 files changed, 20 insertions(+), 1 deletion(-)

--- 3.4-rc7/arch/x86/platform/efi/efi.c
+++ 3.4-rc7-EFI-RTC-platform-dev/arch/x86/platform/efi/efi.c
@@ -34,6 +34,7 @@
 #include <linux/export.h>
 #include <linux/bootmem.h>
 #include <linux/memblock.h>
+#include <linux/platform_device.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/time.h>
@@ -912,6 +913,24 @@ out:
 	kfree(new_memmap);
 }
 
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (!efi_enabled)
+		return -ENODEV;
+
+	if (platform_device_register(&rtc_efi_dev) < 0)
+		printk(KERN_ERR "unable to register EFI RTC device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+arch_initcall(rtc_init);
+
 /*
  * Convenience functions to obtain memory types and attributes
  */
--- 3.4-rc7/drivers/rtc/Kconfig
+++ 3.4-rc7-EFI-RTC-platform-dev/drivers/rtc/Kconfig
@@ -563,7 +563,7 @@ config RTC_DRV_DA9052
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on IA64
+	depends on EFI
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.



