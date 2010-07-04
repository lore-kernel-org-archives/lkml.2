Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab0GDHo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:44:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40360 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0GDHo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=P5D2oTVn/Zyfi3sXHdLSdciq0soobovfg2E8vFiHUL5TttQpncu8z6QzfL5NVzpmXn
         AS4x/EssSj5SCOeU6sWLcvJC12NO6G+R7dsQAKOLFcBfAaBGHWi0x62nHJ3uKB7y52r0
         V01pY3l0u4K+nCHTLrQbgX40L17FHRvSTfsbo=
Date: Sun, 4 Jul 2010 00:44:18 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kent.overstreet@gmail.com
Subject: [RFC][PATCH 1/3] Bcache: Version 6
Message-ID: <a0bdf4c5c6b14d429900cc58c28795bd5b6b8e85.1278227772.git.kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcache: Cache arbitrary block devices with other block devices - designed
around SSDs; the goal is to be a truly generic and drop in component that
doesn't require configuration or tuning. See http://bcache.evilpiepirate.org
for a bit more.

I've now got it, as near as I can tell, stable and completely working - it
easily handles all the torture tests I can come up with. There's a bit left to
flesh out before it could be used in production - mainly IO error handling -
but at this point it really needs and is ready for outside testing, call it
early beta quality.

The main issue at this point - which I'm really hoping to get some pointers
on - are some bizzare performance issues. On random 4k reads from cache,
bcache matches what the SSD can do. Same with direct sequential IO. Buffered
sequential IO however... is weird. On my test box it's typically 160-180
mb/sec; the SSD can do ~237 mb/sec. That is, with a non preemptible kernel -
with volutary preemption, I get 238 mb/sec. Best I can come up with is some
sort of bizzare scheduler interaction, I've got various theories but nothing
I've been able to make fit.

But the code should be substantially more readable at this point, and I'm
getting fairly confident in it. Besides the performance issues everything's
working well; I'm hoping to get this into mainline eventually and while
there's still quite a bit to be written I don't expect a huge amount of churn
at this point.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 Documentation/bcache.txt |   75 ++++++++++++++++++++++++++++++++++++++++++++++
 block/Kconfig            |   14 ++++++++
 2 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/bcache.txt

diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
new file mode 100644
index 0000000..53079a7
--- /dev/null
+++ b/Documentation/bcache.txt
@@ -0,0 +1,75 @@
+Say you've got a big slow raid 6, and an X-25E or three. Wouldn't it be
+nice if you could use them as cache... Hence bcache.
+
+It's designed around the performance characteristics of SSDs - it only allocates
+in erase block sized buckets, and it uses a bare minimum btree to track cached
+extants (which can be anywhere from a single sector to the bucket size). It's
+also designed to be very lazy, and use garbage collection to clean stale
+pointers.
+
+Cache devices are used as a pool; all available cache devices are used for all
+the devices that are being cached.  The cache devices store the UUIDs of
+devices they have, allowing caches to safely persist across reboots.  There's
+space allocated for 256 UUIDs right after the superblock - which means for now
+that there's a hard limit of 256 devices being cached.
+
+Currently only writethrough caching is supported; data is transparently added
+to the cache on writes but the write is not returned as completed until it has
+reached the underlying storage. Writeback caching will be supported when
+journalling is implemented.
+
+To protect against stale data, the entire cache is invalidated if it wasn't
+cleanly shutdown, and if caching is turned on or off for a device while it is
+opened read/write, all data for that device is invalidated.
+
+Caching can be transparently enabled and disabled for devices while they are in
+use. All configuration is done via sysfs. To use our SSD sde to cache our
+raid md1:
+
+  make-bcache /dev/sde
+  echo "/dev/sde" > /sys/kernel/bcache/register_cache
+  echo "<UUID> /dev/md1" > /sys/kernel/bcache/register_dev
+
+And that's it.
+
+If md1 was a raid 1 or 10, that's probably all you want to do; there's no point
+in caching multiple copies of the same data. However, if you have a raid 5 or
+6, caching the raw devices will allow the p and q blocks to be cached, which
+will help your random write performance:
+  echo "<UUID> /dev/sda1" > /sys/kernel/bcache/register_dev
+  echo "<UUID> /dev/sda2" > /sys/kernel/bcache/register_dev
+  etc.
+
+To script the UUID lookup, you could do something like:
+  echo  "`find /dev/disk/by-uuid/ -lname "*md1"|cut -d/ -f5` /dev/md1"\
+	  > /sys/kernel/bcache/register_dev 
+
+Of course, if you were already referencing your devices by UUID, you could do:
+  echo "$UUID /dev/disk/by-uiid/$UUID"\
+	  > /sys/kernel/bcache/register_dev 
+
+There are a number of other files in sysfs, some that provide statistics,
+others that allow tweaking of heuristics. Directories are also created
+for both cache devices and devices that are being cached, for per device
+statistics and device removal.
+
+Statistics: cache_hits, cache_misses, cache_hit_ratio
+These should be fairly obvious, they're simple counters.
+
+Cache hit heuristics: cache_priority_seek contributes to the new bucket
+priority once per cache hit; this lets us bias in favor of random IO.
+The file cache_priority_hit is scaled by the size of the cache hit, so
+we can give a 128k cache hit a higher weighting than a 4k cache hit.
+
+When new data is added to the cache, the initial priority is taken from
+cache_priority_initial. Every so often, we must rescale the priorities of
+all the in use buckets, so that the priority of stale data gradually goes to
+zero: this happens every N sectors, taken from cache_priority_rescale. The
+rescaling is currently hard coded at priority *= 7/8.
+
+For cache devices, there are a few more files. Most should be obvious;
+min_priority shows the priority of the bucket that will next be pulled off
+the heap, and tree_depth shows the current btree height.
+
+Writing to the unregister file in a device's directory will trigger the
+closing of that device.
diff --git a/block/Kconfig b/block/Kconfig
index 9be0b56..ae2be2d 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -77,6 +77,20 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
+config BLK_CACHE
+	tristate "Block device as cache"
+	default m
+	---help---
+	Allows a block device to be used as cache for other devices; uses
+	a btree for indexing and the layout is optimized for SSDs.
+
+	Caches are persistent, and store the UUID of devices they cache.
+	Hence, to open a device as cache, use
+	echo /dev/foo > /sys/kernel/bcache/register_cache
+	And to enable caching for a device
+	echo "<UUID> /dev/bar" > /sys/kernel/bcache/register_dev
+	See Documentation/bcache.txt for details.
+
 endif # BLOCK
 
 config BLOCK_COMPAT
-- 
1.7.0.4

