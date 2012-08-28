Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2H1OGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:06:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:53739 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2H1OGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:06:04 -0400
Message-ID: <503CD044.5040007@windriver.com>
Date: Tue, 28 Aug 2012 09:05:56 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "ksummit-2012-discuss@lists.linux-foundation.org" 
	<ksummit-2012-discuss@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
Subject: Lines for locations sizing information (from Kernel Summit 2012 discussion)
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Because I had not done any size profiling since the original RFC
posting, I took 20 min and ported the patch set up to the 3.6-rc3 and
booted the kernel in each configuration.  There are still probably a
few use cases where this patch set might be useful but the general
sentiment seemed that this feature it is probably a bit too wasteful.

The 20 megs that I mentioned yesterday at the kernel summit is not the
actual size taken in ram or the compressed boot image (more on
that later).  The 20 megs was the raw size of the ascii text file that
readelf emitted from processing the vmlinux file.  This file is used
to construct the hash table used by kallsyms via a slightly modified
scripts/kallsyms.

Example:
% ./scripts/readelf --debug-dump=line ./vmlinux -q > decoded_lines
% ls -l decoded_lines |awk '{print $5" "$9}'
20312068 decoded_lines

Here is the data for the raw sizing in bytes for the exact same kernel.

4347104 - bzImage.no_lines_for_locations
6573280 - bzImage.lines_for_locations
Delta: 2,226,176

For a kernel module things are a bit different.  The kernel modules
are actually no different in size with or without this patch.  The
difference comes at the time kernel module is loaded.  Instead of the
in kernel module load routine throwing away the lines for locations
section, it reads it and constructs a hash table which will be read at
a later point.

Taking the data from readelf for my example kernel module looks like:

  [22] .debug_line       PROGBITS         0000000000000000  0000e143
       0000000000000bcd  0000000000000000           0     0     1

Prior to hash construction we are talking about 56K, and post
constructed hash for this one in kernel memory is ~30K.

It is worth pointing out that you could use this just for 1 or more
kernel modules and not the core kernel since the tables are completely
separate in the kernel memory, much like the kallsyms data is
separated for modules and the core kernel.  Just because you use one,
doesn't mean you have to use the other, in the case of the lines for
locations.

Here are the statistics for the in-kernel memory footprint.

On the left is the data from /proc/meminfo on the
non-lines-for-locations kernel immediately after the system has
booted.  On the right is the same data but for the lines-for-locations
built into the kallsyms table.


MemTotal:         366816 kB     MemTotal:         376804 kB
MemFree:          355596 kB     MemFree:          365580 kB
Buffers:               0 kB     Buffers:               0 kB
Cached:             2640 kB     Cached:             2640 kB
SwapCached:            0 kB     SwapCached:            0 kB
Active:             1256 kB     Active:             1268 kB
Inactive:           1936 kB     Inactive:           1936 kB
Active(anon):        552 kB     Active(anon):        564 kB
Inactive(anon):        0 kB     Inactive(anon):        0 kB
Active(file):        704 kB     Active(file):        704 kB
Inactive(file):     1936 kB     Inactive(file):     1936 kB
Unevictable:           0 kB     Unevictable:           0 kB
Mlocked:               0 kB     Mlocked:               0 kB
SwapTotal:             0 kB     SwapTotal:             0 kB
SwapFree:              0 kB     SwapFree:              0 kB
Dirty:                 0 kB     Dirty:                 0 kB
Writeback:             0 kB     Writeback:             0 kB
AnonPages:           556 kB     AnonPages:           572 kB
Mapped:              860 kB     Mapped:              852 kB
Shmem:                 0 kB     Shmem:                 0 kB
Slab:               4524 kB     Slab:               4532 kB
SReclaimable:       1676 kB     SReclaimable:       1676 kB
SUnreclaim:         2848 kB     SUnreclaim:         2856 kB
KernelStack:         288 kB     KernelStack:         288 kB
PageTables:           76 kB     PageTables:           80 kB
NFS_Unstable:          0 kB     NFS_Unstable:          0 kB
Bounce:                0 kB     Bounce:                0 kB
WritebackTmp:          0 kB     WritebackTmp:          0 kB
CommitLimit:      183408 kB     CommitLimit:      188400 kB
Committed_AS:      10428 kB     Committed_AS:      10444 kB
VmallocTotal:   34359738367 kB  VmallocTotal:   34359738367 kB
VmallocUsed:        1352 kB     VmallocUsed:        1352 kB
VmallocChunk:   34359737007 kB  VmallocChunk:   34359737007 kB


So the difference is about 10 megs of memory you don't get back, which
is less than the 16 megs that HPA quoted for the use of kexec. :-)

---

Q: Can we do better?  A: Probably

It seems like the kallsyms approach here was not as efficient as the
module hash function, because kallsyms really wasn't designed to be
used this way.  We can probably consider using the same logic that is
used to construct the module hash table.  The decoded_lines file looks
like this inside and has 612886 total lines in the file:
   head64.c:40 0xffffffff824b1358
   pgtable_64.h:110 0xffffffff824b135a
   bitops.h:321 0xffffffff824b1368
   tlbflush.h:51 0xffffffff824b136f
   irqflags.h:20 0xffffffff824b1374

There are a only 1687 unique file entries in the example kernel:

% cat decoded_lines |sed -e 's/:.*//'|sort -u  > files
% ls --block-size=1 -s files
18282 files
% wc -l files
1687 files

So if we don't care about speed and don't index the file list table we
would use ~18K for just the file list table.  For this 64bit kernel
the base offset is always 0xffffffff so we could use a 32 bit number
to represent it (4 bytes).  The largest file in this kernel was
"tg3.c:9998", so we can use 2 bytes for the line location, and 2 bytes
for the index into the stored file block.  Using a bit more math here
that theoretical minimum storage using a simple hash should be:

Size of array * (4 + 2 + 2):
612886 * (4 + 2 + 2) = 4903088

We add to that our 18K for the ascii file table and get ~5megs.  So it
would certainly be possible to cut the usage in 1/2 vs the current
patch, but it still isn't < 1 meg that Linus said was the upper
limit. :-)

---

Certainly there are other options of course like:

- Perhaps it is more reasonable to just use the lines for locations for
  the kernel modules you care about.

- Another possibility here would be to allow the kernel to use an
  early boot argument to control the loading of the extra data into
  the kallsyms.  The idea being that you could selectively elect to
  boot with the feature on or off at runtime, if we assume disk space
  is relatively cheap for the bzImage storage.

- Yet one more possibility is to allow loading the extra data after
  the system has booted from user space.

This all started out as an experiment just to see what it would take
to get lines for locations information in the kernel, because I wanted
it for doing fast back traces in kdb as well as finding out what line
I was on without the need for any kind of scripting.  I don't know yet
if it is the end of the road for these patches, but for anyone who
wanted to try the latest version of this patch set it is at:

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git lines_for_locations_3_6

And thanks to everyone for the good discussion.

Cheers,
Jason.

