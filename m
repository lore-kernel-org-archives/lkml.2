Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab1C3VH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:60385 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933432Ab1C3VHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447528"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: venki@google.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [100/275] sched: Add a PF flag for ksoftirqd identification
Message-Id: <20110330210538.E7F8D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: 6cdd5199daf0cb7b0fcc8dca941af08492612887 upstream

To account softirq time cleanly in scheduler, we need to identify whether
softirq is invoked in ksoftirqd context or softirq at hardirq tail context.
Add PF_KSOFTIRQD for that purpose.

As all PF flag bits are currently taken, create space by moving one of the
infrequently used bits (PF_THREAD_BOUND) down in task_struct to be along
with some other state fields.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1286237003-12406-4-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h |    1 +
 kernel/softirq.c      |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6.35.y/include/linux/sched.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/sched.h	2011-03-29 23:03:00.229294303 -0700
+++ linux-2.6.35.y/include/linux/sched.h	2011-03-29 23:55:00.771447437 -0700
@@ -1685,6 +1685,7 @@
 /*
  * Per process flags
  */
+#define PF_KSOFTIRQD	0x00000001	/* I am ksoftirqd */
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
Index: linux-2.6.35.y/kernel/softirq.c
===================================================================
--- linux-2.6.35.y.orig/kernel/softirq.c	2011-03-29 23:03:00.152296274 -0700
+++ linux-2.6.35.y/kernel/softirq.c	2011-03-29 23:54:58.951494004 -0700
@@ -713,6 +713,7 @@
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
+	current->flags |= PF_KSOFTIRQD;
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
