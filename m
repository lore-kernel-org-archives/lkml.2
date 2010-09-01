Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0IAPSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:18:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52910 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab0IAPSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=t2PAGMUVwfYGH9bUpCRpZ6J6yRRHztGbSgfKZGItygAkSbFvcDYBClB4JJPM3niUKZ
         xfRm0+TAbNcV6w+VAvLWLO4/108Rygh9IMW0l+yPSzjePBD3qDapeJ5b4Rw3gacArley
         RcjZVzqJJqPfQb6wm+7MeWEqXOvENjXbY1ZOo=
MIME-Version: 1.0
Date: Wed, 1 Sep 2010 10:18:12 -0500
Message-ID: <AANLkTikqu8ZC46LzX97604T1asCO=-Bu3LQx8aG6c8sJ@mail.gmail.com>
Subject: two physical drives, but two device files point to same drive
From: Matt Garman <matthew.garman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a backup server with 25 total SATA drives.  I just swapped two
drives for two new ones.  When I boot, there are two /dev/sdX device
files, but both device files actually refer to the same physical
drive.  The other physical drive does not have a device file and
cannot be accessed.

Here is a dmesg excerpt where the two drives are identified:

mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 21, phy 26, sas_addr 0x
50030480006cd85a
  Vendor: ATA       Model: Hitachi HDS72202  Rev: A3EA
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdx: 3907029168 512-byte hdwr sectors (2000399 MB)
sdx: Write Protect is off
sdx: Mode Sense: 73 00 00 08
SCSI device sdx: drive cache: write back
SCSI device sdx: 3907029168 512-byte hdwr sectors (2000399 MB)
sdx: Write Protect is off
sdx: Mode Sense: 73 00 00 08
SCSI device sdx: drive cache: write back
 sdx: sdx1
sd 4:0:22:0: Attached scsi disk sdx
mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 21, phy 27,
sas_addr 0x50030480006cd85b
  Vendor: ATA       Model: Hitachi HDS72202  Rev: A3EA
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdy: 3907029168 512-byte hdwr sectors (2000399 MB)
sdy: Write Protect is off
sdy: Mode Sense: 73 00 00 08
SCSI device sdy: drive cache: write back
SCSI device sdy: 3907029168 512-byte hdwr sectors (2000399 MB)
sdy: Write Protect is off
sdy: Mode Sense: 73 00 00 08
SCSI device sdy: drive cache: write back
 sdy: sdy1
sd 4:0:23:0: Attached scsi disk sdy

So the two drives are supposed to be sdx and sdy.

Here is an excerpt from "smartctl -a /dev/sdx":

Device Model:     Hitachi HDS722020ALA330
Serial Number:    JK11A1YAJHEX7V
Firmware Version: JKAOA3EA
User Capacity:    2,000,398,934,016 bytes


Likewise, "smartctl -a /dev/sdy":

Device Model:     Hitachi HDS722020ALA330
Serial Number:    JK11A1YAJHEX7V
Firmware Version: JKAOA3EA
User Capacity:    2,000,398,934,016 bytes

As you can see, the serial numbers are the same.

Furthermore, the drives are both brand new, and come from the factory
without any partition table.  I created a partition table and ext3
filesystem on sdx.  When I started fdisk for sdy, a partition already
existed.  I went ahead and tried to create an ext3 filesystem on sdy
as well, but after creating the inode blocks, it failed, saying, "file
already exists".

The drives are attached to an LSI Logic SASX36 expander/backplane.
The SAS controller is: LSI Logic / Symbios Logic SAS1068E PCI-Express
Fusion-MPT SAS.

The kernel is from RHEL/CentOS: 2.6.18-194.3.1.el5

With the exception of these two new Hitachi drives, I have been using
this hardware for several months, with other drives connected to the
exact same expander ports.  The only difference is that this is the
first time I've used Hitachi drives.  Is it possible they are not
compatible with the expander?  Or is it a kernel/driver bug (for
either the SAS controller or expander)?

Thanks,
Matt
