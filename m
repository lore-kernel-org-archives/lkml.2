Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab2I1Uxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:53:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43100 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423043Ab2I1Usa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:30 -0400
X-Sasl-enc: Us1Lf02p8CLvFjMuAvQ9nO1y91KLiumeeiQG+6uSkbym 1348865309
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [ 095/127] workqueue: UNBOUND -> REBIND morphing in rebind_workers() should be atomic
Date: Fri, 28 Sep 2012 13:34:28 -0700
Message-Id: <20120928203057.033915276@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 96e65306b81351b656835c15931d1d237b252f27 upstream.

The compiler may compile the following code into TWO write/modify
instructions.

	worker->flags &= ~WORKER_UNBOUND;
	worker->flags |= WORKER_REBIND;

so the other CPU may temporarily see worker->flags which doesn't have
either WORKER_UNBOUND or WORKER_REBIND set and perform local wakeup
prematurely.

Fix it by using single explicit assignment via ACCESS_ONCE().

Because idle workers have another WORKER_NOT_RUNNING flag, this bug
doesn't exist for them; however, update it to use the same pattern for
consistency.

tj: Applied the change to idle workers too and updated comments and
    patch description a bit.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3412,14 +3412,17 @@ static int __cpuinit trustee_thread(void
 
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
+		unsigned long worker_flags = worker->flags;
 
 		/*
 		 * Rebind_work may race with future cpu hotplug
 		 * operations.  Use a separate flag to mark that
-		 * rebinding is scheduled.
+		 * rebinding is scheduled.  The morphing should
+		 * be atomic.
 		 */
-		worker->flags |= WORKER_REBIND;
-		worker->flags &= ~WORKER_ROGUE;
+		worker_flags |= WORKER_REBIND;
+		worker_flags &= ~WORKER_ROGUE;
+		ACCESS_ONCE(worker->flags) = worker_flags;
 
 		/* queue rebind_work, wq doesn't matter, use the default one */
 		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,


