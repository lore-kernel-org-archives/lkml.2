Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab1ACFQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 00:16:39 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55616 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1ACFQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 00:16:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=l/slIRT7lBGievjZcXdbQALXBUXA723wScJBrH+oqo/nW/Bg1Ek4weTjmnWDac9Q8V
         uE3nSP0WFGYSN5htOoLZKgoLQCT9x/WpOzYZgDGrR9iQsBUyVhkY/swqcipLU7K9/hfc
         fQTtOAlaLfjm1Xzjt0G6U/wNW8YyfXtoSuigs=
Date: Sun, 2 Jan 2011 21:15:30 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Bcache version 10
Message-ID: <20110103051530.GA1386@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcache is a patch to use SSDs to transparently cache arbitrary block
devices. Its main claim to fame is that it's designed for the
performance characteristics of SSDs - it avoids random writes and
extraneous IO at all costs, instead allocating buckets sized to your
erase blocks and filling them up seqentially. It uses a hybrid
btree/log, instead of a hash table as some other caches.

It does both writethrough and writeback caching - it can use most of
your SSD for buffering random writes, which are then flushed
sequentially to the backing device. Skips sequential IO, too.

Bcache currently looks suitable for noncritical use; don't throw it on
your server without testing your specific configuration with it but the
risk of data corruption is minimal.

---

Since the last patch, there hasn't been a huge amount of user visible
stuff. Much of the recent work has been on making memory allocation
deadlock proof, which is mostly done at this point.

Replaced some changes to the bio code with a different less intrusive
way of doing things - this previously caused problems for btrfs and
raid5 (as they used bios without calling bio_init() on them each time).

The userspace interface has been changed a bit more: /sys/kernel/bcache
moves to /sys/kernel/config/bcache, and attaching a cache to a backing
device is now done more explicitly - see Documentation/bcache.txt.

This will be the last version based on 2.6.35, next on my todo list is
syncing up with mainline. All that's left before I'll consider it ready
for mainline is replacing the hooks for transparent caching with
something else; I'm hoping to be able to submit it by the next merge
window but that could turn out to be pure fantasy...

I was previously working on a device mapper interface to replace said
transparent caching, but I'm giving up on that - dm just looks too
unsuited to bcache's needs. If someone who knows the dm code better felt
like taking a stab at it I'll be happy to help (and they should have an
easy time of it, I got it minimally working) but I'm going to be doing
something else.

Further off, once the new block interface is done I'll be starting on
thin provisioning, then tiered storage and multiple cache devices. As
part of thin provisioning, bcache will be getting logical volume
management. I'm perfectly happy to work with anyone else who's
interested on interfaces, userspace and otherwise.

Bcache is available from
git://evilpiepirate.org/~kent/linux-bcache.git
git://evilpiepirate.org/~kent/bcache-tools.git
http://bcache.evilpiepirate.org

 Documentation/ABI/testing/sysfs-block-bcache |  156 +
 Documentation/bcache.txt                     |  178 +
 block/Kconfig                                |   16 +
 block/Makefile                               |    4 +
 block/bcache.c                               | 5505 ++++++++++++++++++++++++++
 block/bcache_util.c                          |   78 +
 block/bcache_util.h                          |  306 ++
 block/blk-core.c                             |    7 +-
 include/linux/bio.h                          |    1 +
 include/linux/blkdev.h                       |    1 +
 include/linux/fs.h                           |    5 +
 include/linux/sched.h                        |    4 +
 kernel/fork.c                                |    3 +
13 files changed, 6262 insertions(+), 2 deletions(-)

