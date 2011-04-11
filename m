Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab1DKI4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:56:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50298 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1DKI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:56:29 -0400
Date: Mon, 11 Apr 2011 09:56:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: viresh kumar <viresh.kumar@st.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Amit GOEL <amit.goel@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: dmaengine: Can we schedule new transfer from dma callback
	routine??
Message-ID: <20110411085603.GA13041@n2100.arm.linux.org.uk>
References: <4DA2B3D8.6060707@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA2B3D8.6060707@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 01:25:04PM +0530, viresh kumar wrote:
> 
> Hello,
> 
> In dw_dmac.c driver, dwc_descriptor_complete() routine, following is
> mentioned before calling callback:
> 
> 	/*
> 	 * The API requires that no submissions are done from a
> 	 * callback, so we don't need to drop the lock here
> 	 */
> 	if (callback)
> 		callback(param);
> 
> Does this hold true for dmaengine??

Not for slave devices - see Dan's reply:

http://lists.arm.linux.org.uk/lurker/message/20101223.005313.a38d7bf0.en.html

As the slave API hasn't been well documented, there's a lot of
inconsistency of behaviour between DMA engine slave implementations.
I'd suggest at least fixing slave DMA engine drivers to ensure that:

(a) the callback is always called in tasklet context
(b) the callback can submit new slave transactions (iow, the spinlock
    which prep_slave_sg takes must not be held during the callback.)

The way that others solve this is to move the completed txd structures
to a local 'completed' list, and then walk this list after the spinlocks
have been dropped.

IOW, something like this:

my_tasklet()
{
	INIT_LIST_HEAD(completed);

	spin_lock_irqsave(my_chan->lock);
	for_each_txd(my_txd, my_chan) {
		if (has_completed(my_txd))
			list_add_tail(my_txd->node, &completed);
	}
	spin_unlock_irqrestore(my_chan->lock);

	list_for_each_entry_safe(my_txd, next, &completed, node) {
		void *callback_param = my_txd->txd.callback_param;
		void (*fn)(void *) = my_txd->txd.callback;

		my_txd_free(my_chan, my_txd);

		fn(callback_param);
	}	
}
