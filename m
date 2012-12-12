Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab2LLDDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 22:03:04 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61652 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2LLDDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 22:03:02 -0500
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 22:03:02 EST
MIME-Version: 1.0
In-Reply-To: <20121210221222.GA25700@quack.suse.cz>
References: <20121210221222.GA25700@quack.suse.cz>
Date: Wed, 12 Dec 2012 10:55:15 +0800
X-Google-Sender-Auth: OeUY7KeUert5_K1ByH5_m5uqJMA
Message-ID: <CANejiEW2+iUVnyV0EV2n=vi_+bjX42SkeT9F6EUV5LkwXH4e0g@mail.gmail.com>
Subject: Re: Read starvation by sync writes
From: Shaohua Li <shli@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/11 Jan Kara <jack@suse.cz>:
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
>
>   The question is how can we fix this? Two quick hacks that come to my mind
> are remove timeout from the batching logic (is it that important?) or
> further separate request allocation logic so that reads have their own
> request pool. More systematic fix would be to change request allocation
> logic to always allow at least a fixed number of requests per IOC. What do
> people think about this?

As long as queue depth > workload iodepth, there is little we can do
to prioritize tasks/IOC. Because throttling a task/IOC means queue
will be idle. We don't want to idle a queue (especially for SSD), so
we always push as more requests as possible to the queue, which
will break any prioritization. As far as I know we always have such
issue in CFQ for big queue depth disk.

Thanks,
Shaohua
