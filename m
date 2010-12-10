Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab0LJAL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 19:11:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:12353 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab0LJAL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 19:11:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,322,1288594800"; 
   d="scan'208";a="866553758"
Date: Thu, 9 Dec 2010 16:11:55 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/4] [USB] UASP: Add MaxNumStreams module parameter
Message-ID: <20101210001155.GB11803@xanatos>
References: <20101209205820.GA6014@xanatos>
 <463402.63193.qm@web31809.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <463402.63193.qm@web31809.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 02:54:19PM -0800, Luben Tuikov wrote:
> --- On Thu, 12/9/10, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> > -0800, Luben Tuikov wrote:
> > > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > > ---
> > >  The long story is that we see some host
> > controllers misreport their
> > >  PSA as they solved 2^v = streams, instead of
> > 2^(v+1) = streams. Thus
> > >  They report that they support 32 streams when in
> > fact they support 16.
> > >  When the device attempts to return status for
> > stream > 15, the host
> > >  says ACK(NumP=0), the device goes in flow
> > control, blah, blah, this
> > >  module parameter allows you to set a max cap on
> > the number of streams
> > >  the driver will ask XHCI HCD to allocate.
> > 
> > If this is an issue with a host then the work-around should
> > be in the
> > xHCI driver instead.  It should be based on the
> > vendor/device ID of the
> > offending host instead of being a module parameter in the
> > UAS driver.
> > The only people who benefit from this patch are the people
> > "in the know"
> > about which hosts are buggy, not normal Linux users.
> 
> The OS might want to limit the number of streams for reasons other
> than a buggy HC. So this module parameter add flexibility other than
> making a buggy HC work.

Ok, that's fine, but my comments still stand about fixing this
particular bug in the xHCI driver, rather than in the UAS driver.

> (I didn't know you were reading my patches and yet to a "competing"
> driver of a driver where you're listed as a co-author...)

I always read emails that seem like they might be xHCI related.
Especially when they're a patch.

> > Streams could be used for things other than UAS in the future, so
> > the fix should really be in the xHCI host controller driver.  And
> > please put the information about the host bug in the commit message,
> > so your private comments don't get lost in the bowels of the
> > linux-usb mailing list.
> 
> I've an updated HC of this particular make sitting on my desk which
> I've not had time to test... The HC this was found in is an early
> version of that make.

If the earlier version of the HC is already out in the market, then the
fix needs to get into the xHCI driver, regardless of whether the new
version works.  Otherwise some poor user is going to plug in their
off-the-shelf UAS device into their off-the-shelf host controller and
wonder why it doesn't work.

> > In the future, please Cc me on any patches that involve xHCI, or
> > bulk streams in general.
> 
> In this case, you should probably not add 1 to the number of streams a
> protocol driver requests, if that number is already a power of 2.

Why?  What if the host and endpoints can handle 32 streams, but the
driver requests 16?  Is there a reason the xHCI driver shouldn't
allocate transfer rings for streams 1 through 16?  Something special to
do with powers of two?

There's a deeper design decision here that I never really resolved.
Say a driver asks for 16 streams.  Stream 0 is reserved, and can't be
used after streams are enabled.  The xHCI host controller spec forbids
allocating a transfer ring for stream 0.

Now, what should the contract between the host controller and the driver
be?  Should the xHCI driver allocate stream rings for stream IDs 1
through 15, thereby guaranteeing 15 streams can be used?  Or should it
allocate streams 1 through 16, giving the driver the 16 active streams
it actually wanted?  I chose the latter, which is why I add 1 to the
number of streams the driver requests.

> To extend this and make it foolproof, the XHCI should probably know if
> the number of streams came from a descriptor or the driver made it up
> (in which case you know more precisely what to do). Now, since you
> return the number of streams the driver can use, implementing the
> former is probably just enough.

In either case, I look at the endpoint descriptors that the driver
passes me, and never allocate more streams than those endpoints can
handle.  The driver also never allocates more streams than the host
controller can handle.  All that work is done in
xhci_calculate_streams_and_bitmask().

> Also please add a comment as to the return value therein, to the
> effect that the range of streams the caller can use is [1, the value
> returned], WLG.

It's documented in Documentation/usb/bulk-streams.txt under the "Picking
new Stream IDs to use" section.  But yes, it should probably be
documented in the function comments above usb_alloc_streams().

Sarah Sharp
