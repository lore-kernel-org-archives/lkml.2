Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab1AJIDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:03:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab1AJIDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:03:43 -0500
Date: Mon, 10 Jan 2011 10:03:21 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jes.Sorensen@redhat.com,
        stable@kernel.org
Subject: [PATCH] vhost: fix signed/unsigned comparison
Message-ID: <20110110080320.GA10846@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To detect that a sequence number is done, we are doing math on unsigned
integers so the result is unsigned too. Not what was intended for the <=
comparison. The result is user stuck forever in flush call.
Convert to int to fix this.

Further, get rid of ({}) to make code clearer.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

I've put this on my vhost.git tree.

 drivers/vhost/vhost.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 159c77a..522b8fc 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -98,22 +98,26 @@ void vhost_poll_stop(struct vhost_poll *poll)
 	remove_wait_queue(poll->wqh, &poll->wait);
 }
 
+static bool vhost_work_seq_done(struct vhost_dev *dev, struct vhost_work *work,
+				unsigned seq)
+{
+	int left;
+	spin_lock_irq(&dev->work_lock);
+	left = seq - work->done_seq;
+	spin_unlock_irq(&dev->work_lock);
+	return left <= 0;
+}
+
 static void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work)
 {
 	unsigned seq;
-	int left;
 	int flushing;
 
 	spin_lock_irq(&dev->work_lock);
 	seq = work->queue_seq;
 	work->flushing++;
 	spin_unlock_irq(&dev->work_lock);
-	wait_event(work->done, ({
-		   spin_lock_irq(&dev->work_lock);
-		   left = seq - work->done_seq <= 0;
-		   spin_unlock_irq(&dev->work_lock);
-		   left;
-	}));
+	wait_event(work->done, vhost_work_seq_done(dev, work, seq));
 	spin_lock_irq(&dev->work_lock);
 	flushing = --work->flushing;
 	spin_unlock_irq(&dev->work_lock);
-- 
1.7.3.2.91.g446ac
