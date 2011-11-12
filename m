Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab1KLBJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 20:09:13 -0500
Received: from sous-sol.org ([216.99.217.87]:46180 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756183Ab1KLBJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 20:09:11 -0500
Date: Fri, 11 Nov 2011 17:08:50 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Roland Dreier <roland@purestorage.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains
 unattached to iommus
Message-ID: <20111112010850.GT14486@sequoia.sous-sol.org>
References: <20111111224849.9756.13368.stgit@bling.home>
 <1321058267.2006.21.camel@shinybook.infradead.org>
 <CAL1RGDXZjKhA++3eFVPbazixaM7Q_JfBJyLKE0xjBs+sK55idg@mail.gmail.com>
 <20111112005100.GR14486@sequoia.sous-sol.org>
 <1321059340.2006.27.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321059340.2006.27.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> On Fri, 2011-11-11 at 16:51 -0800, Chris Wright wrote:
> > * Roland Dreier (roland@purestorage.com) wrote:
> > > On Fri, Nov 11, 2011 at 4:37 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> > > > This brain-damage only affects the first chipsets
> > > > from before we worked out that cache incoherency was a *really* f*cking
> > > > stupid idea, doesn't it?
> > > 
> > > As we talked about at KS, I have some Westmere EP (ie latest
> > > and greatest server platform) systems where the BIOS exposes
> > > an option that allows choosing VT-d coherency on or off, and
> > > defaults it to "off".
> > 
> > That's just more brain damage AFAICT.  Esp. if you do performance
> > testing (and choose not to use passthrough mode)... have and it's
> > quite measurable.  I switched default to on long time ago, w/out
> > issue.
> > 
> > > What is the "official" Intel line on coherency with Westmere and
> > > Tylersburg -- because as I also mentioned, I was seeing some
> > > problems with VT-d and the default "coherency off" setting that
> > > looked like the IOMMU HW is getting stale PTEs (ie a missing
> > > or not working cache flush).
> > 
> > That sounds like sw bugs more than official recommendation issue.
> 
> Although the cache-flushing has been tested on the original chipsets
> fairly well, and it's one of the parts I've mostly rewritten when doing
> performance work since I inherited the code, so that might not be my
> first suspicion.

All the stale PTE issues I've encountered in the past have turned into
fixed sw bugs (perhaps it's since been fixed?).  Also, I thought with
Coherency On/Off it's only effecting the use of clflush, not IOTLB or
Context Entry cache flushing (invalidations).

On a slightly separate, but performance related note...have you ever
tried using the hw queue?  Currently we only have a sw queue, but the
submission path for invalidations doesn't really queue (unless I missed
it).  It seems to pull from the software queue and submit/wait,
submit/wait...Seems simple enough to submit the whole queue and then
issue the wait.

This would be a huge win if we ever have an emulated IOMMU.  We could
make the sw queue bigger, and allocate more than a single page for the
hw queue.  We'd only exit on running the queue rather than every
invalidation.

> I would be more inclined to suspect that there's some
> chipset buffering that we aren't correctly flushing (which might in
> itself be a hardware issue, since the way to flush the cache is supposed
> to be well-defined).

Roland, have you tried switching BIOS to Coherency On and can do you
ever see stale PTEs?

thanks,
-chris
