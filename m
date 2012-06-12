Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2FLPhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:37:47 -0400
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:51323 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2FLPhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:37:46 -0400
X-Greylist: delayed 895 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2012 11:37:46 EDT
Message-ID: <4FD75EB9.4090503@cogweb.net>
Date: Tue, 12 Jun 2012 08:22:33 -0700
From: David Liontooth <lionteeth@cogweb.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Nick Cheng <support@areca.com.tw>
Subject: arcmsr: cascading failures
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On a system with Areca 1680 cards, the failure of a single drive leads 
to a cascading failure of the other good drives:

The troubles starts with an arcmsr abort of the bad drive:

Jun 11 07:20:42 cartago kernel: arcmsr7: abort device command of scsi id 
= 1 lun = 3

Jun 11 07:20:42 cartago kernel: arcmsr: executing bus reset 
eh.....num_resets = 1, num_aborts = 16
Jun 11 07:20:42 cartago kernel: arcmsr7: executing hw bus reset .....
Jun 11 07:20:55 cartago kernel: arcmsr7: waiting for hw bus reset 
return, retry=0
Jun 11 07:23:05 cartago kernel: arcmsr7: waiting for hw bus reset 
return, retry=13
Jun 11 07:23:05 cartago kernel: arcmsr7: waiting for hw bus reset 
return, RETRY TERMINATED!!

Jun 11 07:23:05 cartago kernel: sd 7:0:1:3: Device offlined - not ready 
after error recovery
Jun 11 07:23:05 cartago kernel: sd 7:0:1:3: [sds] Unhandled error code

Jun 11 07:23:05 cartago kernel: sd 7:0:1:3: [sds]  Result: 
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun 11 07:23:05 cartago kernel: sd 7:0:1:3: [sds] CDB: Write(10): 2a 00 
29 1d a5 8f 00 00 10 00
Jun 11 07:23:05 cartago kernel: end_request: I/O error, dev sds, sector 
689808783
Jun 11 07:23:05 cartago kernel: sd 7:0:1:3: rejecting I/O to offline device

Jun 11 07:23:05 cartago kernel: XFS (sds1): xfs_do_force_shutdown(0x2) 
called from line 891 of file fs/xfs/xfs_log.c.
Jun 11 07:23:05 cartago kernel: XFS (sds1): Log I/O Error Detected.  
Shutting down filesystem
Jun 11 07:23:05 cartago kernel: XFS (sds1): Please umount the filesystem 
and rectify the problem(s)
Jun 11 07:23:35 cartago kernel: XFS (sds1): xfs_log_force: error 5 returned.

So far, so good -- the drive has failed and been taken offline. The 
kernel handles this fine, though it would be nice to have a way to tell 
XFS to stop trying to shut down the file system -- it's a lost cause.

Now the trouble starts: arcmsr starts aborting device commands to other 
drives:

Jun 11 07:23:36 cartago kernel: arcmsr7: abort device command of scsi id 
= 3 lun = 1
Jun 11 07:23:40 cartago kernel: arcmsr7: abort device command of scsi id 
= 3 lun = 1
Jun 11 07:23:44 cartago kernel: arcmsr7: abort device command of scsi id 
= 1 lun = 5
Jun 11 07:23:48 cartago kernel: arcmsr: executing bus reset 
eh.....num_resets = 2, num_aborts = 19
Jun 11 07:23:48 cartago kernel: arcmsr: there is an  bus reset eh 
proceeding.......

Udev notices a drive is missing and starts removing disk references -- 
this is a good working drive:

Jun 11 07:27:29 cartago udevd[17693]: removing watch on '/dev/sde1'
Jun 11 07:27:29 cartago udevd[17693]: no reference left, remove 
'/dev/disk/by-id/scsi-2001b4d2070476002-part1'
Jun 11 07:27:29 cartago udevd[17693]: no reference left, remove 
'/dev/disk/by-label/2007_05'
Jun 11 07:27:29 cartago udevd[17693]: no reference left, remove 
'/dev/disk/by-path/pci-0000:06:00.0-scsi-0:0:1:2-part1'
Jun 11 07:27:29 cartago udevd[17693]: no reference left, remove 
'/dev/disk/by-uuid/34c6f15b-427a-4414-8840-7e227efae0e3'
Jun 11 07:27:29 cartago udevd[17693]: device node '/dev/sde1' has sticky 
bit set, skip removal
Jun 11 07:27:29 cartago udevd[17693]: passed -1 bytes to netlink monitor 
0x2611130
Jun 11 07:27:29 cartago udevd[17693]: seq 2126 processed with 0
Jun 11 07:27:29 cartago udevd[1427]: seq 2126 done with 0

XFS gets busy trying to shut down a good drive:

Jun 11 07:27:29 cartago kernel: XFS (sde1): xfs_do_force_shutdown(0x1) 
called from line 1052 of file fs/xfs/linux-2.6/xfs_b$
Jun 11 07:27:29 cartago kernel: XFS (sde1): I/O Error Detected. Shutting 
down filesystem
Jun 11 07:27:29 cartago kernel: XFS (sde1): Please umount the filesystem 
and rectify the problem(s)

arcmsr keeps trying to "recover" and spreads mayhem to all the other 
drives -- there's around 20 of them:

Jun 11 07:28:12 cartago kernel: arcmsr7: abort device command of scsi id 
= 3 lun = 1
Jun 11 07:28:16 cartago kernel: arcmsr: executing bus reset 
eh.....num_resets = 4, num_aborts = 21
Jun 11 07:28:26 cartago kernel: sd 7:0:1:5: Device offlined - not ready 
after error recovery
Jun 11 07:28:26 cartago kernel: sd 7:0:3:1: Device offlined - not ready 
after error recovery
Jun 11 07:28:26 cartago kernel: sd 7:0:3:1: Device offlined - not ready 
after error recovery
Jun 11 07:28:26 cartago kernel: sd 7:0:1:5: [sdg] Unhandled error code

Gory details available on request. The machine now will now not halt and 
requires a very expensive hard reset.

Is there some way to keep this from happening? A failed drive should be 
isolated and dropped; this is losing the whole army to save one dead man.

Cheers,
David

# modinfo arcmsr
filename:       /lib/modules/3.0.26/kernel/drivers/scsi/arcmsr/arcmsr.ko
version:        Driver Version 1.20.00.15 2010/08/05
license:        Dual BSD/GPL
description:    ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host Bus 
Adapter
author:         Nick Cheng <support@areca.com.tw>
srcversion:     F9D834593FE182DC013DBD0

# uname -a
Linux cartago 3.0.26 #1 SMP Sat Apr 14 15:04:35 PDT 2012 x86_64 GNU/Linux


