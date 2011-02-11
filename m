Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab1BKPfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:35:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57154 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1BKPfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:35:53 -0500
Date: Fri, 11 Feb 2011 15:35:24 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Shiyong Li <shi-yong.li@motorola.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: "slab: Fix missing DEBUG_SLAB last user" breaks ARM
Message-ID: <20110211153524.GB26188@flint.arm.linux.org.uk>
References: <20110207180606.GB2966@flint.arm.linux.org.uk> <AANLkTi=Lftr41mHDXzK0c=pf7JYYOVWMjLX65JCLqDsU@mail.gmail.com> <20110208125546.GA4286@flint.arm.linux.org.uk> <alpine.DEB.2.00.1102080856020.12521@router.home> <AANLkTimFDZFcO=J6PEOOo5RBdr0m7fjCKzWh1M_NaiLx@mail.gmail.com> <20110211091413.GA32687@flint.arm.linux.org.uk> <alpine.DEB.2.00.1102110920060.12360@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1102110920060.12360@router.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 09:20:27AM -0600, Christoph Lameter wrote:
> On Fri, 11 Feb 2011, Russell King wrote:
> 
> > On Fri, Feb 11, 2011 at 09:02:45AM +0200, Pekka Enberg wrote:
> > > On Tue, Feb 8, 2011 at 5:02 PM, Christoph Lameter <cl@linux.com> wrote:
> > > > Uhh.. That first hunk in commit 5c5e3b33b7cb959a401f823707bee006caadd76e
> > > > looks wrong to me. ralign is usually a power of two and greater than
> > > > alignof(unsigned long long). The & operation will result in 0 and never
> > > > exempt any caches.
> > > >
> > > > diff --git a/mm/slab.c b/mm/slab.c
> > > > index bac0f4f..525c664 100644
> > > > --- a/mm/slab.c
> > > > +++ b/mm/slab.c
> > > > @@ -2220,8 +2220,8 @@ kmem_cache_create (const char *name, size_t size,
> > > > size_t align,
> > > >        if (ralign < align) {
> > > >                ralign = align;
> > > >        }
> > > > -       /* disable debug if necessary */
> > > > -       if (ralign > __alignof__(unsigned long long))
> > > > +       /* disable debug if not aligning with REDZONE_ALIGN */
> > > > +       if (ralign & (__alignof__(unsigned long long) - 1))
> > > >                flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
> > > >        /*
> > > >         * 4) Store it.
> > > >
> > > >
> > > > Did you mean
> > > >
> > > >        if (ralign > REDZONE_ALIGN) ...
> > > >
> > > > ?
> > >
> > > Ping. Any arm-capable tester out there that can verify this fix? OTOH,
> > > since Shiyong Li hasn't showed up, I'm inclined to just revert the
> > > commit...
> >
> > What fix?  The above is a quote of the patch in 5c5e3b33.
> 
> He was referring to the change of the if statement.

Replacing what with what?

	if (ralign & (__alignof__(unsigned long long) - 1))
with
	if (ralign > __alignof__(unsigned long long))
or
	if (ralign > REDZONE_ALIGN)

?  A patch is a wonderful way to describe the change to be tested.


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
