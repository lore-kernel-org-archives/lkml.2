Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab1BJXpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:45:15 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14304 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab1BJXpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:45:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6253"; a="73980382"
Message-ID: <4D54787C.4070007@codeaurora.org>
Date: Thu, 10 Feb 2011 15:45:00 -0800
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
CC: Dima Zavin <dima@android.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] msm: gpiomux: decentralize and modularize gpiomux init.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize gpiomux initialization as follows:
- remove the global static gpiomux configuration table;
- remove the universal initcall from gpiomux.c;
- add a public function, msm_gpiomux_init, which installs
   a provided gpiomux config table and runs the code
   previously run by the universal init.
- Add initcalls in each of the board-specific gpiomux files.

This decentralization of gpiomux init improves its flexibility
by allowing board-specific runtime code to select and/or
assemble the correct gpiomux-config table and send it to the
gpiomux framework for initialization. Rather than having a single
static array which must meet all needs.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
  arch/arm/mach-msm/board-msm7x27.c |   17 ++++++++-
  arch/arm/mach-msm/board-msm7x30.c |   51 ++++++++++++++++++--------
  arch/arm/mach-msm/board-msm8x60.c |   15 +++++++-
  arch/arm/mach-msm/board-qsd8x50.c |   33 ++++++++++++++----
  arch/arm/mach-msm/gpiomux-v1.h    |   10 +-----
  arch/arm/mach-msm/gpiomux-v2.h    |    4 +--
  arch/arm/mach-msm/gpiomux.c       |   70 
+++++++++++++++++++++++++++++--------
  arch/arm/mach-msm/gpiomux.h       |   30 ++++++++++-----
  8 files changed, 167 insertions(+), 63 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x27.c 
