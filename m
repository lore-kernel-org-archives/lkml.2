Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab2GVKBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 06:01:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2GVKBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 06:01:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: arm-allnoconfig error: '__LINUX_ARM_ARCH__' undeclared
Date: Sun, 22 Jul 2012 10:01:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20120722024313.GD8279@localhost>
In-Reply-To: <20120722024313.GD8279@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207221001.43528.arnd@arndb.de>
X-Provags-ID: V02:K0:dKzpLNkzjDaPOvVuf2m987mmJNYoY42jA0dCNgsCoEa
 lFyeW70jWKBML6LH42jG86zTva7cEAGY4dO/L7em6VURLxmTkt
 CttdxV/6fQ7OY/awHgb5bp8Dv1zYgKl7t2mZzeNGbxW0VGk8X6
 pjcrNCzLnlYNlLAUwe+yqn4mghpKzGzM2hHnq52vvIKbmKl/k/
 ifyOwO4KfD0pXEQGxW/JTIywGxW1Hx2RV5trVXV8qyj/zju9Jf
 hM8+YyR4SH2QhPyJXwRd/WDt/o0PUnXEPcVFgO/Gt1A2a7LhSV
 k+TDd+5mZWyO522KzRxdvxtBATlj7NNNeSO06ziDNeiujnklg1
 PMowpeRsAae7kL2Lp6Yw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2012, Fengguang Wu wrote:
> Kernel build failed on arm-allnoconfig:
> 
> include/linux/math64.h:55:15: error: '__LINUX_ARM_ARCH__' undeclared (first use in this function)
> arch/arm/include/asm/glue-cache.h:129:2: error: #error Unknown cache maintenance model
> arch/arm/include/asm/glue-df.h:99:2: error: #error Unknown data abort handler type
> arch/arm/include/asm/glue-pf.h:54:2: error: #error Unknown prefetch abort handler type
> 
> Do you think this allnoconfig test meaningful at all?

The allno/mod/yesconfig tests on ARM are somewhat limited in their
usefulness at the moment because they always pick the same platform
type (versatile) and don't really cover the cases that most people
are interested in.

The particular problem with allnoconfig is that the logic to determine
the architecture level depends on at least one platform being selected,
and there are also problems with nommu kernels that tend to not work
if certain other options are not set correctly. 

We can make the nommu case go away if we make hide the option for
non-expert configurations including allnoconfig. I suggested adding
some logic to all the subarch Kconfig files that forces at least
one of the boards to be enabled like the patch below, but a number
of people didn't like it.

For reference, here is what I would use in order to get 'make
allnoconfig' to work on ARM. My impression is at the moment that
we should make a more serious attempt at fixing all the possible
configurations when we get to 'multiplatform' configurations,
because that will be more interesting than doing it just for
the versatile platform.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a306d6d..e43e743 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -236,7 +236,7 @@ source "kernel/Kconfig.freezer"
 menu "System Type"
 
 config MMU
-	bool "MMU-based Paged Memory Management Support"
+	bool "MMU-based Paged Memory Management Support" if EXPERT
 	default y
 	help
 	  Select if you want MMU-based virtualised addressing space
diff --git a/arch/arm/mach-versatile/Kconfig b/arch/arm/mach-versatile/Kconfig
index c1f38f6..455f20a 100644
--- a/arch/arm/mach-versatile/Kconfig
+++ b/arch/arm/mach-versatile/Kconfig
@@ -25,4 +25,13 @@ config MACH_VERSATILE_DT
 	  Include support for the ARM(R) Versatile/PB platform,
 	  using the device tree for discovery
 
+config MACH_VERSATILE_AUTO
+	def_bool y
+	depends on !ARCH_VERSATILE_PB
+	depends on !MACH_VERSATILE_AB
+	select MACH_VERSATILE_DT
+	help
+	  We autoselect MACH_VERSATILE_DT if both PB and AB are
+	  disabled, to ensure that at least one platform is enabled.
+
 endmenu
