Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1HJPEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:04:25 -0400
Received: from service87.mimecast.com ([94.185.240.25]:42205 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753356Ab1HJPEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:04:14 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v7 15/16] ARM: LPAE: add support for ATAG_MEM64
Date: Wed, 10 Aug 2011 16:03:38 +0100
Message-Id: <1312988619-16804-16-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 10 Aug 2011 15:03:55.0554 (UTC) FILETIME=[B9684820:01CC576E]
X-MC-Unique: 111081016041200301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p7AF4ksT003927

From: Will Deacon <will.deacon@arm.com>

LPAE provides support for memory banks with physical addresses of up
to 40 bits.

This patch adds a new atag, ATAG_MEM64, so that the Kernel can be
informed about memory that exists above the 4GB boundary.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/setup.h |    8 ++++++++
 arch/arm/kernel/setup.c      |   10 ++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index 915696d..a3ca303 100644
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
 
@@ -148,6 +155,7 @@ struct tag {
 	union {
 		struct tag_core		core;
 		struct tag_mem32	mem;
+		struct tag_mem64	mem64;
 		struct tag_videotext	videotext;
 		struct tag_ramdisk	ramdisk;
 		struct tag_initrd	initrd;
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 70bca64..a126558 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -608,6 +608,16 @@ static int __init parse_tag_mem32(const struct tag *tag)
 
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

