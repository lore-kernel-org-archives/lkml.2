Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0HBH65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:58:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:35912 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0HBH64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:58:56 -0400
Date: Mon, 2 Aug 2010 07:58:22 GMT
From: tip-bot for Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        marcin.slusarz@gmail.com, fweisbec@gmail.com,
        nouveau@lists.freedesktop.org, rostedt@goodmis.org, pq@iki.fi,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        marcin.slusarz@gmail.com, fweisbec@gmail.com,
        nouveau@lists.freedesktop.org, rostedt@goodmis.org, pq@iki.fi,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100731205101.GA5860@joi.lan>
References: <20100731205101.GA5860@joi.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86,mmiotrace: Add support for tracing STOS instruction
Message-ID: <tip-cc05152ab72d7a65e6ea97d286af4f878c8f7371@git.kernel.org>
Git-Commit-ID: cc05152ab72d7a65e6ea97d286af4f878c8f7371
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:58:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc05152ab72d7a65e6ea97d286af4f878c8f7371
Gitweb:     http://git.kernel.org/tip/cc05152ab72d7a65e6ea97d286af4f878c8f7371
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Sat, 31 Jul 2010 22:51:01 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 2 Aug 2010 01:32:01 +0200

x86,mmiotrace: Add support for tracing STOS instruction

Add support for stos access tracing with mmiotrace.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Pekka Paalanen <pq@iki.fi>
Cc: Nouveau <nouveau@lists.freedesktop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100731205101.GA5860@joi.lan>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/mm/pf_in.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
index 308e325..38e6d17 100644
--- a/arch/x86/mm/pf_in.c
+++ b/arch/x86/mm/pf_in.c
@@ -40,16 +40,16 @@ static unsigned char prefix_codes[] = {
 static unsigned int reg_rop[] = {
 	0x8A, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
 };
-static unsigned int reg_wop[] = { 0x88, 0x89 };
+static unsigned int reg_wop[] = { 0x88, 0x89, 0xAA, 0xAB };
 static unsigned int imm_wop[] = { 0xC6, 0xC7 };
 /* IA32 Manual 3, 3-432*/
-static unsigned int rw8[] = { 0x88, 0x8A, 0xC6 };
+static unsigned int rw8[] = { 0x88, 0x8A, 0xC6, 0xAA };
 static unsigned int rw32[] = {
-	0x89, 0x8B, 0xC7, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
+	0x89, 0x8B, 0xC7, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F, 0xAB
 };
-static unsigned int mw8[] = { 0x88, 0x8A, 0xC6, 0xB60F, 0xBE0F };
+static unsigned int mw8[] = { 0x88, 0x8A, 0xC6, 0xB60F, 0xBE0F, 0xAA };
 static unsigned int mw16[] = { 0xB70F, 0xBF0F };
-static unsigned int mw32[] = { 0x89, 0x8B, 0xC7 };
+static unsigned int mw32[] = { 0x89, 0x8B, 0xC7, 0xAB };
 static unsigned int mw64[] = {};
 #else /* not __i386__ */
 static unsigned char prefix_codes[] = {
@@ -63,20 +63,20 @@ static unsigned char prefix_codes[] = {
 static unsigned int reg_rop[] = {
 	0x8A, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
 };
-static unsigned int reg_wop[] = { 0x88, 0x89 };
+static unsigned int reg_wop[] = { 0x88, 0x89, 0xAA, 0xAB };
 static unsigned int imm_wop[] = { 0xC6, 0xC7 };
-static unsigned int rw8[] = { 0xC6, 0x88, 0x8A };
+static unsigned int rw8[] = { 0xC6, 0x88, 0x8A, 0xAA };
 static unsigned int rw32[] = {
-	0xC7, 0x89, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
+	0xC7, 0x89, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F, 0xAB
 };
 /* 8 bit only */
-static unsigned int mw8[] = { 0xC6, 0x88, 0x8A, 0xB60F, 0xBE0F };
+static unsigned int mw8[] = { 0xC6, 0x88, 0x8A, 0xB60F, 0xBE0F, 0xAA };
 /* 16 bit only */
 static unsigned int mw16[] = { 0xB70F, 0xBF0F };
 /* 16 or 32 bit */
 static unsigned int mw32[] = { 0xC7 };
 /* 16, 32 or 64 bit */
-static unsigned int mw64[] = { 0x89, 0x8B };
+static unsigned int mw64[] = { 0x89, 0x8B, 0xAB };
 #endif /* not __i386__ */
 
 struct prefix_bits {
@@ -410,7 +410,6 @@ static unsigned long *get_reg_w32(int no, struct pt_regs *regs)
 unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs)
 {
 	unsigned int opcode;
-	unsigned char mod_rm;
 	int reg;
 	unsigned char *p;
 	struct prefix_bits prf;
@@ -437,8 +436,13 @@ unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs)
 	goto err;
 
 do_work:
-	mod_rm = *p;
-	reg = ((mod_rm >> 3) & 0x7) | (prf.rexr << 3);
+	/* for STOS, source register is fixed */
+	if (opcode == 0xAA || opcode == 0xAB) {
+		reg = arg_AX;
+	} else {
+		unsigned char mod_rm = *p;
+		reg = ((mod_rm >> 3) & 0x7) | (prf.rexr << 3);
+	}
 	switch (get_ins_reg_width(ins_addr)) {
 	case 1:
 		return *get_reg_w8(reg, prf.rex, regs);
