Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab2AaWW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:22:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab2AaWW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:22:26 -0500
Date: Tue, 31 Jan 2012 17:22:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>,
        Herbert Poetzl <herbert@13thfloor.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Wu Fengguang <wfg@linux.intel.com>
Subject: Re: [PATCH] fix readahead pipeline break caused by block plug
Message-ID: <20120131222217.GE4378@redhat.com>
References: <1327996780.21268.42.camel@sli10-conroe>
 <20120131220333.GD4378@redhat.com>
 <20120131141301.ba35ffe0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120131141301.ba35ffe0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 02:13:01PM -0800, Andrew Morton wrote:

[..]
> > For me, this patch helps only so much and does not get back all the
> > performance lost in case of raw disk read. It does improve the throughput
> > from around 85-90 MB/s to 110-120 MB/s but running the same dd with
> > iflag=direct, gets me more than 250MB/s.
> > 
> > # echo 3 > /proc/sys/vm/drop_caches 
> > # dd if=/dev/sdb of=/dev/null bs=1M count=1K
> > 1024+0 records in
> > 1024+0 records out
> > 1073741824 bytes (1.1 GB) copied, 9.03305 s, 119 MB/s
> > 
> > echo 3 > /proc/sys/vm/drop_caches 
> > # dd if=/dev/sdb of=/dev/null bs=1M count=1K iflag=direct
> > 1024+0 records in
> > 1024+0 records out
> > 1073741824 bytes (1.1 GB) copied, 4.07426 s, 264 MB/s
> 
> Buffered I/O against the block device has a tradition of doing Weird
> Things.  Do you see the same behavior when reading from a regular file?

No. Reading file on ext4 file system is working just fine.

> 
> > I think it is happening because in case of raw read we are submitting
> > one page at a time to request queue
> 
> (That's not a raw read - it's using pagecache.  Please get the terms right!)

Ok.

> 
> We've never really bothered making the /dev/sda[X] I/O very efficient
> for large I/O's under the (probably wrong) assumption that it isn't a
> very interesting case.  Regular files will (or should) use the mpage
> functions, via address_space_operations.readpages().  fs/blockdev.c
> doesn't even implement it.
> 
> > and by the time all the pages
> > are submitted and one big merged request is formed it wates lot of time.
> 
> But that was the case in eariler kernels too.  Why did it change?

Actually, I assumed that the case of reading /dev/sda[X] worked well in
earlier kernels. Sorry about that. Will build a 2.6.38 kernel tonight
and run the test case again to make sure we had same overhead and
relatively poor performance while reading /dev/sda[X].

I think I got confused with Eric's result in another mail where he was
reading /dev/sda and getting around 265MB/s with plug removed. And I was
wondering that why am I not getting same results.

# echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sdb of=/dev/null bs=2M
# count=2048
2048+0 enregistrements lus
2048+0 enregistrements écrits
4294967296 octets (4,3 GB) copiés, 16,2309 s, 265 MB/s

Maybe something to do with SSD. I will test it anyway with older kernel.

Thanks
Vivek
