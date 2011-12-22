Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab1LVSCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:02:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51740 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1LVSC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:02:29 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com, torvalds@linux-foundation.org
Subject: [PATCH 0/3] possible privilege escalation via SG_IO ioctl (CVE-2011-4127)
Date: Thu, 22 Dec 2011 19:02:16 +0100
Message-Id: <1324576939-23619-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partition block devices or LVM volumes can be sent SCSI commands via
SG_IO, which are then passed down to the underlying device.  (Yes, that
is it.  I tried hard to build a climax in the cover letter, but couldn't
get anything that satisfied me).

It has been this way forever.  I found a reference from 2004 at
https://lkml.org/lkml/2004/8/12/218 and it is even documented in the
sg_dd man page:

    blk_sgio=1
              when set to 0, block devices (e.g. /dev/sda) are treated
              like normal files (i.e. read(2) and write(2) are used for
              IO). When set to 1, block devices are assumed to accept the
              SG_IO ioctl and  SCSI commands are issued for IO. [...]
              If the input or output device is a block device partition
              (e.g. /dev/sda3) then setting this option causes the
              partition information to be ignored (since access is
              directly to the underlying device).

This is quite nasty, because "safe" SCSI commands, including READ
or WRITE, can be sent to the disk without any particular capability.  All
that is required is having a file descriptor for the block device, and
permission (e.g. from SELinux) to send a ioctl.  However, when a user lets
a program access /dev/sda2, it still should not be able to read/write
outside the boundaries of /dev/sda2.

This is also entirely independent of capabilities.  Continuing the
previous example, if the same user gives CAP_SYS_RAWIO to the program and
write access to /dev/sdb, the program should be able to send arbitrary
SCSI commands to /dev/sdb, but still should not be able to access /dev/sda
outside the boundaries of /dev/sda2.

These rules are quite obvious once you consider a real attack that can be
performed using SG_IO.  The attack lets a virtual machine, whose disk is
hosted on a partition, read and write arbitrary data from the host's disk.
To work, the guest needs to be able to send SG_IO ioctls to its devices.
As far as I know it affects virtual machine monitors that use virtio-blk,
and also OpenVZ.  It does not affect Xen, which does not support SG_IO
on its paravirtualized block devices.

In the virtio case, virtio-blk supports a limited form of SCSI passthrough
via the SG_IO ioctl; the virtio-blk device model on the host (e.g. qemu)
relies on the kernel to filter commands, so it will always forward the ioctl
to the block device and pass back the results to the VM.  When the block
device is a partition, the VM can read as well as clobber blocks outside
its assigned volume.  Note that SELinux cannot do anything to stop the
attack, because qemu _is_ supposed to send ioctls to disks.

With OpenVZ, a container would also be able to read and write outside
the partition limits with SG_IO ioctls.  Passing block devices is not
too common with OpenVZ but nevertheless possible.

In the virtio case the vulnerability can be mitigated by disabling SCSI
passthrough for the virtio-blk device; however, the root cause is in
the kernel and needs to be fixed there.

The patches implement a simple global whitelist for both partitions
and partial disk mappings.  While it is also possible to introduce a more
flexible per-device whitelist mechanism, in our testing the patches turned
out to be surprisingly tricky to get right.  Hence, I prefer to send a
version that more closely matches what we applied to the RHEL kernel.
Refactoring can then be done outside security@kernel.org.

Patch 1 refactors the code to prepare for introduction of the whitelist,
while patch 2 actually implements it for the SCSI ioctls.  drivers/ide/
has several ioctls that should only be restricted to the full block
device (for example HDIO_SET_*, HDIO_DRIVE_CMD, HDIO_DRIVE_TASK,
HDIO_DRIVE_RESET).  However, all of them require either CAP_SYS_ADMIN
or CAP_SYS_RAWIO, so they have a much smaller security impact.

Logical volumes are also affected if they have only one target, and this
target can pass ioctls to the underlying block device.  Patch 3 thus adds
the whitelist to logical volumes as well.

Paolo

Paolo Bonzini (3):
  block: add and use scsi_blk_cmd_ioctl
  block: fail SCSI passthrough ioctls on partition devices
  dm: do not forward ioctls from logical volumes to the underlying device

 block/scsi_ioctl.c             |   41 ++++++++++++++++++++++++++++++++++++++++
 drivers/block/cciss.c          |    6 ++--
 drivers/block/ub.c             |   14 +------------
 drivers/block/virtio_blk.c     |    4 +-
 drivers/cdrom/cdrom.c          |    3 +-
 drivers/ide/ide-floppy_ioctl.c |    3 +-
 drivers/md/dm-flakey.c         |   11 +++++++++-
 drivers/md/dm-linear.c         |   12 ++++++++++-
 drivers/md/dm-mpath.c          |    6 +++++
 drivers/scsi/sd.c              |   13 +++++++++--
 include/linux/blkdev.h         |    3 ++
 11 files changed, 89 insertions(+), 27 deletions(-)

-- 
1.7.7.1

