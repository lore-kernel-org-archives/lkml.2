Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0IXPpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:45:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52005 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0IXPpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=x244z6bmn1e9lmoVQr8e9qfbN8DiZcdgGMsYWn74tgadB/6MJGSgM9jwt5c8llfZSb
         YsitMvw+5KHLW6ikpHiuV0oHt6kBwLLxgjKbxwrQZVhpOUEjGB84sqay7BHrFv3OHyuA
         S+X3bcUeICWQIzZHbNVR37A2oUw5xneUhtTZ4=
MIME-Version: 1.0
In-Reply-To: <20100924072523.GM23406@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
	<1281956870-12463-3-git-send-email-s.hauer@pengutronix.de>
	<AANLkTin8v_29HESnmhE5==3OLmb29bmoOY1iona4C+eD@mail.gmail.com>
	<20100924072523.GM23406@pengutronix.de>
Date: Fri, 24 Sep 2010 08:45:45 -0700
X-Google-Sender-Auth: 8JxRhcNheHCilR8LGEo-jVSHRNA
Message-ID: <AANLkTi=tY=W05K5N77Xv6kz5CX9U2=Gvm2vDavMN5DSu@mail.gmail.com>
Subject: Re: [PATCH 2/3] dmaengine: add wrapper functions for dmaengine
From: Dan Williams <dan.j.williams@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 12:25 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Hi Dan,
>
> On Thu, Sep 23, 2010 at 12:53:58PM -0700, Dan Williams wrote:
>> > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>> > index 0df7864..635c60b 100644
>> > --- a/include/linux/dmaengine.h
>> > +++ b/include/linux/dmaengine.h
>> > @@ -491,6 +491,47 @@ struct dma_device {
>> >        void (*device_issue_pending)(struct dma_chan *chan);
>> >  };
>> >
>> > +static inline int dmaengine_device_control(struct dma_chan *chan,
>> > +                                          enum dma_ctrl_cmd cmd,
>> > +                                          unsigned long arg)
>> > +{
>> > +       return chan->device->device_control(chan, cmd, arg);
>> > +}
>> > +
>> > +static inline int dmaengine_slave_config(struct dma_chan *chan,
>> > +                                         struct dma_slave_config *config)
>> > +{
>> > +       return dmaengine_device_control(chan, DMA_SLAVE_CONFIG,
>> > +                       (unsigned long)config);
>> > +}
>> > +
>> > +static inline int dmaengine_terminate_all(struct dma_chan *chan)
>> > +{
>> > +       return dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
>> > +}
>> > +
>> > +static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
>> > +               struct dma_chan *chan, struct scatterlist *sgl,
>> > +               unsigned int sg_len, enum dma_data_direction direction,
>> > +               unsigned long flags)
>> > +{
>> > +       return chan->device->device_prep_slave_sg(chan, sgl, sg_len, direction,
>> > +                       flags);
>> > +}
>> > +
>> > +static inline struct dma_async_tx_descriptor *dmaengine_prep_cyclic(
>> > +               struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
>> > +               size_t period_len, enum dma_data_direction direction)
>> > +{
>> > +       return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
>> > +                       period_len, direction);
>> > +}
>> > +
>>
>> No strong disagreements on the above, the type safety of
>> dmaengine_slave_config() is nice.
>
> So you have only small disagreements? ;) I can drop the dmaengine_prep_*
> functions and only keep the device_control functions if like it better.
>

The prep versions may just be code churn, unless there is another
advantage for having a helper... debug/tracing perhaps?

>>
>> > +static inline int dmaengine_tx_submit(struct dma_async_tx_descriptor *desc)
>> > +{
>> > +       return desc->tx_submit(desc);
>> > +}
>>
>> This one can drop the tx.
>
> You mean the function should be named dmaengine_submit?

Yes, the "tx" is often mistaken, understandably, for "transmit".
Linus proposed renaming ->tx_submit() to just ->submit().  This helper
would be a softer way to introduce that rename.

--
Dan
