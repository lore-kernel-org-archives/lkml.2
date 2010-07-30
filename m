Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065Ab0G3STg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:19:36 -0400
Received: from kroah.org ([198.145.64.141]:58788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760019Ab0G3R4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:34 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:44 2010
Message-Id: <20100730175144.757805894@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bin Yang <bin.yang@marvell.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [119/205] ARM: 6226/1: fix kprobe bug in ldr instruction emulation
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Pitre <nico@fluxnic.net>

commit 0ebe25f90cd99bb1bcf622ec8a841421d48380d6 upstream.

From: Bin Yang <bin.yang@marvell.com>

Signed-off-by: Bin Yang <bin.yang@marvell.com>
Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/kprobes-decode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/kprobes-decode.c
+++ b/arch/arm/kernel/kprobes-decode.c
@@ -583,13 +583,14 @@ static void __kprobes emulate_ldr(struct
 {
 	insn_llret_3arg_fn_t *i_fn = (insn_llret_3arg_fn_t *)&p->ainsn.insn[0];
 	kprobe_opcode_t insn = p->opcode;
+	long ppc = (long)p->addr + 8;
 	union reg_pair fnr;
 	int rd = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
 	long rdv;
-	long rnv  = regs->uregs[rn];
-	long rmv  = regs->uregs[rm]; /* rm/rmv may be invalid, don't care. */
+	long rnv = (rn == 15) ? ppc : regs->uregs[rn];
+	long rmv = (rm == 15) ? ppc : regs->uregs[rm];
 	long cpsr = regs->ARM_cpsr;
 
 	fnr.dr = insnslot_llret_3arg_rflags(rnv, 0, rmv, cpsr, i_fn);


