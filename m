Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab1FPPVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:21:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab1FPPVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:21:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Dynamic patching in discarded sections
Date: Thu, 16 Jun 2011 17:21:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>, dave.martin@linaro.org
References: <201106081123.59414.arnd@arndb.de> <alpine.LFD.2.00.1106080946000.2142@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1106080946000.2142@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161721.27330.arnd@arndb.de>
X-Provags-ID: V02:K0:JYQ03gN3e4fP2CR2baQubPJoBAy659PDTQX3iKpTWMd
 XuUiGFCMv1IqCmDVtWE4a4bIuxbG0B/fPrmyyYwdpgM82FxVQ7
 NzxOUTmNQxDAh4AIzSV7t9mc6NQsf+FEPjKCLz+YJ0/TSumwyu
 LvN/Dzjy+3xmdoSFamP+H/MCCdUuVX5UxT1kxscPVRftlW8PWO
 us07rlfvgGN4bqQL7LN1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 June 2011, Nicolas Pitre wrote:
> Dave Martin proposed an extension to gas here (also sent to 
> binutils@sourceware.org):
> 
> http://article.gmane.org/gmane.linux.linaro.toolchain/701
> 
> But as far as I know, nothing further happened. And this is not an ARM 
> specific issue either as the X86 alternates have the same problem.

Ah, yes. That would be really nice to have. Dave, do you still have hopes
that this patch gets merged?

> > I don't know if the same problem exists in other places in the code, but it's
> > entirely possible. I also couldn't think of a good solution for this, short of
> > moving the definition of dma_unmap_single() to out of line code.
> 
> Probably the best interim solution would be:
> 
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index dfbb377..f231c92 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -21,7 +21,8 @@
>  #define ARM_CPU_KEEP(x)
>  #endif
>  
> -#if defined(CONFIG_SMP_ON_UP) && !defined(CONFIG_DEBUG_SPINLOCK)
> +#if (defined(CONFIG_SMP_ON_UP) && !defined(CONFIG_DEBUG_SPINLOCK)) || \
> +    defined(CONFIG_ARM_PATCH_PHYS_VIRT)
>  #define ARM_EXIT_KEEP(x)       x
>  #else
>  #define ARM_EXIT_KEEP(x)
> 
> But clearly the toolchain should be more accommodating instead.
> 

10000 randconfig kernel build later without that patch, I'm rather sure
that there is only a single driver that is suffering from this. While your
patch absolutely makes sense, a less invasive workaround would be to just
not mark mmc_spi_remove as __devexit until Dave's patch gets in.

	Arnd
