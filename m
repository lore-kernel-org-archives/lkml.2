Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1IHP1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 11:27:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63198 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1IHP1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:27:53 -0400
MIME-Version: 1.0
In-Reply-To: <201109081652.20552.arnd@arndb.de>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com> <201109081652.20552.arnd@arndb.de>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 8 Sep 2011 23:27:32 +0800
Message-ID: <CAGsJ_4wOQddus_Vz5zUjy-4ETOeaiZ+STRD22SwRy+yr4YLaRA@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
To: Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <Baohua.Song@csr.com>, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Rongjun Ying <rongjun.ying@csr.com>, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
Thanks!

2011/9/8 Arnd Bergmann <arnd@arndb.de>
>
> On Wednesday 07 September 2011, Barry Song wrote:
> > +/*
> > + * The DMA controller consists of 16 independent DMA channels.
> > + * Each channel is allocated to a different function
> > + */
> > +bool sirfsoc_dma_filter_id(struct dma_chan *chan, void *chan_id)
> > +{
> > +       unsigned int ch_nr = (unsigned int) chan_id;
> > +
> > +       if (ch_nr == chan->chan_id)
> > +               return true;
> > +
> > +       return false;
> > +}
> > +EXPORT_SYMBOL(sirfsoc_dma_filter_id);
> > +
>
> Hi Barry,
>
> It seems wrong that you have to export this function. The dmaengine API
> should be able to work without this, and when you have drivers using the
> interface, those should not rely on a specific implementation as the
> purpose of the API is specifically to hide that.
>
> Am I missing something?

i am not sure whether i have other way to require a special channel
for a special device. it seems dma_request_channel only gives me a
chance to use a filter function since my all channels have same DMA
cap masks.

this filter is used by all drivers with DMA since every dma channel is
fixed to be assigned to one device.

i did do some copy from coh901318.c:
bool coh901318_filter_id(struct dma_chan *chan, void *chan_id)
{
    unsigned int ch_nr = (unsigned int) chan_id;

    if (ch_nr == to_coh901318_chan(chan)->id)
        return true;

    return false;
}
EXPORT_SYMBOL(coh901318_filter_id);

if it does become a common filter,  we might have a function like:

bool dmaengine_filter_match_channel_id(struct dma_chan *chan, void *chan_id)
{
    if (ch_nr == chan->chan_id)
        return true;

    return false;
}
EXPORT_SYMBOL(dmaengine_filter_match_channel_id);

Another filter is in amba-pl08x.c, it is filtering channel by name:
bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)
{
    struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
    char *name = chan_id;

    /* Check that the channel is not taken! */
    if (!strcmp(plchan->name, name))
        return true;

    return false;
}

>
>        Arnd
>

-barry
