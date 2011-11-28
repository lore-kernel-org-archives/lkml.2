Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab1K1WqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:46:12 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:56610 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab1K1WqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:46:10 -0500
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
Date: Mon, 28 Nov 2011 17:45:45 -0500
Subject: [PATCH 2/4] delayacct: add members to struct task_delay_info to
 save max delays
Thread-Topic: [PATCH 2/4] delayacct: add members to struct task_delay_info
 to save max delays
Thread-Index: AcyuHz1jOo2pA4gdSJ2m+oX/c0nTOAAAB+cQ
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB574E712@USINDEVS02.corp.hds.com>
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

This patch adds members to struct task_delay_info and a parameter to
delayacct_end() and saves maximum values for IO/SWAP/RECLAIM delays.

Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>
---
 include/linux/sched.h |    3 +++
 kernel/delayacct.c    |   13 +++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1665e2c..edd8ad2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -768,6 +768,8 @@ struct task_delay_info {
 	struct timespec blkio_start, blkio_end;	/* Shared by blkio, swapin */
 	u64 blkio_delay;	/* wait for sync block io completion */
 	u64 swapin_delay;	/* wait for swapin block io completion */
+	u64 blkio_delay_max;    /* max wait for sync block io completion */
+	u64 swapin_delay_max;   /* max wait for swapin block io completion */
 	u32 blkio_count;	/* total count of the number of sync block */
 				/* io operations performed */
 	u32 swapin_count;	/* total count of the number of swapin block */
@@ -775,6 +777,7 @@ struct task_delay_info {
 
 	struct timespec freepages_start, freepages_end;
 	u64 freepages_delay;	/* wait for memory reclaim */
+	u64 freepages_delay_max;/* max wait for memory reclaim */
 	u32 freepages_count;	/* total count of memory reclaim */
 };
 #endif	/* CONFIG_TASK_DELAY_ACCT */
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 418b3f7..33d090b 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -61,7 +61,7 @@ static inline void delayacct_start(struct timespec *start)
  */
 
 static void delayacct_end(struct timespec *start, struct timespec *end,
-				u64 *total, u32 *count)
+				u64 *total, u32 *count, u64 *max)
 {
 	struct timespec ts;
 	s64 ns;
@@ -76,6 +76,8 @@ static void delayacct_end(struct timespec *start, struct timespec *end,
 	spin_lock_irqsave(&current->delays->lock, flags);
 	*total += ns;
 	(*count)++;
+	if (*max < ns)
+		*max = ns;
 	spin_unlock_irqrestore(&current->delays->lock, flags);
 }
 
@@ -91,12 +93,14 @@ void __delayacct_blkio_end(void)
 		delayacct_end(&current->delays->blkio_start,
 			&current->delays->blkio_end,
 			&current->delays->swapin_delay,
-			&current->delays->swapin_count);
+			&current->delays->swapin_count,
+			&current->delays->swapin_delay_max);
 	else	/* Other block I/O */
 		delayacct_end(&current->delays->blkio_start,
 			&current->delays->blkio_end,
 			&current->delays->blkio_delay,
-			&current->delays->blkio_count);
+			&current->delays->blkio_count,
+			&current->delays->blkio_delay_max);
 }
 
 int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
@@ -181,6 +185,7 @@ void __delayacct_freepages_end(void)
 	delayacct_end(&current->delays->freepages_start,
 			&current->delays->freepages_end,
 			&current->delays->freepages_delay,
-			&current->delays->freepages_count);
+			&current->delays->freepages_count,
+			&current->delays->freepages_delay_max);
 }
 
-- 
1.7.6.4


