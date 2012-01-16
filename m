Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2APQv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:51:59 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53925 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab2APQv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:51:58 -0500
MIME-Version: 1.0
In-Reply-To: <20120116083615.GB23622@elte.hu>
References: <1326389222.9115.2.camel@localhost.localdomain>
	<20120116075639.GG15641@elte.hu>
	<CADZ9YHjxuqJ2YpEonqXjRsJZGsihy7ao_cA-NRwXoOM1KF3Tpw@mail.gmail.com>
	<20120116083615.GB23622@elte.hu>
Date: Mon, 16 Jan 2012 22:51:57 +0600
Message-ID: <CADZ9YHh9rnTom8dRk5PBdY0Qu6WQVNpUr2jJDeyqg7fxTiu1gg@mail.gmail.com>
Subject: Re: [PATCH] sched: Update scheduler stat documentation.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 2:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>
> Yes - but we should also change it to export a value of zero.
> The field is a legacy 'array expirations' field, and as such it
> should be zero.
>

Ok, thanks for suggestions. Please, look at the following patch, it's
been roughly created to address your suggestion. If it looks okay,
then I can send formal patch (perhaps two separate patches?). In this
way, I think we can also remove rq->sched_switch field (not done in
this patch)?

diff --git a/Documentation/scheduler/sched-stats.txt
b/Documentation/scheduler/sched-stats.txt
index 1cd5d51..cc2d107 100644
--- a/Documentation/scheduler/sched-stats.txt
+++ b/Documentation/scheduler/sched-stats.txt
@@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
      1) # of times sched_yield() was called

 Next three are schedule() statistics:
-     2) # of times we switched to the expired queue and reused it
+     2) This field is a legacy array expiration field used in O(1) scheduler.
+	But still kept for ABI integrity.
      3) # of times schedule() was called
      4) # of times schedule() left the processor idle

diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index 2a581ba..01a52d9 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -25,6 +25,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 	seq_printf(seq, "timestamp %lu\n", jiffies);
 	for_each_online_cpu(cpu) {
 		struct rq *rq = cpu_rq(cpu);
+		int rq_sched_switch = 0;
 #ifdef CONFIG_SMP
 		struct sched_domain *sd;
 		int dcount = 0;
@@ -34,7 +35,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		seq_printf(seq,
 		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
 		    cpu, rq->yld_count,
-		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
+		    rq_sched_switch, rq->sched_count, rq->sched_goidle,
 		    rq->ttwu_count, rq->ttwu_local,
 		    rq->rq_cpu_time,
 		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
