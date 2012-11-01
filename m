Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237Ab2KAUPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:15:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:5754 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758502Ab2KAUPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:15:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="214131378"
Date: Thu, 1 Nov 2012 13:15:52 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] xhci: fix null-pointer dereference when destroying
 half-built segment rings
Message-ID: <20121101201552.GA9472@xanatos>
References: <20121101175217.GJ29270@xanatos>
 <1351799279-23824-1-git-send-email-jwerner@chromium.org>
 <CAHp75VfqYNMxxDKKvHOVOdtf0+ZkC_N3Zfy0Ahb0nNdG4Xh9xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfqYNMxxDKKvHOVOdtf0+ZkC_N3Zfy0Ahb0nNdG4Xh9xA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 10:13:00PM +0200, Andy Shevchenko wrote:
> On Thu, Nov 1, 2012 at 9:47 PM, Julius Werner <jwerner@chromium.org> wrote:
> > xhci_alloc_segments_for_ring() builds a list of xhci_segments and links
> > the tail to head at the end (forming a ring). When it bails out for OOM
> > reasons half-way through, it tries to destroy its half-built list with
> > xhci_free_segments_for_ring(), even though it is not a ring yet. This
> > causes a null-pointer dereference upon hitting the last element.
> >
> > Furthermore, one of its callers (xhci_ring_alloc()) mistakenly believes
> > the output parameters to be valid upon this kind of OOM failure, and
> > calls xhci_ring_free() on them. Since the (incomplete) list/ring should
> > already be destroyed in that case, this would lead to a use after free.
> >
> > This patch fixes those issues by having xhci_alloc_segments_for_ring()
> > destroy its half-built, non-circular list manually and destroying the
> > invalid struct xhci_ring in xhci_ring_alloc() with a plain kfree().
> >
> > Signed-off-by: Julius Werner <jwerner@chromium.org>
> > ---
> >  drivers/usb/host/xhci-mem.c |    9 +++++++--
> >  1 files changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> > index 487bc08..fb51c70 100644
> > --- a/drivers/usb/host/xhci-mem.c
> > +++ b/drivers/usb/host/xhci-mem.c
> > @@ -205,7 +205,12 @@ static int xhci_alloc_segments_for_ring(struct xhci_hcd *xhci,
> >
> >                 next = xhci_segment_alloc(xhci, cycle_state, flags);
> >                 if (!next) {
> > -                       xhci_free_segments_for_ring(xhci, *first);
> > +                       prev = *first;
> > +                       while (prev) {
> > +                               next = prev->next;
> > +                               xhci_segment_free(xhci, prev);
> > +                               prev = next;
> > +                       }
> 
> Is it just
> for (prev = *first; prev; prev = prev->next)
>     xhci_segment_free(xhci, prev);
> 
> ?

Yeah, that seems cleaner.

Sarah Sharp
