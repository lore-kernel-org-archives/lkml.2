Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab2AEOwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:52:24 -0500
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:35118
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab2AEOwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:52:23 -0500
Date: Thu, 5 Jan 2012 15:52:18 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <903212040.20120105155218@eikelenboom.it>
To: Theodore Tso <tytso@MIT.EDU>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: can't recover ext4 on lvm from ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd
In-Reply-To: <6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu>
References: <217150909.20120105113759@eikelenboom.it> <197607646.20120105142107@eikelenboom.it> <6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thursday, January 5, 2012, 3:45:01 PM, you wrote:


> On Jan 5, 2012, at 8:21 AM, Sander Eikelenboom wrote:

>> Hmm it seems to be over by reverting from a 3.2.0 to a 3.1.5 kernel, i now can copy the files after the fsck without it being remounted-ro due to the error.

> Hmm…  So the question is whether this is caused by changes to ext4 or in the device-mapper / LVM.

> The error which ext4 is reporting is that a block bitmap appears to be corrupted; the block group descriptors are reporting that there are 32258 free blocks, while only 32254 free blocks are found in the block bitmap.  Since one or the other is must be wrong, and continuing could potentially cause data loss, the file system gets mounted remounted read-only.

> What's funny is that fsck didn't report anything wrong.   That implies that the LVM volume is returning different block contents, at least under some circumstances.

> Hmm…. can you try reproducing this?   What happens if you now reboot into 3.2?   Do you still get the file system getting remounted read-only?    Can you try running dumpe2fs on the file system before and after running e2fsck, and when you try to reproduce it, can you make a special note of the EXT4-fs error message:

> [  220.748928] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd

> Do the numbers stay the same each time you reproduce the problem?   And are there any changes in the output of dumpe2fs (run diff; it will probably be a very tiny difference).

> Also, what is the underlying devices underlying the LVM?   Are you using a MD device?   Or is the 200T volume spread out across multiple hard drives directly (i.e., no RAID)?

> -- Ted


Yes well, since it worked again, i continued reshuffling the lvm layout that was planned for today, but this specific LV is still there, so i will try booting 3.2 again to see if i can reproduce and do the things you asked for.
No MD is used, it's one sata disk, containing 2 partitions (boot and a lvm PV), it has one VG that has the PV. That one is split into multiple LV's.



>> 
>> --
>> Sander
>> 
>> 
>> This is a forwarded message
>> From: Sander Eikelenboom <linux@eikelenboom.it>
>> To: "Theodore Ts'o" <tytso@mit.edu>
>> Date: Thursday, January 5, 2012, 11:37:59 AM
>> Subject: can't recover ext4 on lvm from ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd
>> 
>> ===8<==============Original message text===============
>> 
>> I'm having some troubles with a ext4 filesystem on LVM, it seems bricked and fsck doesn't seem to find and correct the problem.
>> 
>> Steps:
>> 1) fsck -v -p -f the filesystem
>> 2) mount the filesystem
>> 3) Try to copy a file
>> 4) filesystem will be mounted RO on error  (see below)
>> 5) fsck again, journal will be recovered, no other errors
>> 6) start at 1)
>> 
>> 
>> I think the way i bricked it is:
>> - make a lvm snapshot from that lvm logical disk
>> - mount that lvm snapshot as RO
>> - try to copy a file from that mounted RO snapshot to a diffrent dir on the lvm logical disk the snapshot is from.
>> - it fails and i can't recover (see above)
>> 
>> 
>> Is there a way to recover from this ?
>> 
>> 
>> 
>> [  220.748928] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd
>> [  220.749415] Aborting journal on device dm-2-8.
>> [  220.771633] EXT4-fs error (device dm-2): ext4_journal_start_sb:327: Detected aborted journal
>> [  220.772593] EXT4-fs (dm-2): Remounting filesystem read-only
>> [  220.792455] EXT4-fs (dm-2): Remounting filesystem read-only
>> [  220.805118] EXT4-fs (dm-2): ext4_da_writepages: jbd2_start: 9680 pages, ino 4079617; err -30
>> serveerstertje:/mnt/xen_images/domains/production# cd /
>> serveerstertje:/# umount /mnt/xen_images/
>> serveerstertje:/# fsck -f -v -p /dev/serveerstertje/xen_images
>> fsck from util-linux-ng 2.17.2
>> /dev/mapper/serveerstertje-xen_images: recovering journal
>> 
>>     277 inodes used (0.00%)
>>       5 non-contiguous files (1.8%)
>>       0 non-contiguous directories (0.0%)
>>         # of inodes with ind/dind/tind blocks: 41/41/3
>>         Extent depth histogram: 69/28/2
>> 51890920 blocks used (79.18%)
>>       0 bad blocks
>>      41 large files
>> 
>>     199 regular files
>>      53 directories
>>       0 character device files
>>       0 block device files
>>       0 fifos
>>       0 links
>>      16 symbolic links (16 fast symbolic links)
>>       0 sockets
>> --------
>>     268 files
>> serveerstertje:/#
>> 
>> 
>> 
>> 
>> System:
>> - Kernel 3.2.0
>> - Debian Squeeze with:
>> ii  e2fslibs                              1.41.12-4stable1                     ext2/ext3/ext4 file system libraries
>> ii  e2fsprogs                             1.41.12-4stable1                     ext2/ext3/ext4 file system utilities
>> 
>> ===8<===========End of original message text===========
>> 
>> 
>> 
>> -- 
>> Best regards,
>> Sander                            mailto:linux@eikelenboom.it<Message01.eml>




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

