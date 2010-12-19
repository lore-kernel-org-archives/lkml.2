Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab0LSNuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 08:50:06 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:4916 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756089Ab0LSNuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 08:50:04 -0500
Subject: [PATCH] kthread_worker: Initialize dynamically allocated spinlock
 properly for lockdep
From: Andy Walls <awalls@md.metrocast.net>
To: linux-kernel@vger.kernel.org
Cc: nicolas.mailhot@laposte.net, Tejun Heo <tj@kernel.org>,
        Jarod Wilson <jarod@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 07:49:35 -0500
Message-ID: <1292762975.2403.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-19_02:2010-12-18,2010-12-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1012190037
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_kthread_worker(), via KTHREAD_WORKER_INIT(), used an
initializer for static spin_lock objects, SPIN_LOCK_UNLOCKED, on
a dynamically allocated kthread_worker object's internal spinlock_t.
This causes lockdep to gripe:

	INFO: trying to register non-static key.
	the code is fine but needs lockdep annotation.
	turning off the locking correctness validator.

To keep lockdep happy, use spin_lock_init() for dynamically
allocated kthread_worker objects' internal spinlock_t.

Reported-by: Nicolas <nicolas.mailhot@laposte.net>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>

Cc: Tejun Heo <tj@kernel.org>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 685ea65..e65d0b1 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -83,7 +83,13 @@ struct kthread_work {
 
 static inline void init_kthread_worker(struct kthread_worker *worker)
 {
-	*worker = (struct kthread_worker)KTHREAD_WORKER_INIT(*worker);
+	/*
+	 * Lockdep complains if a dynamically allocated worker's spinlock_t
+	 * is initialzed using SPIN_LOCK_UNLOCKED.
+	 */
+	spin_lock_init(&worker->lock);
+	INIT_LIST_HEAD(&worker->work_list);
+	worker->task = NULL;
 }
 
 static inline void init_kthread_work(struct kthread_work *work,


