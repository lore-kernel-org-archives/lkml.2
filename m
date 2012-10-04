Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab2JDVwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:52:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934019Ab2JDVXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:23:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bart Van Assche <bvanassche@acm.org>, David Dillow <dillowda@ornl.gov>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 53/58] IB/srp: Fix use-after-free in srp_reset_req()
Date: Thu,  4 Oct 2012 14:20:00 -0700
Message-Id: <20121004210642.185391087@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 9b796d06d5d1b1e85ae2316a283ea11dd739ef96 upstream.

srp_free_req() uses the scsi_cmnd structure contents to unmap
buffers, so we must invoke srp_free_req() before we release
ownership of that structure.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Dillow <dillowda@ornl.gov>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -638,9 +638,9 @@ static void srp_reset_req(struct srp_tar
 	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
 
 	if (scmnd) {
+		srp_free_req(target, req, scmnd, 0);
 		scmnd->result = DID_RESET << 16;
 		scmnd->scsi_done(scmnd);
-		srp_free_req(target, req, scmnd, 0);
 	}
 }
 


