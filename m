Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab1EDIVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:21:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:28701 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab1EDIVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:21:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="917770627"
Message-Id: <20110504082115.093981766@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 May 2011 16:17:26 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jaxboe@fusionio.com, htejun@gmail.com, jgarzik@pobox.com,
        hch@infradead.org, djwong@us.ibm.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 1/3] block: add a non-queueable flush flag
References: <20110504081725.946950281@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=blk-nonqueueable-flush-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush request isn't queueable in some drives. Add a flag to let driver
notify block layer about this. We can optimize flush performance with the
knowledge.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/blkdev.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2011-05-04 14:23:42.000000000 +0800
+++ linux/include/linux/blkdev.h	2011-05-04 14:24:40.000000000 +0800
@@ -364,6 +364,7 @@ struct request_queue
 	 * for flush operations
 	 */
 	unsigned int		flush_flags;
+	unsigned int		flush_not_queueable:1;
 	unsigned int		flush_pending_idx:1;
 	unsigned int		flush_running_idx:1;
 	unsigned long		flush_pending_since;
@@ -549,6 +550,16 @@ static inline void blk_clear_queue_full(
 		queue_flag_clear(QUEUE_FLAG_ASYNCFULL, q);
 }
 
+static inline void blk_set_queue_flush_queueable(struct request_queue *q,
+		bool queueable)
+{
+	q->flush_not_queueable = !queueable;
+}
+
+static inline bool blk_queue_flush_queueable(struct request_queue *q)
+{
+	return !q->flush_not_queueable;
+}
 
 /*
  * mergeable request must not have _NOMERGE or _BARRIER bit set, nor may

