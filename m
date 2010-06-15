Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab0FOE51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 00:57:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39415 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0FOE50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 00:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RN4RyssPp3hxC5QgZcV5xquBYeTLEtA5excXDRIwf+NKZaK9VcpBBadpsATEW4dzRf
         rN6MSi83F5ANnx/jDd7svVMv/fzxV8BY9sNfVmgy8DCz+cGBd27XlheT8Y2ce+fyNqtW
         PN6IrTFLfDtyzo3OhBGiYbMVm2H3vme3V02FA=
MIME-Version: 1.0
In-Reply-To: <CEE6BB42CAD6E947908279175AF8470A025E5ADB78@EXDCVYMBSTM006.EQ1STM.local>
References: <1275394835-26161-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTinR-mwXyrGlrCg2TCR3DtPewBPnaoZf_MWySJzX@mail.gmail.com>
	<CEE6BB42CAD6E947908279175AF8470A025E5ADB78@EXDCVYMBSTM006.EQ1STM.local>
Date: Mon, 14 Jun 2010 21:57:25 -0700
X-Google-Sender-Auth: DO8Kd-Ej3XNWwaxi2iqEzpGrja4
Message-ID: <AANLkTikCR8e-9yMFzgFAOoyizpEFHJtKsfpNt08Conzu@mail.gmail.com>
Subject: Re: [PATCH 02/18] DMAENGINE: ste_dma40: only write phy channel config 
	first time
From: Dan Williams <dan.j.williams@intel.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jonas ABERG <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 9:39 AM, Linus WALLEIJ
<linus.walleij@stericsson.com> wrote:
> Thanks Dan,
>
> Is it OK that we send a new version of the entire patch set trying
> to address all comments? (Then hopefully you can merge forward
> through the set until there is some further issue.)

There other patches were fine.  If you could just send replacement
patches for the ones I commented on I'll get this merged and pushed
out.

>
> On 06/12/2010 12:23 AM, Dan Williams wrote:
>> On Tue, Jun 1, 2010 at 5:20 AM, Linus Walleij
>> <linus.walleij@stericsson.com> wrote:
>>> We only need to write the configuration to a physical channel if it
>>> is free, else it is already written.
>>>
>>> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
>>> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>>> ---
>>>  drivers/dma/ste_dma40.c |   19 +++++++++++++------
>>>  1 files changed, 13 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c index
>>> 4618d6c..1cd1ff7 100644
>>> --- a/drivers/dma/ste_dma40.c
>>> +++ b/drivers/dma/ste_dma40.c
>>> @@ -1211,9 +1211,9 @@ out:
>>>  }
>>>
>>>  static int d40_config_chan(struct d40_chan *d40c,
>>> -                          struct stedma40_chan_cfg *info)
>>> +                          struct stedma40_chan_cfg *info,
>>> +                          bool is_free_phy)
>>>  {
>>> -
>>>        /* Fill in basic CFG register values */
>>>        d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
>>>                    &d40c->dst_def_cfg, d40c->log_num !=
>>> D40_PHY_CHAN); @@ -1230,8 +1230,14 @@ static int d40_config_chan(struct d40_chan *d40c,
>>>                                d40c->dma_cfg.dst_dev_type * 32 + 16;
>>>        }
>>>
>>> -       /* Write channel configuration to the DMA */
>>> -       return d40_config_write(d40c);
>>> +       /*
>>> +        * Only write channel configuration to the DMA if the physical
>>> +        * resource is free. In case of multiple logical channels
>>> +        * on the same physical resource, only the first write is necessary.
>>> +        */
>>> +       if (is_free_phy)
>>> +               return d40_config_write(d40c);
>>> +       return 0;
>>>  }
>>>
>>>  static int d40_config_memcpy(struct d40_chan *d40c) @@ -1691,7
>>> +1697,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
>>>        unsigned long flags;
>>>        struct d40_chan *d40c =
>>>                container_of(chan, struct d40_chan, chan);
>>> -
>>> +       bool is_free_phy;
>>>        spin_lock_irqsave(&d40c->lock, flags);
>>>
>>>        d40c->completed = chan->cookie = 1; @@ -1705,6 +1711,7 @@
>>> static int d40_alloc_chan_resources(struct dma_chan *chan)
>>>                if (err)
>>>                        goto err_alloc;
>>>        }
>>> +       is_free_phy = (d40c->phy_chan == NULL);
>>>
>>
>> It seems like d40_config_chan() just wants to be open coded in
>> d40_alloc_chan_resources().  It does not have its own local variables,
>> and the only thing that returns an error is d40_config_write().
>
> True. There are a few more such smaller functions that shall be removed.
> I will do the clean up in a second version of this patch set, ok?

Ok, or it could be incremental to this set... either way is fine.

>> While trying to figure out why this flag was needed I happened to
>> notice a gratuitous use of gotos in d40_allocate_channel().  Can we
>> make this function easier to read by just returning -EINVAL directly
>> when those tests fail?
>
> We'll try to see if I can make this function easier to read with less gotos.
>
> Yours,
> Linus Walleij

Thanks,
Dan
