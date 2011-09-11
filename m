Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab1IKGTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 02:19:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1IKGTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 02:19:04 -0400
Date: Sun, 11 Sep 2011 08:18:54 +0200
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org
Subject: Re: [GIT] Bcache version 12
Message-ID: <20110911081854.2958fdc8@notabene.brown>
In-Reply-To: <20110910064531.GA32536@moria>
References: <20110910064531.GA32536@moria>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Sep 2011 23:45:31 -0700 Kent Overstreet <kent.overstreet@gmail.com>
wrote:

> bcache, n.: a cache for arbitrary block devices that uses an SSD
> 
> It's probably past time I started poking people to see about getting
> this stuff in. It's synced up with mainline, the documentation is for
> once relatively up to date, and it looks just about production ready.
> 
> Suggestions are more than welcome on how to make it easier to review -
> it's entirely too much code, I know (near 10k lines now). I'll be
> emailing the patches that touch other parts of the kernel separately.
> 
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itself
> as a new block device, a bit like say md. You can cache an arbitrary
> number of block devices with a single cache device, and attach and
> detach things at runtime - it's quite flexible.
> 
> It's very fast. It uses a b+ tree for the index, along with a journal to
> coalesce index updates, and a bunch of other cool tricks like auxiliary
> binary search trees with software floating point keys to avoid a bunch
> of random memory accesses when doing binary searches in the btree. It
> does over 50k iops doing 4k random /writes/ without breaking a sweat,
> and would do many times that if I had faster hardware.
> 
> It (configurably) tracks and skips sequential IO, so as to efficiently
> cache random IO. It's got more cool features than I can remember at this
> point. It's resilient, handling IO errors from the SSD when possible up
> to a configurable threshhold, then detaches the cache from the backing
> device even while you're still using it.
> 
> The code is up at
> git://evilpiepirate.org/~kent/linux-bcache.git

In particular it is in the bcache-3.1 branch I assume.
The  HEAD branch is old 2.6.34 code.

> git://evilpiepirate.org/~kent/bcache-tools.git
> 
> The wiki is woefully out of date, but that might change one day:
> http://bcache.evilpiepirate.org
> 
> The most up to date documentation is in the kernel tree -
> Documentation/bcache.txt
> 
>  Documentation/ABI/testing/sysfs-block-bcache |  156 +
>  Documentation/bcache.txt                     |  265 +
>  block/Kconfig                                |   36 +
>  block/Makefile                               |    4 +
>  block/bcache.c                               | 8479 ++++++++++++++++++++++++++
>  block/bcache_util.c                          |  661 ++
>  block/bcache_util.h                          |  555 ++
>  fs/bio.c                                     |    9 +-

Any change that a new driver needs to existing code much raise a big question
mark.
This change in bio.c looks like a bit of a hack.  Could you just provide a
'front_pad' to bioset_create to give you space in each bio to store the
bio pool that the bio was allocated from.  See use of
mddev_bio_destructor in drivers/md/md.c for an example.


>  include/linux/blk_types.h                    |    2 +
>  include/linux/sched.h                        |    4 +

Could we have a few words justifying the new fields in task_struct?

In general your commit logs are much much to brief (virtually non-existent).
It is much easier to review code if you also tell us what the purpose is :-)


>  include/trace/events/bcache.h                |   53 +
>  kernel/fork.c                                |    3 +

Does this code even compile?
fork.c now has
+#ifdef CONFIG_BLK_CACHE
+       p->sequential_io = p->nr_ios = 0;
+#endif

but you have removed nr_ios from task_struct ??



>  12 files changed, 10225 insertions(+), 2 deletions(-)


Looking at bcache.txt....

To make bcache devices known to the kernel, echo them to /sys/fs/bcache/register
  echo /dev/sdb > /sys/fs/bcache/register
  echo /dev/sdc > /sys/fs/bcache/register

???
I know that /sys is heading the way of /proc and becoming a disorganised ad
hoc mess, but we don't need to actively encourage that.
So when you are created a new block device type, putting controls
under /sys/fs (where I believe 'fs' stands for "file system") seem ill
advised.

My personal preference would be to see this as configuring the module and us
  /sys/modules/bcache/parameters/register

Alternately you could device a new 'bus' type for bcache and do some sort of
device-model magic to attach something as a new device of that type.

NeilBrown
