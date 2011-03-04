Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab1CDRfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:35:10 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:17148 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759836Ab1CDRfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:35:08 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 12:35:08 EST
Subject: Re: [PATCH] Fix over-zealous flush_disk when changing device size.
From: Andrew Patterson <andrew.patterson@hp.com>
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, James.Bottomley@suse.de
In-Reply-To: <20110304111624.4be27aaf@notabene.brown>
References: <20110217165057.5c50e566@notabene.brown>
	 <20110303143120.GA8134@infradead.org>
	 <20110304111624.4be27aaf@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 10:25:06 -0700
Message-ID: <1299259506.2118.24.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 11:16 +1100, NeilBrown wrote:
> On Thu, 3 Mar 2011 09:31:20 -0500 Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Thu, Feb 17, 2011 at 04:50:57PM +1100, NeilBrown wrote:
> > > 
> > > Hi Andrew (and others)
> > >  I wonder if you would review the following for me and comment.
> > 
> > Please send think in this area through -fsdevel next time, thanks!
> 
> Will try to remember - it is sometimes hard to get this sort of patch before
> the right audience ... I thought "block layer" rather than "file systems" :-(
> 
> Thanks for finding it anyway.
> 
> > 
> > > There are two cases when we call flush_disk.
> > > In one, the device has disappeared (check_disk_change) so any
> > > data will hold becomes irrelevant.
> > > In the oter, the device has changed size (check_disk_size_change)
> > > so data we hold may be irrelevant.
> > > 
> > > In both cases it makes sense to discard any 'clean' buffers,
> > > so they will be read back from the device if needed.
> > 
> > Does it?  If the device has disappeared we can't read them back anyway.
> 
> I think that is the point - return an error rather than stale data.
> 
> > If the device has resized to a smaller size the same is true about
> > those buffers that have gone away, and if it has resized to a larger
> > size invalidating anything doesn't make sense at all.  I think this
> > area needs more love than a quick kill_dirty hackjob.
> 
> I tend to agree.  I wasn't entirely convinced by the changelog comments on
> the original offending patch, but I couldn't convince myself there was no
> justification either, and I wanted to fix the corruption I saw - while close
> to the end of a release cycle - without introducing any new regressions.
> 
> > 
> > > In the former case it makes sense to discard 'dirty' buffers
> > > as there will never be anywhere safe to write the data.  In the
> > > second case it *does*not* make sense to discard dirty buffers
> > > as that will lead to file system corruption when you simply enlarge
> > > the containing devices.
> > 
> > Doing anything like this at the buffer cache layer or inode cache layer
> > doesn't make any sense.  If a device goes away or shrinks below the
> > filesystem size the filesystem simply needs to be shut down and in te
> > former size the admin needs to start a manual repair.  Trying to do
> > any botch jobs in lower layer never works in practice.
> 
> Amen.
> What I personally would really like to see is an interface for the block
> device to say to the filesystem (or more specifically: whatever has bdclaimed
> it) "I am about to resize to $X - is that OK?" and also "I have resized -
> deal with it".
> 
> > 
> > For now I think the best short term fix is to simply revert commit
> > 608aeef17a91747d6303de4df5e2c2e6899a95e8
> > 
> > 	"Call flush_disk() after detecting an online resize."
> 
> You may be right, but I suspect that Andrew Patterson had a real issue to
> solve which lead to submitting it, and I'd really like to understand that
> issue before I would feel confident just reverting it.
> 
> Andrew:  are you out there?  Can you provide some background for your patch?

I put in the flush disk stuff at the suggestion of James Bottomley. In
fact the text for the justification in 608aeef17a91747d6303 is mostly
his.  The idea is to get errors reported immediately rather than waiting
around for them to eventually get flushed and to make sure stale data is
not kept around.  Certainly, at a minimum, not keeping stale data around
seems valuable to me. 

What parts of the original justification did you think are unconvincing?
Note that the flush for growing the device is really only there for the
degenerate case where someone might shrink then grow a device
(admittedly, the user probably deserves to get data corruption/security
holes in such a case).

Andrew



