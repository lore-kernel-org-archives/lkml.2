Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2GXBJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:09:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45805 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab2GXBJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:09:53 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <nico@linaro.org>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, Cyril Chemparathy <cyril@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [RFC 02/23] ARM: LPAE: use signed arithmetic for mask definitions
Date: Mon, 23 Jul 2012 21:09:04 -0400
Message-ID: <1343092165-9470-3-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343092165-9470-1-git-send-email-cyril@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies to PAGE_MASK, PMD_MASK, and PGDIR_MASK, where forcing
unsigned long math truncates the mask at the 32-bits.  This clearly does bad
things on PAE systems.

This patch fixes this problem by defining these masks as signed quantities.
We then rely on sign extension to do the right thing.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/include/asm/page.h           |    7 ++++++-
 arch/arm/include/asm/pgtable-3level.h |    6 +++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
index ecf9019..1c810d2 100644
--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -13,7 +13,12 @@
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT		12
 #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
-#define PAGE_MASK		(~(PAGE_SIZE-1))
+
+/*
+ * We do not use PAGE_SIZE in the following because we rely on sign
+ * extension to appropriately extend upper bits for PAE systems
+ */
+#define PAGE_MASK		(~((1 << PAGE_SHIFT) - 1))
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index b249035..ae39d11 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -48,16 +48,16 @@
 #define PMD_SHIFT		21
 
 #define PMD_SIZE		(1UL << PMD_SHIFT)
-#define PMD_MASK		(~(PMD_SIZE-1))
+#define PMD_MASK		(~((1 << PMD_SHIFT) - 1))
 #define PGDIR_SIZE		(1UL << PGDIR_SHIFT)
-#define PGDIR_MASK		(~(PGDIR_SIZE-1))
+#define PGDIR_MASK		(~((1 << PGDIR_SHIFT) - 1))
 
 /*
  * section address mask and size definitions.
  */
 #define SECTION_SHIFT		21
 #define SECTION_SIZE		(1UL << SECTION_SHIFT)
-#define SECTION_MASK		(~(SECTION_SIZE-1))
+#define SECTION_MASK		(~((1 << SECTION_SHIFT) - 1))
 
 #define USER_PTRS_PER_PGD	(PAGE_OFFSET / PGDIR_SIZE)
 
-- 
1.7.9.5

