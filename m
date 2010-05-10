Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab0EJW6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:58:16 -0400
Received: from kroah.org ([198.145.64.141]:51574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365Ab0EJW5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:22 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:34 2010
Message-Id: <20100510223534.889748823@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [05/98] libata: fix locking around blk_abort_request()
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit fa41efdae7de61191a7bda3a00e88ef69afb5bb9 upstream.

blk_abort_request() expectes queue lock to be held by the caller.
Grab it before calling the function.

Lack of this synchronization led to infinite loop on corrupt
q->timeout_list.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -870,6 +870,8 @@ static void ata_eh_set_pending(struct at
 void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
+	struct request_queue *q = qc->scsicmd->device->request_queue;
+	unsigned long flags;
 
 	WARN_ON(!ap->ops->error_handler);
 
@@ -881,7 +883,9 @@ void ata_qc_schedule_eh(struct ata_queue
 	 * Note that ATA_QCFLAG_FAILED is unconditionally set after
 	 * this function completes.
 	 */
+	spin_lock_irqsave(q->queue_lock, flags);
 	blk_abort_request(qc->scsicmd->request);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
 /**


