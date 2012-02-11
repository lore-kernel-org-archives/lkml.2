Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2BKXJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:09:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab2BKXJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:09:22 -0500
Date: Sat, 11 Feb 2012 15:08:59 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-f8d98f1095210da708a59f3a0b6fd267ad8f3f03@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120210053340.30429.73410.stgit@localhost.localdomain>
References: <20120210053340.30429.73410.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Fix to decode grouped AVX with VEX pp bits
Git-Commit-ID: f8d98f1095210da708a59f3a0b6fd267ad8f3f03
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 11 Feb 2012 15:09:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8d98f1095210da708a59f3a0b6fd267ad8f3f03
Gitweb:     http://git.kernel.org/tip/f8d98f1095210da708a59f3a0b6fd267ad8f3f03
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 10 Feb 2012 14:33:40 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Feb 2012 15:11:35 +0100

x86: Fix to decode grouped AVX with VEX pp bits

Fix to decode grouped AVX with VEX pp bits which should be
handled as same as last-prefixes. This fixes below warnings
in posttest with CONFIG_CRYPTO_SHA1_SSSE3=y.

 Warning: arch/x86/tools/test_get_len found difference at <sha1_transform_avx>:ffffffff810d5fc0
 Warning: ffffffff810d6069:	c5 f9 73 de 04       	vpsrldq $0x4,%xmm6,%xmm0
 Warning: objdump says 5 bytes, but insn_get_length() says 4
 ...

With this change, test_get_len can decode it correctly.

 $ arch/x86/tools/test_get_len -v -y
 ffffffff810d6069:       c5 f9 73 de 04          vpsrldq $0x4,%xmm6,%xmm0
 Succeed: decoded and checked 1 instructions

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20120210053340.30429.73410.stgit@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
