Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0EaPtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:49:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418Ab0EaPtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:49:31 -0400
Date: Tue, 1 Jun 2010 01:49:25 +1000
From: Nick Piggin <npiggin@suse.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Message-ID: <20100531154925.GO9453@laptop>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
 <1275318102.2823.47.camel@mulgrave.site>
 <4C03D5FD.3000202@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C03D5FD.3000202@panasas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 06:30:05PM +0300, Boaz Harrosh wrote:
> On 05/31/2010 06:01 PM, James Bottomley wrote:
> > On Mon, 2010-05-31 at 10:20 -0400, Martin K. Petersen wrote:
> >>>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> >>
> >> Christof> Since the guard tags are created in Linux, it seems that the
> >> Christof> data attached to the write request changes between the
> >> Christof> generation in bio_integrity_generate and the call to
> >> Christof> sd_prep_fn.
> >>
> >> Yep, known bug.  Page writeback locking is messed up for buffer_head
> >> users.  The extNfs folks volunteered to look into this a while back but
> >> I don't think they have found the time yet.
> >>
> >>
> >> Christof> Using ext3 or ext4 instead of ext2 does not show the problem.
> >>
> >> Last I looked there were still code paths in ext3 and ext4 that
> >> permitted pages to be changed during flight.  I guess you've just been
> >> lucky.
> > 
> > Pages have always been modifiable in flight.  The OS guarantees they'll
> > be rewritten, so the drivers can drop them if it detects the problem.
> > This is identical to the iscsi checksum issue (iscsi adds a checksum
> > because it doesn't trust TCP/IP and if the checksum is generated in
> > software, there's time between generation and page transmission for the
> > alteration to occur).  The solution in the iscsi case was not to
> > complain if the page is still marked dirty.
> > 
> 
> And also why RAID1 and RAID4/5/6 need the data bounced. I wish VFS
> would prevent data writing given a device queue flag that requests
> it. So all these devices and modes could just flag the VFS/filesystems
> that: "please don't allow concurrent writes, otherwise I need to copy data"
> 
> >From what Chris Mason has said before, all the mechanics are there, and it's
> what btrfs is doing. Though I don't know how myself?

The filesystems can do it themselves, they should have everything
required.

Easiest way would be to not unlock page during the writeback, unmap
mmaps before taking the checksum, and using vm_flags to prevent
get_user_pages.

More complex and maybe more performant would be to avoid holding page
lock but wait_on_page_writeback in page-modification (write, fault)
paths. More complex again could opportunistically replace the page
with a duplicate one and allow modification ops to continue from there.

That's all possible by overriding existing callbacks though. I don't
think I would like to put branches and flag dependent locking all
over existing functions.

