Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab0GDUfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 16:35:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64102 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab0GDUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 16:35:49 -0400
Date: Sun, 4 Jul 2010 13:34:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/3] Bcache: Version 6
Message-Id: <20100704133434.fb23cc37.randy.dunlap@oracle.com>
In-Reply-To: <a0bdf4c5c6b14d429900cc58c28795bd5b6b8e85.1278227772.git.kent.overstreet@gmail.com>
References: <a0bdf4c5c6b14d429900cc58c28795bd5b6b8e85.1278227772.git.kent.overstreet@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C30F0A3.0032:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jul 2010 00:44:18 -0700 Kent Overstreet wrote:

>  Documentation/bcache.txt |   75 ++++++++++++++++++++++++++++++++++++++++++++++
>  block/Kconfig            |   14 ++++++++
>  2 files changed, 89 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/bcache.txt
> 
> diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
> new file mode 100644
> index 0000000..53079a7
> --- /dev/null
> +++ b/Documentation/bcache.txt
> @@ -0,0 +1,75 @@
> +Say you've got a big slow raid 6, and an X-25E or three. Wouldn't it be
> +nice if you could use them as cache... Hence bcache.
> +
> +It's designed around the performance characteristics of SSDs - it only allocates
> +in erase block sized buckets, and it uses a bare minimum btree to track cached
> +extants (which can be anywhere from a single sector to the bucket size). It's
> +also designed to be very lazy, and use garbage collection to clean stale
> +pointers.
> +
> +Cache devices are used as a pool; all available cache devices are used for all
> +the devices that are being cached.  The cache devices store the UUIDs of
> +devices they have, allowing caches to safely persist across reboots.  There's
> +space allocated for 256 UUIDs right after the superblock - which means for now
> +that there's a hard limit of 256 devices being cached.
> +
> +Currently only writethrough caching is supported; data is transparently added
> +to the cache on writes but the write is not returned as completed until it has
> +reached the underlying storage. Writeback caching will be supported when
> +journalling is implemented.
> +
> +To protect against stale data, the entire cache is invalidated if it wasn't
> +cleanly shutdown, and if caching is turned on or off for a device while it is
> +opened read/write, all data for that device is invalidated.
> +
> +Caching can be transparently enabled and disabled for devices while they are in
> +use. All configuration is done via sysfs. To use our SSD sde to cache our
> +raid md1:
> +
> +  make-bcache /dev/sde
> +  echo "/dev/sde" > /sys/kernel/bcache/register_cache
> +  echo "<UUID> /dev/md1" > /sys/kernel/bcache/register_dev

Hi,

Where does one find 'make-bcache'?
Maybe that info could be added here.

> +And that's it.
> +
> +If md1 was a raid 1 or 10, that's probably all you want to do; there's no point
> +in caching multiple copies of the same data. However, if you have a raid 5 or
> +6, caching the raw devices will allow the p and q blocks to be cached, which
> +will help your random write performance:
> +  echo "<UUID> /dev/sda1" > /sys/kernel/bcache/register_dev
> +  echo "<UUID> /dev/sda2" > /sys/kernel/bcache/register_dev
> +  etc.
> +
> +To script the UUID lookup, you could do something like:
> +  echo  "`find /dev/disk/by-uuid/ -lname "*md1"|cut -d/ -f5` /dev/md1"\
> +	  > /sys/kernel/bcache/register_dev 
> +
> +Of course, if you were already referencing your devices by UUID, you could do:
> +  echo "$UUID /dev/disk/by-uiid/$UUID"\
> +	  > /sys/kernel/bcache/register_dev 
> +
> +There are a number of other files in sysfs, some that provide statistics,
> +others that allow tweaking of heuristics. Directories are also created
> +for both cache devices and devices that are being cached, for per device
> +statistics and device removal.
> +
> +Statistics: cache_hits, cache_misses, cache_hit_ratio
> +These should be fairly obvious, they're simple counters.
> +
> +Cache hit heuristics: cache_priority_seek contributes to the new bucket
> +priority once per cache hit; this lets us bias in favor of random IO.
> +The file cache_priority_hit is scaled by the size of the cache hit, so
> +we can give a 128k cache hit a higher weighting than a 4k cache hit.
> +
> +When new data is added to the cache, the initial priority is taken from
> +cache_priority_initial. Every so often, we must rescale the priorities of
> +all the in use buckets, so that the priority of stale data gradually goes to
> +zero: this happens every N sectors, taken from cache_priority_rescale. The
> +rescaling is currently hard coded at priority *= 7/8.
> +
> +For cache devices, there are a few more files. Most should be obvious;
> +min_priority shows the priority of the bucket that will next be pulled off
> +the heap, and tree_depth shows the current btree height.
> +
> +Writing to the unregister file in a device's directory will trigger the
> +closing of that device.
> diff --git a/block/Kconfig b/block/Kconfig
> index 9be0b56..ae2be2d 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -77,6 +77,20 @@ config BLK_DEV_INTEGRITY
>  	T10/SCSI Data Integrity Field or the T13/ATA External Path
>  	Protection.  If in doubt, say N.
>  
> +config BLK_CACHE
> +	tristate "Block device as cache"
> +	default m

We try not to add (enable) non-core drivers to the kernel build.
OTOH, in a year or a few, this could be a core driver.


> +	---help---
> +	Allows a block device to be used as cache for other devices; uses
> +	a btree for indexing and the layout is optimized for SSDs.
> +
> +	Caches are persistent, and store the UUID of devices they cache.
> +	Hence, to open a device as cache, use
> +	echo /dev/foo > /sys/kernel/bcache/register_cache
> +	And to enable caching for a device
> +	echo "<UUID> /dev/bar" > /sys/kernel/bcache/register_dev
> +	See Documentation/bcache.txt for details.
> +
>  endif # BLOCK
>  
>  config BLOCK_COMPAT
> -- 



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
