Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab1AEJ5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:57:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55397 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1AEJ5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:57:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ZxpaMSI4JWji1SGjNUlLbRxLCB+6wLTxp/eXs22Pri275zQ32NE0/Js/sJ9ErguUl2
         LPeH7fUAW890gq6vf9bJrP+YP2A4vbpONJFDsUFsSkKH0WdlS4NPByzpc7z9hHnlHYz/
         h7iH0xbgeB/WuFtanyEiGA1w1KPSejGwUbnws=
Message-ID: <4D24408B.8060204@gmail.com>
Date: Wed, 05 Jan 2011 10:57:31 +0100
From: Guillaume Rousse <guillomovitch@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101214 Mandriva/3.1.7-1mdv2011.0 (2011.0) Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: VFS issue with hardware-encrypted usb devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm currently playing with hardware-encrypted Imation defender USB
devices, which are USB keys/drives, using password and/or fingerprint
sensors for unlocking content:
http://www.imation.com/en-us/Imation-Products/

The main issue is that they are automatically mounted under gnome (and I
guess all other modern desktop) before being unlocked, and the VFS
doesn't likes the behind-the-scene changes very much.

Here the syslog trace when plugging (the normal partition is seen as a
CD-ROM, the encrypted one as a standard removal drive):
Jan  3 15:14:07 beria kernel: : usb 2-1: new high speed USB device using
ehci_hcd and address 8
Jan  3 15:14:08 beria kernel: : usb 2-1: New USB device found,
idVendor=0718, idProduct=0682
Jan  3 15:14:08 beria kernel: : usb 2-1: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Jan  3 15:14:08 beria kernel: : usb 2-1: Product: Defender F200
Jan  3 15:14:08 beria kernel: : usb 2-1: Manufacturer: Imation
Jan  3 15:14:08 beria kernel: : usb 2-1: SerialNumber: F5121031F003008E
Jan  3 15:14:08 beria kernel: : scsi10 : usb-storage 2-1:1.0
Jan  3 15:14:09 beria kernel: : scsi 10:0:0:0: CD-ROM
Defender F200 Application 0001 PQ: 0 ANSI: 2
Jan  3 15:14:09 beria kernel: : sr0: scsi-1 drive
Jan  3 15:14:09 beria kernel: : sr 10:0:0:0: Attached scsi generic sg1
type 5
Jan  3 15:14:09 beria kernel: : scsi 10:0:0:1: Direct-Access
Defender F200 Private     0001 PQ: 0 ANSI: 2
Jan  3 15:14:09 beria kernel: : sd 10:0:0:1: Attached scsi generic sg2
type 0
Jan  3 15:14:09 beria kernel: : sd 10:0:0:1: [sdb] 18434 512-byte
logical blocks: (9.43 MB/9.00 MiB)
Jan  3 15:14:09 beria kernel: : sd 10:0:0:1: [sdb] Write Protect is off
Jan  3 15:14:09 beria kernel: : sd 10:0:0:1: [sdb] Assuming drive cache:
write through
Jan  3 15:14:09 beria kernel: : sd 10:0:0:1: [sdb] Assuming drive cache:
write through
Jan  3 15:14:09 beria kernel: : sdb:
Jan  3 15:14:09 beria kernel: : sd 10:0:0:1: [sdb] Assuming drive cache:
write through
Jan  3 15:14:09 beria kernel: : sd 10:0:0:1: [sdb] Attached SCSI
removable disk

Then unlocking is performed, by sweeping fingerprint sensor, and the
hardware change, triggering issues:
Jan  3 15:14:21 beria kernel: : VFS: busy inodes on changed media or
resized disk sdb
Jan  3 15:14:21 beria kernel: : sd 10:0:0:1: [sdb] 3393536 512-byte
logical blocks: (1.73 GB/1.61 GiB)
Jan  3 15:14:21 beria kernel: : sd 10:0:0:1: [sdb] Assuming drive cache:
write through

Jan  3 15:14:40 beria kernel: : FAT: Filesystem error (dev sdb)
Jan  3 15:14:40 beria kernel: : fat_get_cluster: invalid cluster chain
(i_pos 262)
Jan  3 15:14:40 beria kernel: : FAT: Filesystem has been set read-only
Jan  3 15:14:40 beria kernel: : FAT: Filesystem error (dev sdb)

If I'm quick enough at jumping on sensor to unlock at mount time,
everything works fine, meaning the real issue is changing partition
status when already mounted.

I don't know how this issue should be properly handled. Should the VFS
be aware than some kind of exotic hardware are able to perform this kind
of tricks ? Should the automounter be able to manage those kind of
device by not mouting them automatically, at least until they reach
proper state ?

Forgive me if it's not the right place to discuss the issue, but I
couldn't find a better one for VFS issues.
-- 
BOFH excuse #31:

cellular telephone interference
