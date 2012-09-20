Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2ITVYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:24:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19940 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2ITVYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:24:20 -0400
Date: Thu, 20 Sep 2012 17:24:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Oliver Chick <oliver.chick@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
Message-ID: <20120920212407.GD27312@konrad-lan.dumpdata.com>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <505AF126.2050806@citrix.com>
 <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
 <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
 <20120920134951.GC1998@localhost.localdomain>
 <1348150422.24539.58.camel@oliverchick-Precision-WorkStation-T3400>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348150422.24539.58.camel@oliverchick-Precision-WorkStation-T3400>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 03:13:42PM +0100, Oliver Chick wrote:
> On Thu, 2012-09-20 at 14:49 +0100, Konrad Rzeszutek Wilk wrote:
> > On Thu, Sep 20, 2012 at 12:48:41PM +0100, Jan Beulich wrote:
> > > >>> On 20.09.12 at 13:30, Oliver Chick <oliver.chick@citrix.com> wrote:
> > > > The memory overhead, and fallback mode points are related:
> > > > -Firstly, it turns out that the overhead is actually 2.75MB, not 11MB
> > > > per device. I made a mistake (pointed out by Jan) as the maximum number
> > > > of requests that can fit into a single-page ring is 64, not 256.
> > > > -Clearly, this still scales linearly. So the problem of memory footprint
> > > > will occur with more VMs, or block devices.
> > > > -Whilst 2.75MB per device is probably acceptable (?), if we start using
> > > > multipage rings, then we might not want to have
> > > > BLKIF_MAX_PERS_REQUESTS_PER_DEVICE==__RING_SIZE, as this will cause the
> > > > memory overhead to increase. This is why I have implemented the
> > > > 'fallback' mode. With a multipage ring, it seems reasonable to want the
> > > > first $x$ grefs seen by blkback to be treated as persistent, and any
> > > > later ones to be non-persistent. Does that seem sensible?
> > > 
> > > From a resource usage pov, perhaps. But this will get the guest
> > > entirely unpredictable performance. Plus I don't think 11Mb of
> > 
> > Wouldn't it fall back to the older performance?
> 
> I guess it would be a bit more complex than that. It would be worse than
> the new performance because the grefs that get processed by the
> 'fallback' mode will cause TLB shootdowns. But any early grefs will
> still be processed by the persistent mode, so won't have shootdowns.
> Therefore, depending on the ratio of {persistent grants}:{non-persistent
> grants), allocated by blkfront, the performance will be somewhere
> inbetween the two extremes.
> 
> I guess that the choice is between
> 1) Compiling blk{front,back} with a pre-determined number of persistent
> grants, and failing if this limit is exceeded. This seems rather
> unflexible, as blk{front,back} must then both both use the same version,
> or you will get failures.
> 2 (current setup)) Have a recommended maximum number of
> persistently-mapped pages, and going into a 'fallback' mode if blkfront
> exceeds this limit.
> 3) Having blkback inform blkfront on startup as to how many grefs it is
> willing to persistently-map. We then hit the same question again though:
> what should be do if blkfront ignores this limit?

How about 2 and 3 together? Meaning have a recommended maximmum number.
If we fall back due to memory pressure we can tell the guest that we
are entering fall-back mode. The frontend can decide what it wants to do
(throttle the amount of I/Os?) or just do a printk telling the user it
dropped the speed from "Insane Hot!" down to "Turbo!"... 

Or maybe not. Perhaps just reporting it in the backend that we are
hitting memory pressure and using the old-style-fallback mechanism
so the system admin can take actions (and tell his users why suddenly
their I/Os are so slow).
