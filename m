Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2LLXdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:33:33 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:11404 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466Ab2LLXdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:33:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AosLANwTyVB5LB3g/2dsb2JhbABFhU+zFoYIF3OCHgEBBAE6HCMFCwgDDgouFCUDIROICwW+DBSMN4NiYQOWCJBJgwc
Date: Thu, 13 Dec 2012 10:33:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: Read starvation by sync writes
Message-ID: <20121212233307.GA16353@dastard>
References: <20121210221222.GA25700@quack.suse.cz>
 <x49ehiw2rio.fsf@segfault.boston.devel.redhat.com>
 <20121212023137.GA18885@quack.suse.cz>
 <20121212041821.GV16353@dastard>
 <20121212102617.GD18885@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212102617.GD18885@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 11:26:17AM +0100, Jan Kara wrote:
> On Wed 12-12-12 15:18:21, Dave Chinner wrote:
> > On Wed, Dec 12, 2012 at 03:31:37AM +0100, Jan Kara wrote:
> > > On Tue 11-12-12 16:44:15, Jeff Moyer wrote:
> > > > Jan Kara <jack@suse.cz> writes:
> > > > 
> > > > >   Hi,
> > > > >
> > > > >   I was looking into IO starvation problems where streaming sync writes (in
> > > > > my case from kjournald but DIO would look the same) starve reads. This is
> > > > > because reads happen in small chunks and until a request completes we don't
> > > > > start reading further (reader reads lots of small files) while writers have
> > > > > plenty of big requests to submit. Both processes end up fighting for IO
> > > > > requests and writer writes nr_batching 512 KB requests while reader reads
> > > > > just one 4 KB request or so. Here the effect is magnified by the fact that
> > > > > the drive has relatively big queue depth so it usually takes longer than
> > > > > BLK_BATCH_TIME to complete the read request. The net result is it takes
> > > > > close to two minutes to read files that can be read under a second without
> > > > > writer load. Without the big drive's queue depth, results are not ideal but
> > > > > they are bearable - it takes about 20 seconds to do the reading. And for
> > > > > comparison, when writer and reader are not competing for IO requests (as it
> > > > > happens when writes are submitted as async), it takes about 2 seconds to
> > > > > complete reading.
> > > > >
> > > > > Simple reproducer is:
> > > > >
> > > > > echo 3 >/proc/sys/vm/drop_caches
> > > > > dd if=/dev/zero of=/tmp/f bs=1M count=10000 &
> > > > > sleep 30
> > > > > time cat /etc/* 2>&1 >/dev/null
> > > > > killall dd
> > > > > rm /tmp/f
> > > > 
> > > > This is a buffered writer.  How does it end up that you are doing all
> > > > synchronous write I/O?  Also, you forgot to mention what file system you
> > > > were using, and which I/O scheduler.
> > >   So IO scheduler is CFQ, filesystem is ext3 - which is the culprit why IO
> > > ends up being synchronous - in ext3 in data=ordered mode kjournald often ends
> > > up submitting all the data to disk and it can do it as WRITE_SYNC if someone is
> > > waiting for transaction commit. In theory this can happen with AIO DIO
> > > writes or someone running fsync on a big file as well. Although when I
> > > tried this now, I wasn't able to create as big problem as kjournald does
> > > (a kernel thread submitting huge linked list of buffer heads in a tight loop
> > > is hard to beat ;). Hum, so maybe just adding some workaround in kjournald
> > > so that it's not as aggressive will solve the real world cases as well...
> > 
> > Maybe kjournald shouldn't be using WRITE_SYNC for those buffers? I
> > mean, if there is that many of them then it's really a batch
> > submission an dthe latency of a single buffer IO is really
> > irrelevant to the rate at which the buffers are flushed to disk....
>   Yeah, the idea why kjournald uses WRITE_SYNC is that we know someone is
> waiting for transaction commit and that's pretty much definition of what
> WRITE_SYNC means.

Well, XFS only uses WRITE_SYNC for WB_SYNC_ALL writeback, which
means only when a user is waiting on the wdata writeback will it use
WRITE_SYNC. I'm really not sure what category journal flushes fall
into, because XFS doesn't do data writeback from journal flushes....

> Hum, maybe if DIO wasn't using WRITE_SYNC (one could make similar
> argument there as with kjournald). But then the definition of what
> WRITE_SYNC should mean starts to be pretty foggy.

DIO used WRITE_ODIRECT, not WRITE_SYNC. The difference is that
WRITE_SYNC sets REQ_NOIDLE, so DIO is actually different to
WRITE_SYNC behaviour for CFQ...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
