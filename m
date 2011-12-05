Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab1LERmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:42:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58759 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab1LERmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:42:19 -0500
Date: Mon, 5 Dec 2011 09:42:01 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-130b78b2bf16d5d89091db38374faef896360cf9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111205120539.15475.91428.stgit@cloud>
References: <20111205120539.15475.91428.stgit@cloud>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Fix instruction decoder to handle grouped AVX instructions
Git-Commit-ID: 130b78b2bf16d5d89091db38374faef896360cf9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:42:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  130b78b2bf16d5d89091db38374faef896360cf9
Gitweb:     http://git.kernel.org/tip/130b78b2bf16d5d89091db38374faef896360cf9
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 5 Dec 2011 21:05:39 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 14:53:15 +0100

x86: Fix instruction decoder to handle grouped AVX instructions

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

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20111205120539.15475.91428.stgit@cloud
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
