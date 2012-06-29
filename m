Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab2F2QDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:03:06 -0400
Received: from smtp-out-134.synserver.de ([212.40.185.134]:1292 "EHLO
	smtp-out-132.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932069Ab2F2QDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:03:04 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11340
Message-ID: <4FEDD29C.8040209@metafoo.de>
Date: Fri, 29 Jun 2012 18:06:52 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Takashi Iwai <tiwai@suse.de>, "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>, "perex@perex.cz" <perex@perex.cz>,
        "clemens@ladisch.de" <clemens@ladisch.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ASoC: Move pcm writecombine dma buffer allocation
 to core
References: <1340965398-20872-1-git-send-email-ldewangan@nvidia.com> <s5h7guqxqnd.wl%tiwai@suse.de> <4FEDC3F8.8000501@nvidia.com>
In-Reply-To: <4FEDC3F8.8000501@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 05:04 PM, Laxman Dewangan wrote:
> [...]
> 
> 
>> +/* allocate the coherent DMA pages */
>> +static void *snd_malloc_dev_pages(struct device *dev, size_t size,
>> dma_addr_t *dma)
>> +{
>> +    return __snd_malloc_dev_pages(dev, size, dma, dma_alloc_coherent);
> 
> This does not get compiled in ARM because dma_alloc_coherant is macro
> defined as
> 
> #define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
> 
> static inline void *dma_alloc_attrs(struct device *dev, size_t size,
>                                        dma_addr_t *dma_handle, gfp_t flag,
>                                        struct dma_attrs *attrs)
> 
> 
> I fixed this by
> static void *_dma_alloc_coherent(struct device *dev, size_t size,
>                 dma_addr_t *dma_handle, gfp_t flag)
> {
>         return dma_alloc_coherent(dev, size, dma_handle, flag);
> }
> 
> /* allocate the coherent DMA pages */
> static void *snd_malloc_dev_pages(struct device *dev, size_t size,
> dma_addr_t *dma)
> {
>         return _snd_malloc_dev_pages(dev, size, dma, _dma_alloc_coherent);
> }

I think all dma_alloc_* functions use dma_alloc_attrs internally these days.
I think it might be a better idea just to use dma_alloc_attrs in
__snd_malloc_dev_pages and just pass a dma_attrs struct instead of a function.

Something like:

static void *__snd_malloc_dev_pages(struct device *dev, size_t size,
			    dma_addr_t *dma, struct dma_attrs *attrs)
{
....
	res = dma_alloc_attrs(dev, PAGE_SIZE << pg, dma, gfp_flags, attrs);
....
}


static void *snd_malloc_dev_pages(struct device *dev, size_t size,
	dma_addr_t *dma)
{
	return __snd_malloc_dev_pages(dev, size, dma, NULL);
}

static void *snd_malloc_dev_wc_pages(struct device *dev, size_t size,
	dma_addr_t *dma)
{
	DEFINE_DMA_ATTRS(attrs);
	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);

	return __snd_malloc_dev_pages(dev, size, dma, &attrs);
}

Same applies for freeing the memory again.

- Lars