b/arch/arm/mach-msm/board-msm7x27.c
index 16d7580..64f29f6 100644
--- a/arch/arm/mach-msm/board-msm7x27.c
+++ b/arch/arm/mach-msm/board-msm7x27.c
@@ -1,6 +1,6 @@
  /*
   * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2008-2009, Code Aurora Forum. All rights reserved.
+ * Copyright (C) 2008-2009, 2011 Code Aurora Forum. All rights reserved.
   * Author: Brian Swetland <swetland@google.com>
   *
   * This software is licensed under the terms of the GNU General Public
@@ -75,6 +75,19 @@ static struct platform_device *devices[] __initdata = {

  extern struct sys_timer msm_timer;

+static int __init gpiomux_init(void)
+{
+    int rc;
+
+    rc = msm_gpiomux_init(NR_GPIO_IRQS);
+    if (rc) {
+        printk(KERN_ERR "msm_gpiomux_init failed - %n", rc);
+        return rc;
+    }
+
+    return 0;
+}
+
  static void __init msm7x2x_init_irq(void)
  {
      msm_init_irq();
@@ -85,6 +98,8 @@ static void __init msm7x2x_init(void)
      if (socinfo_init() < 0)
          BUG();

+    gpiomux_init();
+
      if (machine_is_msm7x25_ffa() || machine_is_msm7x27_ffa()) {
          smc91x_resources[0].start = 0x98000300;
          smc91x_resources[0].end = 0x980003ff;
diff --git a/arch/arm/mach-msm/board-msm7x30.c 
b/arch/arm/mach-msm/board-msm7x30.c
index dc9fac1..7b4c414 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
   *
   * This program is free software; you can redistribute it and/or modify
   * it under the terms of the GNU General Public License version 2 and
@@ -39,6 +39,9 @@
  #include "gpiomux.h"
  #include "proc_comm.h"

+#define UART2_SUSPENDED (GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |\
+            GPIOMUX_FUNC_2 | GPIOMUX_VALID)
+
  extern struct sys_timer msm_timer;

  static int hsusb_phy_init_seq[] = {
@@ -53,25 +56,23 @@ static struct msm_otg_platform_data msm_otg_pdata = {
      .otg_control        = OTG_PHY_CONTROL,
  };

-struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
-#ifdef CONFIG_SERIAL_MSM_CONSOLE
-    [49] = { /* UART2 RFR */
-        .suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-                 GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+struct msm_gpiomux_config msm7x30_uart2_configs[] __initdata = {
+    {
+        .gpio = 49, /* UART2 RFR */
+        .suspended = UART2_SUSPENDED,
      },
-    [50] = { /* UART2 CTS */
-        .suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-                 GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+    {
+        .gpio = 50, /* UART2 CTS */
+        .suspended = UART2_SUSPENDED,
      },
-    [51] = { /* UART2 RX */
-        .suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-                 GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+    {
+        .gpio = 51, /* UART2 RX */
+        .suspended = UART2_SUSPENDED,
      },
-    [52] = { /* UART2 TX */
-        .suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-                 GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+    {
+        .gpio = 52, /* UART2 TX */
+        .suspended = UART2_SUSPENDED,
      },
-#endif
  };

  static struct platform_device *devices[] __initdata = {
@@ -84,6 +85,22 @@ static struct platform_device *devices[] __initdata = {
&msm_device_hsusb_host,
  };

+static int __init gpiomux_init(void)
+{
+    int rc;
+
+    rc = msm_gpiomux_init(NR_GPIO_IRQS);
+    if (rc) {
+        printk(KERN_ERR "msm_gpiomux_init failed - %d\n", rc);
+        return rc;
+    }
+
+    msm_gpiomux_install(msm7x30_uart2_configs,
+            ARRAY_SIZE(msm7x30_uart2_configs));
+    return 0;
+
+}
+
  static void __init msm7x30_init_irq(void)
  {
      msm_init_irq();
@@ -95,6 +112,8 @@ static void __init msm7x30_init(void)
      msm_device_hsusb.dev.parent = &msm_device_otg.dev;
      msm_device_hsusb_host.dev.parent = &msm_device_otg.dev;

+    gpiomux_init();
+
      platform_add_devices(devices, ARRAY_SIZE(devices));
  }

diff --git a/arch/arm/mach-msm/board-msm8x60.c 
b/arch/arm/mach-msm/board-msm8x60.c
index 6c0b868..a3a28f0 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
   *
   * This program is free software; you can redistribute it and/or modify
   * it under the terms of the GNU General Public License version 2 and
@@ -29,8 +29,18 @@
  #include <mach/msm_iomap.h>
  #include "gpiomux.h"

-struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {};
+static int __init gpiomux_init(void)
+{
+    int rc;
+
+    rc = msm_gpiomux_init(NR_GPIO_IRQS);
+    if (rc) {
+        printk(KERN_ERR "msm_gpiomux_init failed %d\n", rc);
+        return rc;
+    }

+    return 0;
+}

  static void __init msm8x60_map_io(void)
  {
@@ -65,6 +75,7 @@ static void __init msm8x60_init_irq(void)

  static void __init msm8x60_init(void)
  {
+    gpiomux_init();
  }

  MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
diff --git a/arch/arm/mach-msm/board-qsd8x50.c 
b/arch/arm/mach-msm/board-qsd8x50.c
index b63b7c4..33ab1fe 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -38,16 +38,19 @@
  #include "devices.h"
  #include "gpiomux.h"

+#define UART3_SUSPENDED (GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |\
+            GPIOMUX_FUNC_1 | GPIOMUX_VALID)
+
  extern struct sys_timer msm_timer;

-struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
-    [86] = { /* UART3 RX */
-        .suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-                 GPIOMUX_FUNC_1 | GPIOMUX_VALID,
+struct msm_gpiomux_config qsd8x50_uart3_configs[] __initdata = {
+    {
+        .gpio = 86, /* UART3 RX */
+        .suspended = UART3_SUSPENDED,
      },
-    [87] = { /* UART3 TX */
-        .suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-                 GPIOMUX_FUNC_1 | GPIOMUX_VALID,
+    {
+        .gpio = 87, /* UART3 TX */
+        .suspended = UART3_SUSPENDED,
      },
  };

@@ -169,6 +172,21 @@ static struct msm_mmc_platform_data 
qsd8x50_sdc1_data = {
      .gpio_data = &sdc1_gpio,
  };

+static int __init gpiomux_init(void)
+{
+    int rc;
+
+    rc = msm_gpiomux_init(NR_GPIO_IRQS);
+    if (rc) {
+        printk(KERN_ERR "msm_gpiomux_init failed - %d\n", rc);
+        return rc;
+    }
+
+    msm_gpiomux_install(qsd8x50_uart3_configs,
+            ARRAY_SIZE(qsd8x50_uart3_configs));
+    return 0;
+}
+
  static void __init qsd8x50_init_mmc(void)
  {
      if (machine_is_qsd8x50_ffa() || machine_is_qsd8x50a_ffa())
@@ -202,6 +220,7 @@ static void __init qsd8x50_init(void)
      msm_device_otg.dev.platform_data = &msm_otg_pdata;
      msm_device_hsusb.dev.parent = &msm_device_otg.dev;
      msm_device_hsusb_host.dev.parent = &msm_device_otg.dev;
+    gpiomux_init();
      platform_add_devices(devices, ARRAY_SIZE(devices));
      qsd8x50_init_mmc();
  }
diff --git a/arch/arm/mach-msm/gpiomux-v1.h b/arch/arm/mach-msm/gpiomux-v1.h
index 71d86fe..4d545f7 100644
--- a/arch/arm/mach-msm/gpiomux-v1.h
+++ b/arch/arm/mach-msm/gpiomux-v1.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
   *
   * This program is free software; you can redistribute it and/or modify
   * it under the terms of the GNU General Public License version 2 and
@@ -17,14 +17,6 @@
  #ifndef __ARCH_ARM_MACH_MSM_GPIOMUX_V1_H
  #define __ARCH_ARM_MACH_MSM_GPIOMUX_V1_H

-#if defined(CONFIG_ARCH_MSM7X30)
-#define GPIOMUX_NGPIOS 182
-#elif defined(CONFIG_ARCH_QSD8X50)
-#define GPIOMUX_NGPIOS 165
-#else
-#define GPIOMUX_NGPIOS 133
-#endif
-
  typedef u32 gpiomux_config_t;

  enum {
diff --git a/arch/arm/mach-msm/gpiomux-v2.h b/arch/arm/mach-msm/gpiomux-v2.h
index 3bf10e7..2840de9 100644
--- a/arch/arm/mach-msm/gpiomux-v2.h
+++ b/arch/arm/mach-msm/gpiomux-v2.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
   *
   * This program is free software; you can redistribute it and/or modify
   * it under the terms of the GNU General Public License version 2 and
@@ -17,8 +17,6 @@
  #ifndef __ARCH_ARM_MACH_MSM_GPIOMUX_V2_H
  #define __ARCH_ARM_MACH_MSM_GPIOMUX_V2_H

-#define GPIOMUX_NGPIOS 173
-
  typedef u16 gpiomux_config_t;

  enum {
diff --git a/arch/arm/mach-msm/gpiomux.c b/arch/arm/mach-msm/gpiomux.c
index 53af21a..b4a6fd6 100644
--- a/arch/arm/mach-msm/gpiomux.c
+++ b/arch/arm/mach-msm/gpiomux.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
   *
   * This program is free software; you can redistribute it and/or modify
   * it under the terms of the GNU General Public License version 2 and
@@ -15,20 +15,31 @@
   * 02110-1301, USA.
   */
  #include <linux/module.h>
+#include <linux/slab.h>
  #include <linux/spinlock.h>
  #include "gpiomux.h"

+struct msm_gpiomux_rec {
+    gpiomux_config_t active;
+    gpiomux_config_t suspended;
+    int              ref;
+};
  static DEFINE_SPINLOCK(gpiomux_lock);
+static struct msm_gpiomux_rec *msm_gpiomux_recs;
+static unsigned msm_gpiomux_ngpio;

  int msm_gpiomux_write(unsigned gpio,
                gpiomux_config_t active,
                gpiomux_config_t suspended)
  {
-    struct msm_gpiomux_config *cfg = msm_gpiomux_configs + gpio;
+    struct msm_gpiomux_rec *cfg = msm_gpiomux_recs + gpio;
      unsigned long irq_flags;
      gpiomux_config_t setting;

-    if (gpio >= GPIOMUX_NGPIOS)
+    if (!msm_gpiomux_recs)
+        return -EFAULT;
+
+    if (gpio >= msm_gpiomux_ngpio)
          return -EINVAL;

      spin_lock_irqsave(&gpiomux_lock, irq_flags);
@@ -50,10 +61,13 @@ EXPORT_SYMBOL(msm_gpiomux_write);

  int msm_gpiomux_get(unsigned gpio)
  {
-    struct msm_gpiomux_config *cfg = msm_gpiomux_configs + gpio;
+    struct msm_gpiomux_rec *cfg = msm_gpiomux_recs + gpio;
      unsigned long irq_flags;

-    if (gpio >= GPIOMUX_NGPIOS)
+    if (!msm_gpiomux_recs)
+        return -EFAULT;
+
+    if (gpio >= msm_gpiomux_ngpio)
          return -EINVAL;

      spin_lock_irqsave(&gpiomux_lock, irq_flags);
@@ -66,10 +80,13 @@ EXPORT_SYMBOL(msm_gpiomux_get);

  int msm_gpiomux_put(unsigned gpio)
  {
-    struct msm_gpiomux_config *cfg = msm_gpiomux_configs + gpio;
+    struct msm_gpiomux_rec *cfg = msm_gpiomux_recs + gpio;
      unsigned long irq_flags;

-    if (gpio >= GPIOMUX_NGPIOS)
+    if (!msm_gpiomux_recs)
+        return -EFAULT;
+
+    if (gpio >= msm_gpiomux_ngpio)
          return -EINVAL;

      spin_lock_irqsave(&gpiomux_lock, irq_flags);
@@ -81,16 +98,39 @@ int msm_gpiomux_put(unsigned gpio)
  }
  EXPORT_SYMBOL(msm_gpiomux_put);

-static int __init gpiomux_init(void)
+int msm_gpiomux_init(size_t ngpio)
+{
+    if (!ngpio)
+        return -EINVAL;
+
+    if (msm_gpiomux_recs)
+        return -EPERM;
+
+    msm_gpiomux_recs = kzalloc(sizeof(struct msm_gpiomux_rec) * ngpio,
+                   GFP_KERNEL);
+    if (!msm_gpiomux_recs)
+        return -ENOMEM;
+
+    msm_gpiomux_ngpio = ngpio;
+
+    return 0;
+}
+EXPORT_SYMBOL(msm_gpiomux_init);
+
+void msm_gpiomux_install(struct msm_gpiomux_config *configs, unsigned 
nconfigs)
  {
      unsigned n;
+    int rc;
+
+    if (!msm_gpiomux_recs)
+        return;

-    for (n = 0; n < GPIOMUX_NGPIOS; ++n) {
-        msm_gpiomux_configs[n].ref = 0;
-        if (!(msm_gpiomux_configs[n].suspended & GPIOMUX_VALID))
-            continue;
-        __msm_gpiomux_write(n, msm_gpiomux_configs[n].suspended);
+    for (n = 0; n < nconfigs; ++n) {
+        rc = msm_gpiomux_write(configs[n].gpio,
+                       configs[n].active,
+                       configs[n].suspended);
+        if (rc)
+            pr_err("%s: write failure: %d\n", __func__, rc);
      }
-    return 0;
  }
-postcore_initcall(gpiomux_init);
+EXPORT_SYMBOL(msm_gpiomux_install);
diff --git a/arch/arm/mach-msm/gpiomux.h b/arch/arm/mach-msm/gpiomux.h
index b178d9c..cc2e58a 100644
--- a/arch/arm/mach-msm/gpiomux.h
+++ b/arch/arm/mach-msm/gpiomux.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
   *
   * This program is free software; you can redistribute it and/or modify
   * it under the terms of the GNU General Public License version 2 and
@@ -37,17 +37,16 @@
   * Available settings differ by target; see the gpiomux header
   * specific to your target arch for available configurations.
   *
+ * @gpio: The index number of the gpio being described.
   * @active: The configuration to be installed when the line is
   * active, or its reference count is > 0.
   * @suspended: The configuration to be installed when the line
   * is suspended, or its reference count is 0.
- * @ref: The reference count of the line.  For internal use of
- * the gpiomux framework only.
   */
  struct msm_gpiomux_config {
+    unsigned         gpio;
      gpiomux_config_t active;
      gpiomux_config_t suspended;
-    unsigned         ref;
  };

  /**
@@ -63,13 +62,16 @@ enum {

  #ifdef CONFIG_MSM_GPIOMUX

-/* Each architecture must provide its own instance of this table.
- * To avoid having gpiomux manage any given gpio, one or both of
- * the entries can avoid setting GPIOMUX_VALID - the absence
- * of that flag will prevent the configuration from being applied
- * during state transitions.
+/* Before using gpiomux, initialize the subsystem by telling it how many
+ * gpios are going to be managed.  Calling any other gpiomux functions 
before
+ * msm_gpiomux_init is unsupported.
   */
-extern struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS];
+int msm_gpiomux_init(size_t ngpio);
+
+/* Install a block of gpiomux configurations in gpiomux.  This is 
functionally
+ * identical to calling msm_gpiomux_write many times.
+ */
+void msm_gpiomux_install(struct msm_gpiomux_config *configs, unsigned 
nconfigs);

  /* Increment a gpio's reference count, possibly activating the line. */
  int __must_check msm_gpiomux_get(unsigned gpio);
@@ -94,6 +96,14 @@ int msm_gpiomux_write(unsigned gpio,
   */
  void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val);
  #else
+static inline int msm_gpiomux_init(size_t ngpio)
+{
+    return -ENOSYS;
+}
+
+static inline void
+msm_gpiomux_install(struct msm_gpiomux_config *configs, unsigned 
nconfigs) {}
+
  static inline int __must_check msm_gpiomux_get(unsigned gpio)
  {
      return -ENOSYS;
-- 
1.7.3.3


Thanks,
Rohit Vaswani

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

