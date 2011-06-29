Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1F2PAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:00:00 -0400
Received: from atl.turmel.org ([74.117.157.138]:59803 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab1F2O76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:59:58 -0400
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 10:59:58 EDT
Message-ID: <4E0B3A2A.3050906@turmel.org>
Date: Wed, 29 Jun 2011 10:43:54 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110603 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
CC: linux-kernel@vger.kernel.org,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: nested block devices (partitioned RAID with LVM): where Linux
 sucks ;-)
References: <4E0AED02020000A100006458@gwsmtp1.uni-regensburg.de>
In-Reply-To: <4E0AED02020000A100006458@gwsmtp1.uni-regensburg.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added linux-raid.  Where this should have gone in the first place.]

Note:  I'm somewhat less polite than usual, considering the subject line and tone.

On 06/29/2011 03:14 AM, Ulrich Windl wrote:
> Hi!
> 
> I decided to write this to the general kernel list instead of sending to the more specific lists, as this seems to be a colaboration issue:

There's nothing in your report about general kernel development, sorry.  Doesn't seem to be a collaboration issue, either.  A distribution issue, perhaps.

> For SLES11 SP1 (x86_64) I had configured a MD-RAID1 (0.9 superblock) on multipathed SAN devices (the latter should not be important). Then I partitioned the RAID, and one partition was used as PV for LVM. A VG had been created and LVs in it. Filesystems created, populated, etc.

> The RAID device was being used as boot disk for XEN VMs. Everything worked fine until the host machine was rebooted.

I hope you didn't put it in production without testing.

> (Note: The mdadm command (mdadm - v3.0.3 - 22nd October 2009) has several mis-features regarding proper error reporting standards)

Indeed, 2-1/2 years in the open source world closes many bugs.  Please retest with current kernel, udev, mdadm, and LVM.

FWIW, the default metadata was changed to v1.1 in November of 2009, and later to v1.2.  Either would have avoided your problems.

> The RAIDs couldn't be assembled with errors like this:
> mdadm: /dev/disk/by-id/dm-name-whatever-E1 has wrong uuid.
> mdadm: /dev/disk/by-id/dm-name-whatever-E2 has wrong uuid.
> 
> However:
> # mdadm --examine /dev/disk/by-id/dm-name-whatever-E1 |grep -i uuid
>            UUID : 2861aad0:228a48bc:f93e96a3:b6fdd813 (local to host host)
> # mdadm --examine /dev/disk/by-id/dm-name-whatever-E2 |grep -i uuid
>            UUID : 2861aad0:228a48bc:f93e96a3:b6fdd813 (local to host host)
> 
> Only when calling "mdadm -v -A /dev/md1" there are more reasonable messages like:
> mdadm: cannot open device /dev/disk/by-id/dm-name-whatever-E1: Device or resource busy
> 
> Now the question is: "Why is the device busy?" and "Who is holding the device busy?"
> Unfortunately (and here's a problem), neither "lsof" nor "fuser" could tell. That gave me a big headache.

Stacked devices have been this way forever.  There's no process holding the device.  The kernel's got it internally.

> Further digging in the verbose output of "mdadm" I found lines like this:
> mdadm: no recogniseable superblock on /dev/disk/by-id/dm-name-whatever-E2_part5
> mdadm: /dev/disk/by-id/dm-name-whatever-E2_part5 has wrong uuid.
> mdadm: cannot open device /dev/disk/by-id/dm-name-whatever-E2_part2: Device or resource busy
> mdadm: /dev/disk/by-id/dm-name-whatever-E2_part2 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/disk/by-id/dm-name-whatever-E2_part1
> mdadm: /dev/disk/by-id/dm-name-whatever-E2_part1 has wrong uuid.
> mdadm: cannot open device /dev/disk/by-id/dm-name-whatever-E2: Device or resource busy
> mdadm: /dev/disk/by-id/dm-name-whatever-E2 has wrong uuid.
> 
> So mdadm is considering partitions as well. I guessed that activating the partitions might keept the "parent device" busy, so I tried a "kpart -vd /dev/disk/by-id/dm-name-whatever-E2", but that did do nothing (with no error message).

Without instructions otherwise, both mdadm and LVM consider every block device.

The man-page for mdadm.conf describes how to filter the devices to consider.  Did you read about this?

The man-page for lvm.conf describes how to filter devices to consider, including a setting called "md_component_detection".  Did you read about this?

> Then I suspected LVM could activate the PV in partition 5. I tried to deactivate LVM on the device, but that also failed.
> 
> At this point I had googled at lot, and the kernel boot parameter "nodmraid" did not help either.
> 
> At a state of despair I decided to zap away the partition table temporarily:
> # sfdisk -d /dev/disk/by-id/dm-name-whatever-E1 >E1 ## Backup
> # sfdisk -d /dev/disk/by-id/dm-name-whatever-E2 >E2 ## Backup
> # dd if=/dev/zero bs=512 count=1 of=/dev/disk/by-id/dm-name-whatever-E1
> # dd if=/dev/zero bs=512 count=1 of=/dev/disk/by-id/dm-name-whatever-E2
> 
> Then I logically disconnected the SAN disks and reconnected them (via some /sys magic).
> 
> Then the RAID devices could be assembled again! This demonstrates that:
> 1) The original error message of mdadm about a wrong UUID is completely wrong ("device busy" would have been correct)
> 2) partitions on unassembled raid legs are activated before the RAID is assembled, effectively preventing a RAID assembly (I could not find out how to fix/prevent this)
> 
> After that I restored the saved partition table to the RAID(!) device (as it had been done originally).
> 
> I haven't studied the block data structures, but obviously the RAID metadata is not at the start of the devices. If they were, a partition table would not be found, and the RAID could have been assembled without a problem.

The metadata placement for the various versions is well documented in the man pages.  Metadata versions 1.1 and 1.2 are at the beginning of the device, for this very reason, among others.

> I'm not subscribed to the kernel-list, so please CC. your replies! Thanks!
> 
> I'm sending this message to make developers aware of the problem, and possibly help normal users finding this solution via Google.

Developers dealt with these use-cases more than a year ago, and pushed the fixes out in the normal way.  You used old tools to set up a system.  They could have been configured to deal with your use-case.  This is your problem, or your distribution's problem.

> Regards,
> Ulrich Windl
> P.S. Novell Support was not able to provide a solution for this problem in time

"in time" ?  So, you *did* put an untested system into production.  And you are rude to the volunteers who might help?  Not a good start.

Phil
