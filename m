Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2F2PHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:07:24 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19324 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2F2PHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:07:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 29 Jun 2012 08:07:20 -0700
Message-ID: <4FEDC3F8.8000501@nvidia.com>
Date: Fri, 29 Jun 2012 20:34:24 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        Stephen Warren <swarren@nvidia.com>, "perex@perex.cz" <perex@perex.cz>,
        "clemens@ladisch.de" <clemens@ladisch.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ASoC: Move pcm writecombine dma buffer allocation
 to core
References: <1340965398-20872-1-git-send-email-ldewangan@nvidia.com> <s5h7guqxqnd.wl%tiwai@suse.de>
In-Reply-To: <s5h7guqxqnd.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,
Thanks for sample code. It helps lot.

On Friday 29 June 2012 05:43 PM, Takashi Iwai wrote:
> At Fri, 29 Jun 2012 15:53:15 +0530,
> Laxman Dewangan wrote:
>> Some of the ARM based soc allocate the writecombine dma buffer for
>> pcm substreams. They have the same codes for managing this buffer.
>> Moving this to the core/pcm files so that they can use that directly.
>>
>> Remove the code from Tegra PCM and use these new library function.
>>
>> This is enabled only for ARM specific and can be extended to other
>> architecture if they support the writecombine dma buffer.
>>
>> This patch is based on detail discussion on patch:
>> [PATCH] ASoC: snd_dmaengine: add common api for pcm_mmap
>> And suggestion from Lars and Takashi.
> Looking through your patch, I think an easier integration is just to
> add writecombine option to memalloc.c which calls
> dma_alloc_writecombine() instead of dma_alloc_coherent().
>
> The addition for mmap is still an open question.  Again, an easier
> option so far looks like just add the call of dma_alloc_writecombine()
> in snd_pcm_lib_default_mmap().  Alternatively, we can create an
> individual mmap pcm_ops as we discussed.
>
> Below is a totally untested patch, but you can imagine what I meant.
>
> After this change, replace with snd_pcm_lib_malloc_pages with
> SNDRV_DMA_TYPE_DEV_WC, and that's all you need in the driver side.

We can not use the snd_pcm_lib_malloc_pages() in the pcm_new callback 
because at this time the substream->runtime is not initialized and it 
leads to the kernel crash.

I used the apis as

int snd_soc_pcm_new_wc_dma_buffer(struct snd_soc_pcm_runtime *rtd,
                 size_t max_bytes)
{
      :::::::::::::
         substream = pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream;
         if (substream) {
                 substream->dma_buffer.dev.type = SNDRV_DMA_TYPE_DEV_WC;
                 ret = snd_pcm_lib_malloc_pages(substream, max_bytes);
                 if (ret)
                         goto err;
         }
::::::::
}


int snd_pcm_lib_malloc_pages(struct snd_pcm_substream *substream, size_t 
size)
{
         struct snd_pcm_runtime *runtime;
         struct snd_dma_buffer *dmab = NULL;

         if (PCM_RUNTIME_CHECK(substream))
                 return -EINVAL;

         if (snd_BUG_ON(substream->dma_buffer.dev.type ==
                        SNDRV_DMA_TYPE_UNKNOWN))
                 return -EINVAL;

         runtime = substream->runtime;

         if (runtime->dma_buffer_p) {
---------------Kernel crash at this point ----------

So I used the snd_dma_alloc_pages() from the driver to allocate WC memory.


> +/* allocate the coherent DMA pages */
> +static void *snd_malloc_dev_pages(struct device *dev, size_t size, dma_addr_t *dma)
> +{
> +	return __snd_malloc_dev_pages(dev, size, dma, dma_alloc_coherent);

This does not get compiled in ARM because dma_alloc_coherant is macro 
defined as

#define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)

static inline void *dma_alloc_attrs(struct device *dev, size_t size,
                                        dma_addr_t *dma_handle, gfp_t flag,
                                        struct dma_attrs *attrs)


I fixed this by
static void *_dma_alloc_coherent(struct device *dev, size_t size,
                 dma_addr_t *dma_handle, gfp_t flag)
{
         return dma_alloc_coherent(dev, size, dma_handle, flag);
}

/* allocate the coherent DMA pages */
static void *snd_malloc_dev_pages(struct device *dev, size_t size, 
dma_addr_t *dma)
{
         return _snd_malloc_dev_pages(dev, size, dma, _dma_alloc_coherent);
}

