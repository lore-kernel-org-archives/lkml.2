Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2IMAVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:21:47 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59246 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab2ILXgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:36:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Sreekanth Reddy <sreekanth.reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 088/108] SCSI: mpt2sas: Fix for Driver oops, when loading driver with max_queue_depth command line option to a very small value
Date: Wed, 12 Sep 2012 16:29:26 -0700
Message-Id: <20120912232459.730393981@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2424,10 +2424,13 @@ _base_allocate_memory_pools(struct MPT2S
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
 
@@ -2502,7 +2505,7 @@ _base_allocate_memory_pools(struct MPT2S
 	/* set the scsi host can_queue depth
 	 * with some internal commands that could be outstanding
 	 */
-	ioc->shost->can_queue = ioc->scsiio_depth - (2);
+	ioc->shost->can_queue = ioc->scsiio_depth;
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsi host: "
 	    "can_queue depth (%d)\n", ioc->name, ioc->shost->can_queue));
 


