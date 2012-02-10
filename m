Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2BJFdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:33:43 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49350 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2BJFdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:33:42 -0500
X-AuditID: b753bd60-9825fba00000359c-f0-4f34ac33e157
X-AuditID: b753bd60-9825fba00000359c-f0-4f34ac33e157
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH] [BUGFIX] x86: Fix to decode grouped AVX with VEX pp bits
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Fri, 10 Feb 2012 14:33:40 +0900
Message-ID: <20120210053340.30429.73410.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to decode grouped AVX with VEX pp bits which should be
handled as same as last-prefixes. This fixes below warnings
in posttest with CONFIG_CRYPTO_SHA1_SSSE3=y.


Warning: arch/x86/tools/test_get_len found difference at
<sha1_transform_avx>:ffffffff810d5fc0

Warning: ffffffff810d6069:	c5 f9 73 de 04       	vpsrldq
$0x4,%xmm6,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 4
...


With this change, test_get_len can decode it correctly.


$ arch/x86/tools/test_get_len -v -y
ffffffff810d6069:       c5 f9 73 de 04          vpsrldq $0x4,%xmm6,%xmm0
^D
Succeed: decoded and checked 1 instructions

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 arch/x86/include/asm/inat.h |    5 +++--
 arch/x86/include/asm/insn.h |   18 ++++++++++++------
 arch/x86/lib/inat.c         |   36 ++++++++++++++++++------------------
 arch/x86/lib/insn.c         |   13 +++++++------
 4 files changed, 40 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
index 205b063..74a2e31 100644
--- a/arch/x86/include/asm/inat.h
+++ b/arch/x86/include/asm/inat.h
@@ -97,11 +97,12 @@
 
 /* Attribute search APIs */
 extern insn_attr_t inat_get_opcode_attribute(insn_byte_t opcode);
