Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1K1Wqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:46:38 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:33085 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab1K1Wqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:46:36 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "nagar@watson.ibm.com" <nagar@watson.ibm.com>,
        "kobayashi.kk@ncos.nec.co.jp" <kobayashi.kk@ncos.nec.co.jp>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Mon, 28 Nov 2011 17:46:18 -0500
Subject: [PATCH 3/4] delayacct: update taskstats to save max delays
Thread-Topic: [PATCH 3/4] delayacct: update taskstats to save max delays
Thread-Index: AcyuHz1jOo2pA4gdSJ2m+oX/c0nTOAAAD0+Q
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB574E714@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB574E70D@USINDEVS02.corp.hds.com>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB574E70D@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1111280247
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds memberes to struct taskstats to save maximum
CPU/IO/SWAP/RECLAIM delays and saves them in __delayacct_and_tsk().

Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>
---
 Documentation/accounting/taskstats-struct.txt |    9 +++++++++
 include/linux/taskstats.h                     |    8 +++++++-
 kernel/delayacct.c                            |   12 +++++++++++-
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/Documentation/accounting/taskstats-struct.txt b/Documentation/accounting/taskstats-struct.txt
index e7512c0..f7c0fa6 100644
--- a/Documentation/accounting/taskstats-struct.txt
+++ b/Documentation/accounting/taskstats-struct.txt
@@ -28,6 +28,8 @@ There are three different groups of fields in the struct taskstats:
 
 6) Extended delay accounting fields for memory reclaim
 
+7) Extended delay accounting fields for maximum delay
+
 Future extension should add fields to the end of the taskstats struct, and
 should not change the relative position of each field within the struct.
 
@@ -177,4 +179,11 @@ struct taskstats {
 	/* Delay waiting for memory reclaim */
 	__u64	freepages_count;
 	__u64	freepages_delay_total;
+
+7) Extended delay accounting fields for maximum delay
+        /* Max value for each delay */
+        __u64   cpu_delay_max;
+        __u64   blkio_delay_max;
+        __u64   swapin_delay_max;
+        __u64   freepages_delay_max;
 }
diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 2466e55..1a775fb 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -33,7 +33,7 @@
  */
 
 
-#define TASKSTATS_VERSION	8
+#define TASKSTATS_VERSION	9
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -163,6 +163,12 @@ struct taskstats {
 	/* Delay waiting for memory reclaim */
 	__u64	freepages_count;
 	__u64	freepages_delay_total;
+
+	/* Max value for each delay */
+	__u64   cpu_delay_max;
+	__u64   blkio_delay_max;
+	__u64   swapin_delay_max;
+	__u64   freepages_delay_max;
 };
 
 
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 33d090b..ad0fdb5 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -107,7 +107,7 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 {
 	s64 tmp;
 	unsigned long t1;
-	unsigned long long t2, t3;
+	unsigned long long t2, t3, t4;
 	unsigned long flags;
 	struct timespec ts;
 
@@ -135,6 +135,7 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	t1 = tsk->sched_info.pcount;
 	t2 = tsk->sched_info.run_delay;
 	t3 = tsk->se.sum_exec_runtime;
+	t4 = tsk->sched_info.max_delay;
 
 	d->cpu_count += t1;
 
@@ -145,6 +146,9 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	d->cpu_run_virtual_total =
 		(tmp < (s64)d->cpu_run_virtual_total) ?	0 : tmp;
 
+	if (d->cpu_delay_max < t4)
+		d->cpu_delay_max = t4;
+
 	/* zero XXX_total, non-zero XXX_count implies XXX stat overflowed */
 
 	spin_lock_irqsave(&tsk->delays->lock, flags);
@@ -157,6 +161,12 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	d->blkio_count += tsk->delays->blkio_count;
 	d->swapin_count += tsk->delays->swapin_count;
 	d->freepages_count += tsk->delays->freepages_count;
+	if (d->blkio_delay_max < tsk->delays->blkio_delay_max)
+		d->blkio_delay_max = tsk->delays->blkio_delay_max;
+	if (d->swapin_delay_max < tsk->delays->swapin_delay_max)
+		d->swapin_delay_max = tsk->delays->swapin_delay_max;
+	if (d->freepages_delay_max < tsk->delays->freepages_delay_max)
+		d->freepages_delay_max = tsk->delays->freepages_delay_max;
 	spin_unlock_irqrestore(&tsk->delays->lock, flags);
 
 done:
-- 
1.7.6.4


