Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2A0WQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 17:16:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:50812 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab2A0WQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 17:16:18 -0500
Message-ID: <1327702566.24487.26.camel@pasglop>
Subject: Re: Probing unconfigured PCI bridge resouces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Jan 2012 09:16:06 +1100
In-Reply-To: <20120127093658.27dc258b@jbarnes-desktop>
References: <1327379147.19850.29.camel@pasglop>
	 <1327380633.19850.33.camel@pasglop>
	 <20120127093658.27dc258b@jbarnes-desktop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 09:36 -0800, Jesse Barnes wrote:

> > Ok, I think I was missing pci_bridge_check_ranges(), gotta figure now
> > why this didn't kick in properly for me, probably some arch code
> > crackpot.
> > 
> > One thing I noticed is that we do clear IORESOURCE_UNSET in setup-res.c
> > when setting up a device resource but we don't clear it for bridges in
> > generic code ever, so it leaks all the way through from my early arch
> > code. Not a big deal but annoying.
> 
> Maybe you can fix that when you unify your arch resource handling code
> with the core one day. :)
> 
> There have been a lot of changes to handle re-allocation and such, and
> I'm sure there's more duplication now...

There isn't much the my arch does that isn't just calling into core
nowadays on powerpc, look at my resource survey :-)

I have some slightly different (arguably better ?) logic to deal with
unassigned resources in the initial allocation pass before re-assigning
(or assigning unassigned) and flags to enable ignoring the initial state
of devices (which should be improved with core changes one of these
days, for example we still read all bridge bases even when we know we
are just going to re-assign everything etc...).

The one thing I cannot unify is actually new in 3.3, it's the code to
assign resources on the new "powernv" platform which requires its own
logic unfortunately and I'm not sure I can make the core do what I want
without major uglyness.

The main reason is that on p7ioc and similar recent IBM host bridges, we
have a domain mechanism which allows error isolation, dma isolation
etc... which also encompass MMIO (in order to properly assign MMIO
errors such as target aborts etc... with a domain).

The way this works is by segmenting the MMIO space, which means that all
BARs of a all devices in a given domain shall be assigned to a group of
segments. Now I -can- renumber 32-bit segments so in theory I could get
away with alignment tricks (tho nasty ones) only but I can't always
renumber 64-bit segments (tho in my current scheme I simply don't use
64-bit MMIO segments at all, in part due to that complication).

The consequence is that I need to pre-assign domains at boot based on
various constraints and policy decisions which unfortunately have to be
made by the kernel arbitrarily, and then tweak the MMIO resource
allocation to assign BARs of devices accordingly so they fit into
"segments" that can be made to correspond with the domains.

Cheers,
Ben.


