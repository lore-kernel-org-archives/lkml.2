Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0IGNek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:34:40 -0400
Received: from bar.sig21.net ([80.81.252.164]:60787 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab0IGNee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:34:34 -0400
Date: Tue, 7 Sep 2010 15:34:29 +0200
From: Johannes Stezenbach <js@sig21.net>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: block cache replacement strategy?
Message-ID: <20100907133429.GB3430@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.610,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

during some simple disk read throughput testing I observed
caching behaviour that doesn't seem right.  The machine
has 2G of RAM and AMD Athlon 4850e, x86_64 kernel but 32bit
userspace, Linux 2.6.35.4.  It seems that contents of the
block cache are not evicted to make room for other blocks.
(Or something like that, I have no real clue about this.)

Since this is a rather artificial test I'm not too worried,
but it looks strange to me so I thought I better report it.


zzz:~# echo 3 >/proc/sys/vm/drop_caches 
zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 13.9454 s, 75.2 MB/s
zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 0.92799 s, 1.1 GB/s

OK, seems like the blocks are cached. But:

zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000 skip=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 13.8375 s, 75.8 MB/s
zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000 skip=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 13.8429 s, 75.7 MB/s

Even if I let 15min pass and repeat the dd command
several times, I cannot see any caching effects, it
stays at ~75 MB/s.

zzz:~# cat /proc/meminfo 
MemTotal:        1793272 kB
MemFree:           15216 kB
Buffers:         1378820 kB
Cached:            20080 kB
SwapCached:            0 kB
Active:           792720 kB
Inactive:         758832 kB
Active(anon):      91716 kB
Inactive(anon):    64652 kB
Active(file):     701004 kB
Inactive(file):   694180 kB

But then:

zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 5.23983 s, 200 MB/s
zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 0.908284 s, 1.2 GB/s

zzz:~# cat /proc/meminfo 
MemTotal:        1793272 kB
MemFree:           16168 kB
Buffers:         1377308 kB
Cached:            20660 kB
SwapCached:            0 kB
Active:          1140384 kB
Inactive:         410236 kB
Active(anon):      91716 kB
Inactive(anon):    64652 kB
Active(file):    1048668 kB
Inactive(file):   345584 kB


And finally:

zzz:~# echo 3 >/proc/sys/vm/drop_caches
zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000 skip=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 13.948 s, 75.2 MB/s
zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000 skip=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 0.985031 s, 1.1 GB/s


Now these blocks get cached but then the others don't:

zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 13.9394 s, 75.2 MB/s
zzz:~# dd if=/dev/sda2 of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 13.9403 s, 75.2 MB/s


Best Regards,
Johannes
