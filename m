Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1K1WpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:45:21 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:32844 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab1K1WpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:45:16 -0500
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
Date: Mon, 28 Nov 2011 17:44:56 -0500
Subject: [PATCH 1/4] sched: add members to struct sched_info to save maximum
Thread-Topic: [PATCH 1/4] sched: add members to struct sched_info to save
 maximum
Thread-Index: AcyuHz1jOo2pA4gdSJ2m+oX/c0nTOAAAAQVQ
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB574E70F@USINDEVS02.corp.hds.com>
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

This patch adds members to struct sched_info and save max delays
into it.

Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>
---
 include/linux/sched.h |    2 ++
 kernel/sched_stats.h  |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c4f3e9..1665e2c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -736,6 +736,8 @@ struct sched_info {
 	/* cumulative counters */
 	unsigned long pcount;	      /* # of times run on this cpu */
 	unsigned long long run_delay; /* time spent waiting on a runqueue */
+	unsigned long long max_delay; /* max run_delay */
+	unsigned long long prev_cpu_delay; /* time spent waiting on prev cpus' runqueue */
 
 	/* timestamps */
 	unsigned long long last_arrival,/* when we last ran on a cpu */
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 87f9e36..48e9db9 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -171,6 +171,7 @@ static inline void sched_info_dequeued(struct task_struct *t)
 			delta = now - t->sched_info.last_queued;
 	sched_info_reset_dequeued(t);
 	t->sched_info.run_delay += delta;
+	t->sched_info.prev_cpu_delay += delta;
 
 	rq_sched_info_dequeued(task_rq(t), delta);
 }
@@ -190,6 +191,10 @@ static void sched_info_arrive(struct task_struct *t)
 	t->sched_info.run_delay += delta;
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;
+	t->sched_info.prev_cpu_delay += delta;
+	if (t->sched_info.max_delay < t->sched_info.prev_cpu_delay)
+		t->sched_info.max_delay = t->sched_info.prev_cpu_delay;
+	t->sched_info.prev_cpu_delay = 0;
 
 	rq_sched_info_arrive(task_rq(t), delta);
 }
-- 
1.7.6.4


