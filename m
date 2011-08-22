Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1HVQlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:41:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:24996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1HVQlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="40654352"
Date: Mon, 22 Aug 2011 09:41:43 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: Amit Blay <ablay@codeaurora.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        Amit Blay <ablay@qualcomm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to
 devio.c
Message-ID: <20110822164143.GA7680@xanatos>
References: <20110818224713.GA6738@xanatos>
 <201108220956.51135.hselasky@c2i.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108220956.51135.hselasky@c2i.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 09:56:51AM +0200, Hans Petter Selasky wrote:
> Hi,
> 
> > 
> > On Wed, Aug 17, 2011 at 09:06:03AM +0200, Hans Petter Selasky wrote:
> > > I'm looking into implementing USB 3.0 streams support for FreeBSD and
> > > would like to have a solution in Linux which is not too far apart, also
> > > regarding API's for userspace.
> > > 
> > > I would suggest overloading the "unsigned int pipe", instead of breaking
> > > existing API's by adding a new stream ID value. Also for LibUSB.
> > > 
> > > ./linux/usb.h:  unsigned int pipe;              /* (in) pipe information
> > > */
> > 
> > I think this gets very close to breaking current API for usbfs.  What
> > happens if some application is putting garbage in the upper bits of the
> > pipe? 
> 
> I think this will never happen, because all USB applications I know about are 
> taught to use a set of macros to create the "pipe" value, which by default 
> zero these bits.

Userspace programs aren't required to use the macros, so there is always
a possibility that some program out there will be passing garbage.  If
your argument had been "the kernel checks for garbage, and returns an
error code if there is garbage, so therefore there can't be any programs
that put garbage in the upper bits", then that would be a different
story.

> > Why do you think reusing the pipe variable would be a better solution?
> > You're going to need a new IOCTL to enable streams anyway, so why not
> > also have a new IOCTL for submitting an URB to an endpoint with streams
> > enabled?
> 
> What I'm thinking is that you should try to integrate the streams 
> functionality as much as possible, with existing API's, so that API's that do 
> roughly the same are not duplicated. In FreeBSD 8/9 we have more free bits in 
> the pipe variable, and I'll probably use that for the stream ID.

We'll try to coalesce the streams and non-streams functions in the
kernel so they share as much code as possible.  I see adding a new call
parameter in a new usbfs ioctl as the right way to share new
functionality in KAPI, rather than overloading currently free bits.
However, if you come from a hardware background, I can see where adding
new functionality in "reserved" bits seems normal.

> It's like 
> IPv4 and IPv6, that you extend fields when required and not duplicate them. 
> I'm just worried that intel will come up with yet-another way to transfer data 
> in a few years, and then we'll have to wreck API's again.

We're not wrecking APIs, we're just creating new ones.  New programs
will have to do something different for streams (especially since
they'll have to deal with out-of-order completions), so it's reasonable
to ask them to call a different function in order to ensure we can use
the full stream ID range.

> So why not foresee 
> that now and make 128-bits available for endpoint/stream/XXX addressing?

We can't predict the future here.  Who knows whether they will come up
with some completely different mechanism that doesn't involve streams?

Besides, it would take a major rev of the USB spec (or at least a very
careful errata) to add more stream ID bits, since the upper bits are
reserved for specific host and device states.  Intel is not the only
company behind USB, and it takes time to get spec changes through the
USB-IF working groups.  Considering that it took them eight years to
update the USB 2.0 spec to USB 3.0, I think it's safe to say the current
stream ID range limitations will be around for several years.

Sarah Sharp
