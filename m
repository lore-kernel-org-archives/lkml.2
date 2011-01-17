Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1AQIfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:35:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:50258 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab1AQIfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:35:10 -0500
From: "Stanley.Miao" <stanley.miao@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] support ARM BE8 mode on a little endian machine
Date: Mon, 17 Jan 2011 16:42:08 +0800
Message-Id: <1295253729-23153-3-git-send-email-stanley.miao@windriver.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1295253729-23153-1-git-send-email-stanley.miao@windriver.com>
References: <1295253729-23153-1-git-send-email-stanley.miao@windriver.com>
X-OriginalArrivalTime: 17 Jan 2011 08:35:01.0434 (UTC) FILETIME=[6E8161A0:01CBB621]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When BE8 kernel is running on a little endian machine, the kernel endian
mode need to be converted at the begining of the startup procedure with
the instruction "setend be".

Besides, the tags that the bootloader passed to the kernel are in
little-endian mode and they need to be inverted.

Signed-off-by: Stanley.Miao <stanley.miao@windriver.com>
---
 arch/arm/boot/compressed/head.S |    3 +++
 arch/arm/include/asm/setup.h    |   13 +++++++++----
 arch/arm/kernel/head-common.S   |    6 ++++++
 arch/arm/kernel/setup.c         |   22 +++++++++++-----------
 arch/arm/mm/Kconfig             |    7 +++++++
 5 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index a00055d..a33075b 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -131,6 +131,9 @@ start:
 		mov	r0, r0
 		.endr
 
+#ifdef CONFIG_BE8_ON_LE
+		setend	be
+#endif
 		b	1f
 		.word	0x016f2818		@ Magic numbers to help the loader
 		.word	start			@ absolute load/run zImage address
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index f1e5a9b..1504d09 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -173,15 +173,20 @@ struct tagtable {
 	int (*parse)(const struct tag *);
 };
 
+#ifdef CONFIG_BE8_ON_LE
+#define read_tag(a)	le32_to_cpu(a)
+#else
+#define read_tag(a)	a
+#endif
+
 #define tag_member_present(tag,member)				\
 	((unsigned long)(&((struct tag *)0L)->member + 1)	\
-		<= (tag)->hdr.size * 4)
-
-#define tag_next(t)	((struct tag *)((__u32 *)(t) + (t)->hdr.size))
+		<= read_tag((tag)->hdr.size) * 4)
+#define tag_next(t)	((struct tag *)((__u32 *)(t) + read_tag((t)->hdr.size)))
 #define tag_size(type)	((sizeof(struct tag_header) + sizeof(struct type)) >> 2)
 
 #define for_each_tag(t,base)		\
-	for (t = base; t->hdr.size; t = tag_next(t))
+	for (t = base; read_tag((t)->hdr.size); t = tag_next(t))
 
 #ifdef __KERNEL__
 
diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index bbecaac..37cfa88 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -118,10 +118,16 @@ __vet_atags:
 	bne	1f
 
 	ldr	r5, [r2, #0]			@ is first tag ATAG_CORE?
+#ifdef CONFIG_BE8_ON_LE
+	rev	r5, r5
+#endif
 	cmp	r5, #ATAG_CORE_SIZE
 	cmpne	r5, #ATAG_CORE_SIZE_EMPTY
 	bne	1f
 	ldr	r5, [r2, #4]
+#ifdef CONFIG_BE8_ON_LE
+	rev	r5, r5
+#endif
 	ldr	r6, =ATAG_CORE
 	cmp	r5, r6
 	bne	1f
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3cadb46..9098aa5 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -578,10 +578,10 @@ request_standard_resources(struct meminfo *mi, struct machine_desc *mdesc)
  */
 static int __init parse_tag_core(const struct tag *tag)
 {
-	if (tag->hdr.size > 2) {
-		if ((tag->u.core.flags & 1) == 0)
+	if (read_tag(tag->hdr.size) > 2) {
+		if ((read_tag(tag->u.core.flags) & 1) == 0)
 			root_mountflags &= ~MS_RDONLY;
-		ROOT_DEV = old_decode_dev(tag->u.core.rootdev);
+		ROOT_DEV = old_decode_dev(read_tag(tag->u.core.rootdev));
 	}
 	return 0;
 }
@@ -590,7 +590,7 @@ __tagtable(ATAG_CORE, parse_tag_core);
 
 static int __init parse_tag_mem32(const struct tag *tag)
 {
-	return arm_add_memory(tag->u.mem.start, tag->u.mem.size);
+	return arm_add_memory(read_tag(tag->u.mem.start), read_tag(tag->u.mem.size));
 }
 
 __tagtable(ATAG_MEM, parse_tag_mem32);
@@ -643,7 +643,7 @@ __tagtable(ATAG_SERIAL, parse_tag_serialnr);
 
 static int __init parse_tag_revision(const struct tag *tag)
 {
-	system_rev = tag->u.revision.rev;
+	system_rev = read_tag(tag->u.revision.rev);
 	return 0;
 }
 
@@ -670,7 +670,7 @@ static int __init parse_tag(const struct tag *tag)
 	struct tagtable *t;
 
 	for (t = &__tagtable_begin; t < &__tagtable_end; t++)
-		if (tag->hdr.tag == t->tag) {
+		if ((read_tag(tag->hdr.tag) == t->tag)) {
 			t->parse(tag);
 			break;
 		}
@@ -684,9 +684,9 @@ static int __init parse_tag(const struct tag *tag)
  */
 static void __init parse_tags(const struct tag *t)
 {
-	for (; t->hdr.size; t = tag_next(t))
+	for (; read_tag(t->hdr.size); t = tag_next(t))
 		if (!parse_tag(t))
-			printk(KERN_WARNING
+			early_printk(KERN_WARNING
 				"Ignoring unrecognised tag 0x%08x\n",
 				t->hdr.tag);
 }
@@ -824,16 +824,16 @@ void __init setup_arch(char **cmdline_p)
 	 * If we have the old style parameters, convert them to
 	 * a tag list.
 	 */
-	if (tags->hdr.tag != ATAG_CORE)
+	if (read_tag(tags->hdr.tag) != ATAG_CORE)
 		convert_to_tag_list(tags);
 #endif
-	if (tags->hdr.tag != ATAG_CORE)
+	if (read_tag(tags->hdr.tag) != ATAG_CORE)
 		tags = (struct tag *)&init_tags;
 
 	if (mdesc->fixup)
 		mdesc->fixup(mdesc, tags, &from, &meminfo);
 
-	if (tags->hdr.tag == ATAG_CORE) {
+	if (read_tag(tags->hdr.tag) == ATAG_CORE) {
 		if (meminfo.nr_banks != 0)
 			squash_mem_tags(tags);
 		save_atags(tags);
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index c16ae86..eb74e6b 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -686,6 +686,13 @@ config CPU_ENDIAN_BE32
 	help
 	  Support for the BE-32 (big-endian) mode on pre-ARMv6 processors.
 
+config BE8_ON_LE
+	bool "Run BE8 kernel on a little endian machine"
+	depends on CPU_V6 || CPU_V7
+	select CPU_BIG_ENDIAN
+	help
+	  Run BE8 kernel on a little endian machine.
+
 config CPU_HIGH_VECTOR
 	depends on !MMU && CPU_CP15 && !CPU_ARM740T
 	bool "Select the High exception vector"
-- 
1.5.4.3

