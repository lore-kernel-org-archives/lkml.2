Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2EFIWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 04:22:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab2EFIV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 04:21:56 -0400
Message-ID: <4FA634A0.8020504@redhat.com>
Date: Sun, 06 May 2012 11:21:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Remove stale values from ctxt->memop before
 emulation
References: <1336148056-15662-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1336148056-15662-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 07:14 PM, Joerg Roedel wrote:
> When instruction decoding begins there could be stale values
> in the ctxt->memop structure. This causes problems when an
> instruction is emulated with more op-bytes then the guest
> wants (like the bsr instruction which is always emulated
> with 4 or 8 op-bytes).
>
> The stale value in this structure causes the unit-test for
> the bsrw instruction to fail. Initialize the memop.val with
> 0 to prevent such bugs (an alternative fix could be to
> always emulate instructions with the number of op-bytes
> requested by the guest).
>
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index d4bf50c..1b516ec 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3937,6 +3937,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>  	struct opcode opcode;
>  
>  	ctxt->memop.type = OP_NONE;
> +	ctxt->memop.val  = 0;
>  	ctxt->memopp = NULL;
>  	ctxt->_eip = ctxt->eip;
>  	ctxt->fetch.start = ctxt->_eip;

This only works for long sized values - it doesn't initialize val64 on
i386, for example.  So I think it's better to change bsr (and family) to
use emualte_2op_SrcV_nobyte() instead (which has the added benefit of
using the same values as the processor for the "undefined" bits).

-- 
error compiling committee.c: too many arguments to function

