Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2FTOHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:07:25 -0400
Received: from smtp-out-173.synserver.de ([212.40.185.173]:1214 "EHLO
	smtp-out-128.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751553Ab2FTOHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:07:22 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12632
Message-ID: <4FE1D9F7.3000902@metafoo.de>
Date: Wed, 20 Jun 2012 16:11:03 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>, alsa-devel@alsa-project.org,
        Russell King <linux@arm.linux.org.uk>,
        Mika Westerberg <mika.westerberg@iki.fi>, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [alsa-devel] [PATCH v2 3/3] ASoC: dmaengine-pcm: Add support
 for querying stream position from DMA driver
References: <1339438302-12417-1-git-send-email-lars@metafoo.de> <1339438302-12417-3-git-send-email-lars@metafoo.de> <20120620134800.GL10387@shlinux2.ap.freescale.net>
In-Reply-To: <20120620134800.GL10387@shlinux2.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 03:48 PM, Dong Aisheng wrote:
> On Mon, Jun 11, 2012 at 08:11:42PM +0200, Lars-Peter Clausen wrote:
>> Currently the sound dmaengine pcm helper functions implement the pcm_pointer
>> callback by trying to count the number of elapsed periods. This is done by
>> advancing the stream position in the dmaengine callback by one period.
>> Unfortunately there is no guarantee that the callback will be called for each
>> elapsed period. It may be possible that under high system load it is only called
>> once for multiple elapsed periods. This patch addresses the issue by
>> implementing support for querying the current stream position directly from the
>> dmaengine driver. Since not all dmaengine drivers support reporting the stream
>> position yet the old period counting implementation is kept for now.
>>
>> Furthermore the new mechanism allows to report the stream position with a
>> sub-period granularity, given that the dmaengine driver supports this.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>
>> ---
>> Changes since v1:
>> 	* Don't implement fallback support in snd_dmaengine_pcm_pointer, instead it
>> 	  is now moved to its own function. This was done to make it more explicit
>> 	  that implementing residue reporting for cyclic is required and that this
>> 	  won't be optional for new drivers.
>> ---
>>  include/sound/dmaengine_pcm.h |    1 +
>>  sound/soc/soc-dmaengine-pcm.c |   29 ++++++++++++++++++++++++++++-
>>  2 files changed, 29 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/sound/dmaengine_pcm.h b/include/sound/dmaengine_pcm.h
>> index ea57915..b877334 100644
>> --- a/include/sound/dmaengine_pcm.h
>> +++ b/include/sound/dmaengine_pcm.h
>> @@ -38,6 +38,7 @@ void *snd_dmaengine_pcm_get_data(struct snd_pcm_substream *substream);
>>  int snd_hwparams_to_dma_slave_config(const struct snd_pcm_substream *substream,
>>  	const struct snd_pcm_hw_params *params, struct dma_slave_config *slave_config);
>>  int snd_dmaengine_pcm_trigger(struct snd_pcm_substream *substream, int cmd);
>> +snd_pcm_uframes_t snd_dmaengine_pcm_pointer(struct snd_pcm_substream *substream);
>>  snd_pcm_uframes_t snd_dmaengine_pcm_pointer_no_residue(struct snd_pcm_substream *substream);
>>  
>>  int snd_dmaengine_pcm_open(struct snd_pcm_substream *substream,
>> diff --git a/sound/soc/soc-dmaengine-pcm.c b/sound/soc/soc-dmaengine-pcm.c
>> index 7c0877e..2995334 100644
>> --- a/sound/soc/soc-dmaengine-pcm.c
>> +++ b/sound/soc/soc-dmaengine-pcm.c
>> @@ -30,6 +30,7 @@
>>  
>>  struct dmaengine_pcm_runtime_data {
>>  	struct dma_chan *dma_chan;
>> +	dma_cookie_t cookie;
>>  
>>  	unsigned int pos;
>>  
>> @@ -153,7 +154,7 @@ static int dmaengine_pcm_prepare_and_submit(struct snd_pcm_substream *substream)
>>  
>>  	desc->callback = dmaengine_pcm_dma_complete;
>>  	desc->callback_param = substream;
>> -	dmaengine_submit(desc);
>> +	prtd->cookie = dmaengine_submit(desc);
>>  
>>  	return 0;
>>  }
>> @@ -213,6 +214,32 @@ snd_pcm_uframes_t snd_dmaengine_pcm_pointer_no_residue(struct snd_pcm_substream
>>  }
>>  EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_pointer_no_residue);
>>  
>> +/**
>> + * snd_dmaengine_pcm_pointer - dmaengine based PCM pointer implementation
>> + * @substream: PCM substream
>> + *
>> + * This function can be used as the PCM pointer callback for dmaengine based PCM
>> + * driver implementations.
>> + */
>> +snd_pcm_uframes_t snd_dmaengine_pcm_pointer(struct snd_pcm_substream *substream)
>> +{
>> +	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
>> +	struct dma_tx_state state;
>> +	enum dma_status status;
>> +	unsigned int buf_size;
>> +	unsigned int pos = 0;
>> +
>> +	status = dmaengine_tx_status(prtd->dma_chan, prtd->cookie, &state);
>> +	if (status == DMA_IN_PROGRESS || status == DMA_PAUSED) {
>> +		buf_size = snd_pcm_lib_buffer_bytes(substream);
>> +		if (state.residue > 0 && state.residue <= buf_size)
>> +			pos = buf_size - state.residue;
> One question i still not very clear, for the case when one buffer size of cyclic dma
> transfer completes, the dma residue may be buf_size( or 0 as Russell said), then
> pos here is 0. So is it correct that call bytes_to_frames(substream->runtime, 0)
> for this case?
> 

Yes, a residue of 0 and of buf_size are equivalent. And the fact that
residue may be 0 for cyclic DMA is just leakage through our abstraction
layers when cyclic DMA is emulated using "normal" DMA. For real cyclic DMA
residue should never be zero.

The value which is returned by the pcm_pointer callback needs to less than
buffer_size, otherwise the ALSA core code will report an error. So if
residue is 0 and we'd not do any special handling for this case we'd return
buffer_size here.

- Lars

