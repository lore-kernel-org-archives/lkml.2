Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2LLKLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:11:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab2LLKLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:11:10 -0500
Date: Wed, 12 Dec 2012 11:11:08 +0100
From: Jan Kara <jack@suse.cz>
To: Shaohua Li <shli@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: Read starvation by sync writes
Message-ID: <20121212101108.GC18885@quack.suse.cz>
References: <20121210221222.GA25700@quack.suse.cz>
 <CANejiEW2+iUVnyV0EV2n=vi_+bjX42SkeT9F6EUV5LkwXH4e0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANejiEW2+iUVnyV0EV2n=vi_+bjX42SkeT9F6EUV5LkwXH4e0g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 12-12-12 10:55:15, Shaohua Li wrote:
> 2012/12/11 Jan Kara <jack@suse.cz>:
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
> >
> >   The question is how can we fix this? Two quick hacks that come to my mind
> > are remove timeout from the batching logic (is it that important?) or
> > further separate request allocation logic so that reads have their own
> > request pool. More systematic fix would be to change request allocation
> > logic to always allow at least a fixed number of requests per IOC. What do
> > people think about this?
> 
> As long as queue depth > workload iodepth, there is little we can do
> to prioritize tasks/IOC. Because throttling a task/IOC means queue
> will be idle. We don't want to idle a queue (especially for SSD), so
> we always push as more requests as possible to the queue, which
> will break any prioritization. As far as I know we always have such
> issue in CFQ for big queue depth disk.
  Yes, I understand that. But actually big queue depth on its own doesn't
make the problem really bad (at least for me). When the reader doesn't have
to wait for free IO requests, it progresses at a reasonable speed. What
makes it really bad is that big queue depth effectively disallows any use
of ioc_batching() mode for the reader and thus it blocks in request
allocation for every single read request unlike writer which always uses
its full batch (32 requests).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
