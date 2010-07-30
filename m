Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561Ab0G3Ruc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:50:32 -0400
Received: from kroah.org ([198.145.64.141]:35987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360Ab0G3Rf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:27 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:11 2010
Message-Id: <20100730173111.017167268@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [092/140] ARM: 6201/1: RealView: Do not use outer_sync() on ARM11MPCore boards with L220
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 2503a5ecd86c002506001eba432c524ea009fe7f upstream.

RealView boards with certain revisions of the L220 cache controller (ARM11*
processors only) may have issues (hardware deadlock) with the recent changes to
the mb() barrier implementation (DSB followed by an L2 cache sync). The patch
redefines the RealView ARM11MPCore mandatory barriers without the outer_sync()
call.

Tested-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-realview/Kconfig                 |    2 ++
 arch/arm/mach-realview/include/mach/barriers.h |    8 ++++++++
 2 files changed, 10 insertions(+)

--- a/arch/arm/mach-realview/Kconfig
+++ b/arch/arm/mach-realview/Kconfig
@@ -18,6 +18,7 @@ config REALVIEW_EB_ARM11MP
 	bool "Support ARM11MPCore tile"
 	depends on MACH_REALVIEW_EB
 	select CPU_V6
+	select ARCH_HAS_BARRIERS if SMP
 	help
 	  Enable support for the ARM11MPCore tile on the Realview platform.
 
@@ -35,6 +36,7 @@ config MACH_REALVIEW_PB11MP
 	select CPU_V6
 	select ARM_GIC
 	select HAVE_PATA_PLATFORM
+	select ARCH_HAS_BARRIERS if SMP
 	help
 	  Include support for the ARM(R) RealView MPCore Platform Baseboard.
 	  PB11MPCore is a platform with an on-board ARM11MPCore and has
--- /dev/null
+++ b/arch/arm/mach-realview/include/mach/barriers.h
@@ -0,0 +1,8 @@
+/*
+ * Barriers redefined for RealView ARM11MPCore platforms with L220 cache
+ * controller to work around hardware errata causing the outer_sync()
+ * operation to deadlock the system.
+ */
+#define mb()		dsb()
+#define rmb()		dmb()
+#define wmb()		mb()


