Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab0LUSVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:21:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59392 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0LUSVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:21:52 -0500
Date: Tue, 21 Dec 2010 18:20:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Peter Pearse <peter.pearse@arm.com>,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20101221182037.GA4783@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having just looked at this while trying to undo the DMA API abuses
in the PL011 UART driver, I'm getting rather frustrated with this
code.

What's wrong with the PL08x DMA engine driver?  Well, in the PL011
UART driver, you do this:

+static void pl011_dma_tx_callback(void *data)
+{
...
+       /* Refill the TX if the buffer is not empty */
+       if (!uart_circ_empty(xmit)) {
+               ret = pl011_dma_tx_refill(uap);
...
+static int pl011_dma_tx_refill(struct uart_amba_port *uap)
+{
...
+       /* Prepare the scatterlist */
+       desc = chan->device->device_prep_slave_sg(chan,
+                                                 &dmatx->scatter,
+                                                 1,
+                                                 DMA_TO_DEVICE,
+                                                 DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
...
+       /* Some data to go along to the callback */
+       desc->callback = pl011_dma_tx_callback;
+       desc->callback_param = uap;

Note that this calls the channel device_prep_slave_sg() from the
callback.  This seems reasonable.

Right, now let's look at this driver (from the latest kernel):

static void pl08x_tasklet(unsigned long data)
{
...
        spin_lock(&plchan->lock);
...
                dma_async_tx_callback callback =
                        plchan->at->tx.callback;
                void *callback_param =
                        plchan->at->tx.callback_param;
...
                /*
                 * Callback to signal completion
                 */
                if (callback)
                        callback(callback_param);

Note that the callback is called with the channel lock held.

struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
                struct dma_chan *chan, struct scatterlist *sgl,
                unsigned int sg_len, enum dma_data_direction direction,
                unsigned long flags)
{
...
        ret = pl08x_prep_channel_resources(plchan, txd);
        if (ret)
                return NULL;
        /*
         * NB: the channel lock is held at this point so tx_submit()
         * must be called in direct succession.
         */

XXXXXXXX DEADLOCK XXXXXXXX

Has anyone reviewed the locking in the AMBA PL08x DMA driver?

It also seems to do nothing with the DMA_COMPL_* flags - it's unclear
whether it should, but if a user were to specify one of these flags
and the DMA engine driver ignored it, things would get stuffed as far
as the DMA API goes.

These seem to be some really basic errors - and as such I'm far from
happy with even attempting to use this driver to the point that I'm
thinking about starting again with it.
