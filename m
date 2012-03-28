Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab2C1Whk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:37:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:60396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875Ab2C1Whi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:37:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124519631"
Message-Id: <20120328131153.475460374@intel.com>
User-Agent: quilt/0.51-1
Date: Wed, 28 Mar 2012 20:13:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linux Memory Management List <linux-mm@kvack.org>
cc: Vivek Goyal <vgoyal@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
cc: Suresh Jayaraman <sjayaraman@suse.com>,
        Andrea Righi <andrea@betterlinux.com>
cc: Jeff Moyer <jmoyer@redhat.com>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] blk-cgroup: buffered write IO controller - bandwidth limit interface
References: <20120328121308.568545879@intel.com>
Content-Disposition: inline; filename=writeback-io-controller-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add blkio controller interface "throttle.buffered_write_bps".

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 block/blk-cgroup.c         |   21 +++++++++++++++++++++
 include/linux/blk-cgroup.h |    1 +
 2 files changed, 22 insertions(+)

--- linux-next.orig/block/blk-cgroup.c	2012-03-28 15:36:16.402093131 +0800
+++ linux-next/block/blk-cgroup.c	2012-03-28 15:36:44.974092545 +0800
@@ -1355,6 +1355,12 @@ static u64 blkiocg_file_read_u64 (struct
 			return (u64)blkcg->weight;
 		}
 		break;
+	case BLKIO_POLICY_THROTL:
+		switch (name) {
+		case BLKIO_THROTL_buffered_write_bps:
+			return (u64)blkcg->buffered_write_bps;
+		}
+		break;
 	default:
 		BUG();
 	}
@@ -1377,6 +1383,13 @@ blkiocg_file_write_u64(struct cgroup *cg
 			return blkio_weight_write(blkcg, val);
 		}
 		break;
+	case BLKIO_POLICY_THROTL:
+		switch (name) {
+		case BLKIO_THROTL_buffered_write_bps:
+			blkcg->buffered_write_bps = val;
+			return 0;
+		}
+		break;
 	default:
 		BUG();
 	}
@@ -1500,6 +1513,14 @@ struct cftype blkio_files[] = {
 				BLKIO_THROTL_io_serviced),
 		.read_map = blkiocg_file_read_map,
 	},
+	{
+		.name = "throttle.buffered_write_bps",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_buffered_write_bps),
+		.read_u64 = blkiocg_file_read_u64,
+		.write_u64 = blkiocg_file_write_u64,
+		.max_write_len = 256,
+	},
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
 #ifdef CONFIG_DEBUG_BLK_CGROUP
--- linux-next.orig/include/linux/blk-cgroup.h	2012-03-28 15:36:16.426093131 +0800
+++ linux-next/include/linux/blk-cgroup.h	2012-03-28 15:36:44.974092545 +0800
@@ -113,6 +113,7 @@ enum blkcg_file_name_throtl {
 	BLKIO_THROTL_write_iops_device,
 	BLKIO_THROTL_io_service_bytes,
 	BLKIO_THROTL_io_serviced,
+	BLKIO_THROTL_buffered_write_bps,
 };
 
 struct blkio_cgroup {


