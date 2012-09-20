Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2ITNxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:53:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22988 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2ITNxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:53:11 -0400
Date: Thu, 20 Sep 2012 09:52:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Oliver Chick <oliver.chick@citrix.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Persistent grant maps for xen blk drivers
Message-ID: <20120920135257.GD1998@localhost.localdomain>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <20120919141138.GC12367@phenom.dumpdata.com>
 <1348146745.24539.42.camel@oliverchick-Precision-WorkStation-T3400>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348146745.24539.42.camel@oliverchick-Precision-WorkStation-T3400>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 02:12:25PM +0100, Oliver Chick wrote:
> Thank you for all your useful feedback, Konrad.
> 
> I have made most of the changes you suggest. I will test them and
> repost. I have made a few points below.

Great. Looking forward to your next patch. Also pls include it
as an attachment as I could not apply it last time.. Not sure if
that is something with your mailer - but attachments usually survive
any MUA mangling.
> > > +                             page_to_pfn(pers_gnt->page));
> > 
> > Would it make sense to cache this in the 'pers_gnt' structure?
> 
> As far as I can tell, we only need this value when mapping, and
> unmapping. So if we cache it, we will use it a maximum of one time. I
> think it's cheap to calculate. Am I right?

Then lets not cache it.
> > > @@ -688,7 +804,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> > >       for (i = 0; i < nseg; i++) {
> > >               while ((bio == NULL) ||
> > >                      (bio_add_page(bio,
> > > -                                  blkbk->pending_page(pending_req, i),
> > 
> > Can we get rid of pending_page macro?
> 
> Unfortunately not, it is still used in the non-persistent mode to
> populate the pages[].

Fair enough
> > > +                             memcpy(shared_data + sg->offset,
> > > +                                    bvec_data   + sg->offset,
> > > +                                    sg->length);
> > 
> > Do we need to worry about it spilling over a page? Should we check that
> > sg>offset + sg->length < PAGE_SIZE ?
> 
> I agree, this is probably a worthwhile thing to check.

> 
> > 
> > Also this would imply that based on the offset (so say it is 3999) that the old data (0->3998)
> > might be still there - don't know how important that is?
> 
> This is true. I spoke with IanC about this, and we *think* that this is
> ok. Any old data that is there will have already been given to blkback,
> so we're not really leaking data that we shouldn't be. 

Put a comment in saying that. In case in the future we want to share
the persistent grants with other domains, we would need to address this.
