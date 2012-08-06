Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2HFVbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:31:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55646 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2HFVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:31:40 -0400
Date: Mon, 6 Aug 2012 22:31:24 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120806213124.GB14594@flint.arm.linux.org.uk>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com> <20120806143016.GK16861@opensource.wolfsonmicro.com> <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com> <20120806154619.GO16861@opensource.wolfsonmicro.com> <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com> <20120806155805.GR16861@opensource.wolfsonmicro.com> <20120806192209.GA14594@flint.arm.linux.org.uk> <20120806195352.GC16199@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806195352.GC16199@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 08:53:52PM +0100, Mark Brown wrote:
> On Mon, Aug 06, 2012 at 08:22:09PM +0100, Russell King wrote:
> > On Mon, Aug 06, 2012 at 04:58:06PM +0100, Mark Brown wrote:
> 
> > > That's one reason why I've not attacked this problem myself, but frankly
> > > I'm totally happy with using _IO here so I've not looked particularly
> > > closely.
> 
> > NO.  This is stupid.  We've been here before, and I've said what I'm
> > saying below before too.
> 
> > IORESOURCE_IO is for PCI/ISA IO resources.
> > IORESOURCE_MEM is for _memory mapped_ IO resources.
> 
> > On ARM, we only have memory mapped IO resources, with the exception that
> > if we have a real PCI/ISA bus, we give them IORESOURCE_IO resources.
> 
> > Never use IORESOURCE_IO for anything but PCI/ISA bus IO resources. Ever.
> 
> *sigh*  You must be aware that this isn't getting us anywhere.  As you
> know the issues here aren't practical ones if we make sure the resource
> trees are split (which is what Haojian should really be doing if he's
> not done so already) and that the resource code is sadly difficult to
> modify to support new resource types due to the full bitmask that
> Haojian mentioned.  
> 
> Clearly nobody has the combination of time and interest to add a new
> resource type and we do have actual systems running now (and for the
> past several years) relying on this.
> 
> To be perfectly frank I have a hard time convincing myself that there's
> any real problem with the current solution; obviously it's not what _IO
> was originally intended for but having several different trees of
> resources seems like a reasonable extension here and the effort involved
> in any other changes seems disproportionately high.  I guess we could
> formalise it by making an alias for _IO but I doubt that'd address the
> concerns you have.

So, the fact that platform devices will get any resource marked
IORESOURCE_IO registered against ioport_resource isn't a problem
then...

Anyway, given that this thread is broken, there's no way for me to find
out what the _original_ issue is that you're talking about.  So I'm going
to guess that it's come up because we're out of IORESOURCE bits.

Let's look a little closer:

#define IORESOURCE_TYPE_BITS    0x00001f00      /* Resource type */
#define IORESOURCE_IO           0x00000100
#define IORESOURCE_MEM          0x00000200
#define IORESOURCE_IRQ          0x00000400
#define IORESOURCE_DMA          0x00000800
#define IORESOURCE_BUS          0x00001000

So, if we made this a numeric index, then we have 32 resource types
to deal with, and no need to bugger around with re-using an existing
type for something else.

This makes sense, MEM, IRQ and DMA are all mutually exclusive, as
should be MEM and IO (because they can't coexist in two resource trees
at the same time.)  BUS only gets used in a hand-full of places and
not with any other flags.

So, looks like we can have 27 new resource types fairly easily.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
