Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0KLMMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 07:12:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab0KLMM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 07:12:29 -0500
Subject: dlm: Use cmwq for send and receive workqueues
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        David Teigland <teigland@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 12 Nov 2010 12:12:29 +0000
Message-ID: <1289563949.2419.13.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So far as I can tell, there is no reason to use a single-threaded
send workqueue for dlm, since it may need to send to several sockets
concurrently. Both workqueues are set to WQ_MEM_RECLAIM to avoid
any possible deadlocks, WQ_HIGHPRI since locking traffic is highly
latency sensitive (and to avoid a priority inversion wrt GFS2's
glock_workqueue) and WQ_FREEZABLE just in case someone needs to do
that (even though with current cluster infrastructure, it doesn't
make sense as the node will most likely land up ejected from the
cluster) in the future.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Tejun Heo <tj@kernel.org>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 37a34c2..0893b30 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1431,14 +1431,16 @@ static void work_stop(void)
 static int work_start(void)
 {
 	int error;
-	recv_workqueue = create_workqueue("dlm_recv");
+	recv_workqueue = alloc_workqueue("dlm_recv", WQ_MEM_RECLAIM |
+					 WQ_HIGHPRI | WQ_FREEZEABLE, 0);
 	error = IS_ERR(recv_workqueue);
 	if (error) {
 		log_print("can't start dlm_recv %d", error);
 		return error;
 	}
 
-	send_workqueue = create_singlethread_workqueue("dlm_send");
+	send_workqueue = alloc_workqueue("dlm_send", WQ_MEM_RECLAIM |
+					 WQ_HIGHPRI | WQ_FREEZEABLE, 0);
 	error = IS_ERR(send_workqueue);
 	if (error) {
 		log_print("can't start dlm_send %d", error);



