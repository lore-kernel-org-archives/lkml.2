Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2LaE5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 23:57:41 -0500
Received: from nigelcunningham.com.au ([178.79.133.97]:37121 "EHLO
	nigelcunningham.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2LaE5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 23:57:39 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Dec 2012 23:57:39 EST
Message-ID: <50E118DA.4070202@nigelcunningham.com.au>
Date: Mon, 31 Dec 2012 15:47:22 +1100
From: Nigel Cunningham <nigel@nigelcunningham.com.au>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] Add support for DMI matching in calculating RTC_ALWAYS_BCD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 037d9b44c9a18e6c2e3dedde2b8391215accc236 Mon Sep 17 00:00:00 2001
From: Nigel <nigel@tuxonice.net>
Date: Mon, 31 Dec 2012 10:58:54 +1100
Subject: [PATCH] Add support for DMI matching in calculating RTC_ALWAYS_BCD.

The Sony Vaio VPCSE15FG needs RTC_ALWAYS_BCD to be false rather than the
otherwise universal value of true. Add support for catching this model
via DMI matching.

There have been no BIOS updates for the VPCSE15FG, so I've not specified
a BIOS version in the criteria for matching.

Signed-off-by: Nigel Cunningham <nigel@nigelcunningham.com.au>
---
  arch/x86/include/asm/mc146818rtc.h |    2 +-
  drivers/rtc/Makefile               |    1 +
  drivers/rtc/dmi.c                  |   46 
++++++++++++++++++++++++++++++++++++
  include/linux/rtc.h                |    6 +++++
  4 files changed, 54 insertions(+), 1 deletion(-)
  create mode 100644 drivers/rtc/dmi.c

diff --git a/arch/x86/include/asm/mc146818rtc.h 
b/arch/x86/include/asm/mc146818rtc.h
index d354fb7..b88f2c6 100644
--- a/arch/x86/include/asm/mc146818rtc.h
+++ b/arch/x86/include/asm/mc146818rtc.h
@@ -10,7 +10,7 @@

  #ifndef RTC_PORT
  #define RTC_PORT(x)    (0x70 + (x))
-#define RTC_ALWAYS_BCD    1    /* RTC operates in binary mode */
+#define RTC_ALWAYS_BCD    (rtc_always_bcd)    /* Does the RTC operate 
in binary mode? */
  #endif

  #if defined(CONFIG_X86_32) && defined(__HAVE_ARCH_CMPXCHG)
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index c3f62c8..e008f65 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -12,6 +12,7 @@ rtc-core-y            := class.o interface.o
  rtc-core-$(CONFIG_RTC_INTF_DEV)    += rtc-dev.o
  rtc-core-$(CONFIG_RTC_INTF_PROC) += rtc-proc.o
  rtc-core-$(CONFIG_RTC_INTF_SYSFS) += rtc-sysfs.o
+rtc-core-$(CONFIG_DMI) += dmi.o

  # Keep the list ordered.

diff --git a/drivers/rtc/dmi.c b/drivers/rtc/dmi.c
new file mode 100644
index 0000000..609c2b5
--- /dev/null
+++ b/drivers/rtc/dmi.c
@@ -0,0 +1,46 @@
+/*
+ * RTC driver DMI matching.
+ *
+ *   Most machines using the mc146818 RTC need RTC_ALWAYS_BCD set to 1.
+ *   This file does DMI matching for the tiny number (1 so far!) of 
machines
+ *   that don't fit that mould.
+ *
+ *   (C) 2012 Nigel Cunningham <nigel@nigelcunningham.com.au>
+ *    Add support for checking for the Sony Vaio VPCSE15FG.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as 
published by
+ * the Free Software Foundation.
+ *
+ * Trademarks are the property of their respective owners.
+ */
+
+#include <linux/module.h>
+#include <linux/dmi.h>
+
+int __read_mostly rtc_always_bcd;
+EXPORT_SYMBOL_GPL(rtc_always_bcd);
+
+static const struct dmi_system_id __initconst nonbcd_dmi_table[] = {
+#if defined(CONFIG_DMI) && defined(CONFIG_X86)
+    {
+        /* Sony VAIO VPCSE15FG */
+        .matches = {
+            DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+            DMI_MATCH(DMI_PRODUCT_NAME, "VPCSE15FG"),
+        },
+    },
+#endif
+    { }
+};
+
+static int __init rtc_check_always_bcd(void)
+{
+    if (dmi_check_system(nonbcd_dmi_table)) {
+        printk("Non BCD RTC clock detected via DMI check.\n");
+    } else
+        rtc_always_bcd = 1;
+
+    return 0;
+}
+core_initcall(rtc_check_always_bcd);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 9531845..0049f0f 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -164,6 +164,12 @@ extern int rtc_alarm_irq_enable(struct rtc_device 
*rtc, unsigned int enabled);
  extern int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc,
                          unsigned int enabled);

+#ifdef CONFIG_DMI
+extern int rtc_always_bcd;
+#else
+#define rtc_always_bcd (1)
+#endif
+
  void rtc_handle_legacy_irq(struct rtc_device *rtc, int num, int mode);
  void rtc_aie_update_irq(void *private);
  void rtc_uie_update_irq(void *private);
-- 
1.7.10.4

