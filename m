Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab1CFGsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 01:48:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:36268 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1CFGsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 01:48:08 -0500
Date: Sun, 6 Mar 2011 17:47:55 +1100
From: NeilBrown <neilb@suse.de>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, James.Bottomley@suse.de
Subject: Re: [PATCH] Fix over-zealous flush_disk when changing device size.
Message-ID: <20110306174755.49404c8e@notabene.brown>
In-Reply-To: <1299259506.2118.24.camel@grinch>
References: <20110217165057.5c50e566@notabene.brown>
	<20110303143120.GA8134@infradead.org>
	<20110304111624.4be27aaf@notabene.brown>
	<1299259506.2118.24.camel@grinch>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Mar 2011 10:25:06 -0700 Andrew Patterson <andrew.patterson@hp.com>
wrote:

> On Fri, 2011-03-04 at 11:16 +1100, NeilBrown wrote:
> > On Thu, 3 Mar 2011 09:31:20 -0500 Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > On Thu, Feb 17, 2011 at 04:50:57PM +1100, NeilBrown wrote:
> > > > 
> > > > Hi Andrew (and others)
> > > >  I wonder if you would review the following for me and comment.
> > > 
> > > Please send think in this area through -fsdevel next time, thanks!
> > 
> > Will try to remember - it is sometimes hard to get this sort of patch before
> > the right audience ... I thought "block layer" rather than "file systems" :-(
> > 
> > Thanks for finding it anyway.
> > 
> > > 
> > > > There are two cases when we call flush_disk.
> > > > In one, the device has disappeared (check_disk_change) so any
> > > > data will hold becomes irrelevant.
> > > > In the oter, the device has changed size (check_disk_size_change)
> > > > so data we hold may be irrelevant.
> > > > 
> > > > In both cases it makes sense to discard any 'clean' buffers,
> > > > so they will be read back from the device if needed.
> > > 
> > > Does it?  If the device has disappeared we can't read them back anyway.
> > 
> > I think that is the point - return an error rather than stale data.
> > 
> > > If the device has resized to a smaller size the same is true about
> > > those buffers that have gone away, and if it has resized to a larger
> > > size invalidating anything doesn't make sense at all.  I think this
> > > area needs more love than a quick kill_dirty hackjob.
> > 
> > I tend to agree.  I wasn't entirely convinced by the changelog comments on
> > the original offending patch, but I couldn't convince myself there was no
> > justification either, and I wanted to fix the corruption I saw - while close
> > to the end of a release cycle - without introducing any new regressions.
> > 
> > > 
> > > > In the former case it makes sense to discard 'dirty' buffers
> > > > as there will never be anywhere safe to write the data.  In the
> > > > second case it *does*not* make sense to discard dirty buffers
> > > > as that will lead to file system corruption when you simply enlarge
> > > > the containing devices.
> > > 
> > > Doing anything like this at the buffer cache layer or inode cache layer
> > > doesn't make any sense.  If a device goes away or shrinks below the
> > > filesystem size the filesystem simply needs to be shut down and in te
> > > former size the admin needs to start a manual repair.  Trying to do
> > > any botch jobs in lower layer never works in practice.
> > 
> > Amen.
> > What I personally would really like to see is an interface for the block
> > device to say to the filesystem (or more specifically: whatever has bdclaimed
> > it) "I am about to resize to $X - is that OK?" and also "I have resized -
> > deal with it".
> > 
> > > 
> > > For now I think the best short term fix is to simply revert commit
> > > 608aeef17a91747d6303de4df5e2c2e6899a95e8
> > > 
> > > 	"Call flush_disk() after detecting an online resize."
> > 
> > You may be right, but I suspect that Andrew Patterson had a real issue to
> > solve which lead to submitting it, and I'd really like to understand that
> > issue before I would feel confident just reverting it.
> > 
> > Andrew:  are you out there?  Can you provide some background for your patch?
> 
> I put in the flush disk stuff at the suggestion of James Bottomley. In
> fact the text for the justification in 608aeef17a91747d6303 is mostly
> his.  The idea is to get errors reported immediately rather than waiting
> around for them to eventually get flushed and to make sure stale data is
> not kept around.  Certainly, at a minimum, not keeping stale data around
> seems valuable to me. 
> 
> What parts of the original justification did you think are unconvincing?
> Note that the flush for growing the device is really only there for the
> degenerate case where someone might shrink then grow a device
> (admittedly, the user probably deserves to get data corruption/security
> holes in such a case).

hi Andrew.

 One of the things that I didn't like about the change log is that it didn't
 give clear context - what exactly is the problem it is trying to fix?
 When you talk about "disks" changing size (reduced radius:-?) I think first
 of 'dm' and  'md' - yet it clearly isn't dm related as dm doesn't even use
 that code, and if it was 'md' related I would have thought I would have
 heard about it....
 So presumably these are some SCSI-attached devices that do internal volume
 management and can change the size of .... targets?  LUNs?  something like
 that.
 So can these things change size without the SCSI layer immediately knowing
 about it??  Don't you get some sort of "unit attention" or something?

 The idea that the device might reduce in size and then grow again seems just
 plain wrong.  If that is possible it could return to it's original size and
 you would never notice?  And if there are cases that you know you will never
 notice, then it seems like it is the wrong solution.
 It would have been more credible if it *only* tried to flush when the size
 was reduced ... which you do suggest as a possibility above I think.


 The "potential security hole" seems completely bogus.
  If you give me permission to read something, and I do, then you remove that
  permission, the fact that I still remember what I read is not a security
  hole.  It is a natural fact of life

 As for the two cases: I would describe them:
   1. planned.  The fs is already shrunk to within the new boundary so there
      is nothing to be gained by flushing, and we could have to reload a
      pile of data from storage which would be pointless
   2. unplanned.  The fs is probably toast, so whether we invalidate or not
      isn't going to make a whole lot of difference.

 So I would vote for not flushing.

 The "not keeping stale data around" argument ... the only data that is
 clearly stale is data that is in the block-device cache and beyond the new
 EOF.  Most filesystems keep most data in the page cache rather than the
 block device cache so this would just be some metadata - maybe inode tables
 or block usage bitmaps or similar.  And caches regularly keep data around
 that isn't actually going to be used - so keeping a bit more on the rare
 occasion of a block-device-resize doesn't seem like an important cost.

 Getting errors a little bit earlier in the case of an unplanned shrink is
 possibly a credible argument.  This would be read errors only of course -
 write errors would still arrive at the same time.  I'm not sure it would
 really be very much earlier...maybe a bit in some cases.

 On the whole, the arguments both for and against this change - in principle
 - seem rather weak:  "maybe" and "possibly" rather than something concrete.

 So given that (due to an oversight) it actually causes filesystem
 corruption, I tend to agree with Christoph that the best approach at this
 stage is the revert the original patch, and then review all the related code
 and come up with a "correct" approach.


 And just to clarify: when I first found that description "unconvincing" I
 hadn't thought through all of these issues - I think it was just that the
 justification seems vague rather than concrete, so it was hard to reason
 about it.


 Would you be uncomfortable if I asked Linus to revert both my fix and your
 original patch??

Thanks,
NeilBrown

