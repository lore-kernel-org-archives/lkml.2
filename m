Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab0JOX0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 19:26:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:49780 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab0JOX0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 19:26:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,338,1283756400"; 
   d="scan'208";a="336723622"
Date: Fri, 15 Oct 2010 16:26:29 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, lud <linux-usb@vger.kernel.org>,
        Andiry Xu <andiry.xu@amd.com>, Dong Nguyen <dong.nguyen@amd.com>,
        Libin Yang <libin.yang@amd.com>
Subject: Re: [PATCH] usb: Fix linker errors with CONFIG_PM=n
Message-ID: <20101015232629.GA26031@xanatos>
References: <20101015205756.GA1757@xanatos>
 <20101015215915.GA25942@xanatos>
 <20101015222301.GA4080@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015222301.GA4080@joi.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 12:23:01AM +0200, Marcin Slusarz wrote:
> On Fri, Oct 15, 2010 at 02:59:15PM -0700, Sarah Sharp wrote:
> > diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> > index c08928a..93d3bf4 100644
> > --- a/drivers/usb/host/xhci.h
> > +++ b/drivers/usb/host/xhci.h
> > @@ -1405,8 +1405,15 @@ int xhci_init(struct usb_hcd *hcd);
> >  int xhci_run(struct usb_hcd *hcd);
> >  void xhci_stop(struct usb_hcd *hcd);
> >  void xhci_shutdown(struct usb_hcd *hcd);
> > +
> > +#ifdef	CONFIG_PM
> >  int xhci_suspend(struct xhci_hcd *xhci);
> >  int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
> > +#else
> > +#define	xhci_suspend	NULL
> > +#define	xhci_resume	NULL
> > +#endif
> > +
> 
> "static inline int xhci_suspend(struct xhci_hcd *) {}"
> has the same effect but saves types

That doesn't have the same effect.  Since those functions are only used
as function pointers, the original patch compiles to less code when
CONFIG_PM=n.  Also, the original version will cause an oops if those
functions are ever called when CONFIG_PM=n, which would indicate a bug
in the callee (something we would rather catch anyway).  This is the
style that other USB host controller drivers use, like EHCI.

I don't understand what you mean by "saves types".  Is there something
I've missed?

Sarah Sharp
