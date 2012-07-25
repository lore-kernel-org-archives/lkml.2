Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab2GYWiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:38:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16616 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2GYWh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:37:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 25 Jul 2012 15:37:57 -0700
From: Peter Boonstoppel <pboonstoppel@nvidia.com>
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Andy Walls <awalls@md.metrocast.net>,
        Diwakar Tundlam <dtundlam@nvidia.com>
Date: Wed, 25 Jul 2012 15:35:32 -0700
Subject: RE: [PATCH 1/1] kthread: disable preemption during complete()
Thread-Topic: [PATCH 1/1] kthread: disable preemption during complete()
Thread-Index: Ac1p+bUOczwzIWg+S7i0bgDJNacUQAAvBftg
Message-ID: <5FBF8E85CA34454794F0F7ECBA79798F379D36485E@HQMAIL04.nvidia.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D364859@HQMAIL04.nvidia.com>,<20120725000901.GA5304@google.com>
In-Reply-To: <20120725000901.GA5304@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a kthread is created it signals the requester using complete()
and enters TASK_UNINTERRUPTIBLE. However, since complete() wakes up
the requesting thread this can cause a preemption. The preemption will
not remove the task from the runqueue (for that schedule() has to be
invoked directly).

This is a problem if directly after kthread creation you try to do a
kthread_bind(), which will block in HZ steps until the thread is off
the runqueue.

This patch disables preemption during complete(), since we call
schedule() directly afterwards, so it will correctly enter
TASK_UNINTERRUPTIBLE. This speeds up kthread creation/binding during
cpu hotplug significantly.

Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
---
 kernel/kthread.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index b579af5..757d8dd 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/freezer.h>
+#include <linux/preempt.h>
 #include <trace/events/sched.h>
 
 static DEFINE_SPINLOCK(kthread_create_lock);
@@ -113,7 +114,17 @@ static int kthread(void *_create)
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
 	create->result = current;
+
+	/*
+	 * Disable preemption so we enter TASK_UNINTERRUPTIBLE after
+	 * complete() instead of possibly being preempted. This speeds
+	 * up clients that do a kthread_bind() directly after
+	 * creation.
+	 */
+	preempt_disable();
 	complete(&create->done);
+	preempt_enable_no_resched();
+
 	schedule();
 
 	ret = -EINTR;
-- 
1.7.0.4
