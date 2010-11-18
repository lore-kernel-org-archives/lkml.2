Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab0KRQHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:07:37 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:37452 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab0KRQHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:07:33 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>, Tejun Heo <tj@kernel.org>
Subject: [PATCHv4 03/17] pps: fix race in PPS_FETCH handler
Date: Thu, 18 Nov 2010 19:00:56 +0300
Message-Id: <0e122d13ced47e31cce9e973d8efd85589203a94.1290087476.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a race in PPS_FETCH ioctl handler when several processes want
to obtain PPS data simultaneously using sleeping PPS_FETCH. They all
sleep most of the time in the system call.
With the old approach when the first process waiting on the pps queue
is waken up it makes new system call right away and zeroes pps->go. So
other processes continue to sleep. This is a clear race condition
because of the global 'go' variable.
With the new approach pps->last_ev holds some value increasing at each
PPS event. PPS_FETCH ioctl handler saves current value to the local
variable at the very beginning so it can safely check that there is a
new event by just comparing both variables.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/kapi.c         |    4 ++--
 drivers/pps/pps.c          |   10 +++++++---
 include/linux/pps_kernel.h |    2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 55f3961..3f89f5eb 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -326,8 +326,8 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 
 	/* Wake up if captured something */
 	if (captured) {
-		pps->go = ~0;
-		wake_up_interruptible(&pps->queue);
+		pps->last_ev++;
+		wake_up_interruptible_all(&pps->queue);
 
 		kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
 	}
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index c76afb9..dc7e66c 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -136,6 +136,7 @@ static long pps_cdev_ioctl(struct file *file,
 
 	case PPS_FETCH: {
 		struct pps_fdata fdata;
+		unsigned int ev;
 
 		pr_debug("PPS_FETCH: source %d\n", pps->id);
 
@@ -143,11 +144,12 @@ static long pps_cdev_ioctl(struct file *file,
 		if (err)
 			return -EFAULT;
 
-		pps->go = 0;
+		ev = pps->last_ev;
 
 		/* Manage the timeout */
 		if (fdata.timeout.flags & PPS_TIME_INVALID)
-			err = wait_event_interruptible(pps->queue, pps->go);
+			err = wait_event_interruptible(pps->queue,
+					ev != pps->last_ev);
 		else {
 			unsigned long ticks;
 
@@ -159,7 +161,9 @@ static long pps_cdev_ioctl(struct file *file,
 
 			if (ticks != 0) {
 				err = wait_event_interruptible_timeout(
-						pps->queue, pps->go, ticks);
+						pps->queue,
+						ev != pps->last_ev,
+						ticks);
 				if (err == 0)
 					return -ETIMEDOUT;
 			}
diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index c930d11..c3aed4b 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -55,7 +55,7 @@ struct pps_device {
 	struct pps_ktime clear_tu;
 	int current_mode;			/* PPS mode at event time */
 
-	int go;					/* PPS event is arrived? */
+	unsigned int last_ev;			/* last PPS event id */
 	wait_queue_head_t queue;		/* PPS event queue */
 
 	unsigned int id;			/* PPS source unique ID */
-- 
1.7.2.3

