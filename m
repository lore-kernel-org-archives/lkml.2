Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0JYJBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:01:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46539 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689Ab0JYJBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:01:12 -0400
Subject: [RFC PATCH 16/18] ARM: LPAE: add support for ATAG_MEM64
To: linux-arm-kernel@lists.infradead.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Date: Mon, 25 Oct 2010 10:01:04 +0100
Message-ID: <20101025090104.25275.6292.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-103-g0e84
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 09:01:04.0798 (UTC) FILETIME=[27A4CBE0:01CB7423]
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
index b1f3fe9..a6a37d5 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -556,11 +556,21 @@ __tagtable(ATAG_CORE, parse_tag_core);
 
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

