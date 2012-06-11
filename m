Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2FKN7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:59:23 -0400
Received: from smtp-out-200.synserver.de ([212.40.185.200]:1096 "EHLO
	smtp-out-178.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751007Ab2FKN7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:59:21 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 19005
Message-ID: <4FD5FA82.7090107@metafoo.de>
Date: Mon, 11 Jun 2012 16:02:42 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ASoC: dmaengine-pcm: Add support for querying stream
 position from DMA device
References: <1339416253-4121-1-git-send-email-lars@metafoo.de> <1339416253-4121-2-git-send-email-lars@metafoo.de> <20120611132409.GG11168@n2100.arm.linux.org.uk>
In-Reply-To: <20120611132409.GG11168@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 03:24 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 11, 2012 at 02:04:13PM +0200, Lars-Peter Clausen wrote:
>> @@ -202,7 +203,27 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_trigger);
>>  snd_pcm_uframes_t snd_dmaengine_pcm_pointer(struct snd_pcm_substream *substream)
>>  {
>>  	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
>> -	return bytes_to_frames(substream->runtime, prtd->pos);
>> +	struct dma_tx_state state;
>> +	enum dma_status status;
>> +	unsigned int pos;
>> +
>> +	status = dmaengine_tx_status(prtd->dma_chan, prtd->cookie, &state);
>> +	if (status != DMA_IN_PROGRESS && status != DMA_PAUSED) {
>> +		pos = 0;
>> +	} else if (state.residue == 0) {
>> +		/* This should never happen with cyclic transfers, so assume
>> +		 * that the dmaengine driver does not support reporting residue
>> +		 * and fall back to counting periods. */
>> +		pos = prtd->pos;
> 
> That is an incorrect assumption.
> 
> The current DMA position is defined by the DMA pointer.  When the DMA
> engine has transferred the last few bytes of the DMA, the DMA pointer
> will be pointing to the byte _after_ the last byte transferred in the
> buffer.
> 
> Therefore, when you calculate the residue as (buf_start + buf_len -
> current_pointer) you end up with zero.

My assumption is that for cyclic DMA it will be pointing to the first byte
again after the last byte has been transferred. Something like this:

offset = (offset + 1) % buf_len
and current_pointer = buf_start + offset

If this is not true for a particular DMA controller I think we should still
make sure in the driver for this controller that residue will never be zero
for cyclic transfers, but instead will return the buffer size. This is the
only thing that really makes sense. The buffer only has buf_len bytes, if
residue can be a value in the interval of [0,buf_len] this means that it has
buf_len+1 possible values. Which again means there must be two values which
map to the same state. In this case it would be 0 and buf_len.

> 
> What we need to do is to get rid of this idea that reporting the residue
> is optional for DMA engine drivers.  Let's make it absolutely required
> in order to support cyclic transfers.

While I agree, I don't think we can just rip out the old mechanism until the
platforms which are currently using this have fixed their dmaengine drivers
to provide residue.

- Lars
