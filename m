Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab2LGXEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:04:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48435 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2LGXEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:04:45 -0500
Message-ID: <50C2760A.9070406@gmail.com>
Date: Sat, 08 Dec 2012 00:04:42 +0100
From: Mircea Gherzan <mgherzan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Nicolas Schichan <nschichan@freebox.fr>
CC: rmk+kernel@arm.linux.org.uk, Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: net: bpf_jit_32: fix kzalloc gfp/size mismatch.
References: <1354804718-1662-1-git-send-email-nschichan@freebox.fr>
In-Reply-To: <1354804718-1662-1-git-send-email-nschichan@freebox.fr>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.12.2012 15:38, schrieb Nicolas Schichan:
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

Acked-by: Mircea Gherzan <mgherzan@gmail.com>
