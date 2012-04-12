Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762037Ab2DLGpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:45:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37488 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab2DLGpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120105181535.GB26382@thunk.org>
References: <217150909.20120105113759@eikelenboom.it>
	<197607646.20120105142107@eikelenboom.it>
	<6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu>
	<4910694144.20120105171428@eikelenboom.it>
	<20120105181535.GB26382@thunk.org>
Date: Thu, 12 Apr 2012 08:45:42 +0200
Message-ID: <CAD1=SREuquUehvTz_9L-62s6Cd8xxsxi3GZLfPvLG3V8bQkDwA@mail.gmail.com>
Subject: Re: can't recover ext4 on lvm from ext4_mb_generate_buddy:739: group
 1687, 32254 clusters in bitmap, 32258 in gd
From: Landry Minoza <landry.minoza@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Sander Eikelenboom <linux@eikelenboom.it>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 7:15 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Jan 05, 2012 at 05:14:28PM +0100, Sander Eikelenboom wrote:
>>
>> OK spoke too soon, i have been able to trigger it again:
>> - copying files from LV to the same LV without the snapshot went OK
>> - copying from the RO snapshot of a LV to the same LV gave the error while copying the file again:
>
> OK.  Originally, you said you did this:
>
> 1) fsck -v -p -f the filesystem
> 2) mount the filesystem
> 3) Try to copy a file
> 4) filesystem will be mounted RO on error  (see below)
> 5) fsck again, journal will be recovered, no other errors
> 6) start at 1)
>
> Was this with with a read-only snapshot always being in existence
> through all of these five steps?  When was the RO snapshot created?
>
> If a RO snapshot has to be there in order for this to happen, then
> this is almost certainly a device-mapper regression.  (dm-devel folks,
> this is a problem which apparently occurred when the user went from
> v3.1.5 to v3.2, so this looks likes 3.2 regression.)
>

If it can help, I add the exactly same behaviour: filesystem remounted
read-only with the same messages in dmesg and had to fsck it with a
3.1 kernel when I resized my ext4/lvm root fs.

I used kernel 3.3-rc6 from debian experimental amd64.
root fs remounted read-only with the same errors in dmesg after:
lvresize -L +5G /dev/mapper/perceval_vg1-root
resize2fs /dev/mapper/perceval_vg1-root

Rebooting on 3.3 or 3.2 kernel doesn't helped. Also tried to boot on
3.0 and 2.6.x from rescue CDs without success (fsck ok, mounting
without problem but fs remounted ro as soon as I boot on 3.2 or 3.3
kernel).
I had to install a 3.1 kernel boot on it to be able to finaly reboot on 3.3.

I use a single harddrive without any sort of raid and with one lvm pv
and one vg:
sudo fdisk -l /dev/sda

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xb0000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1              63      273104      136521   de  Dell Utility
/dev/sda2       205073105   205265884       96390   83  Linux
/dev/sda3   *      273105   205073104   102400000    7  HPFS/NTFS/exFAT
/dev/sda4       205265885   976773167   385753641+  8e  Linux LVM

Partition table entries are not in disk order

sudo pvs
  PV         VG           Fmt  Attr PSize   PFree
  /dev/sda4  perceval_vg1 lvm2 a--  367,88g 187,35g

sudo vgs
  VG           #PV #LV #SN Attr   VSize   VFree
  perceval_vg1   1   3   0 wz--n- 367,88g 187,35g

sudo lvs
  LV   VG           Attr   LSize   Origin Snap%  Move Log Copy%  Convert
  home perceval_vg1 -wi-ao 151,75g
  root perceval_vg1 -wi-ao  24,97g
  swap perceval_vg1 -wi-ao   3,82g


Can post other informations if it can help

-- 
Landry MINOZA
landry.minoza@gmail.com
