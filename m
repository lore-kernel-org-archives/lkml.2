Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2A0KHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:07:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4494 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2A0KHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:07:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 27 Jan 2012 02:07:17 -0800
Message-ID: <4F227728.9070400@nvidia.com>
Date: Fri, 27 Jan 2012 15:36:32 +0530
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
References: <1327490378-10904-1-git-send-email-ldewangan@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF178CB8202B@HQMAIL01.nvidia.com> <4F20B03A.3030303@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF178CB82335@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178CB82335@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 January 2012 10:23 PM, Stephen Warren wrote:
> Laxman Dewangan wrote at Wednesday, January 25, 2012 6:46 PM:
>> On Wednesday 25 January 2012 10:33 PM, Stephen Warren wrote:
>>> Laxman Dewangan wrote at Wednesday, January 25, 2012 4:20 AM:
>>>> Allow the transfer size to vary in each DMA request,
>
>> Still issue may come when we need to read the transfered count from dma
>> through status register whether it has completed the old and started new
>> one or still on old req. This can be resolved by having proper lock
>> between the isr and reading status so that if isr clears the
>> interrupt_done, just raise a flag that int_done arrive and so
>> get-active_count() function can handle it properly before workqueu get
>> scheduled. I am seeing that there is  missing synchronization between
>> int_done status and get_active_count().
>> I am also thinking that we can remove the work queue and handle the
>> queue management in isr only
>>
> So I assume you need to make some/all of those modifications before we can
> apply this patch?
>
Ok, I will push that patches first and then we can go for this patch.

>>> Actually looking at the current continuous mode, I'm not convinced that
>>> it correctly handles replacing an in-progress buffer with a new buffer;
>>> I certainly see where handle_continuous_dma() checks for a second (SW)
>>> queued buffer and tells the HW to use that buffer instead, but I don't
>>> see where the (SW) queue management is done; where is the old req removed
>>> from the head of ch->list and marked complete? I assume the "out of sync"
>>> case is only intended to be an error condition and not part of the
>>> buffer switch?
>> We are removing the old req from list in handling of full buffer
>> interrupt handling.
>>
>> 660                 } else if (req->buffer_status ==
>> 661                         TEGRA_DMA_REQ_BUF_STATUS_HALF_FULL) {
>> :::::::::::::::::::::::::::::::::::::::
>> 670                         req->buffer_status =
>> TEGRA_DMA_REQ_BUF_STATUS_FULL;
>> 671                         req->bytes_transferred = bytes_transferred;
>> 672                         req->status = TEGRA_DMA_REQ_SUCCESS;
>> 673                         list_del(&req->node);
> Oh right... Maybe I'm misunderstanding continuous mode works then; I
> thought that the client driver queued a request once, and it continued
> to execute forever until either a new request was queued to replace it,
> or the original request for dequeued. It looks like instead, the req
> is always removed from the queue once we've seen both the ping and the
> pong interrupts. Am I totally misunderstanding what's happening?
>
I agree that many issues are there in this piece of code.
Originally, continuous double support was added only for glitch less 
audio playback. The audio driver makes some requests and the request in 
dma-queue get programmed before the current dma complete and so after 
buffer transfer completion, it will jump to newly programmed value 
without pausing or transfer gap in dma transfer and so no audio glitch. 
The last request was always like silence so that dma can be stop before 
wrapping up actual audio data. Some of the code is missing in this file 
which was fixed.
Currently the audio driver is not using the continuous double buffering 
mechanism, it is using the oneshot dma and you may have small glitches 
in audio when you run higher sampling rate audio.

Here I agree with your thought: continuous double buffering mechanism 
should be in loop if it is last request i.e. do not delete last req 
until client call dequeue or stop_dma. If new request queued then dma 
will start transfer to new address/size once current is completed and 
loop on that request forever.

Currently it is not implemented like that. I will correct this with 
proper documentation on header file about this mode.



