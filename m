Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab2JWTDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:03:05 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57123 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab2JWTDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:03:03 -0400
Date: Tue, 23 Oct 2012 14:50:50 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH RFC] Persistent grant maps for xen blk drivers
Message-ID: <20121023185049.GB20350@phenom.dumpdata.com>
References: <1350559321-19066-1-git-send-email-roger.pau@citrix.com>
 <20121022134708.GA13832@konrad-lan.dumpdata.com>
 <5086C0C8.5000306@citrix.com>
 <20121023172008.GB11787@phenom.dumpdata.com>
 <5086DD57.4000206@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5086DD57.4000206@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 08:09:27PM +0200, Roger Pau Monné wrote:
> On 23/10/12 19:20, Konrad Rzeszutek Wilk wrote:
> >>>> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> >>>> index c6decb9..2b982b2 100644
> >>>> --- a/drivers/block/xen-blkback/blkback.c
> >>>> +++ b/drivers/block/xen-blkback/blkback.c
> >>>> @@ -78,6 +78,7 @@ struct pending_req {
> >>>>       unsigned short          operation;
> >>>>       int                     status;
> >>>>       struct list_head        free_list;
> >>>> +     unsigned int            unmap_seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> 
> Should I change this to a bool? Since we are only setting it to 0 or 1.

I would just keep it as 'int'. Eventually we can replace this with a
bit-map, but that can be done later.

> 
> >>> Perhaps there should be a #define for that array..
> >>
> >> Do you mean something like:
> >>
> >> #define unmap(req, i) req->unmap_seg[i]
> > 
> > I was thinking that you just check for req->unamp_seg[i] to
> > have an non-zero value. But since that array is just used as an check
> > to see whether the functionality is enabled (or not), you might want
> > to declerare the right values so:
> > #define UNMAP_SG_ON 1
> > #define UNMAP_SG_OFF 0
> > 
> > or so.
> 
> Agreed, will add the defines.
> 
> >>>> +             if (persistent_gnts[i]) {
> >>>> +                     if (!persistent_gnts[i]->handle) {
> >>>> +                             /*
> >>>> +                              * If this is a new persistent grant
> >>>> +                              * save the handler
> >>>> +                              */
> >>>> +                             persistent_gnts[i]->handle = map[j].handle;
> >>>> +                             persistent_gnts[i]->dev_bus_addr =
> >>>> +                                     map[j++].dev_bus_addr;
> >>>> +                     }
> >>>> +                     pending_handle(pending_req, i) =
> >>>> +                             persistent_gnts[i]->handle;
> >>>> +                     pending_req->unmap_seg[i] = 0;
> >>>
> >>> Could we have a #define for that?
> >>
> >> Sure.
> 
> I've used the previous macro, so it looks like:
> 
> unmap(req, i) = UNMAP_SG_OFF;
> 
> I'm not sure if this is what you meant, or if you where interested in
> defining a set of macros like:
> 
> #define check_unmap(req, i) req->unmap_seg[i]
> #define unset_unmap(req, i) req->unmap_seg[i] = UNMAP_SG_OFF
> #define set_unmap(req, i) req->unmap_seg[i] = UNMAP_SG_ON
> 
> I would go for the first option (the unmap macro that can be used here
> and in xen_blkbk_unmap).

I was just thinking something as simple as

	if (reg->unmap_seg[i] == UNMAP_SG_OFF)
		continue;

And the #defines are just for the hard-coded values of 0 or 1.

> 
> >>> HA! By default, eh?
> >>
> >> Yes, you caught me, there's a paragraph in the commit message that
> >> explains that we are using persistent grants in the frontend
> >> unconditionally, since the protocol is compatible (you can have a
> >> persistent blkfront and a non-persistent blkback). It simplifies the
> >> logic in blkfront. Are you OK with it?
> > 
> > It is OK, but you should be checking whether the backend supports it.
> > I don't see it checking the info->feature_persistent_grant to print
> > that.
> 
> I don't understand why blkfront needs to check if the backend supports
> persisten grants, blkfront is going to use persistent grants anyway.

What if it does not (say this guest runs on an older xen-blkback?)?
Then you would be still printing 'persistent grants' in the blkfront.
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
