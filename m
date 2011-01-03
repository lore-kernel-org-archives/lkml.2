Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1ACNuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:50:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58971 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab1ACNun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dpeSIeIY2zVi7NjODrKauWAX37xD4aGUf8NRwCnN64d1nnSg4pMFpQZGdxFOBdhbd7
         3pC3REGC6oi8slsmMYosVUqYhw9R4+qFYQ9n4g5kzQHoQzmTUVd7bPgWy8yi7g34XqCn
         sPGw9/1eNO30ZWAn5KIEA1/UVZB9lRDKddspQ=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 24/32] dlm: dlm workqueues aren't used in memory reclaim path
Date: Mon,  3 Jan 2011 14:49:47 +0100
Message-Id: <1294062595-30097-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dlm isn't depended upon during memory reclaim and so are its two
workqueues.  Convert to alloc[_ordered]_workqueue() without
WQ_MEM_RECLAIM.  While at it, fix workqueue allocation failure
handling.  They return %NULL on failure not ERR_PTR() value.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 fs/dlm/lowcomms.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 37a34c2..9aad7c0 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1430,20 +1430,17 @@ static void work_stop(void)
 
 static int work_start(void)
 {
-	int error;
-	recv_workqueue = create_workqueue("dlm_recv");
-	error = IS_ERR(recv_workqueue);
-	if (error) {
-		log_print("can't start dlm_recv %d", error);
-		return error;
+	recv_workqueue = alloc_workqueue("dlm_recv", 0, 1);
+	if (!recv_workqueue) {
+		log_print("can't start dlm_recv");
+		return -ENOMEM;
 	}
 
-	send_workqueue = create_singlethread_workqueue("dlm_send");
-	error = IS_ERR(send_workqueue);
-	if (error) {
-		log_print("can't start dlm_send %d", error);
+	send_workqueue = alloc_ordered_workqueue("dlm_send", 0);
+	if (!send_workqueue) {
+		log_print("can't start dlm_send");
 		destroy_workqueue(recv_workqueue);
-		return error;
+		return -ENOMEM;
 	}
 
 	return 0;
-- 
1.7.1

