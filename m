Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2DTHDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:03:43 -0400
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:55316 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2DTHDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:03:41 -0400
Message-ID: <4F8F3563.9020701@genband.com>
Date: Wed, 18 Apr 2012 15:42:59 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org
Subject: "udevadm info --attribute-walk --path=/block/sda" doesn't show parents
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2012 21:43:00.0487 (UTC) FILETIME=[39CC1970:01CD1DAC]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18848.002
X-TM-AS-Result: No--29.688700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a 2.6.34.10-based kernel with udev-161 (also tested with udevadm from udev-173).

When I run "udevadm info --attribute-walk --path=/block/sda" it just shows the device
itself, and doesn't walk the whole chain showing the parents.

Is there anything I can do, or am I caught with a kernel that isn't properly supported?
I'm not subscribed to the hotplug list, so cc'ing me would be appreciated.


I don't know what's causing the problem, but I find it suspicious that /sys/block/sda
is a directory rather than a symlink like it is on my 2.6.35.14 laptop.  I'm poking
around in the udevadm code now.


Some possibly-useful information:


root@typhoon-base-unit0:/root> udevadm info --attribute-walk --path=/block/sda

Udevadm info starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

  looking at device '/block/sda':
    KERNEL=="sda"
    SUBSYSTEM=="block"
    DRIVER==""
    ATTR{range}=="16"
    ATTR{ext_range}=="256"
    ATTR{removable}=="0"
    ATTR{ro}=="0"
    ATTR{size}=="586072368"
    ATTR{alignment_offset}=="0"
    ATTR{discard_alignment}=="0"
    ATTR{capability}=="50"
    ATTR{stat}=="      12        3       80       50        0        0        0        0        0       50       50"
    ATTR{inflight}=="       0        0"


root@typhoon-base-unit0:/root> udevadm info -p /block/sda -q all
P: /block/sda
N: sda
S: scsi/host/bus/target/lun/disc
S: discs/disc0/disc
S: block/8:0
S: disk/by-id/scsi-1ATA_WDC_WD3000BLHX-01V7BV0_WD-WX61E41PY599
E: UDEV_LOG=3
E: DEVPATH=/block/sda
E: SUBSYSTEM=block
E: DEVNAME=sda
E: ID_SCSI=1
E: ID_VENDOR=ATA
E: ID_VENDOR_ENC=ATA\x20\x20\x20\x20\x20
E: ID_MODEL=WDC_WD3000BLHX-0
E: ID_MODEL_ENC=WDC\x20WD3000BLHX-0
E: ID_REVISION=04.0
E: ID_TYPE=disk
E: ID_SERIAL=1ATA_WDC_WD3000BLHX-01V7BV0_WD-WX61E41PY599
E: ID_SERIAL_SHORT=ATA_WDC_WD3000BLHX-01V7BV0_WD-WX61E41PY599
E: ID_SCSI_SERIAL=WD-WX61E41PY599
E: ID_BUS=scsi
E: MAJOR=8
E: MINOR=0
E: DEVTYPE=disk
E: PHYSDEVPATH=/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0
E: PHYSDEVBUS=scsi
E: PHYSDEVDRIVER=sd
E: DEVLINKS=/dev/scsi/host/bus/target/lun/disc /dev/discs/disc0/disc /dev/block/8:0 /dev/disk/by-id/scsi-1ATA_WDC_WD3000BLHX-01V7BV0_WD-WX61E41PY599

root@typhoon-base-unit0:/root> ls -l /sys/block/sda
total 0
-r--r--r-- 1 root root 4096 Apr 18 14:16 alignment_offset
lrwxrwxrwx 1 root root    0 Apr 18 14:16 bdi -> ../../class/bdi/8:0
-r--r--r-- 1 root root 4096 Apr 18 14:16 capability
-r--r--r-- 1 root root 4096 Apr 18 14:16 dev
lrwxrwxrwx 1 root root    0 Apr 18 14:16 device -> ../../devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0
-r--r--r-- 1 root root 4096 Apr 18 14:16 discard_alignment
-r--r--r-- 1 root root 4096 Apr 18 14:16 ext_range
drwxr-xr-x 2 root root    0 Apr 18 14:16 holders
-r--r--r-- 1 root root 4096 Apr 18 14:16 inflight
drwxr-xr-x 2 root root    0 Apr 18 14:16 power
drwxr-xr-x 3 root root    0 Apr 18 14:16 queue
-r--r--r-- 1 root root 4096 Apr 18 14:16 range
-r--r--r-- 1 root root 4096 Apr 18 14:16 removable
-r--r--r-- 1 root root 4096 Apr 18 14:16 ro
drwxr-xr-x 4 root root    0 Apr 18 14:16 sda1
drwxr-xr-x 4 root root    0 Apr 18 14:16 sda2
-r--r--r-- 1 root root 4096 Apr 18 14:16 size
drwxr-xr-x 2 root root    0 Apr 18 14:16 slaves
-r--r--r-- 1 root root 4096 Apr 18 14:16 stat
lrwxrwxrwx 1 root root    0 Apr 18 14:16 subsystem -> ../../block
-rw-r--r-- 1 root root 4096 Apr 18 14:16 uevent


Thanks,
Chris







-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
