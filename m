Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab0LVXpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:45:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41493 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab0LVXpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:45:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HwYI2b/tClRdrPGViXy02HMmcARc/IYxyeJdwIBfYF2d+eFlw0EhmLo1M3TGuyL7a7
         7P0CBqKDzW0wNGUG/IK22cgXpTghA7/BEgSDDMUWCUl4JWUW9wuRtMLkYkOiCJWOGKJE
         SCsyddUJCgp1s5lKZRiUMBLeClYZ75vuLUHsQ=
MIME-Version: 1.0
In-Reply-To: <20101222122904.GC14693@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
Date: Wed, 22 Dec 2010 15:45:39 -0800
X-Google-Sender-Auth: Eegc9RCuuMH3OSwIzAIobyhjpks
Message-ID: <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 4:29 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Dec 21, 2010 at 06:20:37PM +0000, Russell King - ARM Linux wrote:
>> Having just looked at this while trying to undo the DMA API abuses
>> in the PL011 UART driver, I'm getting rather frustrated with this
>> code.
>>
>> What's wrong with the PL08x DMA engine driver?  Well, in the PL011
>> UART driver, you do this:
>>
>> +static void pl011_dma_tx_callback(void *data)
>> +{
>> ...
>> +       /* Refill the TX if the buffer is not empty */
>> +       if (!uart_circ_empty(xmit)) {
>> +               ret = pl011_dma_tx_refill(uap);
>> ...
>> +static int pl011_dma_tx_refill(struct uart_amba_port *uap)
>> +{
>> ...
>> +       /* Prepare the scatterlist */
>> +       desc = chan->device->device_prep_slave_sg(chan,
>> +                                                 &dmatx->scatter,
>> +                                                 1,
>> +                                                 DMA_TO_DEVICE,
>> +                                                 DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>> ...
>> +       /* Some data to go along to the callback */
>> +       desc->callback = pl011_dma_tx_callback;
>> +       desc->callback_param = uap;
>>
>> Note that this calls the channel device_prep_slave_sg() from the
>> callback.  This seems reasonable.
>>
>> Right, now let's look at this driver (from the latest kernel):
>>
>> static void pl08x_tasklet(unsigned long data)
>> {
>> ...
>>         spin_lock(&plchan->lock);
>> ...
>>                 dma_async_tx_callback callback =
>>                         plchan->at->tx.callback;
>>                 void *callback_param =
>>                         plchan->at->tx.callback_param;
>> ...
>>                 /*
>>                  * Callback to signal completion
>>                  */
>>                 if (callback)
>>                         callback(callback_param);
>>
>> Note that the callback is called with the channel lock held.
>>
>> struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
>>                 struct dma_chan *chan, struct scatterlist *sgl,
>>                 unsigned int sg_len, enum dma_data_direction direction,
>>                 unsigned long flags)
>> {
>> ...
>>         ret = pl08x_prep_channel_resources(plchan, txd);
>>         if (ret)
>>                 return NULL;
>>         /*
>>          * NB: the channel lock is held at this point so tx_submit()
>>          * must be called in direct succession.
>>          */
>>
>> XXXXXXXX DEADLOCK XXXXXXXX
>
> Having found one of my ARM platforms which actually supports DMA (such
> a rare thing - neither my Realview EB nor Versatile Express supports it),
> I can finally see about run-time checking some of this.
>
> BUG: spinlock lockup on CPU#0, sh/417, c1870a08
> Backtrace:
> [<c0038880>] (dump_backtrace+0x0/0x10c) from [<c02c20e0>] (dump_stack+0x18/0x1c) r7:c104e000 r6:c1870a08 r5:00000000 r4:00000000
> [<c02c20c8>] (dump_stack+0x0/0x1c) from [<c017b520>] (do_raw_spin_lock+0x118/0x154)
> [<c017b408>] (do_raw_spin_lock+0x0/0x154) from [<c02c4b98>] (_raw_spin_lock_irqsave+0x54/0x60)
> [<c02c4b44>] (_raw_spin_lock_irqsave+0x0/0x60) from [<c01f5828>] (pl08x_prep_channel_resources+0x718/0x8b4)
>  r7:c1870a08 r6:00000001 r5:c19c3560 r4:ffd04010
> [<c01f5110>] (pl08x_prep_channel_resources+0x0/0x8b4) from [<c01f5bb4>] (pl08x_prep_slave_sg+0x120/0x19c)
> [<c01f5a94>] (pl08x_prep_slave_sg+0x0/0x19c) from [<c01be7a0>] (pl011_dma_tx_refill+0x164/0x224)
>  r8:00000020 r7:c03978c0 r6:c1850000 r5:c1847e00 r4:c1847f40
> [<c01be63c>] (pl011_dma_tx_refill+0x0/0x224) from [<c01bf1c8>] (pl011_dma_tx_callback+0x7c/0xc4)
> [<c01bf14c>] (pl011_dma_tx_callback+0x0/0xc4) from [<c01f4d34>] (pl08x_tasklet+0x60/0x368)
>  r5:c18709a0 r4:00000000
> [<c01f4cd4>] (pl08x_tasklet+0x0/0x368) from [<c004d978>] (tasklet_action+0xa0/0x100)
> [<c004d8d8>] (tasklet_action+0x0/0x100) from [<c004e01c>] (__do_softirq+0xa0/0x170)
>  r8:00000006 r7:00000001 r6:00000018 r5:c104e000 r4:00000100
> [<c004df7c>] (__do_softirq+0x0/0x170) from [<c004e140>] (irq_exit+0x54/0x9c)
> [<c004e0ec>] (irq_exit+0x0/0x9c) from [<c0029080>] (asm_do_IRQ+0x80/0xa0)
> [<c0029000>] (asm_do_IRQ+0x0/0xa0) from [<c00345b8>] (__irq_svc+0x38/0xa0)
>
> As described above in my code analysis, pl08x_tasklet takes the spinlock,
> calls pl011_dma_tx_callback and eventually back to pl08x_prep_slave_sg
> and pl08x_prep_channel_resources which then try to take the spinlock
> again, leading to deadlock.

This is listed in the dmaengine documentation [1], but I obviously
missed this before merging.  This also would have been caught by
lockdep as required by SubmitChecklist.  As far as corrective action
before 2.6.37-final.  It looks like this driver needs a full scrub
which seems unreasonable to complete and test over the holidays before
.37 lands.  Linus we either need to mark this "depends on BROKEN" or
revert it.

Support for the DMA_COMPL flags are necessary if the DMA_MEMCPY
capability is advertised, yes this driver got this wrong.  I'll update
the documentation to make this requirement clear, and audit the other
drivers.  With slave-only drivers the only usage model is one where
the client driver owns dma-mapping.  In the non-slave (opportunistic
memcpy offload) case the client is unaware of the engine so the driver
owns unmapping.  The minimal fix is to disable memcpy offload.

--
Dan

[1]
3.6 Constraints:
1/ Calls to async_<operation> are not permitted in IRQ context.  Other
   contexts are permitted provided constraint #2 is not violated.
2/ Completion callback routines cannot submit new operations.  This
   results in recursion in the synchronous case and spin_locks being
   acquired twice in the asynchronous case.
