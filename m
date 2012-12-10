Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2LJWM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:12:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2LJWMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:12:24 -0500
Date: Mon, 10 Dec 2012 23:12:22 +0100
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Subject: Read starvation by sync writes
Message-ID: <20121210221222.GA25700@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  I was looking into IO starvation problems where streaming sync writes (in
my case from kjournald but DIO would look the same) starve reads. This is
because reads happen in small chunks and until a request completes we don't
start reading further (reader reads lots of small files) while writers have
plenty of big requests to submit. Both processes end up fighting for IO
requests and writer writes nr_batching 512 KB requests while reader reads
just one 4 KB request or so. Here the effect is magnified by the fact that
the drive has relatively big queue depth so it usually takes longer than
BLK_BATCH_TIME to complete the read request. The net result is it takes
close to two minutes to read files that can be read under a second without
writer load. Without the big drive's queue depth, results are not ideal but
they are bearable - it takes about 20 seconds to do the reading. And for
comparison, when writer and reader are not competing for IO requests (as it
happens when writes are submitted as async), it takes about 2 seconds to
complete reading.

Simple reproducer is:

echo 3 >/proc/sys/vm/drop_caches
dd if=/dev/zero of=/tmp/f bs=1M count=10000 &
sleep 30
time cat /etc/* 2>&1 >/dev/null
killall dd
rm /tmp/f

  The question is how can we fix this? Two quick hacks that come to my mind
are remove timeout from the batching logic (is it that important?) or
further separate request allocation logic so that reads have their own
request pool. More systematic fix would be to change request allocation
logic to always allow at least a fixed number of requests per IOC. What do
people think about this?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
