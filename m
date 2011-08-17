Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1HQJXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:23:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab1HQJXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:23:46 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        WANG Cong <amwang@redhat.com>,
        Paul Clements <Paul.Clements@steeleye.com>
Subject: [PATCH 3/5] nbd: replace printk KERN_ERR with dev_err()
Date: Wed, 17 Aug 2011 17:22:41 +0800
Message-Id: <1313572963-3440-3-git-send-email-amwang@redhat.com>
In-Reply-To: <1313572963-3440-1-git-send-email-amwang@redhat.com>
References: <1313572963-3440-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <amwang@redhat.com>


Signed-off-by: WANG Cong <amwang@redhat.com>
---
 drivers/block/nbd.c |   50 +++++++++++++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index da98360..1b8e09f 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -158,8 +158,9 @@ static int sock_xmit(struct nbd_device *lo, int send, void *buf, int size,
 	sigset_t blocked, oldset;
 
 	if (unlikely(!sock)) {
-		printk(KERN_ERR "%s: Attempted %s on closed socket in sock_xmit\n",
-		       lo->disk->disk_name, (send ? "send" : "recv"));
+		dev_err(disk_to_dev(lo->disk),
+			"Attempted %s on closed socket in sock_xmit\n",
+			(send ? "send" : "recv"));
 		return -EINVAL;
 	}
 
@@ -250,8 +251,8 @@ static int nbd_send_req(struct nbd_device *lo, struct request *req)
 	result = sock_xmit(lo, 1, &request, sizeof(request),
 			(nbd_cmd(req) == NBD_CMD_WRITE) ? MSG_MORE : 0);
 	if (result <= 0) {
-		printk(KERN_ERR "%s: Send control failed (result %d)\n",
-				lo->disk->disk_name, result);
+		dev_err(disk_to_dev(lo->disk),
+			"Send control failed (result %d)\n", result);
 		goto error_out;
 	}
 
@@ -270,8 +271,9 @@ static int nbd_send_req(struct nbd_device *lo, struct request *req)
 					lo->disk->disk_name, req, bvec->bv_len);
 			result = sock_send_bvec(lo, bvec, flags);
 			if (result <= 0) {
-				printk(KERN_ERR "%s: Send data failed (result %d)\n",
-						lo->disk->disk_name, result);
+				dev_err(disk_to_dev(lo->disk),
+					"Send data failed (result %d)\n",
+					result);
 				goto error_out;
 			}
 		}
@@ -328,14 +330,13 @@ static struct request *nbd_read_stat(struct nbd_device *lo)
 	reply.magic = 0;
 	result = sock_xmit(lo, 0, &reply, sizeof(reply), MSG_WAITALL);
 	if (result <= 0) {
-		printk(KERN_ERR "%s: Receive control failed (result %d)\n",
-				lo->disk->disk_name, result);
+		dev_err(disk_to_dev(lo->disk),
+			"Receive control failed (result %d)\n", result);
 		goto harderror;
 	}
 
 	if (ntohl(reply.magic) != NBD_REPLY_MAGIC) {
-		printk(KERN_ERR "%s: Wrong magic (0x%lx)\n",
-				lo->disk->disk_name,
+		dev_err(disk_to_dev(lo->disk), "Wrong magic (0x%lx)\n",
 				(unsigned long)ntohl(reply.magic));
 		result = -EPROTO;
 		goto harderror;
@@ -347,15 +348,15 @@ static struct request *nbd_read_stat(struct nbd_device *lo)
 		if (result != -ENOENT)
 			goto harderror;
 
-		printk(KERN_ERR "%s: Unexpected reply (%p)\n",
-				lo->disk->disk_name, reply.handle);
+		dev_err(disk_to_dev(lo->disk), "Unexpected reply (%p)\n",
+			reply.handle);
 		result = -EBADR;
 		goto harderror;
 	}
 
 	if (ntohl(reply.error)) {
-		printk(KERN_ERR "%s: Other side returned error (%d)\n",
-				lo->disk->disk_name, ntohl(reply.error));
+		dev_err(disk_to_dev(lo->disk), "Other side returned error (%d)\n",
+			ntohl(reply.error));
 		req->errors++;
 		return req;
 	}
@@ -369,8 +370,8 @@ static struct request *nbd_read_stat(struct nbd_device *lo)
 		rq_for_each_segment(bvec, req, iter) {
 			result = sock_recv_bvec(lo, bvec);
 			if (result <= 0) {
-				printk(KERN_ERR "%s: Receive data failed (result %d)\n",
-						lo->disk->disk_name, result);
+				dev_err(disk_to_dev(lo->disk), "Receive data failed (result %d)\n",
+					result);
 				req->errors++;
 				return req;
 			}
@@ -408,7 +409,7 @@ static int nbd_do_it(struct nbd_device *lo)
 	lo->pid = task_pid_nr(current);
 	ret = device_create_file(disk_to_dev(lo->disk), &pid_attr);
 	if (ret) {
-		printk(KERN_ERR "nbd: device_create_file failed!");
+		dev_err(disk_to_dev(lo->disk), "device_create_file failed!\n");
 		lo->pid = 0;
 		return ret;
 	}
@@ -457,8 +458,8 @@ static void nbd_handle_req(struct nbd_device *lo, struct request *req)
 	if (rq_data_dir(req) == WRITE) {
 		nbd_cmd(req) = NBD_CMD_WRITE;
 		if (lo->flags & NBD_READ_ONLY) {
-			printk(KERN_ERR "%s: Write on read-only\n",
-					lo->disk->disk_name);
+			dev_err(disk_to_dev(lo->disk),
+				"Write on read-only\n");
 			goto error_out;
 		}
 	}
@@ -468,16 +469,15 @@ static void nbd_handle_req(struct nbd_device *lo, struct request *req)
 	mutex_lock(&lo->tx_lock);
 	if (unlikely(!lo->sock)) {
 		mutex_unlock(&lo->tx_lock);
-		printk(KERN_ERR "%s: Attempted send on closed socket\n",
-		       lo->disk->disk_name);
+		dev_err(disk_to_dev(lo->disk),
+			"Attempted send on closed socket\n");
 		goto error_out;
 	}
 
 	lo->active_req = req;
 
 	if (nbd_send_req(lo, req) != 0) {
-		printk(KERN_ERR "%s: Request send failed\n",
-				lo->disk->disk_name);
+		dev_err(disk_to_dev(lo->disk), "Request send failed\n");
 		req->errors++;
 		nbd_end_request(req);
 	} else {
@@ -549,8 +549,8 @@ static void do_nbd_request(struct request_queue *q)
 		BUG_ON(lo->magic != LO_MAGIC);
 
 		if (unlikely(!lo->sock)) {
-			printk(KERN_ERR "%s: Attempted send on closed socket\n",
-				lo->disk->disk_name);
+			dev_err(disk_to_dev(lo->disk),
+				"Attempted send on closed socket\n");
 			req->errors++;
 			nbd_end_request(req);
 			spin_lock_irq(q->queue_lock);
-- 
1.7.4.4

