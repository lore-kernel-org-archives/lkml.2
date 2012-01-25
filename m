Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab2AYRD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 12:03:29 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16395 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab2AYRD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 12:03:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 25 Jan 2012 09:03:16 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Laxman Dewangan <ldewangan@nvidia.com>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jan 2012 09:03:16 -0800
Subject: RE: [PATCH V1] ARM: tegra: dma: Support variable transfer sizes
Thread-Topic: [PATCH V1] ARM: tegra: dma: Support variable transfer sizes
Thread-Index: AczbU1pKJnu+MAQET3+Ak1FAEwpeiwALsWVQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB8202B@HQMAIL01.nvidia.com>
References: <1327490378-10904-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1327490378-10904-1-git-send-email-ldewangan@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laxman Dewangan wrote at Wednesday, January 25, 2012 4:20 AM:
> Allow the transfer size to vary in each DMA request,
> rather than assuming all requests to be the same size
> as the first request made.
...
> diff --git a/arch/arm/mach-tegra/dma.c b/arch/arm/mach-tegra/dma.c
...
> @@ -434,6 +435,15 @@ static void tegra_dma_update_hw_partial(struct tegra_dma_channel *ch,
>  	writel(apb_ptr, ch->addr + APB_DMA_CHAN_APB_PTR);
>  	writel(ahb_ptr, ch->addr + APB_DMA_CHAN_AHB_PTR);
> 
> +	if (ch->mode & TEGRA_DMA_MODE_CONTINOUS)
> +		ch->req_transfer_count = (req->size >> 3) - 1;
> +	else
> +		ch->req_transfer_count = (req->size >> 2) - 1;

There are cases in the current continuous mode where HW is working on
one buffer and the next buffer is queued in HW. Once we've written the
new request to HW, we don't know exactly which buffer HW is operating
on. Hence, we don't know which buffer ch->req_transfer_count refers to.
If req->size changes, might this change cause the new req->size value
to be used when the old buffer's final completion interrupt goes off
and hence the old buffer's req->bytes_transferred be wrong?

Actually looking at the current continuous mode, I'm not convinced that
it correctly handles replacing an in-progress buffer with a new buffer;
I certainly see where handle_continuous_dma() checks for a second (SW)
queued buffer and tells the HW to use that buffer instead, but I don't
see where the (SW) queue management is done; where is the old req removed
from the head of ch->list and marked complete? I assume the "out of sync"
case is only intended to be an error condition and not part of the
buffer switch?

Perhaps for the current continuous mode, it'd be best to require the
client to dequeue any existing request before queuing another, i.e. to
fail tegra_dma_enqueue_req() if there's already something in ch->list
in continuous mode?

> +	csr = readl(ch->addr + APB_DMA_CHAN_CSR);
> +	csr &= ~CSR_WCOUNT_MASK;
> +	csr |= ch->req_transfer_count << CSR_WCOUNT_SHIFT;
> +	writel(csr, ch->addr + APB_DMA_CHAN_CSR);
> +
>  	req->status = TEGRA_DMA_REQ_INFLIGHT;
>  	return;
>  }

-- 
nvpublic

