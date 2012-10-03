Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2JCDmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 23:42:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46038 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2JCDmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 23:42:33 -0400
Date: Tue, 2 Oct 2012 20:42:00 -0700
From: Kent Overstreet <koverstreet@google.com>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        lkml <linux-kernel@vger.kernel.org>, martin.petersen@oracle.com
Subject: Re: [PATCH] block: makes bio_split support bio without data
Message-ID: <20121003034159.GA24174@moria.home.lan>
References: <20120924145639.3b65fd8b@notabene.brown>
 <20120928162343.GF22647@google.com>
 <20121002162201.2f5d0f91@notabene.brown>
 <20121002210923.GU26488@google.com>
 <20121003133045.272dd564@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003133045.272dd564@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Martin to the cc, so he can chime in on WRITE_SAME if I got it
wrong

On Wed, Oct 03, 2012 at 01:30:45PM +1000, NeilBrown wrote:
> On Tue, 2 Oct 2012 14:09:23 -0700 Kent Overstreet <koverstreet@google.com>
> wrote:
> 
> > On Tue, Oct 02, 2012 at 04:22:01PM +1000, NeilBrown wrote:
> > > On Fri, 28 Sep 2012 09:23:43 -0700 Kent Overstreet <koverstreet@google.com>
> > > wrote:
> > > 
> > > > On Mon, Sep 24, 2012 at 02:56:39PM +1000, NeilBrown wrote:
> > > > > 
> > > > > Hi Jens,
> > > > >  this patch has been sitting in my -next tree for a little while and I was
> > > > >  hoping for it to go in for the next merge window.
> > > > >  It simply allows bio_split() to be used on bios without a payload, such as
> > > > >  'discard'.
> > > > 
> > > > Thing is, at some point in the stack a discard bio is going to have data
> > > > - see blk_add_rquest_payload(), and it used to be the single page was
> > > > added to discard bios above generic_make_request(), in
> > > > blkdev_issue_discard() or whatever it's called.
> > > > 
> > > > So while I'm sure your code works, it's just a fragile way of doing it.
> > > > 
> > > > There's also other types of bios where bi_size has nothing to do with
> > > > the amount of data in the bi_io_vec - actually I think this is a new
> > > > thing, since Martin Petersen just added REQ_WRITE_SAME and I don't think
> > > > there were any other instances besides REQ_DISCARD before.
> > > > 
> > > > So my preference would be defining a mask (REQ_DISCARD|REQ_WRITE_SAME),
> > > > and if bio->bi_rw & that mask is true, just duplicate the bvec or
> > > > whatever.
> > > 
> > > Hi Kent,
> > >  I'm afraid I don't see the relevance of your comments to the patch.
> > > 
> > > The current bio_split code can successfully split a bio with zero or one
> > > bi_vec entry.  If there are more than that, we cannot split.
> > > 
> > > How does it matter whether the bio is a DISCARD or a WRITE_SAME or a DATA or
> > > whatever?
> > 
> > Hrm, I think I didn't explain very well.
> > 
> > After your change, if bio->bi_vcnt != 0, then it splits the bvec.
> > 
> > The trouble is that discard bios do under certain circumstances have
> > bio->bi_vcnt != 0, in which case splitting the bvec is the wrong thing
> > to do - first_sectors will quite likely be bigger than the bvec.
> > 
> > In practice this isn't currently a problem for discard bios, because
> > since Christoph added blk_add_request_payload(), discard bios won't have
> > that bvec added until they hit the scsi layer which will be after any
> > splitting. But this is a fairly recent and unrelated change, and IMO not
> > the kind of behaviour I'd want to rely on.
> > 
> > WRITE_SAME is a problem for the same reason - bio_sectors(bio) may be
> > large, but the bio will always have a single bvec and splitting the bvec
> > is always the wrong thing to do for WRITE_SAME.
> > 
> > So, I think it makes more sense to make the splitting conditional on
> > !(bio->bi_rw & (REQ_DISCARD|REQ_WRITE_SAME)), in addition to
> > bio->bi_vcnt == 1.
> > 
> > ..That make more sense?
> 
> Yes, that does make some more sense, thanks.  However it doesn't convince me
> that we need to change the patch.
> 
> I guess my position is that once we get to this code, we absolutely have to
> split the bio - it maps to two separate devices in a RAID0 or similar so
> not-splitting is not an option.
> 
> Maybe various md devices need to detect and reject REQ_DISCARD requests that
> have a payload and REQ_WRITE_SAME requests?  Or would they need to explicitly
> set a flag to say they accept them?

I think we should be able to split REQ_DISCARD bios that have a payload
or REQ_WRITE_SAME bios just fine though - for both of those cases, the
payload doesn't correspond to a particular sector, so just copy the
original bvec to the two splits and don't do anything else to it.

This gets so much cleaner with immutable bvecs :p

Actually that might be wrong for REQ_DISCARD bios if they had a payload,
I have no idea what that payload is actually for. But that should never
happen anymore, could make do WARN_ON((bio->bi_rw & REQ_DISCARD) &&
bio->bi_vcnt)
