Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0IJQCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:02:55 -0400
Received: from bar.sig21.net ([80.81.252.164]:39246 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab0IJQCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:02:54 -0400
Date: Fri, 10 Sep 2010 18:02:48 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: block cache replacement strategy?
Message-ID: <20100910160247.GA637@sig21.net>
References: <20100907133429.GB3430@sig21.net>
 <20100909120044.GA27765@sig21.net>
 <20100910120235.455962c4@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910120235.455962c4@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.587,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 12:02:35PM +0200, Florian Mickler wrote:
> > On Tue, Sep 07, 2010 at 03:34:29PM +0200, Johannes Stezenbach wrote:
> > > 
> > > during some simple disk read throughput testing I observed
> > > caching behaviour that doesn't seem right.  The machine
> > > has 2G of RAM and AMD Athlon 4850e, x86_64 kernel but 32bit
> > > userspace, Linux 2.6.35.4.  It seems that contents of the
> > > block cache are not evicted to make room for other blocks.
> > > (Or something like that, I have no real clue about this.)
> > > 
> > > Since this is a rather artificial test I'm not too worried,
> > > but it looks strange to me so I thought I better report it.
> 
> Well I personally have  no clue about the block caching, but perhaps
> that is an heuristic to prevent the cache from fluctuating too much?
> Some minimum time a block is hold... in a big linear read the cache is
> useless anyway most of the time, so it could make some sense...
> 
> You could try accessing random files after filling up the cache and
> check if those evict the the cache.  That should rule out any
> linear-read-detection heuristic. 

OK, here is another run with simple files (using two kvm images
I had lying around).
Note how the cache used by /dev/sda2 apparently prevents the
kvm image from being cached, but also how the cache used by test.img
prevents test2.img from being cached.

Linear read heuristic might be a good guess, but it would
be nice to hear a comment from a vm/fs expert which
confirms this works as intended.


Thanks
Johannes

zzz:~# echo 3 >/proc/sys/vm/drop_caches
zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 13.9516 s, 75.2 MB/s
zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 0.957778 s, 1.1 GB/s

zzz:~# dd if=~js/qemu/test.img of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 18.4247 s, 56.9 MB/s
zzz:~# dd if=~js/qemu/test.img of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 18.3675 s, 57.1 MB/s
zzz:~# dd if=~js/qemu/test.img of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 18.3925 s, 57.0 MB/s

zzz:~# echo 3 >/proc/sys/vm/drop_caches
zzz:~# dd if=~js/qemu/test.img of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 18.5455 s, 56.5 MB/s
zzz:~# dd if=~js/qemu/test.img of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 0.950387 s, 1.1 GB/s

zzz:~# dd if=~js/qemu/test2.img of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 18.085 s, 58.0 MB/s
zzz:~# dd if=~js/qemu/test2.img of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 17.7351 s, 59.1 MB/s
