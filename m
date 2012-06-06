Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab2FFPAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:00:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39575 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab2FFPAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:00:45 -0400
Date: Wed, 6 Jun 2012 08:00:28 -0700
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-436d03faf6961b30e13b2d0967aea9d772d6cf44@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, penberg@kernel.org,
        yrl.pp-manager.tt@hitachi.com, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, torvalds@linux-foundation.org,
        penberg@kernel.org, tglx@linutronix.de, yrl.pp-manager.tt@hitachi.com
In-Reply-To: <20120604150911.22338.43296.stgit@localhost.localdomain>
References: <20120604150911.22338.43296.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/decoder: Fix bsr/bsf/
 jmpe decoding with operand-size prefix
Git-Commit-ID: 436d03faf6961b30e13b2d0967aea9d772d6cf44
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:00:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  436d03faf6961b30e13b2d0967aea9d772d6cf44
Gitweb:     http://git.kernel.org/tip/436d03faf6961b30e13b2d0967aea9d772d6cf44
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Tue, 5 Jun 2012 00:09:11 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 08:54:18 +0200

x86/decoder: Fix bsr/bsf/jmpe decoding with operand-size prefix

Fix the x86 instruction decoder to decode bsr/bsf/jmpe with
operand-size prefix (66h). This fixes the test case failure
reported by Linus, attached below.

bsf/bsr/jmpe have a special encoding. Opcode map in
Intel Software Developers Manual vol2 says they have
TZCNT/LZCNT variants if it has F3h prefix. However, there
is no information if it has other 66h or F2h prefixes.
Current instruction decoder supposes that those are
bad instructions, but it actually accepts at least
operand-size prefixes.

H. Peter Anvin further explains:

 " TZCNT/LZCNT are F3 + BSF/BSR exactly because the F2 and
   F3 prefixes have historically been no-ops with most instructions.
   This allows software to unconditionally use the prefixed versions
   and get TZCNT/LZCNT on the processors that have them if they don't
   care about the difference. "

This fixes errors reported by test_get_len:

  Warning: arch/x86/tools/test_get_len found difference at <em_bsf>:ffffffff81036d87
  Warning: ffffffff81036de5:	66 0f bc c2          	bsf    %dx,%ax
  Warning: objdump says 4 bytes, but insn_get_length() says 3
  Warning: arch/x86/tools/test_get_len found difference at <em_bsr>:ffffffff81036ea6
  Warning: ffffffff81036f04:	66 0f bd c2          	bsr    %dx,%ax
  Warning: objdump says 4 bytes, but insn_get_length() says 3
  Warning: decoded and checked 13298882 instructions with 2 warnings

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <yrl.pp-manager.tt@hitachi.com>
Link: http://lkml.kernel.org/r/20120604150911.22338.43296.stgit@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
