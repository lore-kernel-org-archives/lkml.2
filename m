Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab0DVUn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:43:26 -0400
Received: from kroah.org ([198.145.64.141]:37289 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab0DVT1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:50 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:10 2010
Message-Id: <20100422190910.067855413@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [030/197] [SCSI] libiscsi: Fix recovery slowdown regression
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit 4ae0a6c15efcc37e94e3f30e3533bdec03c53126 upstream.

We could be failing/stopping a connection due to libiscsi starting
recovery/cleanup, but the xmit path or scsi eh thread path
could be dropping the connection at the same time.

As a result the session->state gets set to failed instead of in
recovery. We end up not blocking the session
and so the replacement timeout never gets started and we only end up
failing the IO when scsi_softirq_done sees that the
cmd has been running for (cmd->allowed + 1) * rq->timeout secs.

We used to fail the IO right away so users are seeing a long
delay when using dm-multipath. This problem was added in
2.6.28.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libiscsi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2823,14 +2823,15 @@ static void iscsi_start_session_recovery
 		session->state = ISCSI_STATE_TERMINATE;
 	else if (conn->stop_stage != STOP_CONN_RECOVER)
 		session->state = ISCSI_STATE_IN_RECOVERY;
+
+	old_stop_stage = conn->stop_stage;
+	conn->stop_stage = flag;
 	spin_unlock_bh(&session->lock);
 
 	del_timer_sync(&conn->transport_timer);
 	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->lock);
-	old_stop_stage = conn->stop_stage;
-	conn->stop_stage = flag;
 	conn->c_stage = ISCSI_CONN_STOPPED;
 	spin_unlock_bh(&session->lock);
 


