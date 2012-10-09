Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab2JIPei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:34:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab2JIPec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:34:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3/3] ARM: integrator: use __iomem pointers for MMIO, part 2
Date: Tue,  9 Oct 2012 17:34:21 +0200
Message-Id: <1349796861-31164-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796861-31164-1-git-send-email-arnd@arndb.de>
References: <1349796861-31164-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:pxlkrFaTYa2T+ZsQh7C+flm0iB2YyiDvBxKHVW0el3a
 oOeZChG4+EdiaPb2SrPrmps5czm1rTEnu3pKAKqlEZw1bPwbQV
 tzmTsnRBCjIDPCs5EOmjarfD8GcqjtW9MTrsJvOawXttyzR0N5
 fVKyRnwxEFBPfSFB8iKcD9G7qKFKgABG0R7H10HJjopPSCkfty
 9AJVjxeHfi3Kp7Udu/6hDoNAk6YsNTgFo/3XbbJcdxdW+4Bkek
 B9KC3nGNbH7XeJXuMvs+Yjf3RpIINsoS3smK8hNXTzivJ/+97h
 m5z5+85eSTy91W467md7lAXsc6utuI+WZsf1jv5fZ47WDEYrxg
 UkbQJPs2NPbHoV6EcJHtep1U0/wOk6zZm0J7s3Lli39E0OWq4d
 v632jMUoeAJL9A3475G5Fpek1jFiVtEbAw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to some interesting merges in the integrator code, not
all users of mmio pointers were converted before, this
fixes all warnings that got introduced as a consequence.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-integrator/include/mach/cm.h       |    2 +-
 arch/arm/mach-integrator/include/mach/platform.h |    6 +++---
 arch/arm/mach-integrator/integrator_ap.c         |    2 +-
 arch/arm/mach-integrator/integrator_cp.c         |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-integrator/include/mach/cm.h b/arch/arm/mach-integrator/include/mach/cm.h
index 1a78692e..202e6a5 100644
--- a/arch/arm/mach-integrator/include/mach/cm.h
+++ b/arch/arm/mach-integrator/include/mach/cm.h
@@ -3,7 +3,7 @@
  */
 void cm_control(u32, u32);
 
-#define CM_CTRL	IO_ADDRESS(INTEGRATOR_HDR_CTRL)
+#define CM_CTRL	__io_address(INTEGRATOR_HDR_CTRL)
 
 #define CM_CTRL_LED			(1 << 0)
 #define CM_CTRL_nMBDET			(1 << 1)
diff --git a/arch/arm/mach-integrator/include/mach/platform.h b/arch/arm/mach-integrator/include/mach/platform.h
index 4c03475..efeac5d 100644
--- a/arch/arm/mach-integrator/include/mach/platform.h
+++ b/arch/arm/mach-integrator/include/mach/platform.h
@@ -324,9 +324,9 @@
  */
 #define PHYS_PCI_V3_BASE                0x62000000
 
-#define PCI_MEMORY_VADDR		0xe8000000
-#define PCI_CONFIG_VADDR		0xec000000
-#define PCI_V3_VADDR			0xed000000
+#define PCI_MEMORY_VADDR		IOMEM(0xe8000000)
+#define PCI_CONFIG_VADDR		IOMEM(0xec000000)
+#define PCI_V3_VADDR			IOMEM(0xed000000)
 
 /* ------------------------------------------------------------------------
  *  Integrator Interrupt Controllers
diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index d5b5435a..e6617c1 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -157,7 +157,7 @@ static struct map_desc ap_io_desc[] __initdata = {
 static void __init ap_map_io(void)
 {
 	iotable_init(ap_io_desc, ARRAY_SIZE(ap_io_desc));
-	vga_base = PCI_MEMORY_VADDR;
+	vga_base = (unsigned long)PCI_MEMORY_VADDR;
 	pci_map_io_early(__phys_to_pfn(PHYS_PCI_IO_BASE));
 }
 
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index 6870a1f..5b08e8e 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -261,6 +261,8 @@ static void __init intcp_init_early(void)
 #endif
 }
 
+#ifdef CONFIG_OF
+
 static void __init intcp_timer_init_of(void)
 {
 	struct device_node *node;
@@ -297,8 +299,6 @@ static struct sys_timer cp_of_timer = {
 	.init		= intcp_timer_init_of,
 };
 
-#ifdef CONFIG_OF
-
 static const struct of_device_id fpga_irq_of_match[] __initconst = {
 	{ .compatible = "arm,versatile-fpga-irq", .data = fpga_irq_of_init, },
 	{ /* Sentinel */ }
-- 
1.7.10

