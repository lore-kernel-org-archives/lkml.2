Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1AKIwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:52:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:50825 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab1AKIv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:51:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,306,1291622400"; 
   d="scan'208";a="372786979"
Subject: [PATCH 1/2]block cfq:  make queue preempt work for queues from
 different workload
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 16:51:56 +0800
Message-ID: <1294735916.1949.637.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this:
             fio-874   [007]  2157.724514:   8,32   m   N cfq874 preempt
             fio-874   [007]  2157.724519:   8,32   m   N cfq830 slice expired t=1
             fio-874   [007]  2157.724520:   8,32   m   N cfq830 sl_used=1 disp=0 charge=1 iops=0 sect=0
             fio-874   [007]  2157.724521:   8,32   m   N cfq830 set_active wl_prio:0 wl_type:0
             fio-874   [007]  2157.724522:   8,32   m   N cfq830 Not idling. st->count:1
cfq830 is an async queue, and preempted by a sync queue cfq874. But since we
have cfqg->saved_workload_slice mechanism, the preempt is a nop.
Looks currently our preempt is totally broken if the two queues are not from
the same workload type.
Below patch fixes it. This will might make async queue starvation, but it's
what our old code does before cgroup is added.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-01-11 16:24:56.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-01-11 16:41:49.000000000 +0800
@@ -3284,10 +3284,19 @@ cfq_should_preempt(struct cfq_data *cfqd
  */
 static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
+	struct cfq_queue *old_cfqq = cfqd->active_queue;
+
 	cfq_log_cfqq(cfqd, cfqq, "preempt");
 	cfq_slice_expired(cfqd, 1);
 
 	/*
+	 * workload type is changed, don't save slice, otherwise preempt
+	 * doesn't happen
+	 */
+	if (cfqq_type(old_cfqq) != cfqq_type(cfqq))
+		cfqq->cfqg->saved_workload_slice = 0;
+
+	/*
 	 * Put the new queue at the front of the of the current list,
 	 * so we know that it will be selected next.
 	 */


