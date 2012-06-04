Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689Ab2FDPJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:09:20 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52639 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab2FDPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:09:18 -0400
X-AuditID: b753bd60-925c5ba000002ea5-d3-4fcccf9bf124
X-AuditID: b753bd60-925c5ba000002ea5-d3-4fcccf9bf124
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [BUGFIX PATCH] x86/insn: Fix to decode bsr/bsf/jmpe with operand-size
 prefix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Pekka Enberg <penberg@kernel.org>, <yrl.pp-manager.tt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 05 Jun 2012 00:09:11 +0900
Message-ID: <20120604150911.22338.43296.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix x86 instruction decoder to decode bsr/bsf/jmpe with
operand-size prefix (66h). This fixes below failure of
the test case.

bsf/bsr/jmpe have a special encoding. Opcode map in
Intel Software Developers Manual vol2 says they have
TZCNT/LZCNT variants if it has F3h prefix. However, there
is no information if it has other 66h or F2h prefixes.
Current instruction decoder supposes that those are
a bad instruction, but it actually accept at least
operand-size prefix.

This fixes errors reported by test_get_len as below:

  Warning: arch/x86/tools/test_get_len found difference at
<em_bsf>:ffffffff81036d87
  Warning: ffffffff81036de5:	66 0f bc c2          	bsf    %dx,%ax
  Warning: objdump says 4 bytes, but insn_get_length() says 3
  Warning: arch/x86/tools/test_get_len found difference at
<em_bsr>:ffffffff81036ea6
  Warning: ffffffff81036f04:	66 0f bd c2          	bsr    %dx,%ax
  Warning: objdump says 4 bytes, but insn_get_length() says 3
  Warning: decoded and checked 13298882 instructions with 2 warnings

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 arch/x86/lib/x86-opcode-map.txt      |    8 ++++----
 arch/x86/tools/gen-insn-attr-x86.awk |   14 +++++++++-----
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 8191379..5d7e51f 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -28,7 +28,7 @@
 #  - (66): the last prefix is 0x66
 #  - (F3): the last prefix is 0xF3
 #  - (F2): the last prefix is 0xF2
-#
+#  - (!F3) : the last prefix is not 0xF3 (including non-last prefix case)
 
 Table: one byte opcode
 Referrer:
@@ -515,12 +515,12 @@ b4: LFS Gv,Mp
 b5: LGS Gv,Mp
 b6: MOVZX Gv,Eb
 b7: MOVZX Gv,Ew
-b8: JMPE | POPCNT Gv,Ev (F3)
+b8: JMPE (!F3) | POPCNT Gv,Ev (F3)
 b9: Grp10 (1A)
 ba: Grp8 Ev,Ib (1A)
 bb: BTC Ev,Gv
-bc: BSF Gv,Ev | TZCNT Gv,Ev (F3)
-bd: BSR Gv,Ev | LZCNT Gv,Ev (F3)
+bc: BSF Gv,Ev (!F3) | TZCNT Gv,Ev (F3)
+bd: BSR Gv,Ev (!F3) | LZCNT Gv,Ev (F3)
 be: MOVSX Gv,Eb
 bf: MOVSX Gv,Ew
 # 0x0f 0xc0-0xcf
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 5f6a5b6..ddcf39b 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -66,9 +66,10 @@ BEGIN {
 	rex_expr = "^REX(\\.[XRWB]+)*"
 	fpu_expr = "^ESC" # TODO
 
-	lprefix1_expr = "\\(66\\)"
+	lprefix1_expr = "\\((66|!F3)\\)"
 	lprefix2_expr = "\\(F3\\)"
-	lprefix3_expr = "\\(F2\\)"
+	lprefix3_expr = "\\((F2|!F3)\\)"
+	lprefix_expr = "\\((66|F2|F3)\\)"
 	max_lprefix = 4
 
 	# All opcodes starting with lower-case 'v' or with (v1) superscript
@@ -333,13 +334,16 @@ function convert_operands(count,opnd,       i,j,imm,mod)
 		if (match(ext, lprefix1_expr)) {
 			lptable1[idx] = add_flags(lptable1[idx],flags)
 			variant = "INAT_VARIANT"
-		} else if (match(ext, lprefix2_expr)) {
+		}
+		if (match(ext, lprefix2_expr)) {
 			lptable2[idx] = add_flags(lptable2[idx],flags)
 			variant = "INAT_VARIANT"
-		} else if (match(ext, lprefix3_expr)) {
+		}
+		if (match(ext, lprefix3_expr)) {
 			lptable3[idx] = add_flags(lptable3[idx],flags)
 			variant = "INAT_VARIANT"
-		} else {
+		}
+		if (!match(ext, lprefix_expr)){
 			table[idx] = add_flags(table[idx],flags)
 		}
 	}

