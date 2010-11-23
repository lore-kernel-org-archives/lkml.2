Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0KWV0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:26:50 -0500
Received: from relais.videotron.ca ([24.201.245.36]:62029 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0KWV0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:26:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 23 Nov 2010 16:26:47 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: James Jones <jajones@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Fix find_next_zero_bit and related assembly
In-reply-to: <1289524615-22484-1-git-send-email-jajones@nvidia.com>
Message-id: <alpine.LFD.2.00.1011231625380.9313@xanadu.home>
References: <1289524615-22484-1-git-send-email-jajones@nvidia.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, James Jones wrote:

> The find_next_bit, find_first_bit, find_next_zero_bit
> and find_first_zero_bit functions were not properly
> clamping to the maxbit argument at the bit level. They
> were instead only checking maxbit at the byte level.
> To fix this, add a compare and a conditional move
> instruction to the end of the common bit-within-the-
> byte code used by all the functions and be sure not to
> clobber the maxbit argument before it is used.
> 
> Signed-off-by: James Jones <jajones@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>

Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>

Please send to RMK's patch system.



> ---
>  arch/arm/lib/findbit.S |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/lib/findbit.S b/arch/arm/lib/findbit.S
> index 1e4cbd4..64f6bc1 100644
> --- a/arch/arm/lib/findbit.S
> +++ b/arch/arm/lib/findbit.S
> @@ -174,8 +174,8 @@ ENDPROC(_find_next_bit_be)
>   */
>  .L_found:
>  #if __LINUX_ARM_ARCH__ >= 5
> -		rsb	r1, r3, #0
> -		and	r3, r3, r1
> +		rsb	r0, r3, #0
> +		and	r3, r3, r0
>  		clz	r3, r3
>  		rsb	r3, r3, #31
>  		add	r0, r2, r3
> @@ -190,5 +190,7 @@ ENDPROC(_find_next_bit_be)
>  		addeq	r2, r2, #1
>  		mov	r0, r2
>  #endif
> +		cmp	r1, r0			@ Clamp to maxbit
> +		movlo	r0, r1
>  		mov	pc, lr
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
