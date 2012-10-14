Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2JNO66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:58:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46515 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932196Ab2JNOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:26 -0400
Message-Id: <20121014143545.152445165@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bart Van Assche <bvanassche@acm.org>, David Dillow <dillowda@ornl.gov>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 084/147] IB/srp: Fix use-after-free in srp_reset_req()
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 9b796d06d5d1b1e85ae2316a283ea11dd739ef96 upstream.

srp_free_req() uses the scsi_cmnd structure contents to unmap
buffers, so we must invoke srp_free_req() before we release
ownership of that structure.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Dillow <dillowda@ornl.gov>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1b5b0c7..ac66e6b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -638,9 +638,9 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
 
 	if (scmnd) {
+		srp_free_req(target, req, scmnd, 0);
 		scmnd->result = DID_RESET << 16;
 		scmnd->scsi_done(scmnd);
-		srp_free_req(target, req, scmnd, 0);
 	}
 }
 


