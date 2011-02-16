Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab1BPAUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:20:07 -0500
Received: from kroah.org ([198.145.64.141]:39003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915Ab1BPAUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:32 2011
Message-Id: <20110216001432.736801517@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [076/272] [SCSI] mpt2sas: Correct resizing calculation for max_queue_depth
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2057,9 +2057,9 @@ _base_allocate_memory_pools(struct MPT2S
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
 


