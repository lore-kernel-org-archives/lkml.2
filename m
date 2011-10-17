Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1JQOqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:46:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39512 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab1JQOqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <1318859861.23438.137.camel@vkoul-udesk3>
References: <1318844199-19303-1-git-send-email-Barry.Song@csr.com> <1318859861.23438.137.camel@vkoul-udesk3>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 17 Oct 2011 22:45:45 +0800
Message-ID: <CAGsJ_4x35qp+ELFY0vDX3PKSXhTe-POzqv+EO+jbB3ABxs_yrA@mail.gmail.com>
Subject: Re: [PATCH v3] dmaengine: add CSR SiRFprimaII DMAC driver
To: Vinod Koul <vinod.koul@intel.com>
Cc: Barry Song <Barry.Song@csr.com>, Arnd Bergmann <arnd@arndb.de>,
        Rongjun Ying <rongjun.ying@csr.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/17 Vinod Koul <vinod.koul@intel.com>:
>> +static struct dma_async_tx_descriptor *sirfsoc_dma_prep_interleaved(
>> +     struct dma_chan *chan, struct dma_interleaved_template *xt)
>> +{
>> +     struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
>> +     struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
>> +     struct sirfsoc_dma_desc *sdesc = NULL;
>> +     unsigned long iflags;
>> +     int ret;
>> +
>> +     if ((xt->dir != MEM_TO_DEV) || (xt->dir != DEV_TO_MEM)) {
>> +             ret = -EINVAL;
>> +             goto err_dir;
>> +     }
>> +
>> +     /* Get free descriptor */
>> +     spin_lock_irqsave(&schan->lock, iflags);
>> +     if (!list_empty(&schan->free)) {
>> +             sdesc = list_first_entry(&schan->free, struct sirfsoc_dma_desc,
>> +                     node);
>> +             list_del(&sdesc->node);
>> +     }
>> +     spin_unlock_irqrestore(&schan->lock, iflags);
>> +
>> +     if (!sdesc) {
>> +             /* try to free completed descriptors */
>> +             sirfsoc_dma_process_completed(sdma);
>> +             ret = 0;
>> +             goto no_desc;
>> +     }
>> +
>> +     /* Place descriptor in prepared list */
>> +     spin_lock_irqsave(&schan->lock, iflags);
>> +     if ((xt->frame_size == 1) && (xt->numf > 0)) {
> what does this mean?

@numf: Number of frames in this template.
@frame_size: Number of chunks in a frame i.e, size of sgl[].

frame_size==1 means prima2 only support 1 chunk. numf > 0 means
ylen(line number -1) is at least 0 and frame number is at least 1.

>> +             sdesc->cyclic = 0;
>> +             sdesc->xlen = xt->sgl[0].size / 4;
>> +             sdesc->width = (xt->sgl[0].size + xt->sgl[0].icg) / 4;

-barry
