Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1HCX1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:27:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab1HCX1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:27:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:48 2011
Message-Id: <20110803221248.401757363@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <JBottomley@Parallels.com>
Subject: [044/102] [SCSI] fix crash in scsi_dispatch_cmd()
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit bfe159a51203c15d23cb3158fffdc25ec4b4dda1 upstream.

USB surprise removal of sr is triggering an oops in
scsi_dispatch_command().  What seems to be happening is that USB is
hanging on to a queue reference until the last close of the upper
device, so the crash is caused by surprise remove of a mounted CD
followed by attempted unmount.

The problem is that USB doesn't issue its final commands as part of
the SCSI teardown path, but on last close when the block queue is long
gone.  The long term fix is probably to make sr do the teardown in the
same way as sd (so remove all the lower bits on ejection, but keep the
upper disk alive until last close of user space).  However, the
current oops can be simply fixed by not allowing any commands to be
sent to a dead queue.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-core.c        |    3 +++
 block/blk-exec.c        |    7 +++++++
 drivers/scsi/scsi_lib.c |    2 ++
 3 files changed, 12 insertions(+)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -839,6 +839,9 @@ struct request *blk_get_request(struct r
 {
 	struct request *rq;
 
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		return NULL;
+
 	BUG_ON(rw != READ && rw != WRITE);
 
 	spin_lock_irq(q->queue_lock);
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -50,6 +50,13 @@ void blk_execute_rq_nowait(struct reques
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
+		rq->errors = -ENXIO;
+		if (rq->end_io)
+			rq->end_io(rq, rq->errors);
+		return;
+	}
+
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
 	WARN_ON(irqs_disabled());
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -213,6 +213,8 @@ int scsi_execute(struct scsi_device *sde
 	int ret = DRIVER_ERROR << 24;
 
 	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
+	if (!req)
+		return ret;
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
 					buffer, bufflen, __GFP_WAIT))


