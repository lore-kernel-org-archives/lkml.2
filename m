Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1LVTMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:12:51 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30407 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1LVTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:12:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6568"; a="149325029"
Date: Thu, 22 Dec 2011 11:12:47 -0800
From: David Brown <davidb@codeaurora.org>
To: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Trilok Soni <tsoni@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] msm: DMAEngine: Add DMAEngine driver based on old
 MSM DMA APIs
Message-ID: <20111222191247.GA23943@codeaurora.org>
References: <1324559312-23684-1-git-send-email-kumarrav@codeaurora.org>
 <1324559312-23684-2-git-send-email-kumarrav@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324559312-23684-2-git-send-email-kumarrav@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 06:38:32PM +0530, Ravi Kumar V wrote:

> --- a/arch/arm/mach-msm/include/mach/dma.h
> +++ b/arch/arm/mach-msm/include/mach/dma.h
> @@ -18,6 +18,59 @@
>  #include <linux/list.h>
>  #include <mach/msm_iomap.h>
>  
> +#ifdef CONFIG_NEED_SG_DMA_LENGTH
> +#define msm_dma_len(sg, len)		(((sg)->dma_length) = \
> +					(((sg)->dma_length) & 0xFFFF0000) | \
> +					(len & 0xFFFF))
> +#define msm_dma_mode(sg, mode)		(((sg)->dma_length) = \
> +					(((sg)->dma_length) & 0xFFFCFFFF) | \
> +					(mode << 16))
> +#define msm_dma_crci(sg, crci)		(((sg)->dma_length) = \
> +					(((sg)->dma_length) & 0x0003FFFF) | \
> +					(crci << 15))
> +#define msm_dma_endian(sg, en)		(((sg)->dma_length) = \
> +					(((sg)->dma_length) & 0x03FFFFFF) | \
> +					(en << 26))
> +#else
> +#define msm_dma_len(sg, len)		(((sg)->length) = \
> +					(((sg)->length) & 0xFFFF0000) | \
> +					(len & 0xFFFF))
> +#define msm_dma_mode(sg, mode)		(((sg)->length) = \
> +					(((sg)->length) & 0xFFFCFFFF) | \
> +					(mode << 16))
> +#define msm_dma_crci(sg, crci)		(((sg)->length) = \
> +					(((sg)->length) & 0x0003FFFF) | \
> +					(crci << 15))
> +#define msm_dma_endian(sg, en)		(((sg)->length) = \
> +					(((sg)->length) & 0x03FFFFFF) | \
> +					(en << 26))
> +#endif
> +#define msm_dma_offset(sg, val)		(((sg)->offset) = \
> +					(((sg)->offset) & 0xFFFF0000) | \
> +					(val & 0xFFFF))
> +#define msm_dma_row_count(sg, cnt)	(((sg)->offset) = \
> +					(((sg)->offset) & 0x0000FFFF) | \
> +					(cnt << 16))
> +#define msm_dma_address(sg)		((sg)->dma_address)

It looks like you are encoding some extra data in the
dma_length/length and offsets fields of the scatterlist.  At a
minimum, this needs some explanation, but I'm not sure this is quite
the right approach.

The problem is that a driver using DMAEngine would need to know about
this extra information to really be able to use the MSM dma.

Some descriptions of the bits, which are still defined in
arch/arm/mach-msm/include/mach/dma.h:

  - Mode: one of SINGLE, SG, IND_SG, or BOX.  Existing drivers seem
    to only make use of SINGLE (by implication, being zero), and BOX
    mode.  This driver looks like it handles these two cases as well,
    building the proper types of descriptors.

  - CRCI: an MSM-specific term for the flow-control channels on the
    DMA controller.  These are small integers describing which CRCI
    channel is connected to which device.

  - Endian: Some bits directing the controller to perform various
    types of endian conversions as it transfers the data.

Current drivers that are using the current dmov dma interface seem to
be drivers/mmc/host/msm_sdcc.c and drivers/tty/serial/msm_serial_hs.c.
Both make use of the BOX mode, and require a CRCI channel.

The question is how do would we extend DMAEngine to support these
concepts.  Supporting BOX mode, and being able to describe the
flow-control channel are probably the most significant.

A good starting point will be to figure out what other DMA hardware
supports, and might need out of DMAEngine.

It's certainly a possibility to put the driver in as is, but the
clients would have to know the MSM-specific features to be able to use
themic features to be able to use them.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
