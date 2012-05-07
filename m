Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2EGKSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:18:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab2EGKSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:18:05 -0400
Message-ID: <4FA7A159.8050109@redhat.com>
Date: Mon, 07 May 2012 13:18:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Remove stale values from ctxt->memop before
 emulation
References: <1336148056-15662-1-git-send-email-joerg.roedel@amd.com> <4FA634A0.8020504@redhat.com> <20120507101225.GH4687@amd.com>
In-Reply-To: <20120507101225.GH4687@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 01:12 PM, Joerg Roedel wrote:
> On Sun, May 06, 2012 at 11:21:52AM +0300, Avi Kivity wrote:
> > > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > > index d4bf50c..1b516ec 100644
> > > --- a/arch/x86/kvm/emulate.c
> > > +++ b/arch/x86/kvm/emulate.c
> > > @@ -3937,6 +3937,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
> > >  	struct opcode opcode;
> > >  
> > >  	ctxt->memop.type = OP_NONE;
> > > +	ctxt->memop.val  = 0;
> > >  	ctxt->memopp = NULL;
> > >  	ctxt->_eip = ctxt->eip;
> > >  	ctxt->fetch.start = ctxt->_eip;
> > 
> > This only works for long sized values - it doesn't initialize val64 on
> > i386, for example.  So I think it's better to change bsr (and family) to
> > use emualte_2op_SrcV_nobyte() instead (which has the added benefit of
> > using the same values as the processor for the "undefined" bits).
>
> Right, thats a better solution. How about the attached patch? The zf
> check shouldn't be necessary anymore because the generated assembly uses
> dst.val as input and output so writeback shouldn't do anything wrong.
> The bsr and bsf unittests all pass again with this patch.
>
> 	Joerg
>
> From e9262f18e90111d32b584084c0b5564cbd728d65 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Mon, 7 May 2012 12:05:28 +0200
> Subject: [PATCH] KVM: X86: convert bsf/bsr instructions to
>  emulate_2op_SrcV_nobyte()
>
> The instruction emulation for bsrw is broken in KVM because
> the code always uses bsr with 32 or 64 bit operand size for
> emulation. Fix that by using emulate_2op_SrcV_nobyte() macro
> to use guest operand size for emulation.
>

It looks fine.  Do you know what triggered this regression?  (for
figuring out if it's 3.4 material)

-- 
error compiling committee.c: too many arguments to function

