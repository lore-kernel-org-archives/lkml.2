Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1AQKw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:52:58 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37121 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1AQKwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:52:54 -0500
Message-ID: <4D341F81.1040602@linux.vnet.ibm.com>
Date: Mon, 17 Jan 2011 16:22:49 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: [PATCH 1/2 v1.0]sched: Removing unused fields from /proc/schedstat
References: <4D341ECD.3020503@linux.vnet.ibm.com>
In-Reply-To: <4D341ECD.3020503@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------080409010401080602060704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080409010401080602060704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch removes the unused statistics from /proc/schedstat. Also updates the request queue structure fields.

--------------080409010401080602060704
Content-Type: text/plain;
 name="patch1_v1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch1_v1.patch"

Signed-off-by: Ciju Rajan K <ciju@linux.vnet.ibm.com>
---

diff -Naurp a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h	2011-01-17 00:49:08.000000000 +0530
+++ b/include/linux/sched.h	2011-01-17 01:01:27.000000000 +0530
@@ -943,20 +943,9 @@ struct sched_domain {
 	unsigned int alb_failed;
 	unsigned int alb_pushed;
 
-	/* SD_BALANCE_EXEC stats */
-	unsigned int sbe_count;
-	unsigned int sbe_balanced;
-	unsigned int sbe_pushed;
-
-	/* SD_BALANCE_FORK stats */
-	unsigned int sbf_count;
-	unsigned int sbf_balanced;
-	unsigned int sbf_pushed;
-
 	/* try_to_wake_up() stats */
 	unsigned int ttwu_wake_remote;
 	unsigned int ttwu_move_affine;
-	unsigned int ttwu_move_balance;
 #endif
 #ifdef CONFIG_SCHED_DEBUG
 	char *name;
diff -Naurp a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c	2011-01-17 00:32:14.000000000 +0530
+++ b/kernel/sched.c	2011-01-17 00:38:24.000000000 +0530
@@ -545,7 +545,6 @@ struct rq {
 	unsigned int yld_count;
 
 	/* schedule() stats */
-	unsigned int sched_switch;
 	unsigned int sched_count;
 	unsigned int sched_goidle;
 
diff -Naurp a/kernel/sched_debug.c b/kernel/sched_debug.c
--- a/kernel/sched_debug.c	2011-01-17 00:31:36.000000000 +0530
+++ b/kernel/sched_debug.c	2011-01-17 00:36:52.000000000 +0530
@@ -286,7 +286,6 @@ static void print_cpu(struct seq_file *m
 
 	P(yld_count);
 
-	P(sched_switch);
 	P(sched_count);
 	P(sched_goidle);
 #ifdef CONFIG_SMP
diff -Naurp a/kernel/sched_stats.h b/kernel/sched_stats.h
--- a/kernel/sched_stats.h	2011-01-17 00:31:56.000000000 +0530
+++ b/kernel/sched_stats.h	2011-01-17 11:49:50.000000000 +0530
@@ -4,7 +4,7 @@
  * bump this up when changing the output format or the meaning of an existing
  * format, so that tools can adapt (or abort)
  */
-#define SCHEDSTAT_VERSION 15
+#define SCHEDSTAT_VERSION 16
 
 static int show_schedstat(struct seq_file *seq, void *v)
 {
@@ -26,9 +26,9 @@ static int show_schedstat(struct seq_fil
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
-		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
+		    "cpu%d %u %u %u %u %u %llu %llu %lu",
 		    cpu, rq->yld_count,
-		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
+		    rq->sched_count, rq->sched_goidle,
 		    rq->ttwu_count, rq->ttwu_local,
 		    rq->rq_cpu_time,
 		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
@@ -57,12 +57,9 @@ static int show_schedstat(struct seq_fil
 				    sd->lb_nobusyg[itype]);
 			}
 			seq_printf(seq,
-				   " %u %u %u %u %u %u %u %u %u %u %u %u\n",
+				   " %u %u %u %u %u\n",
 			    sd->alb_count, sd->alb_failed, sd->alb_pushed,
-			    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
-			    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
-			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
-			    sd->ttwu_move_balance);
+			    sd->ttwu_wake_remote, sd->ttwu_move_affine);
 		}
 		preempt_enable();
 #endif

--------------080409010401080602060704--
