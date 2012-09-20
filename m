Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2ITLbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:31:08 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:23530 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2ITLbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:31:06 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="14653558"
Message-ID: <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
From: Oliver Chick <oliver.chick@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Sep 2012 12:30:37 +0100
In-Reply-To: <505AF126.2050806@citrix.com>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
	 <505AF126.2050806@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory overhead, and fallback mode points are related:
-Firstly, it turns out that the overhead is actually 2.75MB, not 11MB
per device. I made a mistake (pointed out by Jan) as the maximum number
of requests that can fit into a single-page ring is 64, not 256.
-Clearly, this still scales linearly. So the problem of memory footprint
will occur with more VMs, or block devices.
-Whilst 2.75MB per device is probably acceptable (?), if we start using
multipage rings, then we might not want to have
BLKIF_MAX_PERS_REQUESTS_PER_DEVICE==__RING_SIZE, as this will cause the
memory overhead to increase. This is why I have implemented the
'fallback' mode. With a multipage ring, it seems reasonable to want the
first $x$ grefs seen by blkback to be treated as persistent, and any
later ones to be non-persistent. Does that seem sensible?


On Thu, 2012-09-20 at 11:34 +0100, David Vrabel wrote:
> On 19/09/12 11:51, Oliver Chick wrote:
> > This patch implements persistent grants for the xen-blk{front,back}
> > mechanism.
> [...]
> > We (ijc, and myself) have introduced a new constant,
> > BLKIF_MAX_PERS_REQUESTS_PER_DEV. This is to prevent a malicious guest
> > from attempting a DoS, by supplying fresh grefs, causing the Dom0
> > kernel from to map excessively. 
> [...]
> > 2) Otherwise, we revert to non-persistent grants for all future grefs.
> 
> Why fallback instead of immediately failing the request?
> > diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> > index 73f196c..f95dee9 100644
> > --- a/drivers/block/xen-blkback/blkback.c
> > +++ b/drivers/block/xen-blkback/blkback.c
> > @@ -78,6 +78,7 @@ struct pending_req {
> >  	unsigned short		operation;
> >  	int			status;
> >  	struct list_head	free_list;
> > +	u8			is_pers;
> 
> Using "pers" as an abbreviation for "persistent" isn't obvious.  For
> readability it may be better spell it in full.
> 
Good point

> > +/*
> > + * Maximum number of persistent grants that can be mapped by Dom0 for each
> > + * interface. This is set to be the size of the ring, as this is a limit on
> > + * the number of requests that can be inflight at any one time. 256 imposes
> > + * an overhead of 11MB of mapped kernel space per interface.
> > + */
> > +#define BLKIF_MAX_PERS_REQUESTS_PER_DEV 256
> 
> This 11MB per VBD seems like a lot.  With 150 VMs each with 2 VBDs this
> requires > 3 GB.  Is this a scalability problem?


> 
> Does there need to be a mechanism to expire old maps in blkback?


When blkback closes, I unmap. Or do you mean that I could unmap if there
has been a spike in block-device activity, after which the mapped pages
are not getting used?
> 
> David


