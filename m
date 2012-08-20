Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2HTD5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:57:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab2HTD5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:57:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joseph Glanville <joseph.glanville@orionvm.com.au>,
        David Dillow <dillowda@ornl.gov>, Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 16/16] IB/srp: Fix a race condition
Date: Sun, 19 Aug 2012 20:56:15 -0700
Message-Id: <20120820035459.932711819@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035457.653002510@linuxfoundation.org>
References: <20120820035457.653002510@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 220329916c72ee3d54ae7262b215a050f04a18fc upstream.

Avoid a crash caused by the scmnd->scsi_done(scmnd) call in
srp_process_rsp() being invoked with scsi_done == NULL.  This can
happen if a reply is received during or after a command abort.

Reported-by: Joseph Glanville <joseph.glanville@orionvm.com.au>
Reference: http://marc.info/?l=linux-rdma&m=134314367801595
Acked-by: David Dillow <dillowda@ornl.gov>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |   87 ++++++++++++++++++++++++++----------
 1 file changed, 63 insertions(+), 24 deletions(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -568,24 +568,62 @@ static void srp_unmap_data(struct scsi_c
 			scmnd->sc_data_direction);
 }
 
-static void srp_remove_req(struct srp_target_port *target,
-			   struct srp_request *req, s32 req_lim_delta)
+/**
+ * srp_claim_req - Take ownership of the scmnd associated with a request.
+ * @target: SRP target port.
+ * @req: SRP request.
+ * @scmnd: If NULL, take ownership of @req->scmnd. If not NULL, only take
+ *         ownership of @req->scmnd if it equals @scmnd.
+ *
+ * Return value:
+ * Either NULL or a pointer to the SCSI command the caller became owner of.
+ */
+static struct scsi_cmnd *srp_claim_req(struct srp_target_port *target,
+				       struct srp_request *req,
+				       struct scsi_cmnd *scmnd)
 {
 	unsigned long flags;
 
-	srp_unmap_data(req->scmnd, target, req);
+	spin_lock_irqsave(&target->lock, flags);
+	if (!scmnd) {
+		scmnd = req->scmnd;
+		req->scmnd = NULL;
+	} else if (req->scmnd == scmnd) {
+		req->scmnd = NULL;
+	} else {
+		scmnd = NULL;
+	}
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	return scmnd;
+}
+
+/**
+ * srp_free_req() - Unmap data and add request to the free request list.
+ */
+static void srp_free_req(struct srp_target_port *target,
+			 struct srp_request *req, struct scsi_cmnd *scmnd,
+			 s32 req_lim_delta)
+{
+	unsigned long flags;
+
+	srp_unmap_data(scmnd, target, req);
+
 	spin_lock_irqsave(&target->lock, flags);
 	target->req_lim += req_lim_delta;
-	req->scmnd = NULL;
 	list_add_tail(&req->list, &target->free_reqs);
 	spin_unlock_irqrestore(&target->lock, flags);
 }
 
 static void srp_reset_req(struct srp_target_port *target, struct srp_request *req)
 {
-	req->scmnd->result = DID_RESET << 16;
-	req->scmnd->scsi_done(req->scmnd);
-	srp_remove_req(target, req, 0);
+	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
+
+	if (scmnd) {
+		scmnd->result = DID_RESET << 16;
+		scmnd->scsi_done(scmnd);
+		srp_free_req(target, req, scmnd, 0);
+	}
 }
 
 static int srp_reconnect_target(struct srp_target_port *target)
@@ -1055,11 +1093,18 @@ static void srp_process_rsp(struct srp_t
 		complete(&target->tsk_mgmt_done);
 	} else {
 		req = &target->req_ring[rsp->tag];
-		scmnd = req->scmnd;
-		if (!scmnd)
+		scmnd = srp_claim_req(target, req, NULL);
+		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
 				     "Null scmnd for RSP w/tag %016llx\n",
 				     (unsigned long long) rsp->tag);
+
+			spin_lock_irqsave(&target->lock, flags);
+			target->req_lim += be32_to_cpu(rsp->req_lim_delta);
+			spin_unlock_irqrestore(&target->lock, flags);
+
+			return;
+		}
 		scmnd->result = rsp->status;
 
 		if (rsp->flags & SRP_RSP_FLAG_SNSVALID) {
@@ -1074,7 +1119,9 @@ static void srp_process_rsp(struct srp_t
 		else if (rsp->flags & (SRP_RSP_FLAG_DIOVER | SRP_RSP_FLAG_DIUNDER))
 			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
 
-		srp_remove_req(target, req, be32_to_cpu(rsp->req_lim_delta));
+		srp_free_req(target, req, scmnd,
+			     be32_to_cpu(rsp->req_lim_delta));
+
 		scmnd->host_scribble = NULL;
 		scmnd->scsi_done(scmnd);
 	}
@@ -1613,25 +1660,17 @@ static int srp_abort(struct scsi_cmnd *s
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
 	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
-	int ret = SUCCESS;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req || target->qp_in_error)
-		return FAILED;
-	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
-			      SRP_TSK_ABORT_TASK))
+	if (!req || target->qp_in_error || !srp_claim_req(target, req, scmnd))
 		return FAILED;
+	srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
+			  SRP_TSK_ABORT_TASK);
+	srp_free_req(target, req, scmnd, 0);
+	scmnd->result = DID_ABORT << 16;
 
-	if (req->scmnd) {
-		if (!target->tsk_mgmt_status) {
-			srp_remove_req(target, req, 0);
-			scmnd->result = DID_ABORT << 16;
-		} else
-			ret = FAILED;
-	}
-
-	return ret;
+	return SUCCESS;
 }
 
 static int srp_reset_device(struct scsi_cmnd *scmnd)


