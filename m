Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1H3MtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:49:18 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:34592 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1H3MtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:49:17 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjzYQEROTxg==
X-RZG-CLASS-ID: mo00
Date: Tue, 30 Aug 2011 14:48:56 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 0000/0046] Staging: hv: Driver cleanup
Message-ID: <20110830124856.GA17520@aepfle.de>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1314469874-7017-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, K. Y. Srinivasan wrote:

> 	2) Handle all block devices using the storvsc driver. I have modified
> 	   the implementation here based on Christoph's feedback on my earlier
> 	   implementation.

The upgrade path from hv_blkvsc to hv_storvsc is difficult.

hv_storvsc does not provide the vmbus:hv_block modalias, so mkinitrd
does not know what module to choose when mkinitrd is called in a
previous kernel (like sles11sp1).


In a guest with both SCSI and IDE controllers the IDE disks are
discovered first, so the SCSI drives will also change their names.
Thats not a problem for data partitions because they could be mounted by
UUID or LABEL in fstab.
But its difficult to adjust /boot/grub/device.map for example because
the old  IDE drives do not provide an identifier. What is the best way
to make sure the rename from hd* to sd* in such config files is done
correctly? Is it safe to assume that all drives with a class_id of
32412632-86cb-44a2-9b5c50d1417354f5 are connected to IDE ports?

localhost:~ # head /sys/bus/vmbus/devices/vmbus_0_{1,2,3,10,11}/class_id
==> /sys/bus/vmbus/devices/vmbus_0_1/class_id <==
{32412632-86cb-44a2-9b5c50d1417354f5}

==> /sys/bus/vmbus/devices/vmbus_0_2/class_id <==
{32412632-86cb-44a2-9b5c50d1417354f5}

==> /sys/bus/vmbus/devices/vmbus_0_3/class_id <==
{32412632-86cb-44a2-9b5c50d1417354f5}

==> /sys/bus/vmbus/devices/vmbus_0_10/class_id <==
{ba6163d9-04a1-4d29-b60572e2ffb1dc7f}

==> /sys/bus/vmbus/devices/vmbus_0_11/class_id <==
{ba6163d9-04a1-4d29-b60572e2ffb1dc7f}


In my test system, the IDE drives are now discovered twice, once by
hv_storvsc and once by libata:

localhost:~ # lsscsi 
[0:0:0:0]    disk    Msft     Virtual Disk     1.0   /dev/sda 
[1:0:1:0]    disk    Msft     Virtual Disk     1.0   /dev/sdb 
[2:0:1:0]    disk    Msft     Virtual Disk     1.0   /dev/sdc 
[3:0:0:0]    disk    Msft     Virtual Disk     1.0   /dev/sdd 
[3:0:0:1]    disk    Msft     Virtual Disk     1.0   /dev/sde 
[4:0:0:0]    disk    Msft     Virtual Disk     1.0   /dev/sdf 
[4:0:0:1]    disk    Msft     Virtual Disk     1.0   /dev/sdg 
[5:0:0:0]    disk    ATA      Virtual HD       1.1.  /dev/sdh 
[5:0:1:0]    disk    ATA      Virtual HD       1.1.  /dev/sdi 
[6:0:0:0]    cd/dvd  Msft     Virtual CD/ROM   1.0   /dev/sr0 
[6:0:1:0]    disk    ATA      Virtual HD       1.1.  /dev/sdj 
localhost:~ # blkid
/dev/sda1: UUID="47aebbfb-13ee-49cc-b1e7-bc0c243fe3c0" TYPE="swap" 
/dev/sda2: UUID="ed5a182b-da28-42f2-acff-5649a8fae247" TYPE="ext3" 
/dev/sdh1: UUID="47aebbfb-13ee-49cc-b1e7-bc0c243fe3c0" TYPE="swap" 
/dev/sdh2: UUID="ed5a182b-da28-42f2-acff-5649a8fae247" TYPE="ext3" 

sda/sdh was hda.

Olaf
