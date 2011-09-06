Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1IFOdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:33:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65178 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1IFOdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <1314826214-22428-3-git-send-email-msalter@redhat.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com> <1314826214-22428-3-git-send-email-msalter@redhat.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 6 Sep 2011 15:32:44 +0100
X-Google-Sender-Auth: UdSXId0Km10iDUkKDcwNkzY5-1k
Message-ID: <CAHkRjk7ZMDQh8sYf7N_4LLS12JU2ps8dkC34gNWNH+-Zp0p8Rg@mail.gmail.com>
Subject: Re: [PATCH 2/3] define ARM-specific dma_coherent_write_sync
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ming.lei@canonical.com, stern@rowland.harvard.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 August 2011 22:30, Mark Salter <msalter@redhat.com> wrote:
> For ARM kernels using CONFIG_ARM_DMA_MEM_BUFFERABLE, this patch adds an ARM
> specific dma_coherent_write_sync() to override the default version. This
> routine forces out any data sitting in a write buffer between the CPU and
> memory.
>
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/arm/include/asm/dma-mapping.h |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 7a21d0b..e99562b 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -206,6 +206,16 @@ int dma_mmap_writecombine(struct device *, struct vm_area_struct *,
>                void *, dma_addr_t, size_t);
>
>
> +#ifdef CONFIG_ARM_DMA_MEM_BUFFERABLE
> +#define ARCH_HAS_DMA_COHERENT_WRITE_SYNC
> +
> +static inline void dma_coherent_write_sync(void)
> +{
> +       dsb();
> +       outer_sync();
> +}

That's what mb() and wmb() do already, at least on ARM. Why do we need
another API? IIRC from past discussions on linux-arch around barriers,
the mb() should be sufficient in the case of DMA coherent buffers.
That's why macros like writel() on ARM have the mb() added by default
(for cases where you start the DMA transfer by writing to a device
register).

-- 
Catalin
