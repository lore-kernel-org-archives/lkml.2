Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab1FWS1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:27:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:63074 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab1FWRWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Kashyap, Desai" <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 034/247] mpt2sas: Correct resizing calculation for max_queue_depth
Date: Thu, 23 Jun 2011 13:17:57 -0400
Message-Id: <1308849690-14530-35-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kashyap, Desai <kashyap.desai@lsi.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 11e1b961ab067ee3acaf723531da4d3f23e1d6f7 upstream.

The ioc->hba_queue_depth is not properly resized when the controller
firmware reports that it supports more outstanding IO than what can be fit
inside the reply descriptor pool depth. This is reproduced by setting the
controller global credits larger than 30,000. The bug results in an
incorrect sizing of the queues. The fix is to resize the queue_size by
dividing queue_diff by two.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 88e6eeb..21ddd36 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2026,9 +2026,9 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
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
 
-- 
1.7.4.4

