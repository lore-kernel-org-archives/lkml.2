Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2LLCbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 21:31:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab2LLCbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 21:31:42 -0500
Date: Wed, 12 Dec 2012 03:31:37 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: Read starvation by sync writes
Message-ID: <20121212023137.GA18885@quack.suse.cz>
References: <20121210221222.GA25700@quack.suse.cz>
 <x49ehiw2rio.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ehiw2rio.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-12-12 16:44:15, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >   Hi,
> >
> >   I was looking into IO starvation problems where streaming sync writes (in
> > my case from kjournald but DIO would look the same) starve reads. This is
> > because reads happen in small chunks and until a request completes we don't
> > start reading further (reader reads lots of small files) while writers have
> > plenty of big requests to submit. Both processes end up fighting for IO
> > requests and writer writes nr_batching 512 KB requests while reader reads
> > just one 4 KB request or so. Here the effect is magnified by the fact that
> > the drive has relatively big queue depth so it usually takes longer than
> > BLK_BATCH_TIME to complete the read request. The net result is it takes
> > close to two minutes to read files that can be read under a second without
> > writer load. Without the big drive's queue depth, results are not ideal but
> > they are bearable - it takes about 20 seconds to do the reading. And for
> > comparison, when writer and reader are not competing for IO requests (as it
> > happens when writes are submitted as async), it takes about 2 seconds to
> > complete reading.
> >
> > Simple reproducer is:
> >
> > echo 3 >/proc/sys/vm/drop_caches
> > dd if=/dev/zero of=/tmp/f bs=1M count=10000 &
> > sleep 30
> > time cat /etc/* 2>&1 >/dev/null
> > killall dd
> > rm /tmp/f
> 
> This is a buffered writer.  How does it end up that you are doing all
> synchronous write I/O?  Also, you forgot to mention what file system you
> were using, and which I/O scheduler.
  So IO scheduler is CFQ, filesystem is ext3 - which is the culprit why IO
ends up being synchronous - in ext3 in data=ordered mode kjournald often ends
up submitting all the data to disk and it can do it as WRITE_SYNC if someone is
waiting for transaction commit. In theory this can happen with AIO DIO
writes or someone running fsync on a big file as well. Although when I
tried this now, I wasn't able to create as big problem as kjournald does
(a kernel thread submitting huge linked list of buffer heads in a tight loop
is hard to beat ;). Hum, so maybe just adding some workaround in kjournald
so that it's not as aggressive will solve the real world cases as well...

> Is this happening in some real workload?  If so, can you share what that
> workload is?  How about some blktrace data?
  With ext3 it does happen in a real workload on our servers - e.g. when
you provision KVM images it's a lot of streaming writes and machine
struggles to do anything else during that time. I have put up some 40
seconds of blktrace data to

http://beta.suse.com/private/jack/read_starvation/sda.tar.gz

> >   The question is how can we fix this? Two quick hacks that come to my mind
> > are remove timeout from the batching logic (is it that important?) or
> > further separate request allocation logic so that reads have their own
> > request pool. More systematic fix would be to change request allocation
> > logic to always allow at least a fixed number of requests per IOC. What do
> > people think about this?
> 
> There has been talk of removing the limit on the number of requests
> allocated, but I haven't seen patches for it, and I certainly am not
> convinced of its practicality.  Today, when using block cgroups you do
> get a request list per cgroup, so that's kind of the same thing as one
> per ioc.  I can certainly see moving in that direction for the
> non-cgroup case.
  Ah, I thought blk_get_rl() is one of those trivial wrappers we have in
block layer but now when looking into it, it actually does something useful ;)
Thanks for looking into this!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
