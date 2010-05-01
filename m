Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab0EAAMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:12:52 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55543 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab0EAAMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=h0i4BMAgZGSllX/nfCpts/rZ7iObj9MOpjs18DxXUswYbWAQ/TN/p+AVq8cfPPzK4a
         4XzueOZuwPC9fXIDQuwC9mWJ6Loe8PnbkQolZ++myeV8TNhhMTpu2t2HpinnIJFaWA95
         /eBvuj6t7mOKoY5TqcgN03KxlO1z6wkzcbEaw=
Date: Fri, 30 Apr 2010 16:12:44 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Bcache: version 4
Message-ID: <20100501001244.GB31135@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Documentation/bcache.txt |   56 ++++++++++++++++++++++++++++++++++++++++++++++
 block/Kconfig            |   15 ++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
new file mode 100644
index 0000000..dee1514
--- /dev/null
+++ b/Documentation/bcache.txt
@@ -0,0 +1,56 @@
+Say you've got a big slow raid 6, and an X-25E or three. Wouldn't it be
+nice if you could use them as cache... Hence bcache.
+
+It's designed around the performance characteristics of SSDs - it only allocates
+in erase block sized buckets, and it uses a bare minimum btree to track cached
+extants (which can be anywhere from a single sector to the bucket size). It's
+also designed to be very lazy, and use garbage collection to clean stale
+pointers.
+
+Cache devices are used as a pool, and hold data for all the devices that are
+being cached. The cache devices store the UUIDs of devices they have, allowing
+caches to safely be persistent across reboots.
+
+Caching can be transparently enabled and disabled for devices while they are in
+use. All configuration is done via sysfs. To use our SSD sde to cache our
+raid md1:
+
+  make-bcache /dev/sdc
+  echo "/dev/sdc" > /sys/kernel/bcache/register_cache
+  echo "<UUID> /dev/md1 " > /sys/kernel/bcache/register_dev
+
+And that's it.
+
+To script the UUID lookup, you could do:
+  echo  "`find /dev/disk/by-uuid/ -lname "*md1"|cut -d/ -f5` /dev/md"\
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
index f9e89f4..0e5dbf2 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -100,6 +100,21 @@ config DEBUG_BLK_CGROUP
 	in the blk group which can be used by cfq for tracing various
 	group related activity.
 
+config BLK_CACHE
+	tristate "Block device as cache"
+	select SLOW_WORK
+	default m
+	---help---
+	Allows a block device to be used as cache for other devices; uses
+	a btree for indexing and the layout is optimized for SSDs.
+
+	Caches are persistent, and store the UUID of devices they cache.
+	Hence, to open a device as cache, use
+	"echo /dev/foo" > /sys/kernel/bcache/register_cache
+	And to enable caching for a device
+	"echo <UUID> /dev/foo" > /sys/kernel/bcache/register_dev
+	See Documentation/bcache.txt for details.
+
 endif # BLOCK
 
 config BLOCK_COMPAT
