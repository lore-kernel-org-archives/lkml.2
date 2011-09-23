Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1IWCBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 22:01:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36362 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab1IWCBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 22:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <201109211649.01440.arnd@arndb.de>
References: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com> <201109211649.01440.arnd@arndb.de>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 23 Sep 2011 10:01:30 +0800
Message-ID: <CAGsJ_4x8OkWDPbS85WpRELn5E7wnDuHvONV5jJLED6QamaeQbA@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
To: Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <Baohua.Song@csr.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        vinod.koul@intel.com, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for review and good comments.

2011/9/21 Arnd Bergmann <arnd@arndb.de>:
> Hi Barry,
>
> I just looked at the driver again and stumbled over a potential race:
>
> On Friday 16 September 2011, Barry Song wrote:
>> +
>> +/* Execute all queued DMA descriptors */
>> +static void sirfsoc_dma_execute(struct sirfsoc_dma_chan *schan)
>> +{
>> +       struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(&schan->chan);
>> +       int cid = schan->chan.chan_id;
>> +       struct sirfsoc_dma_desc *sdesc = NULL;
>> +
>> +       sdesc = list_first_entry(&schan->queued, struct sirfsoc_dma_desc,
>> +               node);
>> +       /* Move the first queued descriptor to active list */
>> +       list_move_tail(&schan->queued, &schan->active);
>> +
>> +       /* Start the DMA transfer */
>> +       writel_relaxed(sdesc->width, sdma->base + SIRFSOC_DMA_WIDTH_0 + cid * 4);
>> +       writel_relaxed(cid | (schan->mode << SIRFSOC_DMA_MODE_CTRL_BIT) |
>> +               (schan->direction << SIRFSOC_DMA_DIR_CTRL_BIT),
>> +               sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_CTRL);
>> +       writel_relaxed(sdesc->xlen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_XLEN);
>> +       writel_relaxed(sdesc->ylen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_YLEN);
>> +       writel_relaxed(readl_relaxed(sdma->base + SIRFSOC_DMA_INT_EN) | (1 << cid),
>> +               sdma->base + SIRFSOC_DMA_INT_EN);
>> +       writel_relaxed(schan->addr >> 2, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_ADDR);
>> +}
>
> I think you need to add a memory write barrier somewhere in here, because
> writel_relaxed() does not flush out the CPUs write buffers, unlike writel().
>
> Theoretically, you might be starting a DMA that reads from coherent memory
> but the data is still stuck in the CPU. I assume that the last writel_relaxed()
> is the access that actually starts the DMA, so it should be airtight once you
> replace that with writel().

yes. ARM_DMA_MEM_BUFFERABLE is forced on for CPU_V7 like primaII. we
used __raw_writel or writel_relaxed
before and haven't gotten any bug reported until now. anyway, actually
i need  the IO barrier.

>
>> +/* Interrupt handler */
>> +static irqreturn_t sirfsoc_dma_irq(int irq, void *data)
>> +{
>> +       struct sirfsoc_dma *sdma = data;
>> +       struct sirfsoc_dma_chan *schan;
>> +       u32 is;
>> +       int ch;
>> +
>> +       is = readl_relaxed(sdma->base + SIRFSOC_DMA_CH_INT);
>> +       while ((ch = fls(is) - 1) >= 0) {
>> +               is &= ~(1 << ch);
>> +               writel_relaxed(1 << ch, sdma->base + SIRFSOC_DMA_CH_INT);
>> +               schan = &sdma->channels[ch];
>> +
>> +               spin_lock(&schan->lock);
>> +
>> +               /* Execute queued descriptors */
>> +               list_splice_tail_init(&schan->active, &schan->completed);
>> +               if (!list_empty(&schan->queued))
>> +                       sirfsoc_dma_execute(schan);
>> +
>> +               spin_unlock(&schan->lock);
>> +       }
>
> Similarly, readl_relaxed() does might not force in inbound DMA to be
> completed, causing you to call the tasklet before the data is visible
> to the CPU. While your hardware might have better guarantees, the
> API you are using does not. It should be find when you replace the
> first read_relaxed with readl() here.
>
>        Arnd
>
-barry
