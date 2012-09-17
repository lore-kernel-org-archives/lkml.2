Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab2IQAuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33317 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752924Ab2IQAtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:23 -0400
Message-Id: <20120917003627.321569181@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "sreekanth.reddy@lsi.com" <sreekanth.reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 008/135] [SCSI] mpt2sas: Fix for Driver oops, when loading driver with
 max_queue_depth command line option to a very small value
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "sreekanth.reddy@lsi.com" <sreekanth.reddy@lsi.com>

commit 338b131a3269881c7431234855c93c219b0979b6 upstream.

If the specified max_queue_depth setting is less than the
expected number of internal commands, then driver will calculate
the queue depth size to a negitive number. This negitive number
is actually a very large number because variable is unsigned
16bit integer. So, the driver will ask for a very large amount of
memory for message frames and resulting into oops as memory
allocation routines will not able to handle such a large request.

So, in order to limit this kind of oops, The driver need to set
the max_queue_depth to a scsi mid layer's can_queue value. Then
the overall message frames required for IO is minimum of either
(max_queue_depth plus internal commands) or the IOC global
credits.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 9d46fcb..b25757d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2424,10 +2424,13 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	}
 
 	/* command line tunables  for max controller queue depth */
-	if (max_queue_depth != -1)
-		max_request_credit = (max_queue_depth < facts->RequestCredit)
-		    ? max_queue_depth : facts->RequestCredit;
-	else
+	if (max_queue_depth != -1 && max_queue_depth != 0) {
+		max_request_credit = min_t(u16, max_queue_depth +
+			ioc->hi_priority_depth + ioc->internal_depth,
+			facts->RequestCredit);
+		if (max_request_credit > MAX_HBA_QUEUE_DEPTH)
+			max_request_credit =  MAX_HBA_QUEUE_DEPTH;
+	} else
 		max_request_credit = min_t(u16, facts->RequestCredit,
 		    MAX_HBA_QUEUE_DEPTH);
 
@@ -2502,7 +2505,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	/* set the scsi host can_queue depth
 	 * with some internal commands that could be outstanding
 	 */
-	ioc->shost->can_queue = ioc->scsiio_depth - (2);
+	ioc->shost->can_queue = ioc->scsiio_depth;
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsi host: "
 	    "can_queue depth (%d)\n", ioc->name, ioc->shost->can_queue));
 


