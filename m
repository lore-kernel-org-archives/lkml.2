Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0JMX4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 19:56:08 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:51536 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753575Ab0JMX4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 19:56:07 -0400
Date: Thu, 14 Oct 2010 10:55:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: fs: Inode cache scalability V3
Message-ID: <20101013235552.GA4681@dastard>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <20101013145102.GA12155@infradead.org>
 <20101013155845.GB22447@infradead.org>
 <20101013214609.GA24695@infradead.org>
 <20101013233647.GA18691@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101013233647.GA18691@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 07:36:48PM -0400, Christoph Hellwig wrote:
> On Wed, Oct 13, 2010 at 05:46:09PM -0400, Christoph Hellwig wrote:
> > On Wed, Oct 13, 2010 at 11:58:45AM -0400, Christoph Hellwig wrote:
> > > 
> > > It's 100% reproducible on my kvm VM.  The bug is the assert_spin_locked
> > > in redirty_tail.  I really can't find a way how we reach it without
> > > d_lock so this really confuses me.
> > 
> > We are for some reason getting a block device inode that is on the
> > dirty list of a bdi that it doesn't point to.  Still trying to figure
> > out how exactly that happens.
> 
> It's because __blkdev_put reset the bdi on the mapping, and bdev inodes
> are still special cased to not use s_bdi unlike everybody else.  So
> we keep switch between different bdis that get locked.
> 
> I wonder what's a good workaround for that.  Just flushing out all
> dirty state of a block device inode on last close would fix, but we'd
> still have all the dragons hidden underneath until we finally sort
> out the bdi reference mess.

Perhaps for the moment make __blkdev_put() move the inode onto the
dirty lists for the default bdi when it switches themin the
mapping? e.g. add a "inode_switch_bdi" helper that is only called in
this case?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
