Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab0GEBqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 21:46:31 -0400
Received: from relais.videotron.ca ([24.201.245.36]:45271 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab0GEBq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 21:46:29 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 04 Jul 2010 21:46:27 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the omap tree with the arm tree
In-reply-to: <20100705092055.859d31d8.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.00.1007042144410.6020@xanadu.home>
References: <20100705092055.859d31d8.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jul 2010, Stephen Rothwell wrote:

> Hi all,
> 
> Today's linux-next merge of the omap tree got a conflict in
> arch/arm/kernel/entry-armv.S between commit
> df0698be14c6683606d5df2d83e3ae40f85ed0d9 ("ARM: stack protector: change
> the canary value per task") from the arm tree and commit
> 4481d0c7d25c9de9a3986c8b4c52389ca8bbf929 ("arm: Replace
> CONFIG_HAS_TLS_REG with HWCAP_TLS and check for it on V6") from the omap
> tree.
> 
> Just context changes (I think).  I fixed it up (see below) and can carry
> the fix as necessary.

Yes, the fix is fine.  If you can carry it until either of those is 
merged upstream that would be great.



> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/kernel/entry-armv.S
> index 2d14081,a6cfb17..0000000
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> @@@ -739,17 -740,7 +740,12 @@@ ENTRY(__switch_to
>   #ifdef CONFIG_MMU
>   	ldr	r6, [r2, #TI_CPU_DOMAIN]
>   #endif
> - #if defined(CONFIG_HAS_TLS_REG)
> - 	mcr	p15, 0, r3, c13, c0, 3		@ set TLS register
> - #elif !defined(CONFIG_TLS_REG_EMUL)
> - 	mov	r4, #0xffff0fff
> - 	str	r3, [r4, #-15]			@ TLS val at 0xffff0ff0
> - #endif
> + 	set_tls	r3, r4, r5
>  +#if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
>  +	ldr	r7, [r2, #TI_TASK]
>  +	ldr	r8, =__stack_chk_guard
>  +	ldr	r7, [r7, #TSK_STACK_CANARY]
>  +#endif
>   #ifdef CONFIG_MMU
>   	mcr	p15, 0, r6, c3, c0, 0		@ Set domain register
>   #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
