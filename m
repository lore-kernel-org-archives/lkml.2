Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0IBLUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 07:20:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54902 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab0IBLUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 07:20:42 -0400
Date: Thu, 2 Sep 2010 12:20:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
Message-ID: <20100902112019.GZ26319@n2100.arm.linux.org.uk>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <201008281727.10913.marek.vasut@gmail.com> <20100828161858.GI1473@pengutronix.de> <201008281830.05208.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008281830.05208.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 06:30:05PM +0200, Marek Vasut wrote:
> Dne So 28. srpna 2010 18:18:58 Sascha Hauer napsal(a):
> > Nope, this has nothing to do with static mappings vs. ioremap. The
> > difference is that read[b,w,l] do little endian accesses suitable for
> > PCI whereas the __raw_* functions do accesses in CPU endianess.
> > Peripherals integrated into a SoC like the SDMA engine here are
> > normally accessible in native endianess and thus need the __raw_*
> > functions. An external network controller (for example a LAN9117) will
> > probably need the non raw functions. Note that 99% of the arm users use
> > little endian only and thus cpu_to_le* is a noop, so both types will work
> > for most people.
> 
> Sorry, you got me here. Why do we have io{read,write} then btw. ? That's for 
> x86's io space, right ?

io{read,write} are for use with ioremap/ioport_map, and allow drivers to
be written which can access registers via MMIO or the PC IO space.

If your driver doesn't support the PC IO space (iow, doesn't use
ioport_map) there's no point using the io{read,write} APIs.

Also note that there's one very big difference between read[bwl] and
__raw_read[bwl].  The former have a barrier to ensure correct ordering
for drivers doing DMA, the latter do not.  So if you use the latter and
you care about data being visible to a DMA agent, you have to ensure
you have proper barriers in place.
