Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab0JAMAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:00:10 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:52084 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932442Ab0JAMAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:00:00 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Shiraz Hashim <shiraz.hashim@st.com>, vipin.kumar@st.com,
        deepak.sikri@st.com, armando.visconti@st.com, vipulkumar.samar@st.com,
        rajeev-dlh.kumar@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 50/69] ST SPEAr13xx: Modified static mappings
Date: Fri,  1 Oct 2010 17:26:10 +0530
Message-Id: <81ee7baeea114d591582d1adf33b67f45af5df12.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shiraz Hashim <shiraz.hashim@st.com>

The new static io mappings map regions in 0xE...,.... space to
0xF...,.... and those in space 0x6...,.... to 0xE...,.... range.
This is done to accomodate regions of RAS configuration registers to be
used by clock frameowrk and possibly others.

Signed-off-by: shiraz hashim <shiraz.hashim@st.com>
Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear13xx/include/mach/hardware.h |    7 ++++++-
 arch/arm/mach-spear13xx/include/mach/vmalloc.h  |    2 +-
 arch/arm/mach-spear13xx/spear13xx.c             |    8 ++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-spear13xx/include/mach/hardware.h b/arch/arm/mach-spear13xx/include/mach/hardware.h
index 4abc2c0..44cd0c2 100644
--- a/arch/arm/mach-spear13xx/include/mach/hardware.h
+++ b/arch/arm/mach-spear13xx/include/mach/hardware.h
@@ -17,7 +17,12 @@
 #include <mach/spear.h>
 
 /* Vitual to physical translation of statically mapped space */
-#define IO_ADDRESS(x)		(x | 0xF0000000)
+/*
+ * if phy_addr is 0x8...,.... and above then map it to  0xF...,....
+ * else map it to 0xE...,....
+ */
+
+#define IO_ADDRESS(x)   ((x) | ((((x) >> 31) << 28) | 0xE0000000))
 
 /* typesafe io address */
 #define __io_address(n)		__io(IO_ADDRESS(n))
diff --git a/arch/arm/mach-spear13xx/include/mach/vmalloc.h b/arch/arm/mach-spear13xx/include/mach/vmalloc.h
index 85ad57e..9f329d1 100644
--- a/arch/arm/mach-spear13xx/include/mach/vmalloc.h
+++ b/arch/arm/mach-spear13xx/include/mach/vmalloc.h
@@ -13,6 +13,6 @@
 #ifndef __MACH_VMALLOC_H
 #define __MACH_VMALLOC_H
 
-#include <plat/vmalloc.h>
+#define VMALLOC_END		0xEC800000
 
 #endif /* __MACH_VMALLOC_H */
diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index 8c8a21d..d6a6dc0 100644
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@ -582,6 +582,14 @@ struct map_desc spear13xx_io_desc[] __initdata = {
 		.pfn		= __phys_to_pfn(SPEAR13XX_SYSRAM1_BASE),
 		.length		= SZ_1M,
 		.type		= MT_MEMORY_NONCACHED
+#ifdef CONFIG_MACH_SPEAR1310
+	}, {
+		.virtual	= IO_ADDRESS(SPEAR1310_RAS_BASE),
+		.pfn		= __phys_to_pfn(SPEAR1310_RAS_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE
+
+#endif
 	},
 };
 
-- 
1.7.2.2

