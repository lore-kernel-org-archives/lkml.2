Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3AGPfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:35:08 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:48245 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3AGPfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:35:06 -0500
Date: Mon, 7 Jan 2013 16:34:59 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gerald Schaefer <geraldsc@de.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic/io.h: convert readX defines to functions
Message-ID: <20130107153459.GA6898@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 13010715-1948-0000-0000-000003F4F627
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 75cde984766e7a76d194a11e513a039b5d0a6204 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 7 Jan 2013 14:17:23 +0100
Subject: [PATCH] asm-generic/io.h: convert readX defines to functions

E.g. readl is defined like this

 #define readl(addr) __le32_to_cpu(__raw_readl(addr))

If there is a readl() call that doesn't check the return value
this will cause a compile warning on big endian machines due to
the __le32_to_cpu macro magic.

E.g. code like this:

	readl(addr);

will generate the following compile warning:

warning: value computed is not used [-Wunused-value]

Convert the defines to functions so we get rid of these warnings.
With this patch we get rid of dozens of compile warnings on s390.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/asm-generic/io.h | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 9e0ebe0..2d30764 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -54,8 +54,18 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
 #endif
 
 #define readb __raw_readb
-#define readw(addr) __le16_to_cpu(__raw_readw(addr))
-#define readl(addr) __le32_to_cpu(__raw_readl(addr))
+
+#define readw readw
+static inline u16 readw(const volatile void __iomem *addr)
+{
+	return __le16_to_cpu(__raw_readw(addr));
+}
+
+#define readl readl
+static inline u32 __raw_readl(const volatile void __iomem *addr)
+{
+	return __le32_to_cpu(__raw_readl(addr));
+}
 
 #ifndef __raw_writeb
 static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
@@ -90,7 +100,11 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 }
 #endif
 
-#define readq(addr) __le64_to_cpu(__raw_readq(addr))
+#define readq readq
+static inline u64 readq(const volatile void __iomem *addr)
+{
+	return __le64_to_cpu(__raw_readq(addr));
+}
 
 #ifndef __raw_writeq
 static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
-- 
1.7.12.4

