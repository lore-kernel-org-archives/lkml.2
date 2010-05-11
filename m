Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab0EKLAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 07:00:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:47468 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab0EKK77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 06:59:59 -0400
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Saeed Bishara <saeed@marvell.com>,
       Nicolas Pitre <nico@marvell.com>, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>
In-Reply-To: <1273569821.21352.19.camel@pasglop>
References: <1273569821.21352.19.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 20:57:58 +1000
Message-ID: <1273575478.21352.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 19:23 +1000, Benjamin Herrenschmidt wrote:

> Since I doubt ext3 is busted so dramatically in mainline for "normal" machines,
> I tend to suspect things could be related to the infamous vivt caches. On the
> other hand, it's pretty clearly metadata or journal corruption and I'm not
> sure we ever do things that could cause aliases (such as vmap etc..) on
> these things, and they shouldn't be mapped into userspace... unless it's fsck
> itself that causes aliases to occur at the block device level ? (I do unmount
> though before I run fsck).
> 
> On the other hand, it could also be a busticated marvell SATA driver :-)
> 
> I have no problem with the vendor kernel, but it's ancient (2.6.12) and based
> on an out of tree variant of a Marvell originated BSP, so everything is
> completely different, especially in the area of drivers for the chipset.
> 
> Anyways, I'll see if I can gather more data tomorrow as time, viruses and sick
> kids permits.
> 
> In the meantime, any hint appreciated.

A quick other test which brings more infos, using a smaller (about 5GB)
partition and no md or raid involved:

 - Boot with NFS root
 - mkfs /dev/sdb2 (no md or raid involved)
 - mount /dev/sdb2 /mnt/test
 - rsync -avx /test-stuff /mnt/test
 - cd /mnt/test
 - md5sum -c ~/test-stuff-sums.txt

That gives me a whole bunch of:

md5sum: ./usr/bin/debconf-escape: No such file or directory
./usr/bin/debconf-escape: FAILED open or read
./usr/bin/stat: OK
md5sum: ./usr/bin/chrt: No such file or directory
./usr/bin/chrt: FAILED open or read

In fact, if I do ls /mnt/test/usr/bin/ I see debconf but if I do
ls /mnt/test/usr/bin/chrt then I get No such file or directory.

So something is badly wrong :-)

Now, trying without the dir_index feature (mkfs.ext3 -O ^dir_index)
and it works fine. All my md5sum's are correct and fsck passes.

So there's what looks like a problem specific to htree's. I don't think
it's a SATA driver problem (doesn't smell like it but we can't
completely dismiss the possibility yet). Could be a VIVT issue but then
why ? I don't see ext3 playing with virtual mappings and none of that
should alias with userspace...

Or is it incorrectly accessing pages while they are DMA'ed to or from ?
IE. Accessing with the CPU pages between dma_map_* and dma_unmap_* ?
That will break on a number of setups including swiotlb on x86 so I tend
to doubt it but who knows...

Anyways, enough for tonight.

Cheers,
Ben.


