Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2LKVpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:45:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab2LKVpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:45:01 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Read starvation by sync writes
References: <20121210221222.GA25700@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 11 Dec 2012 16:44:15 -0500
In-Reply-To: <20121210221222.GA25700@quack.suse.cz> (Jan Kara's message of
	"Mon, 10 Dec 2012 23:12:22 +0100")
Message-ID: <x49ehiw2rio.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hi,
>
>   I was looking into IO starvation problems where streaming sync writes (in
> my case from kjournald but DIO would look the same) starve reads. This is
> because reads happen in small chunks and until a request completes we don't
> start reading further (reader reads lots of small files) while writers have
> plenty of big requests to submit. Both processes end up fighting for IO
> requests and writer writes nr_batching 512 KB requests while reader reads
> just one 4 KB request or so. Here the effect is magnified by the fact that
> the drive has relatively big queue depth so it usually takes longer than
> BLK_BATCH_TIME to complete the read request. The net result is it takes
> close to two minutes to read files that can be read under a second without
> writer load. Without the big drive's queue depth, results are not ideal but
> they are bearable - it takes about 20 seconds to do the reading. And for
> comparison, when writer and reader are not competing for IO requests (as it
> happens when writes are submitted as async), it takes about 2 seconds to
> complete reading.
>
> Simple reproducer is:
>
> echo 3 >/proc/sys/vm/drop_caches
> dd if=/dev/zero of=/tmp/f bs=1M count=10000 &
> sleep 30
> time cat /etc/* 2>&1 >/dev/null
> killall dd
> rm /tmp/f

This is a buffered writer.  How does it end up that you are doing all
synchronous write I/O?  Also, you forgot to mention what file system you
were using, and which I/O scheduler.

Is this happening in some real workload?  If so, can you share what that
workload is?  How about some blktrace data?

>   The question is how can we fix this? Two quick hacks that come to my mind
> are remove timeout from the batching logic (is it that important?) or
> further separate request allocation logic so that reads have their own
> request pool. More systematic fix would be to change request allocation
> logic to always allow at least a fixed number of requests per IOC. What do
> people think about this?

There has been talk of removing the limit on the number of requests
allocated, but I haven't seen patches for it, and I certainly am not
convinced of its practicality.  Today, when using block cgroups you do
get a request list per cgroup, so that's kind of the same thing as one
per ioc.  I can certainly see moving in that direction for the
non-cgroup case.

First, though, I'd like to better understand your workload.

Cheers,
Jeff
