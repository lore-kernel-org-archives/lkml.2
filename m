Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab1FROfr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 10:35:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60353 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab1FROfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 10:35:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [Bug 37682] New: Kernel mis-detects size/position of partition created with Seagate DiscWizard (OnTrack Disk Manager)
Date: Sat, 18 Jun 2011 16:34:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: markk@clara.co.uk, Andrew Morton <akpm@linux-foundation.org>,
        bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
References: <bug-37682-10286@https.bugzilla.kernel.org/> <c6813b0914dd61da40fc2db868ea5b11.squirrel@ssl-webmail-vh.clara.net> <1308393501.23584.27.camel@x61.thuisdomein>
In-Reply-To: <1308393501.23584.27.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106181634.53503.arnd@arndb.de>
X-Provags-ID: V02:K0:voI/p2/Ag5Ya5XhUYAwmvgNdTsXZAmzTpXk6WERcL5q
 TY2VnsdMp0ZureMIzjEaG71V6nIowaoiIfqIwG2dKJX/IsFU8u
 0NAbuQwgprTRVsjjlxVmZniy878RfrpXYx105BvEkDv5aCcJ8y
 QzUmRDfNELwzQ22nYGFz9ucKUUXS+6XkEAcJV0L5mBHORoCPAJ
 k9/ik+bMuRjOFaUCpk6nQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 12:38:21 Paul Bolle wrote:
> Perhaps this means one is expected to use dmsetup(8) for this. I have
> never configured device-mapper at that level by hand. man 8 dmsetup is
> over 300 lines of (new for me) information. Without a disk like yours at
> hand, it's hard to say whether device-mapper allows to do stuff like
> this (ie, remapping an entire drive by 63 sectors) by hand.
> 
> Of course, for your particular drive it might be easier to just dd the
> actual partition (so skipping 63 sectors) into new file (a 20G image) on
> another drive. That image should be loop mountable. If that's correct
> you could then do with the drive as you please. Given its age, it may be
> wise to, say, shred(1) its corresponding device and drop the drive at
> your local recycling site.

You can also create a "correct" partition table to replace the old
one and directly point to the FAT partition:

# fdisk -c -u -C2435 -H255 -S 63 /dev/sdX

Command (m for help): p

Disk /dev/sdX: 0 MB, 0 bytes
255 heads, 63 sectors/track, 2434 cylinders, total 0 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

  Device Boot      Start         End      Blocks   Id  System
/dev/sdX   *           9    16434494     8217243   54  OnTrackDM6

Command (m for help): d
Selected partition 1

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First sector (1-39118274, default 1): ?
First sector (1-39118274, default 1): 126
Last sector, +sectors or +size{K,M,G} (126-39118274, default 39118274): +39102147

Command (m for help): t
Selected partition 1
Hex code (type L to list codes): c
Changed system type of partition 1 to c (W95 FAT32 (LBA))

Command (m for help): a
Partition number (1-4): 1

Command (m for help): p

Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

  Device Boot      Start         End      Blocks   Id  System
/dev/sdX   *         126    39102273    19551074    c  W95 FAT32 (LBA)


Command (m for help): w
The partition table has been altered!


WARNING: If you have created or modified any DOS 6.x
partitions, please see the fdisk manual page for additional
information.
Syncing disks.
