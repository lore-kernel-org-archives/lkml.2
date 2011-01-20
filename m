Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1ATFBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 00:01:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab1ATFA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 00:00:59 -0500
Date: Wed, 19 Jan 2011 21:01:43 -0800
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, devel@driverdev.osuosl.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/hv/osd: don't reimplement ALIGN macro
Message-ID: <20110120050143.GC9482@suse.de>
References: <1295365151-9527-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110119053715.GA26304@suse.de>
 <20110119085456.GI10686@pengutronix.de>
 <4D36DC8D.50705@gmail.com>
 <20110119130729.GO10686@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110119130729.GO10686@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 02:07:30PM +0100, Uwe Kleine-König wrote:
> Hello Jiri,
> 
> On Wed, Jan 19, 2011 at 01:43:57PM +0100, Jiri Slaby wrote:
> > On 01/19/2011 09:54 AM, Uwe Kleine-König wrote:
> > > On Tue, Jan 18, 2011 at 09:37:15PM -0800, Greg KH wrote:
> > >> On Tue, Jan 18, 2011 at 04:39:11PM +0100, Uwe Kleine-König wrote:
> > >>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > >>> ---
> > >>>  drivers/staging/hv/osd.h |    5 ++---
> > >>>  1 files changed, 2 insertions(+), 3 deletions(-)
> > >>>
> > >>> diff --git a/drivers/staging/hv/osd.h b/drivers/staging/hv/osd.h
> > >>> index ce064e8..61ae54c 100644
> > >>> --- a/drivers/staging/hv/osd.h
> > >>> +++ b/drivers/staging/hv/osd.h
> > >>> @@ -28,10 +28,9 @@
> > >>>  #include <linux/workqueue.h>
> > >>>  
> > >>>  /* Defines */
> > >>> -#define ALIGN_UP(value, align)	(((value) & (align-1)) ?		\
> > >>> -				 (((value) + (align-1)) & ~(align-1)) :	\
> > >>> -				 (value))
> > >>> +#define ALIGN_UP(value, align)		ALIGN((value), (align))
> > >>
> > >> How about dropping ALIGN_UP entirely and just using the built-in ALIGN()
> > >> macro instead?
> > > Can do.
> > > 
> > >>>  #define ALIGN_DOWN(value, align)	((value) & ~(align-1))
> > >>
> > >> Any chance to get rid of this as well with the ALIGN() macro, or is that
> > >> really not possible?
> > > it would be
> > > 
> > > 	#define ALIGN_DOWN(value, align) ALIGN((value) - (align) + 1, (align))
> > > 
> > > I think, but as it's only used once it might be easier to just use ALIGN
> > > there, too.
> > > 
> > > BTW, it's used as follows:
> > > 
> > > 	#define NUM_PAGES_SPANNED(addr, len)    ((ALIGN(addr+len, PAGE_SIZE) - \
> > > 						 ALIGN_DOWN(addr, PAGE_SIZE)) >>  \
> > > 						 PAGE_SHIFT)
> > 
> > (DIV_ROUND_UP(addr+len, PAGE_SIZE) - ((addr) >> PAGE_SHIFT)))
> > 
> > or maybe better
> > 
> > (PAGE_ALIGN(addr+len) >> PAGE_SHIFT - ((addr) >> PAGE_SHIFT))
> > 
> > > I wonder if there is already a function yielding this value?
> > > Wouldn't
> > > 
> > > 	((addr + len) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT) + 1
> > 
> > No, this won't work (it's not equivalent).
> Ah, this fails if addr + len is page aligned.
> 
> 	((addr + len - 1) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT) + 1
> 
> would work, but I like
> 
> 	(PAGE_ALIGN(addr+len) >> PAGE_SHIFT - ((addr) >> PAGE_SHIFT))
> 
> better.  (In fact these two are equivalent:
> 
> 	PAGE_ALIGN(addr+len) >> PAGE_SHIFT =
> 	__ALIGN_KERNEL(addr+len, PAGE_SIZE) >> PAGE_SHIFT =
> 	__ALIGN_KERNEL_MASK(addr+len, PAGE_SIZE - 1) >> PAGE_SHIFT =
> 	((addr + len + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1)) >> PAGE_SHIFT =
> 	(addr + len + PAGE_SIZE - 1) >> PAGE_SHIFT =
> 	(addr + len - 1) >> PAGE_SHIFT + 1
> 
> Greg: should I send an updated patch or do you modify NUM_PAGES_SPANNED
> accordingly?

Can you please send a new patch?

thanks,

greg k-h
