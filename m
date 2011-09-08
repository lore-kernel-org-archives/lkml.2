Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1IICLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:11:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64801 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab1IICLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:11:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Barry Song <21cnbao@gmail.com>
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
Date: Thu, 8 Sep 2011 18:19:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Barry Song <Baohua.Song@csr.com>, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Rongjun Ying <rongjun.ying@csr.com>, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com> <201109081652.20552.arnd@arndb.de> <CAGsJ_4wOQddus_Vz5zUjy-4ETOeaiZ+STRD22SwRy+yr4YLaRA@mail.gmail.com>
In-Reply-To: <CAGsJ_4wOQddus_Vz5zUjy-4ETOeaiZ+STRD22SwRy+yr4YLaRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109081819.30035.arnd@arndb.de>
X-Provags-ID: V02:K0:bQZf6pnWAK3x+6Mp5YLCa5W3xAuAL3qaXvZ8xc8hekg
 LFYSnhbpemWgvlib1dufWz/WpdUV3xm8tbOCJEJkzx59pJzkRB
 382IWbf6DA791s7aZlwjcdKgRAM3h8ACdxGT7LXX8BWGpB9EN+
 yI9mku7qxkAdqlbhAonGKRFiE2BGrrzT72nHPwRKfJ7T8WnyuT
 Oo3wi/zc0U8j8Z027hMY8jYb+8fx2G/fy7WS+fuS3UpWVsC0SL
 rGVUR1UpXQlrfbPpG16mglCpTLYeKyR/g+8Gx0NaUoMKJ8Olea
 iZSSRzJN0UgDS2NRR8s85xb6RN2z0MHnaXi8JiIOxFOuC4t/xb
 7no6RgfWLQ4s1PLvZUsM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011, Barry Song wrote:
> i am not sure whether i have other way to require a special channel
> for a special device. it seems dma_request_channel only gives me a
> chance to use a filter function since my all channels have same DMA
> cap masks.
> 
> this filter is used by all drivers with DMA since every dma channel is
> fixed to be assigned to one device.
> 
> i did do some copy from coh901318.c:
> bool coh901318_filter_id(struct dma_chan *chan, void *chan_id)
> {
>     unsigned int ch_nr = (unsigned int) chan_id;
> 
>     if (ch_nr == to_coh901318_chan(chan)->id)
>         return true;
> 
>     return false;
> }
> EXPORT_SYMBOL(coh901318_filter_id);
> 
> if it does become a common filter,  we might have a function like:
> 
> bool dmaengine_filter_match_channel_id(struct dma_chan *chan, void *chan_id)
> {
>     if (ch_nr == chan->chan_id)
>         return true;
> 
>     return false;
> }
> EXPORT_SYMBOL(dmaengine_filter_match_channel_id);

Ok, I see now. I think it would be best to introduce a generic
'filter by device tree property' function or alternatively an
dma_of_request_channel function like this:

struct dma_chan *dma_of_request_channel(struct device *dev, unsigned int index)
{
	struct dma_device *dmadev;
	struct {
		unsigned int phandle;
		unsigned int channel_num;
	} *property;
	int lenp;

	property = of_get_property(dev->of_node, "dma-channel", &lenp);
	if (lenp < (index * sizeof (*property))
		return -EINVAL;

	property += index;

	dmadev = dma_find_device(of_find_node_by_phandle(property->phandle));
	if (!dmadev)
		return -ENODEV;

	return dma_get_channel(dmadev, property->channel_num);
}

This way, you can link a device to its dma_channel in the device tree without
the device driver even understanding what a dma_device or a channel id
is.

	Arnd
