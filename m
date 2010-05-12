Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0ELLLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:11:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59667 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928Ab0ELLLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:11:02 -0400
Subject: Re: [BUG] bug when enabling VM DEBUG
From: Catalin Marinas <catalin.marinas@arm.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: saeed bishara <saeed.bishara@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       DE/ATA development list <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
In-Reply-To: <4BEA1559.9000107@gmail.com>
References: <AANLkTikkSRI6u_mp6mNQReECB84t3oh-_MPVzAYEQULN@mail.gmail.com>
	 <AANLkTikoNc6oAY5JthYX1jWx1w2KeJ1fGab72Z-OvIVG@mail.gmail.com>
	 <4BEA1559.9000107@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 12 May 2010 12:10:39 +0100
Message-ID: <1273662639.23818.67.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2010 11:10:39.0811 (UTC) FILETIME=[C1572130:01CAF1C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 03:41 +0100, Robert Hancock wrote:
> On 05/11/2010 09:27 AM, saeed bishara wrote:
> > Jeff,
> > seems that the libata do pio to buffer which was allocated with
> > kmalloc, and under arm arch, the flush_dcache_page() is needed to
> > prevent cache aliasing, the later function calls the page_mapping
> > which falls on PageSlab(page)
> >
> > as the flush_dcache_page() is needed to prevent aliasing, it can be
> > skipped if the page is Slab as such pages are used only by the kernel.
> > here a suggested patch:
> >
> > --- a/drivers/ata/libata-sff.c
> > +++ b/drivers/ata/libata-sff.c
> > @@ -894,7 +894,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
> >                                         do_write);
> >          }
> >
> > -       if (!do_write)
> > +       if (!do_write&&  !PageSlab(page))
> >                  flush_dcache_page(page);
> 
> I would think that check belongs inside flush_dcache_page itself, rather
> than forcing every driver to include it..

Sebastian (cc'ed) reported this as well for MIPS.

I think it makes sense for this check to be done in the
flush_dcache_page() function.

-- 
Catalin

