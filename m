Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab1C3WGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:06:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:41951 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933218Ab1C3VGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411276863"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: kashyap.desai@lsi.com, James.Bottomley@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [40/275] mpt2sas: Correct resizing calculation for max_queue_depth
Message-Id: <20110330210435.C918C3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 11e1b961ab067ee3acaf723531da4d3f23e1d6f7 upstream.

The ioc->hba_queue_depth is not properly resized when the controller
firmware reports that it supports more outstanding IO than what can be fit
inside the reply descriptor pool depth. This is reproduced by setting the
controller global credits larger than 30,000. The bug results in an
incorrect sizing of the queues. The fix is to resize the queue_size by
dividing queue_diff by two.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/scsi/mpt2sas/mpt2sas_base.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/mpt2sas/mpt2sas_base.c	2011-03-29 22:51:53.119363977 -0700
+++ linux-2.6.35.y/drivers/scsi/mpt2sas/mpt2sas_base.c	2011-03-29 23:55:24.206847783 -0700
@@ -2050,9 +2050,9 @@
 		/* adjust hba_queue_depth, reply_free_queue_depth,
 		 * and queue_size
 		 */
-		ioc->hba_queue_depth -= queue_diff;
-		ioc->reply_free_queue_depth -= queue_diff;
-		queue_size -= queue_diff;
+		ioc->hba_queue_depth -= (queue_diff / 2);
+		ioc->reply_free_queue_depth -= (queue_diff / 2);
+		queue_size = facts->MaxReplyDescriptorPostQueueDepth;
 	}
 	ioc->reply_post_queue_depth = queue_size;
 
