Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1IJGpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 02:45:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42999 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1IJGpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 02:45:41 -0400
Date: Fri, 9 Sep 2011 23:45:31 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: rdunlap@xenotime.net, axboe@kernel.dk, akpm@linux-foundation.org,
        neilb@suse.de
Subject: [GIT] Bcache version 12
Message-ID: <20110910064531.GA32536@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcache, n.: a cache for arbitrary block devices that uses an SSD

It's probably past time I started poking people to see about getting
this stuff in. It's synced up with mainline, the documentation is for
once relatively up to date, and it looks just about production ready.

Suggestions are more than welcome on how to make it easier to review -
it's entirely too much code, I know (near 10k lines now). I'll be
emailing the patches that touch other parts of the kernel separately.

Short overview:
Bcache does both writethrough and writeback caching. It presents itself
as a new block device, a bit like say md. You can cache an arbitrary
number of block devices with a single cache device, and attach and
detach things at runtime - it's quite flexible.

It's very fast. It uses a b+ tree for the index, along with a journal to
coalesce index updates, and a bunch of other cool tricks like auxiliary
binary search trees with software floating point keys to avoid a bunch
of random memory accesses when doing binary searches in the btree. It
does over 50k iops doing 4k random /writes/ without breaking a sweat,
and would do many times that if I had faster hardware.

It (configurably) tracks and skips sequential IO, so as to efficiently
cache random IO. It's got more cool features than I can remember at this
point. It's resilient, handling IO errors from the SSD when possible up
to a configurable threshhold, then detaches the cache from the backing
device even while you're still using it.

The code is up at
git://evilpiepirate.org/~kent/linux-bcache.git
git://evilpiepirate.org/~kent/bcache-tools.git

The wiki is woefully out of date, but that might change one day:
http://bcache.evilpiepirate.org

The most up to date documentation is in the kernel tree -
Documentation/bcache.txt

 Documentation/ABI/testing/sysfs-block-bcache |  156 +
 Documentation/bcache.txt                     |  265 +
 block/Kconfig                                |   36 +
 block/Makefile                               |    4 +
 block/bcache.c                               | 8479 ++++++++++++++++++++++++++
 block/bcache_util.c                          |  661 ++
 block/bcache_util.h                          |  555 ++
 fs/bio.c                                     |    9 +-
 include/linux/blk_types.h                    |    2 +
 include/linux/sched.h                        |    4 +
 include/trace/events/bcache.h                |   53 +
 kernel/fork.c                                |    3 +
 12 files changed, 10225 insertions(+), 2 deletions(-)
