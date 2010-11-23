Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0KWW3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:29:41 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6458 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab0KWW3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:29:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 23 Nov 2010 14:25:17 -0800
From: James Jones <jajones@nvidia.com>
Organization: NVIDIA
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] ARM: Fix find_next_zero_bit and related assembly
Date: Tue, 23 Nov 2010 15:28:25 -0800
User-Agent: KMail/1.13.3 (Linux/2.6.33.4; KDE/4.4.3; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1289524615-22484-1-git-send-email-jajones@nvidia.com> <alpine.LFD.2.00.1011231625380.9313@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1011231625380.9313@xanadu.home>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011231528.25668.jajones@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 November 2010 13:26:47 Nicolas Pitre wrote:
> On Thu, 11 Nov 2010, James Jones wrote:
> > The find_next_bit, find_first_bit, find_next_zero_bit
> > and find_first_zero_bit functions were not properly
> > clamping to the maxbit argument at the bit level. They
> > were instead only checking maxbit at the byte level.
> > To fix this, add a compare and a conditional move
> > instruction to the end of the common bit-within-the-
> > byte code used by all the functions and be sure not to
> > clobber the maxbit argument before it is used.
> > 
> > Signed-off-by: James Jones <jajones@nvidia.com>
> > Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> 
> Please send to RMK's patch system.

Thanks for the review.  It's already in the patch system, but I updated the 
entry to include your reviewed-by line.

-James

> > ---
> > 
> >  arch/arm/lib/findbit.S |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/lib/findbit.S b/arch/arm/lib/findbit.S
> > index 1e4cbd4..64f6bc1 100644
> > --- a/arch/arm/lib/findbit.S
> > +++ b/arch/arm/lib/findbit.S
> > @@ -174,8 +174,8 @@ ENDPROC(_find_next_bit_be)
> > 
> >   */
> >  
> >  .L_found:
> >  #if __LINUX_ARM_ARCH__ >= 5
> > 
> > -		rsb	r1, r3, #0
> > -		and	r3, r3, r1
> > +		rsb	r0, r3, #0
> > +		and	r3, r3, r0
> > 
> >  		clz	r3, r3
> >  		rsb	r3, r3, #31
> >  		add	r0, r2, r3
> > 
> > @@ -190,5 +190,7 @@ ENDPROC(_find_next_bit_be)
> > 
> >  		addeq	r2, r2, #1
> >  		mov	r0, r2
> >  
> >  #endif
> > 
> > +		cmp	r1, r0			@ Clamp to maxbit
> > +		movlo	r0, r1
> > 
> >  		mov	pc, lr
