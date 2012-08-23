Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab2HWOVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:21:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63354 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab2HWOVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:21:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 6/6] ARM: imx: select ARM_CPU_SUSPEND when necessary
Date: Thu, 23 Aug 2012 14:20:50 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>,
        stable@vger.kernel.org
References: <1345648390-4234-1-git-send-email-arnd@arndb.de> <1345648390-4234-7-git-send-email-arnd@arndb.de> <20120823024119.GD24242@S2101-09.ap.freescale.net>
In-Reply-To: <20120823024119.GD24242@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201208231420.50247.arnd@arndb.de>
X-Provags-ID: V02:K0:Ea+8QMtC5+40fMHpyfTEMVAIXYHRPAeAjTx4LT/dhBg
 8AwdWt+mm7oBpghqnCQ5XGLljnHg1+dW3NDC70F45EjhnA5Omf
 eXJWT3b71VUokcEaoaKIem8MtwqRK3D+HcpGKXlo0Bamkkev9n
 EgqLTL5YXzQTC/g1LSFR9F4MmRFPdg2DboWnM6Y5p5o7er7aWE
 U0O053A1eU6p1evJzuIGvcQZcDmpp65oNCBLqH4wKzNN7cEoJn
 xXraLNTqysmXfSjMtQ3j304ri06/bGCbIPIG7NK3N31O82NHtb
 XqwXngDNRB1oLn+EHbgyXoO4T99FqQY121P2wSeKwUy3opbpOd
 rk0PUdNP/oK0Ji5V5n6A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012, Shawn Guo wrote:
> On Wed, Aug 22, 2012 at 05:13:10PM +0200, Arnd Bergmann wrote:
> > On i.MX6, we select ARM_CPU_SUSPEND when building with power management
> > support, but for some reason this was omitted on i.MX5. Normally we
> > build kernels for both together so the error only showed up in
> > randconfig tests.
> > 
> > Without this patch, building imx5 standalone results in:
> > 
> > arch/arm/mach-imx/built-in.o: In function `v7_cpu_resume':
> > arch/arm/mach-imx/head-v7.S:104: undefined reference to `cpu_resume'
> > 
> So far, none of the functions in head-v7.S is used on imx5.  Also
> since imx5 SoCs implement State Retention Power Gating in hardware,
> ARM_CPU_SUSPEND support will never be used on imx5.
> 
> Maybe we should make head-v7.S only compile for imx6?

In tegra and shmobile, the respective file is called headsmp.S, so
I would suggest we rename it to the same here and only build it when
CONFIG_SMP is set, which comes down to imx6 at the moment.

How is this version?

	Arnd

>From 4036e8f292887e7b1abc8eacec7d619abd608178 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 17 Aug 2012 00:16:08 +0000
Subject: [PATCH] ARM: imx: build i.MX6 functions only when needed

The head-v7.S contains a call to the generic cpu_suspend function,
which is only available when selected by the i.MX6 code. As
pointed out by Shawn Guo, i.MX does not actually use any
functions defined in head-v7.S. It is also needed only for
the i.MX6 power management code and for the SMP code, so
we can restrict building this file to situations in which
at least one of those two is present.

Finally, other platforms with a similar file call it headsmp.S,
so we can rename it to the same for consistency.

Without this patch, building imx5 standalone results in:

arch/arm/mach-imx/built-in.o: In function `v7_cpu_resume':
arch/arm/mach-imx/head-v7.S:104: undefined reference to `cpu_resume'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Miao <eric.miao@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: stable@vger.kernel.org

diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index e08adb7..d004d37 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -71,14 +71,13 @@ obj-$(CONFIG_DEBUG_LL) += lluart.o
 obj-$(CONFIG_HAVE_IMX_GPC) += gpc.o
 obj-$(CONFIG_HAVE_IMX_MMDC) += mmdc.o
 obj-$(CONFIG_HAVE_IMX_SRC) += src.o
-obj-$(CONFIG_CPU_V7) += head-v7.o
-AFLAGS_head-v7.o :=-Wa,-march=armv7-a
-obj-$(CONFIG_SMP) += platsmp.o
+AFLAGS_headsmp.o :=-Wa,-march=armv7-a
+obj-$(CONFIG_SMP) += headsmp.o platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
 obj-$(CONFIG_SOC_IMX6Q) += clk-imx6q.o mach-imx6q.o
 
 ifeq ($(CONFIG_PM),y)
-obj-$(CONFIG_SOC_IMX6Q) += pm-imx6q.o
+obj-$(CONFIG_SOC_IMX6Q) += pm-imx6q.o headsmp.o
 endif
 
 # i.MX5 based machines
diff --git a/arch/arm/mach-imx/head-v7.S b/arch/arm/mach-imx/headsmp.S
similarity index 100%
rename from arch/arm/mach-imx/head-v7.S
rename to arch/arm/mach-imx/headsmp.S
