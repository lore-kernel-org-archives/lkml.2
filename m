Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab0JHRxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:53:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46149 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab0JHRxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:53:24 -0400
Date: Fri, 8 Oct 2010 18:53:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101008175308.GA10975@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com> <20101007192245.GC26435@n2100.arm.linux.org.uk> <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 12:32:35PM +0300, Felipe Contreras wrote:
> I think when _you_ remove functionality from the architecture, you
> should provide a mechanism that drivers can migrate to. Since there's
> nothing like that, not even a guideline, you are breaking the drivers
> willingly, and expecting other people to fix a difficult problem that
> you yourself have no idea how to fix properly.

We can either wait for people to complain about silent data corruption
or we can be compliant with the architecture specification.  Which is
better - to avoid data corruption and be correct, or allow a system to
become flakey and corrupt people's data.

What I care about is system correctness and people's data - having
multiple mappings with different attributes is documented in very clear
terms as being 'unpredictable' and therefore it isn't permissible to
allow the practice that worked with previous processors (inherently
due to their cache architecture) to continue forward onto processors
with a different cache architecture.

As already discussed, it's nigh on impossible to unmap the existing
direct mapped region (read the previous discussions about why this is)
- which is precisely why there is no direct alternative solution.

The only possible solution is to exclude some memory at boot time from
the system direct map so that it never appears in the direct map, and
use ioremap on _that_.  Another possible alternative is to use highmem,
obtain highmem pages (making sure that it doesn't fall back to lowmem)
and remap them using interfaces such as vmap.

So there are solutions to the problem, but it seems that _no one_ is
willing to discuss it other than "we want our old way back".

If you want the old way back, apply pressure to silicon vendors and
ARM Ltd to change the architecture to lift this restriction - which
will probably mean doing away with aggressive speculative prefetching
so that it's possible to predict what will be in the cache at any
point in time.
