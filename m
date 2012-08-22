Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab2HVS4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:56:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4090 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2HVS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:56:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6811"; a="225983180"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sam Ravnborg <sam@ravnborg.org>, David Daney <david.daney@cavium.com>
Subject: [PATCHv2] ARM: Sort exception table at compile time
Date: Wed, 22 Aug 2012 11:56:33 -0700
Message-Id: <1345661793-26468-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1343683803-15507-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ARM machine identifier to sortextable and select the
config option so that we can sort the exception table at compile
time. sortextable relies on a section named __ex_table existing
in the vmlinux, but ARM's linker script places the exception
table in the data section. Give the exception table its own
section so that sortextable can find it.

This allows us to skip the sorting step during boot.

Cc: David Daney <david.daney@cavium.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Changes since v1:
 * Moved exception table next to RO data for XIP builds

 arch/arm/Kconfig              |  1 +
 arch/arm/kernel/vmlinux.lds.S | 19 +++++++++----------
 scripts/sortextable.c         |  1 +
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 6d6e18f..ccf830b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1,6 +1,7 @@
 config ARM
 	bool
 	default y
+	select BUILDTIME_EXTABLE_SORT if MMU
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select HAVE_AOUT
 	select HAVE_DMA_API_DEBUG
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 36ff15b..b9f38e3 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -114,6 +114,15 @@ SECTIONS
 
 	RO_DATA(PAGE_SIZE)
 
+	. = ALIGN(4);
+	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
+		__start___ex_table = .;
+#ifdef CONFIG_MMU
+		*(__ex_table)
+#endif
+		__stop___ex_table = .;
+	}
+
 #ifdef CONFIG_ARM_UNWIND
 	/*
 	 * Stack unwinding tables
@@ -220,16 +229,6 @@ SECTIONS
 		READ_MOSTLY_DATA(L1_CACHE_BYTES)
 
 		/*
-		 * The exception fixup table (might need resorting at runtime)
-		 */
-		. = ALIGN(4);
-		__start___ex_table = .;
-#ifdef CONFIG_MMU
-		*(__ex_table)
-#endif
-		__stop___ex_table = .;
-
-		/*
 		 * and the usual data section
 		 */
 		DATA_DATA
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index 6acf834..ba8f7c1 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -247,6 +247,7 @@ do_file(char const *const fname)
 	case EM_X86_64:
 		custom_sort = sort_x86_table;
 		break;
+	case EM_ARM:
 	case EM_S390:
 	case EM_MIPS:
 		break;
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

