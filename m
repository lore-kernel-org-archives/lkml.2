Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2FQIYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 04:24:23 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42718 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2FQIYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 04:24:16 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while OK in AmigaOS 4.1
Date: Sun, 17 Jun 2012 10:24:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.3; x86_64; ; )
References: <201206170841.20222.Martin@lichtvoll.de> (sfid-20120617_090121_408610_436C7B18)
In-Reply-To: <201206170841.20222.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201206171024.14766.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 17. Juni 2012 schrieb Martin Steigerwald:
> Hi Jens, hi Linux m68k developers,
> 
> I reported that as
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=43511
> 
> I will attach there some more debug data like binary copy of RDB and
> such.
> 
> But maybe its easier to discuss here.

I think this one is pretty serious:

merkaba:~> pvdisplay /dev/sdb1
  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               steigerwald
  PV Size               1,82 TiB / not usable 4,08 MiB
  Allocatable           yes 
  PE Size               4,00 MiB
  Total PE              476931
  Free PE               105731
  Allocated PE          371200
  PV UUID               ZXMECC-JAir-lX8Q-rLhS-W1cS-quwz-b3FXWp
   
merkaba:~> vgdisplay steigerwald
  --- Volume group ---
  VG Name               steigerwald
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  7
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                5
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               1,82 TiB
  PE Size               4,00 MiB
  Total PE              476931
  Alloc PE / Size       371200 / 1,42 TiB
  Free  PE / Size       105731 / 413,01 GiB
  VG UUID               uhjjE1-0yrD-Ch1A-d9qL-P5jY-UDXE-io4bpi


with

merkaba:~#1> amiga-fdisk -l /dev/sdc
Disk /dev/sdc: 3 heads, 16 sectors, 81396441 cylinders, RDB: 0
Logical Cylinders from 43 to 81396440, 24576  bytes/Cylinder 

Device     Boot Mount   Begin      End     Size   Pri  BBlks    System
/dev/sdc1       *        43   65536043   1572864024     0      0  Linux native
/dev/sdc2       *    65536044   78643244   314572824     0      0  [unknown]
/dev/sdc3       *    78643245   81396440   66076704     0      0  Amiga FFS Int.


Due to truncating oversized partition instead of refusing to use
them the PV and consequently VG span the whole disk instead
of leaving space for the >350GB in the two other partitions:

merkaba:~> cat /proc/partitions 
major minor  #blocks  name

 […]
   8       16 1953514584 sdb
   8       17 1953513552 sdb1

(now sdb instead of sdc back when I run amiga-fdisk)


This is just asking for trouble. Thus:

Bug 43521 - Amiga RDB partitions: truncates miscaluted partitions size instead of refusing to use it
https://bugzilla.kernel.org/show_bug.cgi?id=43521


My suggestion is to bail out if a partition size looks insane and impossible.
Having to manually fix it up to access the data on disk still looks better
to me than potentially overwriting lots of data.



Until today I never actually did an Amiga backup to the disk, I just
created the two Amiga partitions and copied some screenshots of them
but that might be enough to explain the checksum errors I found in a
BTRFS backup partition.

I am now checking my Linux backups. They might be save, cause not all
space on the volume group is used.

See:

kernel got struck while scrubbing BTRFS with node- and leafsize 32768
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg17108.html

s/struck/stuck

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
