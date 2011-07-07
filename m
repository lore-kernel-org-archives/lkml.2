Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1GGPHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:07:09 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34099 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1GGPHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:07:07 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 7 Jul 2011 23:13:32 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 2/3] ARM: mxc: use ARCH_NR_GPIOS to define gpio number
Message-ID: <20110707151331.GB12722@S2100-06.ap.freescale.net>
References: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
 <1309970263-13239-3-git-send-email-shawn.guo@linaro.org>
 <20110707074755.GX6069@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110707074755.GX6069@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 09:47:55AM +0200, Sascha Hauer wrote:
> On Thu, Jul 07, 2011 at 12:37:42AM +0800, Shawn Guo wrote:
> > The patch removes MXC_GPIO_IRQS and instead uses ARCH_NR_GPIOS to
> > define gpio number.  This change is need when we change mxc gpio
> > driver to be device tree aware.  When migrating the driver to device
> > tree, pdev->id becomes unusable.  It requires driver get gpio range
> > from gpio core, which will dynamically allocates number from
> > ARCH_NR_GPIOS to 0.
> > 
> > As a bonus point, it removes lines of '#if' and make the code a
> > little bit cleaner.  The side effect is the waste of number.  But
> > this is not a point when we go single image.
> 
> I'm not sure whether we really should depend on an externally defined
> ARCH_NR_GPIOS. Someone might get the idea to change this to a lower
> value. Maybe we should define this ourselves instead.
> 
Good point.  We should not depend on the externally defined one.  But
the reason in my mind is different from yours.  Right now, i.mx50 gets
192 and i.mx6 gets 224 gpios.  I do not see the point to lower the
value (no lower than 224), since we will go single image soon.  The
thing concerning me is that someday we may have a soc coming out with
more than 256 gpios.  Then we have to override ARCH_NR_GPIOS with our
own definition.

Please take a look at the updated patch below.  If it looks fine to
you, I will resend the patch.

8<----
>From b9cc9f9161b6d5ebb57d52200c3673dd78138899 Mon Sep 17 00:00:00 2001
From: Shawn Guo <shawn.guo@linaro.org>
Date: Wed, 6 Jul 2011 21:11:01 +0800
Subject: [PATCH] ARM: mxc: use ARCH_NR_GPIOS to define gpio number

The patch removes MXC_GPIO_IRQS and instead uses ARCH_NR_GPIOS to
define gpio number.  This change is need when we change mxc gpio
driver to be device tree aware.  When migrating the driver to device
tree, pdev->id becomes unusable.  It requires driver get gpio range
from gpio core, which will dynamically allocates number from
ARCH_NR_GPIOS to 0.

As a bonus point, it removes lines of '#if' and make the code a
little bit cleaner.

It also cleans a couple of unnecessary headers in mach/gpio.h.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/plat-mxc/include/mach/gpio.h |    9 ++++++---
 arch/arm/plat-mxc/include/mach/irqs.h |   21 +++------------------
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/gpio.h b/arch/arm/plat-mxc/include/mach/gpio.h
index 31c820c..f3b26f7 100644
--- a/arch/arm/plat-mxc/include/mach/gpio.h
+++ b/arch/arm/plat-mxc/include/mach/gpio.h
@@ -19,10 +19,13 @@
 #ifndef __ASM_ARCH_MXC_GPIO_H__
 #define __ASM_ARCH_MXC_GPIO_H__
 
-#include <linux/spinlock.h>
-#include <mach/hardware.h>
-#include <asm-generic/gpio.h>
+/*
+ * Define our own ARCH_NR_GPIOS here to override the one
+ * externally defined in asm-generic/gpio.h
+ */
+#define ARCH_NR_GPIOS	224
 
+#include <asm-generic/gpio.h>
 
 /* There's a off-by-one betweem the gpio bank number and the gpiochip */
 /* range e.g. GPIO_1_5 is gpio 5 under linux */
diff --git a/arch/arm/plat-mxc/include/mach/irqs.h b/arch/arm/plat-mxc/include/mach/irqs.h
index 35c89bc..62228f1 100644
--- a/arch/arm/plat-mxc/include/mach/irqs.h
+++ b/arch/arm/plat-mxc/include/mach/irqs.h
@@ -11,6 +11,8 @@
 #ifndef __ASM_ARCH_MXC_IRQS_H__
 #define __ASM_ARCH_MXC_IRQS_H__
 
+#include <mach/gpio.h>
+
 /*
  * SoCs with TZIC interrupt controller have 128 IRQs, those with AVIC have 64
  */
@@ -22,30 +24,13 @@
 
 #define MXC_GPIO_IRQ_START	MXC_INTERNAL_IRQS
 
-/* these are ordered by size to support multi-SoC kernels */
-#if defined CONFIG_SOC_IMX53
-#define MXC_GPIO_IRQS		(32 * 7)
-#elif defined CONFIG_ARCH_MX2
-#define MXC_GPIO_IRQS		(32 * 6)
-#elif defined CONFIG_SOC_IMX50
-#define MXC_GPIO_IRQS		(32 * 6)
-#elif defined CONFIG_ARCH_MX1
-#define MXC_GPIO_IRQS		(32 * 4)
-#elif defined CONFIG_ARCH_MX25
-#define MXC_GPIO_IRQS		(32 * 4)
-#elif defined CONFIG_SOC_IMX51
-#define MXC_GPIO_IRQS		(32 * 4)
-#elif defined CONFIG_ARCH_MX3
-#define MXC_GPIO_IRQS		(32 * 3)
-#endif
-
 /*
  * The next 16 interrupts are for board specific purposes.  Since
  * the kernel can only run on one machine at a time, we can re-use
  * these.  If you need more, increase MXC_BOARD_IRQS, but keep it
  * within sensible limits.
  */
-#define MXC_BOARD_IRQ_START	(MXC_INTERNAL_IRQS + MXC_GPIO_IRQS)
+#define MXC_BOARD_IRQ_START	(MXC_INTERNAL_IRQS + ARCH_NR_GPIOS)
 
 #ifdef CONFIG_MACH_MX31ADS_WM1133_EV1
 #define MXC_BOARD_IRQS  80

-- 
Regards,
Shawn

