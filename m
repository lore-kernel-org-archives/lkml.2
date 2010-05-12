Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0ELNGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:06:50 -0400
Received: from mail2.shareable.org ([80.68.89.115]:51633 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0ELNGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:06:48 -0400
Date: Wed, 12 May 2010 14:06:38 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Jeff Garzik <jeff@garzik.org>, lkml <linux-kernel@vger.kernel.org>,
       DE/ATA development list <linux-ide@vger.kernel.org>,
       saeed bishara <saeed.bishara@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [BUG] bug when enabling VM DEBUG
Message-ID: <20100512130638.GB19314@shareable.org>
References: <AANLkTikkSRI6u_mp6mNQReECB84t3oh-_MPVzAYEQULN@mail.gmail.com> <AANLkTikoNc6oAY5JthYX1jWx1w2KeJ1fGab72Z-OvIVG@mail.gmail.com> <4BEA1559.9000107@gmail.com> <1273662639.23818.67.camel@e102109-lin.cambridge.arm.com> <20100512115340.GA11261@Chamillionaire.breakpoint.cc> <1273667099.23818.86.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273667099.23818.86.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> On Wed, 2010-05-12 at 12:53 +0100, Sebastian Andrzej Siewior wrote:
> > * Catalin Marinas | 2010-05-12 12:10:39 [+0100]:
> > 
> > >> > --- a/drivers/ata/libata-sff.c
> > >> > +++ b/drivers/ata/libata-sff.c
> > >> > @@ -894,7 +894,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
> > >> >                                         do_write);
> > >> >          }
> > >> >
> > >> > -       if (!do_write)
> > >> > +       if (!do_write&&  !PageSlab(page))
> > >> >                  flush_dcache_page(page);
> > >>
> > >> I would think that check belongs inside flush_dcache_page itself, rather
> > >> than forcing every driver to include it..
> > >
> > >Sebastian (cc'ed) reported this as well for MIPS.
> > Thx. The patch above looks what I've sent a while ago. Jeff was going to
> > merge it afaik.
> > 
> > >I think it makes sense for this check to be done in the
> > >flush_dcache_page() function.
> > 
> > Why should flush_dcache_page() not flush pages you tell it?
> > From Documentation/cachetlb.txt:
> > |   NOTE: This routine need only be called for page cache pages
> > |          which can potentially ever be mapped into the address
> > |          space of a user process.  So for example, VFS layer code
> > |          handling vfs symlinks in the page cache need not call
> > |          this interface at all.
> > 
> > A page from slab or stack is not going to see the sky of user land and
> > therefore it should not be fed into flush_dcache_page().
> 
> You are right :), so fixing the driver is the best approach.

It worries me that a driver has any knowledge of the PageSlab() flag,
though.  Especially uncommented knowledge.  That flag seems VM
internal, and it's conceptually iffy: Kernel code using
get_free_pages() and using that for I/O also does not see the sky of
user land.

If all the PIO drivers have to be changed, I'd be happier with:

    flush_dcache_page_for_pio()

which wraps the check, explains it, and provides a single place to
change if needed.

-- Jamie
