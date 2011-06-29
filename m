Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1F2HUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 03:20:37 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:38253 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1F2HUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 03:20:32 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 03:20:32 EDT
Message-Id: <4E0AED02020000A100006458@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Wed, 29 Jun 2011 09:14:42 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: nested block devices (partitioned RAID with LVM): where Linux
 sucks ;-)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I decided to write this to the general kernel list instead of sending to the more specific lists, as this seems to be a colaboration issue:

For SLES11 SP1 (x86_64) I had configured a MD-RAID1 (0.9 superblock) on multipathed SAN devices (the latter should not be important). Then I partitioned the RAID, and one partition was used as PV for LVM. A VG had been created and LVs in it. Filesystems created, populated, etc.

The RAID device was being used as boot disk for XEN VMs. Everything worked fine until the host machine was rebooted.

(Note: The mdadm command (mdadm - v3.0.3 - 22nd October 2009) has several mis-features regarding proper error reporting standards)

The RAIDs couldn't be assembled with errors like this:
mdadm: /dev/disk/by-id/dm-name-whatever-E1 has wrong uuid.
mdadm: /dev/disk/by-id/dm-name-whatever-E2 has wrong uuid.

However:
# mdadm --examine /dev/disk/by-id/dm-name-whatever-E1 |grep -i uuid
           UUID : 2861aad0:228a48bc:f93e96a3:b6fdd813 (local to host host)
# mdadm --examine /dev/disk/by-id/dm-name-whatever-E2 |grep -i uuid
           UUID : 2861aad0:228a48bc:f93e96a3:b6fdd813 (local to host host)

Only when calling "mdadm -v -A /dev/md1" there are more reasonable messages like:
mdadm: cannot open device /dev/disk/by-id/dm-name-whatever-E1: Device or resource busy

Now the question is: "Why is the device busy?" and "Who is holding the device busy?"
Unfortunately (and here's a problem), neither "lsof" nor "fuser" could tell. That gave me a big headache.

Further digging in the verbose output of "mdadm" I found lines like this:
mdadm: no recogniseable superblock on /dev/disk/by-id/dm-name-whatever-E2_part5
mdadm: /dev/disk/by-id/dm-name-whatever-E2_part5 has wrong uuid.
mdadm: cannot open device /dev/disk/by-id/dm-name-whatever-E2_part2: Device or resource busy
mdadm: /dev/disk/by-id/dm-name-whatever-E2_part2 has wrong uuid.
mdadm: no recogniseable superblock on /dev/disk/by-id/dm-name-whatever-E2_part1
mdadm: /dev/disk/by-id/dm-name-whatever-E2_part1 has wrong uuid.
mdadm: cannot open device /dev/disk/by-id/dm-name-whatever-E2: Device or resource busy
mdadm: /dev/disk/by-id/dm-name-whatever-E2 has wrong uuid.

So mdadm is considering partitions as well. I guessed that activating the partitions might keept the "parent device" busy, so I tried a "kpart -vd /dev/disk/by-id/dm-name-whatever-E2", but that did do nothing (with no error message).

Then I suspected LVM could activate the PV in partition 5. I tried to deactivate LVM on the device, but that also failed.

At this point I had googled at lot, and the kernel boot parameter "nodmraid" did not help either.

At a state of despair I decided to zap away the partition table temporarily:
# sfdisk -d /dev/disk/by-id/dm-name-whatever-E1 >E1 ## Backup
# sfdisk -d /dev/disk/by-id/dm-name-whatever-E2 >E2 ## Backup
# dd if=/dev/zero bs=512 count=1 of=/dev/disk/by-id/dm-name-whatever-E1
# dd if=/dev/zero bs=512 count=1 of=/dev/disk/by-id/dm-name-whatever-E2

Then I logically disconnected the SAN disks and reconnected them (via some /sys magic).

Then the RAID devices could be assembled again! This demonstrates that:
1) The original error message of mdadm about a wrong UUID is completely wrong ("device busy" would have been correct)
2) partitions on unassembled raid legs are activated before the RAID is assembled, effectively preventing a RAID assembly (I could not find out how to fix/prevent this)

After that I restored the saved partition table to the RAID(!) device (as it had been done originally).

I haven't studied the block data structures, but obviously the RAID metadata is not at the start of the devices. If they were, a partition table would not be found, and the RAID could have been assembled without a problem.

I'm not subscribed to the kernel-list, so please CC. your replies! Thanks!

I'm sending this message to make developers aware of the problem, and possibly help normal users finding this solution via Google.

Regards,
Ulrich Windl
P.S. Novell Support was not able to provide a solution for this problem in time
