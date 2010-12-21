Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0LUW0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:26:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35447 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0LUW0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:26:05 -0500
Date: Tue, 21 Dec 2010 22:25:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20101221222532.GA7507@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221182037.GA4783@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 06:20:37PM +0000, Russell King - ARM Linux wrote:
> Having just looked at this while trying to undo the DMA API abuses
> in the PL011 UART driver, I'm getting rather frustrated with this
> code.

Here's another couple of problems:

PL011 driver:

+	dmatx->cookie = desc->tx_submit(desc);
+	if (dma_submit_error(dmatx->cookie)) {
+		/* "Complete" DMA (errorpath) */
+		complete(&dmatx->complete);
+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+		return dmatx->cookie;
+	}

dmatx->cookie is of type dma_cookie_t, which is a s32.

MMCI driver:

+	dma_cookie_t cookie;
...
+	cookie = desc->tx_submit(desc);
+
+	/* Here overloaded DMA controllers may fail */
+	if (dma_submit_error(cookie))
+		goto unmap_exit;

#define dma_submit_error(cookie) ((cookie) < 0 ? 1 : 0)

So, DMA errors are negative values returned from the tx_submit function.

PL08x tx_submit method:

static dma_cookie_t pl08x_tx_submit(struct dma_async_tx_descriptor *tx)
{
        struct pl08x_dma_chan *plchan = to_pl08x_chan(tx->chan);

        atomic_inc(&plchan->last_issued);
        tx->cookie = atomic_read(&plchan->last_issued);
        /* This unlock follows the lock in the prep() function */
        spin_unlock_irqrestore(&plchan->lock, plchan->lockflags);

        return tx->cookie;
}

So, after 2^31 DMA transactions, the DMA engine layer continues happily
along with the queued DMA operation, but the driver gets a negative
cookie returned, and so bails out.

I'm also left wondering about that atomic_t.  It's incremented and
read in a locked region, which will in itself prevent two concurrent
increments.  The only other places its used is from dma_tx_status()
where it is only ever read, and on the initialization path.  That to
me makes no sense.

I'll see if I can get to looking at the PL08x stuff once I've finished
sorting out the PL011 UART driver DMA support into a state where I'm
happy that it's doing things correctly.
