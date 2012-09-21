Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2IUOiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:38:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18067 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab2IUOiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:38:01 -0400
Date: Fri, 21 Sep 2012 10:26:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "Oliver Chick (Intern)" <oliver.chick@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
Message-ID: <20120921142630.GA3389@phenom.dumpdata.com>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <505AF126.2050806@citrix.com>
 <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
 <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
 <20120920134951.GC1998@localhost.localdomain>
 <1348150422.24539.58.camel@oliverchick-Precision-WorkStation-T3400>
 <20120920212407.GD27312@konrad-lan.dumpdata.com>
 <1348215044.26501.70.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348215044.26501.70.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 09:10:44AM +0100, Ian Campbell wrote:
> On Thu, 2012-09-20 at 22:24 +0100, Konrad Rzeszutek Wilk wrote:
> > On Thu, Sep 20, 2012 at 03:13:42PM +0100, Oliver Chick wrote:
> > > On Thu, 2012-09-20 at 14:49 +0100, Konrad Rzeszutek Wilk wrote:
> > > > On Thu, Sep 20, 2012 at 12:48:41PM +0100, Jan Beulich wrote:
> > > > > >>> On 20.09.12 at 13:30, Oliver Chick <oliver.chick@citrix.com> wrote:
> > > > > > The memory overhead, and fallback mode points are related:
> > > > > > -Firstly, it turns out that the overhead is actually 2.75MB, not 11MB
> > > > > > per device. I made a mistake (pointed out by Jan) as the maximum number
> > > > > > of requests that can fit into a single-page ring is 64, not 256.
> > > > > > -Clearly, this still scales linearly. So the problem of memory footprint
> > > > > > will occur with more VMs, or block devices.
> > > > > > -Whilst 2.75MB per device is probably acceptable (?), if we start using
> > > > > > multipage rings, then we might not want to have
> > > > > > BLKIF_MAX_PERS_REQUESTS_PER_DEVICE==__RING_SIZE, as this will cause the
> > > > > > memory overhead to increase. This is why I have implemented the
> > > > > > 'fallback' mode. With a multipage ring, it seems reasonable to want the
> > > > > > first $x$ grefs seen by blkback to be treated as persistent, and any
> > > > > > later ones to be non-persistent. Does that seem sensible?
> > > > > 
> > > > > From a resource usage pov, perhaps. But this will get the guest
> > > > > entirely unpredictable performance. Plus I don't think 11Mb of
> > > > 
> > > > Wouldn't it fall back to the older performance?
> > > 
> > > I guess it would be a bit more complex than that. It would be worse than
> > > the new performance because the grefs that get processed by the
> > > 'fallback' mode will cause TLB shootdowns. But any early grefs will
> > > still be processed by the persistent mode, so won't have shootdowns.
> > > Therefore, depending on the ratio of {persistent grants}:{non-persistent
> > > grants), allocated by blkfront, the performance will be somewhere
> > > inbetween the two extremes.
> > > 
> > > I guess that the choice is between
> > > 1) Compiling blk{front,back} with a pre-determined number of persistent
> > > grants, and failing if this limit is exceeded. This seems rather
> > > unflexible, as blk{front,back} must then both both use the same version,
> > > or you will get failures.
> > > 2 (current setup)) Have a recommended maximum number of
> > > persistently-mapped pages, and going into a 'fallback' mode if blkfront
> > > exceeds this limit.
> > > 3) Having blkback inform blkfront on startup as to how many grefs it is
> > > willing to persistently-map. We then hit the same question again though:
> > > what should be do if blkfront ignores this limit?
> > 
> > How about 2 and 3 together?
> 
> I think 1 is fine for a "phase 1" implementation, especially taking into
> consideration that the end of Oliver's internship is next week.

Ah yes. Lets do one and then we can deal with 2 later on. At the
same time when netback persistent grants come online. Seems like
both backends will have to deal with this.
> 
> Also it seems that the cases where there might be some disconnect
> between the number of persistent grants supported by the backend and the
> number of requests from the frontend are currently theoretical or
> predicated on the existence of unmerged or as yet unwritten patches.
> 
> So lets say, for now, that the default number of persistent grants is
> the same as the number of slots in the ring and that it is a bug for
> netfront to try and use more than that if it has signed up to the use of
> persistent grants. netback is at liberty to fail such "overflow"
> requests. In practice this can't happen with the current implementations
> given the default specified above.

OK.
