Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab1KUJl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:41:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:25442 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab1KUJlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:41:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,546,1315206000"; 
   d="scan'208";a="87658478"
Message-Id: <20111121093846.251104145@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 17:18:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, Ankit Jain <radical@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/8] readahead: make default readahead size a kernel parameter
References: <20111121091819.394895091@intel.com>
Content-Disposition: inline; filename=readahead-kernel-parameter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikanth Karthikesan <knikanth@suse.de>

Add new kernel parameter "readahead=", which allows user to override
the static VM_MAX_READAHEAD=128kb.

CC: Ankit Jain <radical@gmail.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 block/blk-core.c                    |    3 +--
 fs/fuse/inode.c                     |    2 +-
 mm/readahead.c                      |   19 +++++++++++++++++++
 4 files changed, 27 insertions(+), 3 deletions(-)

--- linux-next.orig/Documentation/kernel-parameters.txt	2011-10-19 11:11:14.000000000 +0800
+++ linux-next/Documentation/kernel-parameters.txt	2011-11-20 11:09:56.000000000 +0800
@@ -2245,6 +2245,12 @@ bytes respectively. Such letter suffixes
 			Run specified binary instead of /init from the ramdisk,
 			used for early userspace startup. See initrd.
 
+	readahead=nn[KM]
+			Default max readahead size for block devices.
+
+			This default max readahead size may be overrode
+			in some cases, notably NFS, btrfs and software RAID.
+
 	reboot=		[BUGS=X86-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
 			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
--- linux-next.orig/block/blk-core.c	2011-11-08 10:18:16.000000000 +0800
+++ linux-next/block/blk-core.c	2011-11-20 10:49:33.000000000 +0800
@@ -462,8 +462,7 @@ struct request_queue *blk_alloc_queue_no
 	if (!q)
 		return NULL;
 
-	q->backing_dev_info.ra_pages =
-			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	q->backing_dev_info.ra_pages = default_backing_dev_info.ra_pages;
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
 	q->backing_dev_info.name = "block";
--- linux-next.orig/fs/fuse/inode.c	2011-11-08 10:18:39.000000000 +0800
+++ linux-next/fs/fuse/inode.c	2011-11-20 10:50:12.000000000 +0800
@@ -878,7 +878,7 @@ static int fuse_bdi_init(struct fuse_con
 	int err;
 
 	fc->bdi.name = "fuse";
-	fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	fc->bdi.ra_pages = default_backing_dev_info.ra_pages;
 	/* fuse does it's own writeback accounting */
 	fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
 
--- linux-next.orig/mm/readahead.c	2011-11-20 10:48:57.000000000 +0800
+++ linux-next/mm/readahead.c	2011-11-20 11:09:22.000000000 +0800
@@ -18,6 +18,25 @@
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
 
+static int __init config_readahead_size(char *str)
+{
+	unsigned long bytes;
+
+	if (!str)
+		return -EINVAL;
+	bytes = memparse(str, &str);
+	if (*str != '\0')
+		return -EINVAL;
+
+	/* missed 'k'/'m' suffixes? */
+	if (bytes && bytes < PAGE_CACHE_SIZE)
+		return -EINVAL;
+
+	default_backing_dev_info.ra_pages = bytes / PAGE_CACHE_SIZE;
+	return 0;
+}
+early_param("readahead", config_readahead_size);
+
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
  * memset *ra to zero.


