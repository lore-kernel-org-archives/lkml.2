Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2HGI2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:28:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55962 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab2HGI23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:28:29 -0400
Date: Tue, 7 Aug 2012 09:28:13 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807082813.GB24257@flint.arm.linux.org.uk>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com> <20120806143016.GK16861@opensource.wolfsonmicro.com> <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com> <20120806154619.GO16861@opensource.wolfsonmicro.com> <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com> <20120806155805.GR16861@opensource.wolfsonmicro.com> <20120806192209.GA14594@flint.arm.linux.org.uk> <20120806195352.GC16199@opensource.wolfsonmicro.com> <20120806213124.GB14594@flint.arm.linux.org.uk> <1344327742.2698.15.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344327742.2698.15.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 06:22:22PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2012-08-06 at 22:31 +0100, Russell King wrote:
> > 
> > So, if we made this a numeric index, then we have 32 resource types
> > to deal with, and no need to bugger around with re-using an existing
> > type for something else.
> > 
> > This makes sense, MEM, IRQ and DMA are all mutually exclusive, as
> > should be MEM and IO (because they can't coexist in two resource trees
> > at the same time.)  BUS only gets used in a hand-full of places and
> > not with any other flags.
> > 
> > So, looks like we can have 27 new resource types fairly easily.
> 
> Besides we can easily use a single IORESOURCE_OTHER for most things
> really, if we prefer, make it IORESOURCE_IO | IORESOURCE_MEM and have
> platform device avoid that combo...

That will work just the same way that I'm suggesting.  We can keep
the existing bit-based numbers, and:

#define IORESOURCE_OTHER	0x00000300

and the platform code will avoid using the standard resource trees,
because it does things correctly here:

                        if (resource_type(r) == IORESOURCE_MEM)
                                p = &iomem_resource;
                        else if (resource_type(r) == IORESOURCE_IO)
                                p = &ioport_resource;

Same for the resource getting functions.  Hardly surprising this, because
I wrote this code...

So, no need to touch any existing users or change their behaviour in
any way.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
