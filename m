Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab2C3Kiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:38:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54782 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab2C3Kio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:38:44 -0400
Date: Fri, 30 Mar 2012 11:38:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
	__dma_request_channel()
Message-ID: <20120330103828.GC22981@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1203091022200.7852@axis700.grange> <1331285959.4657.76.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091049060.7852@axis700.grange> <1331520476.4657.79.camel@vkoul-udesk3> <Pine.LNX.4.64.1203161029490.13465@axis700.grange> <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com> <Pine.LNX.4.64.1203161128120.13465@axis700.grange> <CACRpkdY7ApBc-gbSdf+=7PLtKSMvzYuBi7RNnVgi=vjcd-KvhQ@mail.gmail.com> <Pine.LNX.4.64.1203161522570.13465@axis700.grange> <CACRpkdbp3EfF-4z2uuy+gLdXvHqUqj+Zmp-GZxhaHv_RxxRKHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbp3EfF-4z2uuy+gLdXvHqUqj+Zmp-GZxhaHv_RxxRKHQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 07:44:09AM +0200, Linus Walleij wrote:
> However you're right (in some later mail) that we need to distinguish
> between RX/TX channels at this point, so I can agree we need some
> additional parameter, but that should be very abstract, not containing
> any custom stuff or any void * or something like that.

No you don't.  DMA engines can generally deal with transfers operating in
either direction on a single channel.

Where many of the restrictions come from is the way virtual channels are
bound to request signals.

Take for instance MMC, where that is strictly half-duplex.  You're either
transferring data to the card, or from the card.  Why would you want to
claim two channels _if_ there was some way to properly configure the DMA
engine between those two modes?

That's something which is lacking in the current DMA engine API, and the
reason is that the data required to do that is somewhat platform specific
and therefore nebulous.  Eg, it could require a different DMA handshake
signal, different external MUX selection, or something like that.

As I'm looking at converting OMAP to DMA engine, if we persist with our
current approach, I need 128 virtual DMA channels, one per request
signal.  It would be better to either create these on the fly or sort
out some way that channels can be _properly_ reconfigured between
different handshake lines.

Actually, I think that's the key thing: the handshake lines should be
the data involved in channel selection and nothing else - though as I've
pointed out already, there's the complication for external MUXing between
the DMA engine and the peripheral which makes that non-trivial.
