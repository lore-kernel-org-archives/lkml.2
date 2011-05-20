Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935246Ab1ETFCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:02:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1ETFCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=h4Ne0vttxhVuo8Qs51kBiQc+zqD1Mw8bvqcRaYVedLrbBtZgFbqd551ZEu5ZAkpQSQ
         xA4PS0CSwkR5ZnvSjQlQ==
Date: Thu, 19 May 2011 22:02:37 -0700
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [GIT] Bcache version 11
Message-ID: <20110520050237.GA383@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcache is a patch to use SSDs to cache arbitrary block devices.  Its
main claim to fame is that it's designed for the performance
characteristics of SSDs - it avoids random writes and extraneous IO at
all costs, instead allocating buckets sized to your erase blocks and
filling them up seqentially. It uses a hybrid btree/log, instead of a
hash table as some other caches.

It does both writethrough and writeback caching - it can use most of
your SSD for buffering random writes, which are then flushed
sequentially to the backing device. Skips sequential IO, too.

Posting a new version has been long overdue, there's quit a bit of new
stuff...

Backing devices now have a bcache specific superblock, and bcache now
opens them and provides a new stacked device to use instead of the old
way of hooking into an existing block device - and that code has been
removed.

This means you can't accidently use a backing device without the cache,
which is particularly important with writeback caching.

Journalling is done. Bcache does not need a journal for consistency -
it was reliably recovering from unclean shutdown months ago. It's purely
for performance - previously random synchronous btree updates required
writes to multiple leaves, now they can all get staged in the journal.
We can do btree writes much more efficiently and we get a significant
boost in random write performance.

The sysfs interface completely changed, again, for multiple cache device
support. Multiple cache devices aren't working yet, I've got all the
metadata changes done (keys with variable numbers of pointers), struct
cache and cache_set pulled apart - at this point it's just a lot of
detail work left which shouldn't break existing code.

The code should be substantially ready for mainline, but I'm going to
hold off probably another couple months - I expect more disk format
changes, and the userspace interfaces might change again and I'd like to
have multiple cache devices done.

After that there's also a roadmap sketched out for thin provisioning,
and building on top of that some ideas for bcachefs. Basically, the idea
is to stick the inode number in bcache's key and use bcache's
allocator/index/garbage collection for the bottom of a very high
performance filesystem... it's a ways off but it's starting to look very
compelling.

The code's currently based off of 2.6.34 (!). Git repository is up at
  git://evilpiepirate.org/~kent/linux-bcache.git
  git://evilpiepirate.org/~kent/bcache-tools.git

And the wiki is at http://bcache.evilpiepirate.org (very out of date
atm)

 Documentation/ABI/testing/sysfs-block-bcache |  156 +
 Documentation/bcache.txt                     |  171 +
 block/Kconfig                                |   15 +
 block/Makefile                               |    4 +
 block/bcache.c                               | 6735 ++++++++++++++++++++++++++
 block/bcache_util.c                          |  421 ++
 block/bcache_util.h                          |  481 ++
 include/linux/sched.h                        |    4 +
 include/trace/events/bcache.h                |   53 +
 kernel/fork.c                                |    3 +
 10 files changed, 8043 insertions(+), 0 deletions(-)


Documentation/bcache.txt:
Say you've got a big slow raid 6, and an X-25E or three. Wouldn't it be
nice if you could use them as cache... Hence bcache.

Userspace tools and a wiki are at:
  git://evilpiepirate.org/~kent/bcache-tools.git
  http://bcache.evilpiepirate.org

It's designed around the performance characteristics of SSDs - it only allocates
in erase block sized buckets, and it uses a hybrid btree/log to track cached
extants (which can be anywhere from a single sector to the bucket size). It's
designed to avoid random writes at all costs; it fills up an erase block
sequentially, then issues a discard before reusing it.

Both writethrough and writeback caching are supported. Writeback defaults to
off, but can be switched on and off arbitrarily at runtime. Bcache goes to
great lengths to order all writes to the cache so that the cache is always in a
consistent state on disk, and it never returns writes as completed until all
necessary data and metadata writes are completed. It's designed to safely
tolerate unclean shutdown without loss of data.

Writeback caching can use most of the cache for buffering writes - writing
dirty data to the backing device is always done sequentially, scanning from the
start to the end of the index.

Since random IO is what SSDs excel at, there generally won't be much benefit
to caching large sequential IO. Bcache detects sequential IO and skips it;
it also keeps a rolling average of the IO sizes per task, and as long as the
average is above the cutoff it will skip all IO from that task - instead of
caching the first 512k after every seek. Backups and large file copies should
thus entirely bypass the cache.

