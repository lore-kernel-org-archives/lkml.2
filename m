Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0JINwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 09:52:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58149 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab0JINwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 09:52:21 -0400
Date: Sat, 9 Oct 2010 14:52:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101009135210.GA25564@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 12:44:22PM +0300, Felipe Contreras wrote:
> For issues related to this:
> http://article.gmane.org/gmane.linux.ports.arm.kernel/84454

This one nicely shows some of the problems which can occur with the
memory type attributes - and this is not attributable to ioremap().

ioremap() is used to map devices.  It creates device memory type mappings.
If what you're mapping doesn't support device memory type mappings, then
accesses via an ioremap()'d region isn't going to work - as this guy is
observing.

That's not because ioremap() is doing something wrong.  It's doing what
it's meant to do.  The use is wrong, and is completely unrelated to the
issue you've raised.

> http://article.gmane.org/gmane.linux.ports.sh.devel/8560

This one we know about, and as I've already said, it ends up with three
aliasing mappings each with different attributes thusly:

	cpu = dma_alloc_coherent(dev, size, &dma, GFP_KERNEL);
	dma_declare_coherent_memory(dev, dma, dma, size, DMA_MEMORY_MAP);
		==> ioremap(dma, size);
	...
	dma_alloc_coherent(dev, ...);

This wasn't spotted in the review of sh-mobile code because it's not part
of the sh-mobile code base, but some of the generic sh architecture code.
sh-mobile went into the kernel on March 12th, so it does pre-date the
change to ioremap, and is therefore technically a regression.

However, as can be seen from the link above, it's been known about since
8th August - two months ago.  The problem has been discussed, and we had
a good solution which would work.  But then an oar got thrown in which
basically resulted in that solution being rejected - on the basis that
"it's an established API and it must work".

Well, this usage of the API doesn't work on x86!

The result - progress on the issue hit a brick wall and is unable to
proceed because of personal viewpoints conflicting with reality.

> http://www.spinics.net/lists/linux-fbdev/msg01745.html

External user?  Unreviewed code?  You can't seriously be suggesting
that we should care about code we haven't seen which is sitting
externally to the kernel tree, and this is a valid reason to hold
off on changes to the kernel.

> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/22271

"No file".
