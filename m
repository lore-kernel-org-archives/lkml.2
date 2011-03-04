Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab1CDAQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 19:16:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:56225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab1CDAQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 19:16:47 -0500
Date: Fri, 4 Mar 2011 11:16:24 +1100
From: NeilBrown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Patterson <andrew.patterson@hp.com>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, James.Bottomley@suse.de
Subject: Re: [PATCH] Fix over-zealous flush_disk when changing device size.
Message-ID: <20110304111624.4be27aaf@notabene.brown>
In-Reply-To: <20110303143120.GA8134@infradead.org>
References: <20110217165057.5c50e566@notabene.brown>
	<20110303143120.GA8134@infradead.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 09:31:20 -0500 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Feb 17, 2011 at 04:50:57PM +1100, NeilBrown wrote:
> > 
> > Hi Andrew (and others)
> >  I wonder if you would review the following for me and comment.
> 
> Please send think in this area through -fsdevel next time, thanks!

Will try to remember - it is sometimes hard to get this sort of patch before
the right audience ... I thought "block layer" rather than "file systems" :-(

Thanks for finding it anyway.

> 
> > There are two cases when we call flush_disk.
> > In one, the device has disappeared (check_disk_change) so any
> > data will hold becomes irrelevant.
> > In the oter, the device has changed size (check_disk_size_change)
> > so data we hold may be irrelevant.
> > 
> > In both cases it makes sense to discard any 'clean' buffers,
> > so they will be read back from the device if needed.
> 
> Does it?  If the device has disappeared we can't read them back anyway.

I think that is the point - return an error rather than stale data.

> If the device has resized to a smaller size the same is true about
> those buffers that have gone away, and if it has resized to a larger
> size invalidating anything doesn't make sense at all.  I think this
> area needs more love than a quick kill_dirty hackjob.

I tend to agree.  I wasn't entirely convinced by the changelog comments on
the original offending patch, but I couldn't convince myself there was no
justification either, and I wanted to fix the corruption I saw - while close
to the end of a release cycle - without introducing any new regressions.

> 
> > In the former case it makes sense to discard 'dirty' buffers
> > as there will never be anywhere safe to write the data.  In the
> > second case it *does*not* make sense to discard dirty buffers
> > as that will lead to file system corruption when you simply enlarge
> > the containing devices.
> 
> Doing anything like this at the buffer cache layer or inode cache layer
> doesn't make any sense.  If a device goes away or shrinks below the
> filesystem size the filesystem simply needs to be shut down and in te
> former size the admin needs to start a manual repair.  Trying to do
> any botch jobs in lower layer never works in practice.

Amen.
What I personally would really like to see is an interface for the block
device to say to the filesystem (or more specifically: whatever has bdclaimed
it) "I am about to resize to $X - is that OK?" and also "I have resized -
deal with it".

> 
> For now I think the best short term fix is to simply revert commit
> 608aeef17a91747d6303de4df5e2c2e6899a95e8
> 
> 	"Call flush_disk() after detecting an online resize."

You may be right, but I suspect that Andrew Patterson had a real issue to
solve which lead to submitting it, and I'd really like to understand that
issue before I would feel confident just reverting it.

Andrew:  are you out there?  Can you provide some background for your patch?

Thanks,
NeilBrown

