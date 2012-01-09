Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2AINZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 08:25:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41656 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab2AINZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 08:25:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120109115143.GL21765@n2100.arm.linux.org.uk>
References: <1326033862-25351-1-git-send-email-richard.zhao@linaro.org>
 <1326033862-25351-3-git-send-email-richard.zhao@linaro.org> <20120109115143.GL21765@n2100.arm.linux.org.uk>
From: Eric Miao <eric.miao@linaro.org>
Date: Mon, 9 Jan 2012 21:25:12 +0800
X-Google-Sender-Auth: Ld5OuKImKvYJ_bpsE_GX1OpBEjU
Message-ID: <CAMPhdO84p=0D3KrrFnwup4igoh4oNWXOCbW+BOkoRiC8m=JnmQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] dma/imx-sdma: convert _raw_readl/_raw_writel to readl/writel
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Richard Zhao <richard.zhao@linaro.org>, patches@linaro.org,
        vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, dan.j.williams@intel.com, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 7:51 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Jan 08, 2012 at 10:44:22PM +0800, Richard Zhao wrote:
>> readl/writel is more genric. And if CONFIG_ARM_DMA_MEM_BUFFERABLE,
>> they includes necessary memory barriers.
>
> In a DMA engine driver, you need to use the barrier accessors when:
>
> 1. You finally enable the DMA engine to perform a transfer.
>   The included barrier ensures that writes to the descriptors are visible
>   to the DMA engine.
>
> 2. You read from a status register before examining the descriptors.
>   This ensures that the descriptor accesses won't be ordered before the
>   status register read.
>
> Provided other accesses are within the same 1K region, the remainder of
> them do not have to be the strictly ordered accessors, and you can use
> the _relaxed variants (but only in ARM specific drivers.)

Russell,

Does this also mean when endian conversion is not necessary, the __raw_*
version will be better here? Or generally the _relaxed variants are more
recommended as endian conversion will be optimized away anyway with
these AMBA accesses as both sides are little-endian?

>
> So, if your DMA engine has a control register, and a descriptor pointer
> register, you can write the descriptor pointer register with a
> writel_relaxed().  When you write the control register to enable the
> transfer, use writel() to ensure there's a barrier so the descriptors
> are visible.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
