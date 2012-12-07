Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422966Ab2LGQxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:53:41 -0500
Received: from zmc.proxad.net ([212.27.53.206]:47650 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422904Ab2LGQxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:53:40 -0500
From: Florian Fainelli <ffainelli@freebox.fr>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: mgherzan@gmail.com, rmk+kernel@arm.linux.org.uk,
        Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: net: bpf_jit_32: fix kzalloc gfp/size mismatch.
Date: Fri, 07 Dec 2012 17:51:39 +0100
Message-ID: <2962422.LznIlvkqaJ@flexo>
Organization: Freebox
User-Agent: KMail/4.9.2 (Linux/3.5.0-17-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1354804718-1662-1-git-send-email-nschichan@freebox.fr>
References: <1354804718-1662-1-git-send-email-nschichan@freebox.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2012 15:38:31 Nicolas Schichan wrote:
> Official prototype for kzalloc is:
> 
> void *kzalloc(size_t, gfp_t);
> 
> The ARM bpf_jit code was having the assumption that it was:
> 
> void *kzalloc(gfp_t, size);
> 
> This was resulting the use of some random GFP flags depending on the
> size requested and some random overflows once the really needed size
> was more than the value of GFP_KERNEL.
> 
> This bug was present since the original inclusion of bpf_jit for ARM
> (ddecdfce: ARM: 7259/3: net: JIT compiler for packet filters).
> 
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>

This patch is a stable candidate for kernels 3.4+.

> ---
>  arch/arm/net/bpf_jit_32.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> index c641fb6..a64d349 100644
> --- a/arch/arm/net/bpf_jit_32.c
> +++ b/arch/arm/net/bpf_jit_32.c
> @@ -845,7 +845,7 @@ void bpf_jit_compile(struct sk_filter *fp)
>  	ctx.skf		= fp;
>  	ctx.ret0_fp_idx = -1;
>  
> -	ctx.offsets = kzalloc(GFP_KERNEL, 4 * (ctx.skf->len + 1));
> +	ctx.offsets = kzalloc(4 * (ctx.skf->len + 1), GFP_KERNEL);
>  	if (ctx.offsets == NULL)
>  		return;
>  
> @@ -864,7 +864,7 @@ void bpf_jit_compile(struct sk_filter *fp)
>  
>  	ctx.idx += ctx.imm_count;
>  	if (ctx.imm_count) {
> -		ctx.imms = kzalloc(GFP_KERNEL, 4 * ctx.imm_count);
> +		ctx.imms = kzalloc(4 * ctx.imm_count, GFP_KERNEL);
>  		if (ctx.imms == NULL)
>  			goto out;
>  	}
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
