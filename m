Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab0FUS5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:57:03 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60516 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab0FUS47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:56:59 -0400
Message-ID: <4C1FB5F7.3070908@kernel.dk>
Date: Mon, 21 Jun 2010 20:56:55 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk> <20100621110436.GA4056@lst.de>
In-Reply-To: <20100621110436.GA4056@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/10 13.04, Christoph Hellwig wrote:
> On Mon, Jun 21, 2010 at 12:04:06PM +0200, Jens Axboe wrote:
>> It's also annotation for blktrace, so you can tell which parts of the IO
>> is meta data etc. The scheduler impact is questionable, I doubt it makes
>> a whole lot of difference.
> 
>> For analysis purposes, annotating all meta data IOs as such would be
>> beneficial (reads as well as writes). As mentioned above, the current
>> scheduler impact isn't huge. There may be some interesting test and
>> benchmarks there for improving that part.
> 
> As mentioned in the previous mail the use of the flag is not very
> wide spread. Currently it's only ext3/ext3 inodes and directories as well
> as all metadata I/O in gfs2 that gets marked this way.  And I'd be much more
> comfortable to add more annotations if it didn't also have some form
> of schedule impact.  The I/O schedules in general and cfq in particular
> have caused us far too many issues with such subtile differences.

FWIW, Windows marks meta data writes and they go out with FUA set
on SATA disks. And SATA firmware prioritizes FUA writes, it's essentially
a priority bit as well as a platter access bit. So at least we have some
one else using a meta data boost. I agree that it would be a lot more
trivial to add the annotations if they didn't have scheduler impact
as well, but I still think it's a sane thing.

>>> 	This one is used in quite a few places, with many of them
>>> 	obsfucated by macros like rw_is_sync, rq_is_sync and
>>> 	cfq_bio_sync.  In general all uses seem to imply giving
>>> 	a write request the same priority as a read request and
>>> 	treat it as synchronous.  I could not spot a place where
>>> 	it actually has any effect on reads.
>>
>> Reads are sync by nature in the block layer, so they don't get that
>> special annotation.
> 
> Well, we do give them this special annotation in a few places, but we
> don't actually use it.

For unplugging?

>> So a large part of that problem is the overloaded meaning of sync. For
>> some cases it means "unplug on issue", and for others it means that the
>> IO itself is syncronous. The other nasty bit is the implicit plugging
>> that happens behind the back of the submitter, but that's an issue to
>> tackle separately. I'd suggest avoiding unnecessary churn in naming of
>> those.
> 
> Well, the current naming is extremly confusing.  The best thing I could
> come up with is to completely drop READ_SYNC and WRITE_SYNC and just
> pass REQ_UNPLUG explicitly together with READ / WRITE_SYNC_PLUG.
> There's only 5 respective 8 users of them, so explicitly documenting
> our intentions there seems useful.  Especially if we want to add more
> _META annotation in which case the simple READ_* / WRITE_* macros
> don't do anymore either.  Similarly it might be useful to remove
> READ_META/WRITE_META and replace them with explicit | REQ_META, which
> is just about as short and a lot more descriptive, especially for
> synchronous metadata writes.

Sure, we can add the explicit plug naming, I don't have an issue
with that.

>>> 	Why do O_DIRECT writes not want to set REQ_NOIDLE (and that
>>> 	exactly does REQ_NOIDLE mean anyway).  It's the only sync writes
>>> 	that do not set it, so if this special case went away we
>>> 	could get rid of the flag and key it off REQ_SYNC.
>>
>> See above for NOIDLE. You kill O_DIRECT write throughput if you don't
>> idle at the end of a write, if you have other activity on the disk.
> 
> Ok, makes sense.  Would you mind taking a patch to kill the
> WRITE_ODIRECT_PLUG and just do a
> 
> 	/*
> 	 * O_DIRECT writes are synchronous, but we must not disable the
> 	 * idling logic in CFQ to avoid killing performance.
> 	 */
> 	if (rw & WRITE)
> 		rw |= REQ_SYNC;

At the caller site? Sure.

> But that leaves the question why disabling the idling logical for
> data integrity ->writepage is fine?  This gets called from ->fsync
> or O_SYNC writes and will have the same impact as O_DIRECT writes.

We have never enabled idling for those. O_SYNC should get a nice
boost too, it just needs to be benchmarked and tested and then
there would be no reason not to add it.

-- 
Jens Axboe

