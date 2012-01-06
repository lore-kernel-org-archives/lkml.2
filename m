Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030363Ab2AFPAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 10:00:19 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43414 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030334Ab2AFPAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 10:00:17 -0500
MIME-Version: 1.0
Date: Fri, 6 Jan 2012 16:00:14 +0100
Message-ID: <CAC-4XGse6sey51J==QtTNq+zHdGBjbj40WLDOjmh50zUCv+T7g@mail.gmail.com>
Subject: Optimizing Filesystem Seek (AKA Combat Filesystem Aging)
From: Ulrik Mikaelsson <ulrik.mikaelsson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've many times noticed how my frequently used systems tend to get
slower overtime, especially with regards to filesystem access.
Reinstalls usually fixes the problem, but it's IMHO the _WRONG_ way to
go.

My assumption is that, when the system is first installed, all files
in the system are more or less populated in the order they are going
to be accessed. This reduces the drive-seek when applications are
subsequently accessing the files. Over time, system upgrades, package
updates and general disk-activity reduces the coherency on-disk
between related files, increasing the number of seek-operations
required for the same access patterns.

Curious about the problem, I set up a little experiment testing
FS-aging effects on boot-time, and want to share the results:

NOTE: I'm not subscribed, so please explicitly CC me in any responses
if you want me to see them quickly.

=== Test-setup and execution ===

 * I used Ubuntu 11.10 as a test-system on a dedicated disk under a
virtual machine.
 * The disk used was a WD Raptor 10k RPM, which already has good
seeking performance and should not show worse than average numbers.
 * I used KVM, and before each trial, I triggered /proc/../drop_caches
in the host to avoid the host caching blocks giving faulty results.
 * I deliberately used a very small filesystem (4GB) in order for it
to have less free space and age more quickly.
 * I used the default FS for the distro, ext4.
 * For all tests, the same partition on disk was used.
 * I clocked it manually using a stop-watch, and each timing was
performed 3 times.
 * Auto-login was used to show boottime from KVM-bios until all icons
popped up on the desktop.

 * Aging was simulated, by letting the guest OS continuously perform
reinstalls of random packages in random order, for ~4 hours.

 * After aging, I tried two forms of filesystem rejuvenation. In both
cases I simply created a new filesystem, but changed the order files
were copied to the new filesystem.
   1. Files were simply copied in alphabetic order.
   2. The order was profiled during a previous boot using, a small
background fanotify listener.

=== Resulting Boot-times ===
(Including a bootchart of each)

Fresh updated install: http://imagebin.org/192118
31.0s
30.6s
30.3s

After simulated aging: http://imagebin.org/192119
$ age.sh # For four hours
38.2s
38.7s
38.7s

After FS-recreate: http://imagebin.org/192120
$ optimg.sh bootlab/degraded.img /dev/sdd1 < /dev/null
31.1s
31.0s
30.9s

After optimization: http://imagebin.org/192122
$ optimg.sh bootlab/degraded.img /dev/sdd1 < bootlab/profile-results
28.6s
26.7s
27.7s

Worth mentioning, I watched the bootchart for all tests, and all boots
started with a 6 second inactivity in both disk and cpu. Also, there
were long periods of without disk-requests during the boot. For
reference, the IO-intensive duration of the boot between the aged
filesystem, and the optimized version, went down from ~17 seconds to
~6.5s, with similar improvements in consistent disk-throughput.

=== Conclusions ===
 * As expected, the filesystem populated in order of boot-usage far
outperformed the degraded filesystem.
 * It also outperformed the fresh install, by a significant margin
(especially when only considering the IO-intensive part of the boot.)
 * The package dependency-order used during a fresh install (to my
surprise) doesn't seem to be any better than alphabetical order.

=== Future Work ===
 * Re-testing required.
  - I've created a git repo at https://github.com/rawler/fsopt with
the utils I've created for these tests. If you're up for it:
    1. Install a new base-distro and perform your timings
    2. Age it. The age.sh script can be used for debian-based distro.
Perform timings.
    3. Install the profiling/watcher into initramfs, and update grub
to run with fsopt in cmdline.
    4. Rejuvenate the filesystem using optimization/optimg.sh (you'll
need extra disk somewhere to create a new similarily sized filesystem)
    5. Post results here, (and please CC me)

  - Repeat for different filesystems on different machines.
  - Repeat on an SSD disk to see if there are any effects (positive or negative)
    # Even though SSD:s doesn't suffer from seek, a high coherence
between related files could mean less blocks/sectors has to be read
still giving a small performance improvement
    # There is a theory that fragmented filesystems are good for SSD:s
due to their parallel internal storage units. However, in modern SSD:s
there is also an sophisticated processor remapping logical blocks to
physical blocks. I'm not sure fragmentation in the logical blocks are
any advantage.
  - The test should be repeated with different disk-based filesystems.
(BTRFS, XFS)?

 * Is ureadahead even useful, if the files are organized in good
order? Looking at the bootcharts, it seems while certainly improving
I/O during it's reading, it is also creating a time-barrier when
CPU-intensive tasks aren't run in parallel with disk.
 * I believe the effects might be larger if using a larger
file-system, since I/O-cache might be less useful, and the disk-arm
moving over a larger active area increasing seek time.

 * Completely re-creating the filesystem aren't viable in real life.
(Assuming a reliable improvement can be repeated in more conditions,)
The VFS should offer some kind of API for letting a user-space daemon
monitor file-access patterns, and optimize the in-kernel filesystems
accordingly, similar to live-defragmentation.
  - I've seen some work in e4defrag indicating improvements in keeping
related inodes close together. I haven't got it working, and I don't
know if it's applicable here.
 * Booting is hardly the only time many small files are read. A daemon
should be implemented that can listen in the background, collect
profiling data, and apply to disk at suitable times, such as during
screensaver, or manually triggered.

What do you think?
