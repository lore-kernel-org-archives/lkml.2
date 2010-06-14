Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0FNPhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:37:39 -0400
Received: from mail-yw0-f204.google.com ([209.85.211.204]:56149 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0FNPhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iPAjjh71FT0WLQm8Kf6S3m2ZZAYY+qPOYvVYz8uIleXxfSimOdvoyH6FwwsJWiZprl
         m81X4SjiPFchz3plsXl9T2DkEleahypr8yQngTzQms5zDmdWNjd2zzbgKkitweXF2GkO
         QT2HRjBavNm6c5aWaU0iuLXtrz8eE/Lxt+N8k=
Date: Mon, 14 Jun 2010 08:37:11 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 1/3] Bcache: Version 5 - read/write, pretty close to
 stable, and some numbers
Message-ID: <20100614153706.GA31477@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I won't call it stable quite yet, but it's surviving hours and hours of
torture testing - I plan on trying it out on my dev machine soon as I
get another SSD.

There's still performance work to be done, but it gets the 4k random
read case right. I used my test program (verifies the data by checksum
or against another drive) to make some quick benchmarks - it prints
every 2 seconds, obviously not meant for fancy graphs. I primed the
cache partway, it's fairly obvious how far I got:

SSD (64 gb corsair nova):
root@utumno:~/bcache-tools# ./bcache-test direct csum /dev/sdc
size 15630662
Loop      0 offset  54106024 sectors   8,      0 mb done
Loop  10274 offset 106147152 sectors   8,     40 mb done
Loop  25842 offset  63312896 sectors   8,    100 mb done
Loop  41418 offset  59704128 sectors   8,    161 mb done
Loop  56986 offset  26853032 sectors   8,    222 mb done
Loop  72562 offset  78815688 sectors   8,    283 mb done
Loop  88128 offset  10733496 sectors   8,    344 mb done
Loop 103697 offset  92038248 sectors   8,    405 mb done
Loop 119269 offset  17938848 sectors   8,    465 mb done
Loop 134841 offset  46156272 sectors   8,    526 mb done 

Uncached - 2 TB WD green drive:
root@utumno:~/bcache-tools# ./bcache-test direct csum
/dev/mapper/utumno-uncached
size 26214384
Loop      0 offset 173690168 sectors   8,      0 mb done
Loop    123 offset  49725720 sectors   8,      0 mb done
Loop    330 offset 204243808 sectors   8,      1 mb done
Loop    539 offset  67742352 sectors   8,      2 mb done
Loop    742 offset 196027992 sectors   8,      2 mb done
Loop    940 offset 200770112 sectors   8,      3 mb done
Loop   1142 offset 168188224 sectors   8,      4 mb done
Loop   1351 offset  88816040 sectors   8,      5 mb done
Loop   1550 offset  75832000 sectors   8,      6 mb done
Loop   1756 offset 179931376 sectors   8,      6 mb done
Loop   1968 offset 125523400 sectors   8,      7 mb done
Loop   2169 offset 148720472 sectors   8,      8 mb done 

And cached:
root@utumno:~/bcache-tools# ./bcache-test direct csum
/dev/mapper/utumno-test
size 26214384
Loop      0 offset 173690168 sectors   8,      0 mb done
Loop  13328 offset 191538448 sectors   8,     52 mb done
Loop  33456 offset  47241912 sectors   8,    130 mb done
Loop  53221 offset  58580000 sectors   8,    207 mb done
Loop  73297 offset  46407168 sectors   8,    286 mb done
Loop  73960 offset  63298512 sectors   8,    288 mb done
Loop  74175 offset  95360928 sectors   8,    289 mb done
Loop  74395 offset 179143144 sectors   8,    290 mb done
Loop  74612 offset  90647672 sectors   8,    291 mb done
Loop  74832 offset 197063392 sectors   8,    292 mb done
Loop  75051 offset 130790552 sectors   8,    293 mb done

There's still a fair amount left before it'll be production ready, and I
wouldn't trust data to it just yet, but it's getting closer.


 Documentation/bcache.txt |   75 ++++++++++++++++++++++++++++++++++++++++++++++
 block/Kconfig            |   15 +++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)

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
index 9be0b56..4ebc4cc 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -77,6 +77,21 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
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
+	echo /dev/foo > /sys/kernel/bcache/register_cache
+	And to enable caching for a device
+	echo "<UUID> /dev/bar" > /sys/kernel/bcache/register_dev
+	See Documentation/bcache.txt for details.
+
 endif # BLOCK
 
 config BLOCK_COMPAT
