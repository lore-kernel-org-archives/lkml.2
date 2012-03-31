Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab2CaKXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 06:23:12 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35043 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab2CaKXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 06:23:09 -0400
Subject: Re: [PATCH] net: bpf_jit: fix BPF_S_ALU_AND_K compilation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: netdev@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <40f4b91c5200771f223966f368095c63.squirrel@webmail.greenhost.nl>
References: <40f4b91c5200771f223966f368095c63.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Mar 2012 12:23:04 +0200
Message-ID: <1333189384.2325.3388.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-31 at 20:52 +1100, Indan Zupancic wrote:
> Hello,
> 
> Finally, after much searching I found one little bug.
> 
> [PATCH] net: bpf_jit: fix BPF_S_ALU_AND_K compilation
> 
> Small typo resulted in bad code generation for certain
> values of K for the BPF_S_ALU_AND_K instruction.
> 
> Signed-off-by: Indan Zupancic <indan@nul.nu>
> ---
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 7c1b765..28bc807 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -289,7 +289,7 @@ void bpf_jit_compile(struct sk_filter *fp)
>  					EMIT2(0x24, K & 0xFF); /* and imm8,%al */
>  				} else if (K >= 0xFFFF0000) {
>  					EMIT2(0x66, 0x25);	/* and imm16,%ax */
> -					EMIT2(K, 2);
> +					EMIT(K, 2);
>  				} else {
>  					EMIT1_off32(0x25, K);	/* and imm32,%eax */
>  				}
> 
> 

Thanks but it was already fixed.

commit 1d24fb3684f347226747c6b11ea426b7b992694e
Author: zhuangfeiran@ict.ac.cn <zhuangfeiran@ict.ac.cn>
Date:   Wed Mar 28 23:27:00 2012 +0000

    x86 bpf_jit: fix a bug in emitting the 16-bit immediate operand of AND
    
    When K >= 0xFFFF0000, AND needs the two least significant bytes of K as
    its operand, but EMIT2() gives it the least significant byte of K and
    0x2. EMIT() should be used here to replace EMIT2().
    
    Signed-off-by: Feiran Zhuang  <zhuangfeiran@ict.ac.cn>
    Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>



