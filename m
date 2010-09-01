Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0IAQqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:46:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33299 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab0IAQqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=lArUuUzr+id2fW+ZEiu964yQyi3aftaGSO4J4qZNMCs31zJmEoXA8c5dv4Qp6R7GTs
         I7u7Rjil5LDid2sSx8z5nDv3ibWAN9mFuPTvbkZU5MFF42O5TqWdzM+NowOxkhW13Ptz
         xQbs0MBs7cXrgLuKDyMvKSOj6otMovcEvT10I=
MIME-Version: 1.0
In-Reply-To: <AANLkTikqu8ZC46LzX97604T1asCO=-Bu3LQx8aG6c8sJ@mail.gmail.com>
References: <AANLkTikqu8ZC46LzX97604T1asCO=-Bu3LQx8aG6c8sJ@mail.gmail.com>
Date: Wed, 1 Sep 2010 11:46:35 -0500
Message-ID: <AANLkTinuecwZ0NZ-24=UrPuUOQepTXOW41a-iH6Qxs0j@mail.gmail.com>
Subject: Re: two physical drives, but two device files point to same drive
From: Matt Garman <matthew.garman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to post this before I did more investigating.  Turns out one of
the new Hitachi drives was bad.

Still, think it's a curious failure model though.  If I pulled the
drive that was "doubly" recognized, then the bad drive isn't
recognized by Linux at all.  If I pulled the bad drive, the good drive
is no longer doubly recognized (i.e. has exactly one device file).

Strange.  But, replacing the broken drive with a good one makes things
look and act like they should.

Thanks,
Matt

On Wed, Sep 1, 2010 at 10:18 AM, Matt Garman <matthew.garman@gmail.com> wrote:
> I have a backup server with 25 total SATA drives.  I just swapped two
> drives for two new ones.  When I boot, there are two /dev/sdX device
> files, but both device files actually refer to the same physical
> drive.  The other physical drive does not have a device file and
> cannot be accessed.
>
> Here is a dmesg excerpt where the two drives are identified:
>
> mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 21, phy 26, sas_addr 0x
> 50030480006cd85a
>  Vendor: ATA       Model: Hitachi HDS72202  Rev: A3EA
>  Type:   Direct-Access                      ANSI SCSI revision: 05
> SCSI device sdx: 3907029168 512-byte hdwr sectors (2000399 MB)
> sdx: Write Protect is off
> sdx: Mode Sense: 73 00 00 08
> SCSI device sdx: drive cache: write back
> SCSI device sdx: 3907029168 512-byte hdwr sectors (2000399 MB)
> sdx: Write Protect is off
> sdx: Mode Sense: 73 00 00 08
> SCSI device sdx: drive cache: write back
>  sdx: sdx1
> sd 4:0:22:0: Attached scsi disk sdx
> mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 21, phy 27,
> sas_addr 0x50030480006cd85b
>  Vendor: ATA       Model: Hitachi HDS72202  Rev: A3EA
>  Type:   Direct-Access                      ANSI SCSI revision: 05
> SCSI device sdy: 3907029168 512-byte hdwr sectors (2000399 MB)
> sdy: Write Protect is off
> sdy: Mode Sense: 73 00 00 08
> SCSI device sdy: drive cache: write back
> SCSI device sdy: 3907029168 512-byte hdwr sectors (2000399 MB)
> sdy: Write Protect is off
> sdy: Mode Sense: 73 00 00 08
> SCSI device sdy: drive cache: write back
>  sdy: sdy1
> sd 4:0:23:0: Attached scsi disk sdy
>
> So the two drives are supposed to be sdx and sdy.
>
> Here is an excerpt from "smartctl -a /dev/sdx":
>
> Device Model:     Hitachi HDS722020ALA330
> Serial Number:    JK11A1YAJHEX7V
> Firmware Version: JKAOA3EA
> User Capacity:    2,000,398,934,016 bytes
>
>
> Likewise, "smartctl -a /dev/sdy":
>
> Device Model:     Hitachi HDS722020ALA330
> Serial Number:    JK11A1YAJHEX7V
> Firmware Version: JKAOA3EA
> User Capacity:    2,000,398,934,016 bytes
>
> As you can see, the serial numbers are the same.
>
> Furthermore, the drives are both brand new, and come from the factory
> without any partition table.  I created a partition table and ext3
> filesystem on sdx.  When I started fdisk for sdy, a partition already
> existed.  I went ahead and tried to create an ext3 filesystem on sdy
> as well, but after creating the inode blocks, it failed, saying, "file
> already exists".
>
> The drives are attached to an LSI Logic SASX36 expander/backplane.
> The SAS controller is: LSI Logic / Symbios Logic SAS1068E PCI-Express
> Fusion-MPT SAS.
>
> The kernel is from RHEL/CentOS: 2.6.18-194.3.1.el5
>
> With the exception of these two new Hitachi drives, I have been using
> this hardware for several months, with other drives connected to the
> exact same expander ports.  The only difference is that this is the
> first time I've used Hitachi drives.  Is it possible they are not
> compatible with the expander?  Or is it a kernel/driver bug (for
> either the SAS controller or expander)?
>
> Thanks,
> Matt
>
