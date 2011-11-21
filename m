Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1KUJIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:08:09 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50856 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab1KUJIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:08:04 -0500
X-AuditID: b753bd60-9ea82ba000000655-48-4eca14f157d3
X-AuditID: b753bd60-9ea82ba000000655-48-4eca14f157d3
Subject: [PATCH 2/4] [BUGFIX] x86: Fix instruction decoder to handle grouped
 AVX instructions
To: Ingo Molnar <mingo@elte.hu>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 22 Nov 2011 03:11:11 +0900
Message-ID: <20111121181111.27410.37362.stgit@cloud>
In-Reply-To: <20111121181044.27410.263.stgit@cloud>
References: <20111121181044.27410.263.stgit@cloud>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For reducing memory usage of attribute table, x86 instruction
decoder puts "Group" attribute only on "no-last-prefix"
attribute table (same as vex_p == 0 case).

Thus, the decoder should look no-last-prefix table first, and
then only if it is not a group, move on to "with-last-prefix"
table (vex_p != 0).

However, current implementation, inat_get_avx_attribute()
looks with-last-prefix directly. So, when decoding
a grouped AVX instruction, the decoder fails to find correct
group because there is no "Group" attribute on the table.
This ends up with the mis-decoding of instructions, as Ingo
reported in http://thread.gmane.org/gmane.linux.kernel/1214103


This patch fixes it to check no-last-prefix table first
even if that is an AVX instruction, and get an attribute from
"with last-prefix" table only if that is not a group.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/lib/inat.c |    9 ++++++++-
 arch/x86/lib/insn.c |    4 +++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/inat.c b/arch/x86/lib/inat.c
index 46fc4ee..88ad5fb 100644
--- a/arch/x86/lib/inat.c
+++ b/arch/x86/lib/inat.c
@@ -82,9 +82,16 @@ insn_attr_t inat_get_avx_attribute(insn_byte_t opcode, insn_byte_t vex_m,
 	const insn_attr_t *table;
 	if (vex_m > X86_VEX_M_MAX || vex_p > INAT_LSTPFX_MAX)
 		return 0;
-	table = inat_avx_tables[vex_m][vex_p];
+	/* At first, this checks the master table */
+	table = inat_avx_tables[vex_m][0];
 	if (!table)
 		return 0;
+	if (!inat_is_group(table[opcode]) && vex_p) {
+		/* If this is not a group, get attribute directly */
+		table = inat_avx_tables[vex_m][vex_p];
+		if (!table)
+			return 0;
+	}
 	return table[opcode];
 }
 
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 374562e..5a1f9f3 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -202,7 +202,7 @@ void insn_get_opcode(struct insn *insn)
 		m = insn_vex_m_bits(insn);
 		p = insn_vex_p_bits(insn);
 		insn->attr = inat_get_avx_attribute(op, m, p);
-		if (!inat_accept_vex(insn->attr))
+		if (!inat_accept_vex(insn->attr) && !inat_is_group(insn->attr))
 			insn->attr = 0;	/* This instruction is bad */
 		goto end;	/* VEX has only 1 byte for opcode */
 	}
@@ -249,6 +249,8 @@ void insn_get_modrm(struct insn *insn)
 			pfx = insn_last_prefix(insn);
 			insn->attr = inat_get_group_attribute(mod, pfx,
 							      insn->attr);
+			if (insn_is_avx(insn) && !inat_accept_vex(insn->attr))
+				insn->attr = 0;	/* This is bad */
 		}
 	}
 

