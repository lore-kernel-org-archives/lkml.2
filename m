Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2EGKMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:12:33 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:22156
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754061Ab2EGKMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:12:31 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944hd25he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3NDOR-01-1NK-02
X-M-MSG: 
Date: Mon, 7 May 2012 12:12:25 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: Remove stale values from ctxt->memop before
 emulation
Message-ID: <20120507101225.GH4687@amd.com>
References: <1336148056-15662-1-git-send-email-joerg.roedel@amd.com>
 <4FA634A0.8020504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FA634A0.8020504@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 11:21:52AM +0300, Avi Kivity wrote:
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index d4bf50c..1b516ec 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -3937,6 +3937,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
> >  	struct opcode opcode;
> >  
> >  	ctxt->memop.type = OP_NONE;
> > +	ctxt->memop.val  = 0;
> >  	ctxt->memopp = NULL;
> >  	ctxt->_eip = ctxt->eip;
> >  	ctxt->fetch.start = ctxt->_eip;
> 
> This only works for long sized values - it doesn't initialize val64 on
> i386, for example.  So I think it's better to change bsr (and family) to
> use emualte_2op_SrcV_nobyte() instead (which has the added benefit of
> using the same values as the processor for the "undefined" bits).

Right, thats a better solution. How about the attached patch? The zf
check shouldn't be necessary anymore because the generated assembly uses
dst.val as input and output so writeback shouldn't do anything wrong.
The bsr and bsf unittests all pass again with this patch.

	Joerg

>From e9262f18e90111d32b584084c0b5564cbd728d65 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Mon, 7 May 2012 12:05:28 +0200
Subject: [PATCH] KVM: X86: convert bsf/bsr instructions to
 emulate_2op_SrcV_nobyte()

The instruction emulation for bsrw is broken in KVM because
the code always uses bsr with 32 or 64 bit operand size for
emulation. Fix that by using emulate_2op_SrcV_nobyte() macro
to use guest operand size for emulation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/emulate.c |   26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0d151e2..a6f8488 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3134,35 +3134,13 @@ static int em_btc(struct x86_emulate_ctxt *ctxt)
 
 static int em_bsf(struct x86_emulate_ctxt *ctxt)
 {
-	u8 zf;
-
-	__asm__ ("bsf %2, %0; setz %1"
-		 : "=r"(ctxt->dst.val), "=q"(zf)
-		 : "r"(ctxt->src.val));
-
-	ctxt->eflags &= ~X86_EFLAGS_ZF;
-	if (zf) {
-		ctxt->eflags |= X86_EFLAGS_ZF;
-		/* Disable writeback. */
-		ctxt->dst.type = OP_NONE;
-	}
+	emulate_2op_SrcV_nobyte(ctxt, "bsf");
 	return X86EMUL_CONTINUE;
 }
 
 static int em_bsr(struct x86_emulate_ctxt *ctxt)
 {
-	u8 zf;
-
-	__asm__ ("bsr %2, %0; setz %1"
-		 : "=r"(ctxt->dst.val), "=q"(zf)
-		 : "r"(ctxt->src.val));
-
-	ctxt->eflags &= ~X86_EFLAGS_ZF;
-	if (zf) {
-		ctxt->eflags |= X86_EFLAGS_ZF;
-		/* Disable writeback. */
-		ctxt->dst.type = OP_NONE;
-	}
+	emulate_2op_SrcV_nobyte(ctxt, "bsr");
 	return X86EMUL_CONTINUE;
 }
 
-- 
1.7.9.5


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