In the event of an IO error or an inconsistency is detected, caching is
automatically disabled; if dirty data was present in the cache it first
disables writeback caching and waits for all dirty data to be flushed.

Getting started:
You'll need make-bcache from the bcache-tools repository. Both the cache device
and backing device must be formatted before use.
  make-bcache -B /dev/sdb
  make-bcache -C -w2k -b1M -j64 /dev/sdc

To make bcache devices known to the kernel, echo them to /sys/fs/bcache/register:
  echo /dev/sdb > /sys/fs/bcache/register
  echo /dev/sdc > /sys/fs/bcache/register

When you register a backing device, you'll get a new /dev/bcache# device:
  mkfs.ext4 /dev/bcache0
  mount /dev/bcache0 /mnt

Cache devices are managed as sets; multiple caches per set isn't supported yet
but will allow for mirroring of metadata and dirty data in the future. Your new
cache set shows up as /sys/fs/bcache/<UUID>

To enable caching, you need to attach the backing device to the cache set by
specifying the UUID:
  echo <UUID> > /sys/block/sdb/bcache/attach

The cache set with that UUID need not be registered to attach to it - the UUID
will be saved to the backing device's superblock and it'll start being cached
when the cache set does show up.

This only has to be done once. The next time you reboot, just reregister all
your bcache devices. If a backing device has data in a cache somewhere, the
/dev/bcache# device won't be created until the cache shows up - particularly
important if you have writeback caching turned on.

If you're booting up and your cache device is gone and never coming back, you
can force run the backing device: 
  echo 1 > /sys/block/sdb/bcache/running

The backing device will still use that cache set if it shows up in the future,
but all the cached data will be invalidated. If there was dirty data in the
cache, don't expect the filesystem to be recoverable - you will have massive
filesystem corruption, though ext4's fsck does work miracles.

Other sysfs files for the backing device:

  bypassed
    Sum of all IO, reads and writes, than have bypassed the cache

  cache_hits
  cache_misses
  cache_hit_ratio
    Hits and misses are counted per individual IO as bcache sees them; a
    partial hit is counted as a miss.

  clear_stats
    Writing to this file resets all the statistics

  flush_delay_ms
  flush_delay_ms_sync
    Optional delay for btree writes to allow for more coalescing of updates to
    the index. Default to 0.

  sequential_cutoff
    A sequential IO will bypass the cache once it passes this threshhold; the
    most recent 128 IOs are tracked so sequential IO can be detected even when
    it isn't all done at once.

  unregister
    Writing to this file disables caching on that device

  writeback
    Boolean, if off only writethrough caching is done

  writeback_delay
    When dirty data is written to the cache and it previously did not contain
    any, waits some number of seconds before initiating writeback. Defaults to
    30.

  writeback_percent
    To allow for more buffering of random writes, writeback only proceeds when
    more than this percentage of the cache is unavailable. Defaults to 0.

  writeback_running
    If off, writeback of dirty data will not take place at all. Dirty data will
    still be added to the cache until it is mostly full; only meant for
    benchmarking. Defaults to on.

For the cache:
  btree_avg_keys_written
    Average number of keys per write to the btree when a node wasn't being
    rewritten - indicates how much coalescing is taking place.

  btree_cache_size
    Number of btree buckets currently cached in memory

  btree_written
    Sum of all btree writes, in (kilo/mega/giga) bytes

  clear_stats
    Clears the statistics associated with this cache

  discard
    Boolean; if on a discard/TRIM will be issued to each bucket before it is
    reused. Defaults to on if supported.

  heap_size
    Number of buckets that are available for reuse (aren't used by the btree or
    dirty data)

  nbuckets
    Total buckets in this cache

  synchronous
    Boolean; when on all writes to the cache are strictly ordered such that it
    can recover from unclean shutdown. If off it will not generally wait for
    writes to complete, but the entire cache contents will be invalidated on
    unclean shutdown. Not recommended that it be turned off when writeback is
    on.

  unregister
    Closes the cache device and all devices being cached; if dirty data is
    present it will disable writeback caching and wait for it to be flushed.

  written
    Sum of all data that has been written to the cache; comparison with
    btree_written gives the amount of write inflation in bcache.

To script the UUID lookup, you could do something like:
  echo "`blkid /dev/md1 -s UUID -o value` /dev/md1"\
	  > /sys/kernel/config/bcache/register_dev

Caveats:

Bcache appears to be quite stable and reliable at this point, but there are a
number of potential issues.

The ordering requirement of barriers is silently ignored; for ext4 (and
possibly other filesystems) you must explicitly mount with -o nobarrier or you
risk severe filesystem corruption in the event of unclean shutdown.