+extern int inat_get_last_prefix_id(insn_byte_t last_pfx);
 extern insn_attr_t inat_get_escape_attribute(insn_byte_t opcode,
-					     insn_byte_t last_pfx,
+					     int lpfx_id,
 					     insn_attr_t esc_attr);
 extern insn_attr_t inat_get_group_attribute(insn_byte_t modrm,
-					    insn_byte_t last_pfx,
+					    int lpfx_id,
 					    insn_attr_t esc_attr);
 extern insn_attr_t inat_get_avx_attribute(insn_byte_t opcode,
 					  insn_byte_t vex_m,
diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 74df3f1..48eb30a 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -96,12 +96,6 @@ struct insn {
 #define X86_VEX_P(vex)	((vex) & 0x03)		/* VEX3 Byte2, VEX2 Byte1 */
 #define X86_VEX_M_MAX	0x1f			/* VEX3.M Maximum value */
 
-/* The last prefix is needed for two-byte and three-byte opcodes */
-static inline insn_byte_t insn_last_prefix(struct insn *insn)
-{
-	return insn->prefixes.bytes[3];
-}
-
 extern void insn_init(struct insn *insn, const void *kaddr, int x86_64);
 extern void insn_get_prefixes(struct insn *insn);
 extern void insn_get_opcode(struct insn *insn);
@@ -160,6 +154,18 @@ static inline insn_byte_t insn_vex_p_bits(struct insn *insn)
 		return X86_VEX_P(insn->vex_prefix.bytes[2]);
 }
 
+/* Get the last prefix id from last prefix or VEX prefix */
+static inline int insn_last_prefix_id(struct insn *insn)
+{
+	if (insn_is_avx(insn))
+		return insn_vex_p_bits(insn);	/* VEX_p is a SIMD prefix id */
+
+	if (insn->prefixes.bytes[3])
+		return inat_get_last_prefix_id(insn->prefixes.bytes[3]);
+
+	return 0;
+}
+
 /* Offset of each field from kaddr */
 static inline int insn_offset_rex_prefix(struct insn *insn)
 {
diff --git a/arch/x86/lib/inat.c b/arch/x86/lib/inat.c
index 88ad5fb..c1f01a8 100644
--- a/arch/x86/lib/inat.c
+++ b/arch/x86/lib/inat.c
@@ -29,46 +29,46 @@ insn_attr_t inat_get_opcode_attribute(insn_byte_t opcode)
 	return inat_primary_table[opcode];
 }
 
-insn_attr_t inat_get_escape_attribute(insn_byte_t opcode, insn_byte_t last_pfx,
+int inat_get_last_prefix_id(insn_byte_t last_pfx)
+{
+	insn_attr_t lpfx_attr;
+
+	lpfx_attr = inat_get_opcode_attribute(last_pfx);
+	return inat_last_prefix_id(lpfx_attr);
+}
+
+insn_attr_t inat_get_escape_attribute(insn_byte_t opcode, int lpfx_id,
 				      insn_attr_t esc_attr)
 {
 	const insn_attr_t *table;
-	insn_attr_t lpfx_attr;
-	int n, m = 0;
+	int n;
 
 	n = inat_escape_id(esc_attr);
-	if (last_pfx) {
-		lpfx_attr = inat_get_opcode_attribute(last_pfx);
-		m = inat_last_prefix_id(lpfx_attr);
-	}
+
 	table = inat_escape_tables[n][0];
 	if (!table)
 		return 0;
-	if (inat_has_variant(table[opcode]) && m) {
-		table = inat_escape_tables[n][m];
+	if (inat_has_variant(table[opcode]) && lpfx_id) {
+		table = inat_escape_tables[n][lpfx_id];
 		if (!table)
 			return 0;
 	}
 	return table[opcode];
 }
 
-insn_attr_t inat_get_group_attribute(insn_byte_t modrm, insn_byte_t last_pfx,
+insn_attr_t inat_get_group_attribute(insn_byte_t modrm, int lpfx_id,
 				     insn_attr_t grp_attr)
 {
 	const insn_attr_t *table;
-	insn_attr_t lpfx_attr;
-	int n, m = 0;
+	int n;
 
 	n = inat_group_id(grp_attr);
-	if (last_pfx) {
-		lpfx_attr = inat_get_opcode_attribute(last_pfx);
-		m = inat_last_prefix_id(lpfx_attr);
-	}
+
 	table = inat_group_tables[n][0];
 	if (!table)
 		return inat_group_common_attribute(grp_attr);
-	if (inat_has_variant(table[X86_MODRM_REG(modrm)]) && m) {
-		table = inat_group_tables[n][m];
+	if (inat_has_variant(table[X86_MODRM_REG(modrm)]) && lpfx_id) {
+		table = inat_group_tables[n][lpfx_id];
 		if (!table)
 			return inat_group_common_attribute(grp_attr);
 	}
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 5a1f9f3..25feb1a 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -185,7 +185,8 @@ err_out:
 void insn_get_opcode(struct insn *insn)
 {
 	struct insn_field *opcode = &insn->opcode;
-	insn_byte_t op, pfx;
+	insn_byte_t op;
+	int pfx_id;
 	if (opcode->got)
 		return;
 	if (!insn->prefixes.got)
@@ -212,8 +213,8 @@ void insn_get_opcode(struct insn *insn)
 		/* Get escaped opcode */
 		op = get_next(insn_byte_t, insn);
 		opcode->bytes[opcode->nbytes++] = op;
-		pfx = insn_last_prefix(insn);
-		insn->attr = inat_get_escape_attribute(op, pfx, insn->attr);
+		pfx_id = insn_last_prefix_id(insn);
+		insn->attr = inat_get_escape_attribute(op, pfx_id, insn->attr);
 	}
 	if (inat_must_vex(insn->attr))
 		insn->attr = 0;	/* This instruction is bad */
@@ -235,7 +236,7 @@ err_out:
 void insn_get_modrm(struct insn *insn)
 {
 	struct insn_field *modrm = &insn->modrm;
-	insn_byte_t pfx, mod;
+	insn_byte_t pfx_id, mod;
 	if (modrm->got)
 		return;
 	if (!insn->opcode.got)
@@ -246,8 +247,8 @@ void insn_get_modrm(struct insn *insn)
 		modrm->value = mod;
 		modrm->nbytes = 1;
 		if (inat_is_group(insn->attr)) {
-			pfx = insn_last_prefix(insn);
-			insn->attr = inat_get_group_attribute(mod, pfx,
+			pfx_id = insn_last_prefix_id(insn);
+			insn->attr = inat_get_group_attribute(mod, pfx_id,
 							      insn->attr);
 			if (insn_is_avx(insn) && !inat_accept_vex(insn->attr))
 				insn->attr = 0;	/* This is bad */

