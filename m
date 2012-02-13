Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab2BMTa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:30:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab2BMTa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:30:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        kzak@redhat.com
Cc: vgoyal@redhat.com, psusi@ubuntu.com, psusi@cfl.rr.com,
        maxim.patlasov@gmail.com
Subject: [PATCH 0/2] block: online resize of disk partitions 
Date: Mon, 13 Feb 2012 14:30:36 -0500
Message-Id: <1329161438-12602-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following patch adds support for online resizing of a partition. This patch
is based on previously posted patches by Phillip Susi.

There are two patches. Out of which one is kernel patch and other one is
util-linux patch to add support of a user space utility "resizepart" to
allow resizing the partition.

This ioctl only resizes the partition size in kenrel and does not change
the size on disk. A user needs to make sure that corresponding changes
are made to disk data structures also using fdisk(or partx), if changes
are to be retained across reboot.

I made some changes according to the feedback received last time. Following
are changes since the version Phillip posted.

- RESIZE ioctl ignores the partition "start" and does not expect user to
  specify one. Caller needs to just specify "device", "partition number" and
  "size" of new partition. 

- Got rid of part_nr_sects_write_begin/part_nr_sects_write_end functions
  and replaced these with single part_nr_sects_write().

- Some sequence counter related changes are simply lifted from i_size_write().

- Initialized part->nr_sects_seq using seqcount_init().

Phillip, do let me know if I should put your signed-off-by also in the
patch.

Any feedback is welcome.

I did following test.

- Create a partition of 10MB on a disk using fdisk.
- Add this partition to a volume group
- Use fdisk to increase the partition size to 20MB. (First delete the
  partition and then create a new one of 20MB size).
- Use resizepart to extend partition size in kernel.
	resizepart /dev/sdc 1 40960
- Do pvresize on partition so that physical volume can be incrased in
  size online.
	pvresize /dev/sda1

pvresize does recognize the new size. Also lsblk and /proc/partitions
report the new size of partition.

Thanks
Vivek

[PATCH 1/2] block: add partition resize function to blkpg ioctl
[PATCH 2/2] resizepart: Utility to resize a partition
