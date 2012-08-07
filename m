Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2HGPud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:50:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56602 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab2HGPuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:50:32 -0400
Date: Tue, 7 Aug 2012 16:50:02 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807155001.GL24257@flint.arm.linux.org.uk>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com> <1344327742.2698.15.camel@pasglop> <20120807082813.GB24257@flint.arm.linux.org.uk> <201208071128.27616.arnd@arndb.de> <20120807113521.GA16861@opensource.wolfsonmicro.com> <20120807114111.GF24257@flint.arm.linux.org.uk> <20120807164555.07c689e1@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807164555.07c689e1@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 04:45:55PM +0100, Alan Cox wrote:
> >  #define IORESOURCE_TYPE_BITS	0x00001f00	/* Resource type */
> >  #define IORESOURCE_IO		0x00000100
> >  #define IORESOURCE_MEM		0x00000200
> > +#define IORESOURCE_FOO		0x00000300
> 
> These are bit masks and checked as such in many places. This makes no
> sense at all.

Correct, but nowhere are they checked as masks in the platform
device/driver code nor the MFD driver code.  Here's the relevant
extracts from the platform driver code:

struct resource *platform_get_resource(struct platform_device *dev,
                                       unsigned int type, unsigned int num)
{
        int i;

        for (i = 0; i < dev->num_resources; i++) {
                struct resource *r = &dev->resource[i];

                if (type == resource_type(r) && num-- == 0)
                        return r;
        }
        return NULL;
}

...
                        if (resource_type(r) == IORESOURCE_MEM)
                                p = &iomem_resource;
                        else if (resource_type(r) == IORESOURCE_IO)
                                p = &ioport_resource;

This is modern code, written using the accessors provided in ioport.h.

resource_type() is defined as:

static inline unsigned long resource_type(const struct resource *res)
{
        return res->flags & IORESOURCE_TYPE_BITS;
}

So, provided these don't leak outside of the platform and the affected
MFD drivers, what the rest of the kernel does doesn't matter.

> Moving to IO_RESOURCE_TYPE() being 0-31 values might be smart but its a
> massive all kernel change.

Only if we want to change the existing numbering _or_ propagate them
outside of platform devices etc, and when that happens that's the time
to start fixing stuff one subsystem at a time.

Of course, if the above helper was being used, we'd already be set.

I don't see that as a blocker to its local use, contained completely
within the MFD and platform device subsystems.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
