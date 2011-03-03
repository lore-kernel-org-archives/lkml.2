Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab1CCObZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:31:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57262 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab1CCObX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:31:23 -0500
Date: Thu, 3 Mar 2011 09:31:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Patterson <andrew.patterson@hp.com>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, James.Bottomley@suse.de
Subject: Re: [PATCH] Fix over-zealous flush_disk when changing device size.
Message-ID: <20110303143120.GA8134@infradead.org>
References: <20110217165057.5c50e566@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217165057.5c50e566@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 04:50:57PM +1100, NeilBrown wrote:
> 
> Hi Andrew (and others)
>  I wonder if you would review the following for me and comment.

Please send think in this area through -fsdevel next time, thanks!

> There are two cases when we call flush_disk.
> In one, the device has disappeared (check_disk_change) so any
> data will hold becomes irrelevant.
> In the oter, the device has changed size (check_disk_size_change)
> so data we hold may be irrelevant.
> 
> In both cases it makes sense to discard any 'clean' buffers,
> so they will be read back from the device if needed.

Does it?  If the device has disappeared we can't read them back anyway.
If the device has resized to a smaller size the same is true about
those buffers that have gone away, and if it has resized to a larger
size invalidating anything doesn't make sense at all.  I think this
area needs more love than a quick kill_dirty hackjob.

> In the former case it makes sense to discard 'dirty' buffers
> as there will never be anywhere safe to write the data.  In the
> second case it *does*not* make sense to discard dirty buffers
> as that will lead to file system corruption when you simply enlarge
> the containing devices.

Doing anything like this at the buffer cache layer or inode cache layer
doesn't make any sense.  If a device goes away or shrinks below the
filesystem size the filesystem simply needs to be shut down and in te
former size the admin needs to start a manual repair.  Trying to do
any botch jobs in lower layer never works in practice.

For now I think the best short term fix is to simply revert commit
608aeef17a91747d6303de4df5e2c2e6899a95e8

	"Call flush_disk() after detecting an online resize."
