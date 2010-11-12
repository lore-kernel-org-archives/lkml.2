Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab0KLSBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:01:36 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50939 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932607Ab0KLSBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:21 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 18/20] ARM: LPAE: add support for ATAG_MEM64
Date: Fri, 12 Nov 2010 18:00:38 +0000
Message-Id: <1289584840-18097-19-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:55.0032 (UTC) FILETIME=[8D29C780:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

LPAE provides support for memory banks with physical addresses of up
to 40 bits.

This patch adds a new atag, ATAG_MEM64, so that the Kernel can be
informed about memory that exists above the 4GB boundary.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/setup.h |   10 +++++++++-
 arch/arm/kernel/compat.c     |    4 ++--
 arch/arm/kernel/setup.c      |   12 +++++++++++-
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index 5092118..fab849f 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -43,6 +43,13 @@ struct tag_mem32 {
 	__u32	start;	/* physical start address */
 };
 
+#define ATAG_MEM64	0x54420002
+
+struct tag_mem64 {
+	__u64	size;
+	__u64	start;	/* physical start address */
+};
+
 /* VGA text type displays */
 #define ATAG_VIDEOTEXT	0x54410003
 
@@ -147,7 +154,8 @@ struct tag {
 	struct tag_header hdr;
 	union {
 		struct tag_core		core;
-		struct tag_mem32	mem;
+		struct tag_mem32	mem32;
+		struct tag_mem64	mem64;
 		struct tag_videotext	videotext;
 		struct tag_ramdisk	ramdisk;
 		struct tag_initrd	initrd;
diff --git a/arch/arm/kernel/compat.c b/arch/arm/kernel/compat.c
index 9256523..f224d95 100644
--- a/arch/arm/kernel/compat.c
+++ b/arch/arm/kernel/compat.c
@@ -86,8 +86,8 @@ static struct tag * __init memtag(struct tag *tag, unsigned long start, unsigned
 	tag = tag_next(tag);
 	tag->hdr.tag = ATAG_MEM;
 	tag->hdr.size = tag_size(tag_mem32);
-	tag->u.mem.size = size;
-	tag->u.mem.start = start;
+	tag->u.mem32.size = size;
+	tag->u.mem32.start = start;
 
 	return tag;
 }
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 751ac80..0128db2 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -591,11 +591,21 @@ __tagtable(ATAG_CORE, parse_tag_core);
 
 static int __init parse_tag_mem32(const struct tag *tag)
 {
-	return arm_add_memory(tag->u.mem.start, tag->u.mem.size);
+	return arm_add_memory(tag->u.mem32.start, tag->u.mem32.size);
 }
 
 __tagtable(ATAG_MEM, parse_tag_mem32);
 
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+static int __init parse_tag_mem64(const struct tag *tag)
+{
+	/* We only use 32-bits for the size. */
+	return arm_add_memory(tag->u.mem64.start, (unsigned long)tag->u.mem64.size);
+}
+
+__tagtable(ATAG_MEM64, parse_tag_mem64);
+#endif /* CONFIG_PHYS_ADDR_T_64BIT */
+
 #if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
 struct screen_info screen_info = {
  .orig_video_lines	= 30,
