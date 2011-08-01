Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1HANim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:38:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35694 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1HANie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:38:34 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no read/write devices V2
Date: Mon,  1 Aug 2011 14:38:30 +0100
Message-Id: <1312205910-13053-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we mount a btrfs filesystem from read-only media there will be no
read/write devices; for example mounting an SD card with its lock enabled.
This triggers an immediate BUG during mount:

  kernel BUG at .../fs/btrfs/super.c:984!

This is triggered by statfs when calculating the free space in the
filesytem.  We bug if the number of read/write devices is 0.

This check seems spurious as the information collected is valid regardless
of whether the devices are read-only or not.  As the count is used to
size the sort array it seems more correct to switch it to the number of
open devices.

BugLink: http://bugs.launchpad.net/bugs/816770
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/btrfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 15634d4..ae4367a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -980,7 +980,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	int i = 0, nr_devices;
 	int ret;
 
-	nr_devices = fs_info->fs_devices->rw_devices;
+	nr_devices = fs_info->fs_devices->open_devices;
 	BUG_ON(!nr_devices);
 
 	devices_info = kmalloc(sizeof(*devices_info) * nr_devices,
-- 
1.7.4.1

