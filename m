Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2AZBqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:46:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9386 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2AZBqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:46:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 25 Jan 2012 17:46:10 -0800
Message-ID: <4F20B03A.3030303@nvidia.com>
Date: Thu, 26 Jan 2012 07:15:30 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1] ARM: tegra: dma: Support variable transfer sizes
References: <1327490378-10904-1-git-send-email-ldewangan@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF178CB8202B@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178CB8202B@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 January 2012 10:33 PM, Stephen Warren wrote:
> Laxman Dewangan wrote at Wednesday, January 25, 2012 4:20 AM:
>> Allow the transfer size to vary in each DMA request,
>> rather than assuming all requests to be the same size
>> as the first request made.
> ...
>> diff --git a/arch/arm/mach-tegra/dma.c b/arch/arm/mach-tegra/dma.c
> ...
>> @@ -434,6 +435,15 @@ static void tegra_dma_update_hw_partial(struct tegra_dma_channel *ch,
>>   	writel(apb_ptr, ch->addr + APB_DMA_CHAN_APB_PTR);
>>   	writel(ahb_ptr, ch->addr + APB_DMA_CHAN_AHB_PTR);
>>
>> +	if (ch->mode&  TEGRA_DMA_MODE_CONTINOUS)
>> +		ch->req_transfer_count = (req->size>>  3) - 1;
>> +	else
>> +		ch->req_transfer_count = (req->size>>  2) - 1;
> There are cases in the current continuous mode where HW is working on
> one buffer and the next buffer is queued in HW. Once we've written the
> new request to HW, we don't know exactly which buffer HW is operating
> on. Hence, we don't know which buffer ch->req_transfer_count refers to.
> If req->size changes, might this change cause the new req->size value
> to be used when the old buffer's final completion interrupt goes off
> and hence the old buffer's req->bytes_transferred be wrong?

Then byte_transferred should be calculated based on req->size, not based 
on ch->req_transfer_count.
Still issue may come when we need to read the transfered count from dma 
through status register whether it has completed the old and started new 
one or still on old req. This can be resolved by having proper lock 
between the isr and reading status so that if isr clears the 
interrupt_done, just raise a flag that int_done arrive and so 
get-active_count() function can handle it properly before workqueu get 
scheduled. I am seeing that there is  missing synchronization between 
int_done status and get_active_count().
I am also thinking that we can remove the work queue and handle the 
queue management in isr only

> Actually looking at the current continuous mode, I'm not convinced that
> it correctly handles replacing an in-progress buffer with a new buffer;
> I certainly see where handle_continuous_dma() checks for a second (SW)
> queued buffer and tells the HW to use that buffer instead, but I don't
> see where the (SW) queue management is done; where is the old req removed
> from the head of ch->list and marked complete? I assume the "out of sync"
> case is only intended to be an error condition and not part of the
> buffer switch?
We are removing the old req from list in handling of full buffer 
interrupt handling.

660                 } else if (req->buffer_status ==
661                         TEGRA_DMA_REQ_BUF_STATUS_HALF_FULL) {
:::::::::::::::::::::::::::::::::::::::
670                         req->buffer_status = 
TEGRA_DMA_REQ_BUF_STATUS_FULL;
671                         req->bytes_transferred = bytes_transferred;
672                         req->status = TEGRA_DMA_REQ_SUCCESS;
673                         list_del(&req->node);


> Perhaps for the current continuous mode, it'd be best to require the
> client to dequeue any existing request before queuing another, i.e. to
> fail tegra_dma_enqueue_req() if there's already something in ch->list
> in continuous mode?
>
>> +	csr = readl(ch->addr + APB_DMA_CHAN_CSR);
>> +	csr&= ~CSR_WCOUNT_MASK;
>> +	csr |= ch->req_transfer_count<<  CSR_WCOUNT_SHIFT;
>> +	writel(csr, ch->addr + APB_DMA_CHAN_CSR);
>> +
>>   	req->status = TEGRA_DMA_REQ_INFLIGHT;
>>   	return;
>>   }

