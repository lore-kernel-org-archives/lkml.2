Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1FQVbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:31:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891Ab1FQVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:31:12 -0400
Date: Fri, 17 Jun 2011 14:31:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: markk@clara.co.uk
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 37682] New: Kernel mis-detects size/position
 of partition created with Seagate DiscWizard (OnTrack Disk Manager)
Message-Id: <20110617143104.3b883bda.akpm@linux-foundation.org>
In-Reply-To: <bug-37682-10286@https.bugzilla.kernel.org/>
References: <bug-37682-10286@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 16 Jun 2011 17:31:02 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=37682
> 
>            Summary: Kernel mis-detects size/position of partition created
>                     with Seagate DiscWizard (OnTrack Disk Manager)

Hey, nice bug report!

There isn't really anyone who maintains that part of the kernel, but
with the info you've provided, pretty much any willing person could fix
this up.  So let's toss it out there and see?

>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.38
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Block Layer
>         AssignedTo: axboe@kernel.dk
>         ReportedBy: markk@clara.co.uk
>         Regression: No
> 
> 
> Created an attachment (id=62332)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=62332)
> First 136 sectors of disk
> 
> Hi,
> 
> The kernel partition table scanning code appears to have a problem with
> partitions created by Seagate DiscWizard (a version of Ontrack Disk Manager).
> 
> I came across a 20GB Seagate drive which was installed in a machine running
> Windows 95. It was formatted using DiscWizard to have a single FAT32 partition.
> The 20GB drive was a secondary drive. However, the system probably booted from
> it to load the OnTrack code, which then booted the OS from the primary drive.
> 
> dmesg output on connecting the drive (via an IDE-USB converter):
>  sd 10:0:0:0: [sdd] 39102336 512-byte logical blocks: (20.0 GB/18.6 GiB)
>  sd 10:0:0:0: [sdd] Write Protect is off
>  sd 10:0:0:0: [sdd] Mode Sense: 00 38 00 00
>  sd 10:0:0:0: [sdd] Asking for cache data failed
>  sd 10:0:0:0: [sdd] Assuming drive cache: write through
>  sd 10:0:0:0: [sdd] Asking for cache data failed
>  sd 10:0:0:0: [sdd] Assuming drive cache: write through
>  sdd: sdd1[DM]
> 
> # blockdev --getsize /dev/sdd1
> 16434486
> 
> A partition is detected; sdd1[DM] appears in dmesg output. However its apparent
> size is too small; 7.37GB instead of ~20GB. So attempting to mount /dev/sdd1
> fails.
> 
> The partition actually starts at sector 126. I was able to mount it manually by
> doing something like:
> # mount -o ro,loop,offset=64512 -t vfat /dev/sdd /mnt/disk
> 
> The "disktype" program makes the same mistake as the kernel:
> # disktype /dev/sdd
> 
> --- /dev/sdd
> Block device, size 18.65 GiB (20020396032 bytes)
> DOS/MBR partition map
> Partition 1: 7.837 GiB (8414456832 bytes, 16434486 sectors from 9, bootable)
>   Type 0x54 (OnTrackDM6)
> 
> 
> If I copy some data from the start of the actual partition to a temporary file
> and run disktype on that:
> # disktype tempfile
> 
> --- tempfile
> Regular file, size 255.9 MiB (268370944 bytes)
> Windows 95/98/ME boot loader
> FAT32 file system (hints score 5 of 5)
>   Volume size 18.64 GiB (20010500096 bytes, 1221344 clusters of 16 KiB)
>   Volume name "DSK2_VOL1"
> 
> 
> In case it helps to diagnose the problem, I have attached the first 0x11000
> bytes of this disk.


