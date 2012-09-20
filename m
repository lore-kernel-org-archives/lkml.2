Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab2ITOOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:14:18 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:8481 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2ITOOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:14:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="14659991"
Message-ID: <1348150422.24539.58.camel@oliverchick-Precision-WorkStation-T3400>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
From: Oliver Chick <oliver.chick@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Sep 2012 15:13:42 +0100
In-Reply-To: <20120920134951.GC1998@localhost.localdomain>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
	 <505AF126.2050806@citrix.com>
	 <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
	 <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
	 <20120920134951.GC1998@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 14:49 +0100, Konrad Rzeszutek Wilk wrote:
> On Thu, Sep 20, 2012 at 12:48:41PM +0100, Jan Beulich wrote:
> > >>> On 20.09.12 at 13:30, Oliver Chick <oliver.chick@citrix.com> wrote:
> > > The memory overhead, and fallback mode points are related:
> > > -Firstly, it turns out that the overhead is actually 2.75MB, not 11MB
> > > per device. I made a mistake (pointed out by Jan) as the maximum number
> > > of requests that can fit into a single-page ring is 64, not 256.
> > > -Clearly, this still scales linearly. So the problem of memory footprint
> > > will occur with more VMs, or block devices.
> > > -Whilst 2.75MB per device is probably acceptable (?), if we start using
> > > multipage rings, then we might not want to have
> > > BLKIF_MAX_PERS_REQUESTS_PER_DEVICE==__RING_SIZE, as this will cause the
> > > memory overhead to increase. This is why I have implemented the
> > > 'fallback' mode. With a multipage ring, it seems reasonable to want the
> > > first $x$ grefs seen by blkback to be treated as persistent, and any
> > > later ones to be non-persistent. Does that seem sensible?
> > 
> > From a resource usage pov, perhaps. But this will get the guest
> > entirely unpredictable performance. Plus I don't think 11Mb of
> 
> Wouldn't it fall back to the older performance?

I guess it would be a bit more complex than that. It would be worse than
the new performance because the grefs that get processed by the
'fallback' mode will cause TLB shootdowns. But any early grefs will
still be processed by the persistent mode, so won't have shootdowns.
Therefore, depending on the ratio of {persistent grants}:{non-persistent
grants), allocated by blkfront, the performance will be somewhere
inbetween the two extremes.

I guess that the choice is between
1) Compiling blk{front,back} with a pre-determined number of persistent
grants, and failing if this limit is exceeded. This seems rather
unflexible, as blk{front,back} must then both both use the same version,
or you will get failures.
2 (current setup)) Have a recommended maximum number of
persistently-mapped pages, and going into a 'fallback' mode if blkfront
exceeds this limit.
3) Having blkback inform blkfront on startup as to how many grefs it is
willing to persistently-map. We then hit the same question again though:
what should be do if blkfront ignores this limit?

> > _virtual_ space is unacceptable overhead in a 64-bit kernel. If
> > you really want/need this in a 32-bit one, then perhaps some
> > other alternatives would be needed (and persistent grants may
> > not be the right approach there in the first place).
> > 
> > Jan
> > 


