Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2IRUxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:53:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35369 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2IRUxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:53:13 -0400
Date: Tue, 18 Sep 2012 21:52:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Hunter <jon-hunter@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Benoit Cousson <b-cousson@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Per Forlin <per.forlin@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] dmaengine: add dmanegine slave map api's
Message-ID: <20120918205248.GZ12245@n2100.arm.linux.org.uk>
References: <1347615189-27052-1-git-send-email-vinod.koul@linux.intel.com> <20120914094155.GC12245@n2100.arm.linux.org.uk> <1347619868.1943.113.camel@vkoul-udesk3> <20120914111842.GD12245@n2100.arm.linux.org.uk> <1347853223.1943.136.camel@vkoul-udesk3> <20120917083654.GO12245@n2100.arm.linux.org.uk> <1347875429.1943.141.camel@vkoul-udesk3> <20120917215753.GS12245@n2100.arm.linux.org.uk> <1347938307.1943.166.camel@vkoul-udesk3> <CACRpkdaBiJXowtWm=yTV4_7=6P=SFuVuZo8+icQfE0EN87A23g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaBiJXowtWm=yTV4_7=6P=SFuVuZo8+icQfE0EN87A23g@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 02:20:53PM +0200, Linus Walleij wrote:
> But we're probably the odd exception here so nevermind.
> One day we may test to rip out the logical channel handling and
> use Russell's virtual channel lib to run the show as an experiment.

Note that I'm beginning to add support for the async_tx API stuff into
the virtual channel DMA support, so it can handle the inter-dependencies
between descriptors that async_tx needs.

I'm currently trying to get the design of this right, as the async_tx
needs yet-another-list of descriptors which have been submitted, may
have been processed and completed, but for whatever reason have not
been acknowledged.  Such descriptors can not be freed because the
async_tx API may hold a reference to them, and may dereference them
at any moment to check the dependency situation.

There's a clue in that paragraph about how the DMA engine TX descriptors
_should_ be handled.  "hold a reference" is the clue.  Or another way to
say it, a kref should be embedded in the structure, providing us with
proper reference counting - and descriptors should only be 'freed'
(whether that means actually freeing them or placing them into a free
list) when the last reference is dropped.  That's _much_ better to
understand than this DMA_CTRL_ACK business...

I think switching stuff over to that may simplify things, but it's
going to be absolute hell modifying all the existing DMA engine drivers,
many of which I have no way to test (and probably as Dan has left Intel,
we have a pile of totally untestable drivers now.)
