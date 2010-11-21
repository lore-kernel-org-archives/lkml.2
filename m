Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0KUOJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:09:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40635 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab0KUOJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:09:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vidIIKuq35HqncPEYGWPj7BqGkTIIFfRrlPb8qX+l/C4uPyzRDXqv7PYNkYJ4xPxOO
         vdBkogqexB0HBtWv0IcBZfOSNM0VTvavj7MQOvU6BJ9Ijyn/pUB8eJt/6KVpLJTij3ts
         4TmaHzQ3BaV8WqgtKMBLTkmbq5hplG41w9ogo=
Date: Sun, 21 Nov 2010 06:09:34 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Bcache version 9
Message-ID: <20101121140808.GA6429@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
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

Current status:
Recovering from unclean shutdown has been the main focus, and is now
working magnificantly - I'm having no luck breaking it. This version
looks to be plenty safe enough for beta testing (still, make backups).

Proper discard support is in and enabled by default; bcache won't ever
write to the same location twice without issuing a discard to that
bucket. On my test box with a Corsair Nova, I'm seeing around a 30% hit
in mysql performance with it on - there might be a bit of room for
improvement, but I'm also curious of other drives do better. Even with
that hit it's well worth it though, the performance degradation over
time on this drive without TRIM is massive.

The sysfs stuff has all been moved around and should be a little more
standard now; the few files that aren't specific to a device
(register_cache, register_dev) could use a better location - any
suggestions?

The btree cache has been rewritten and simplified, should exhibit less
memory pressure than the old code.

The initial implementation of incremental garbage collection is done -
this version doesn't yet normally gc incrementally, as it was needed to
handle allocation failure without deadlocking while ordering writes
correctly. But finishing it is only a bit more work and will give much
better worst case latency and slightly better cache utilization.

Bcache is available from
git://evilpiepirate.org/~kent/linux-bcache.git
git://evilpiepirate.org/~kent/bcache-tools.git

And the (somewhat outdated) wiki is
http://bcache.evilpiepirate.org

diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
new file mode 100644
index 0000000..fc0ebac
--- /dev/null
+++ b/Documentation/bcache.txt
@@ -0,0 +1,170 @@
+Say you've got a big slow raid 6, and an X-25E or three. Wouldn't it be
+nice if you could use them as cache... Hence bcache.
+
+Userspace tools and a wiki are at:
+  git://evilpiepirate.org/~kent/bcache-tools.git
+  http://bcache.evilpiepirate.org
+
+It's designed around the performance characteristics of SSDs - it only allocates
+in erase block sized buckets, and it uses a hybrid btree/log to track cached
+extants (which can be anywhere from a single sector to the bucket size). It's
+designed to avoid random writes at all costs; it fills up an erase block
+sequentially, then issues a discard before reusing it.
+
+Caching can be transparently enabled and disabled on arbitrary block devices
+while they're in use. A caches stores the UUIDs of the devices it is caching,
+allowing caches to safely persist across reboots. There's currently a hard
+limit of 256 backing devices per cache.
+
+Both writethrough and writeback caching are supported. Writeback defaults to
+off, but can be switched on and off arbitrarily at runtime. Bcache goes to
+great lengths to order all writes to the cache so that the cache is always in a
+consistent state on disk, and it never returns writes as completed until all
+necessary data and metadata writes are completed. It's designed to safely
+tolerate unclean shutdown without loss of data.
+
+Writeback caching can use most of the cache for buffering writes - writing
+dirty data to the backing device is always done sequentially, scanning from the
+start to the end of the index.
+
+Since random IO is what SSDs excel at, there generally won't be much benefit
+to caching large sequential IO. Bcache detects sequential IO and skips it;
+it also keeps a rolling average of the IO sizes per task, and as long as the
+average is above the cutoff it will skip all IO from that task - instead of
+caching the first 512k after every seek. Backups and large file copies should
+thus entirely bypass the cache.
+
+In the event of an IO error or an inconsistency is detected, caching is
+automatically disabled; if dirty data was present in the cache it first
+disables writeback caching and waits for all dirty data to be flushed.
+
+All configuration is done via sysfs. To use sde to cache md1, assuming the
+SSD's erase block size is 128k:
+
+  make-bcache -b128k /dev/sde
+  echo "/dev/sde" > /sys/kernel/bcache/register_cache
+  echo "<UUID> /dev/md1" > /sys/kernel/bcache/register_dev
+
+More suitable for scripting might be
+  echo "`blkid /dev/md1 -s UUID -o value` /dev/md1" \
+	  > /sys/kernel/bcache/register_dev
+
+Then, to enable writeback:
+
+  echo 1 > /sys/block/md1/bcache/writeback
+
+Other sysfs files for the backing device:
+
+  bypassed
+    Sum of all IO, reads and writes, than have bypassed the cache
+
+  cache_hits
+  cache_misses
+  cache_hit_ratio
+    Hits and misses are counted per individual IO as bcache sees them; a
+    partial hit is counted as a miss.
+
+  clear_stats
+    Writing to this file resets all the statistics
+
+  flush_delay_ms
+  flush_delay_ms_sync
+    Optional delay for btree writes to allow for more coalescing of updates to
+    the index. Default to 10 ms for normal writes and 0 for sync writes.
+
+  sequential_cutoff
+    A sequential IO will bypass the cache once it passes this threshhold; the
+    most recent 128 IOs are tracked so sequential IO can be detected even when
+    it isn't all done at once.
+
+  unregister
+    Writing to this file disables caching on that device
+
+  writeback
+    Boolean, if off only writethrough caching is done
+
+  writeback_delay
+    When dirty data is written to the cache and it previously did not contain
+    any, waits some number of seconds before initiating writeback. Defaults to
+    30.
+
+  writeback_percent
+    To allow for more buffering of random writes, writeback only proceeds when
+    more than this percentage of the cache is unavailable. Defaults to 0.
+
+  writeback_running
+    If off, writeback of dirty data will not take place at all. Dirty data will
+    still be added to the cache until it is mostly full; only meant for
+    benchmarking. Defaults to on.
+ 
+For the cache:
+  btree_avg_keys_written
+    Average number of keys per write to the btree when a node wasn't being
+    rewritten - indicates how much coalescing is taking place.
+
+  btree_cache_size
+    Number of btree buckets currently cached in memory
+
+  btree_written
+    Sum of all btree writes, in (kilo/mega/giga) bytes
+
+  clear_stats
+    Clears the statistics associated with this cache
+
+  discard
+    Boolean; if on a discard/TRIM will be issued to each bucket before it is
+    reused. Defaults to on if supported.
+
+  heap_size
+    Number of buckets that are available for reuse (aren't used by the btree or
+    dirty data)
+
+  nbuckets
+    Total buckets in this cache
+
+  synchronous
+    Boolean; when on all writes to the cache are strictly ordered such that it
+    can recover from unclean shutdown. If off it will not generally wait for
+    writes to complete, but the entire cache contents will be invalidated on
+    unclean shutdown. Not recommended that it be turned off when writeback is
+    on.
+
+  unregister
+    Closes the cache device and all devices being cached; if dirty data is
+    present it will disable writeback caching and wait for it to be flushed.
+
+  written
+    Sum of all data that has been written to the cache; comparison with
+    btree_written gives the amount of write inflation in bcache.
+
+To script the UUID lookup, you could do something like:
+  echo "`blkid /dev/md1 -s UUID -o value` /dev/md1"\
+	  > /sys/kernel/bcache/register_dev
+
+Caveats:
+
+Bcache appears to be quite stable and reliable at this point, but there are a
+number of potential issues.
+
+The ordering requirement of barriers is silently ignored; for ext4 (and
+possibly other filesystems) you must explicitly mount with -o nobarrier or you
+risk severe filesystem corruption in the event of unclean shutdown.
+
+A change to the generic block layer for ad hoc bio splitting can potentially
+break other things; if a bio is used without calling bio_init() or bio_endio()
+is called more than once, the kernel will BUG(). Ext4, raid1, raid10 and lvm
+work fine for me; raid5/6 and I'm told btrfs are not.
+
+Caching partitions doesn't do anything (though using them as caches works just
+fine). Using the whole device instead works.
+
+Nothing is done to prevent the use of a backing device without the cache it has
+been used with, when the cache contains dirty data; if you do, terribly things
+will happen. 
+
+Furthermore, if the cache didn't have any dirty data and you mount the backing
+device without the cache, you've now made the cache contents stale and they
+need to be manually invalidated. For now the only way to do that is rerun
+make-bcache. The solution to both issues will be the introduction of a bcache
+specific container format for the backing device, which will come at some point
+in the future along with thin provisioning and volume management.
