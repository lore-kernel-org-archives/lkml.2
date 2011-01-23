Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab1AWPDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:03:50 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:59098 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1AWPDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:03:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P4LI8XAv/aXLjELLTuTE5VotApSSIMIN7YD+tDSPBON0k/080lTANDO9YgB2Rjo1R1
         Pv5Ih032TRzjSSiylFb9NEVJolx666sNVjLObNfTG74WPG5+2hxMP4IYl3fIE4Klf4ev
         8ZeB6Q04QgqVlJNXhA2iZtihSRbQXCl31XBIk=
Date: Sun, 23 Jan 2011 23:03:41 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Witten <mfwitten@gmail.com>, linux-kernel@vger.kernel.org,
        Christian Kujau <christian@nerdbynature.de>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: fix autogroup nice tune on UP
Message-ID: <20110123150341.GA2643@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
 <alpine.DEB.2.01.1101230243370.7903@trent.utfs.org>
 <20110123145429.GA2523@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110123145429.GA2523@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And there is another issue on UP when FAIR_GROUP_SCHED
enabled.

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH] sched: fix autogroup nice tune on UP

When on UP with FAIR_GROUP_SCHED enabled, tune shares
only affect tg->shares, but is not reflected on
tg->se->load, the reason is update_cfs_shares()
do nothing on SMP.
So let sched_group_set_shares() update tg->se->load
directly for UP && FAIR_GROUP_SCHED.

This issue is found when enable autogroup, but also
exists on cgroup.cpu on UP.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3ec2c6c..b8ed459 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8483,8 +8483,8 @@ static DEFINE_MUTEX(shares_mutex);
 
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
-	int i;
-	unsigned long flags;
+	int uninitialized_var(i);
+	unsigned long uninitialized_var(flags);
 
 	/*
 	 * We can't change the weight of the root cgroup.
@@ -8502,6 +8502,7 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 		goto done;
 
 	tg->shares = shares;
+#ifdef CONFIG_SMP
 	for_each_possible_cpu(i) {
 		struct rq *rq = cpu_rq(i);
 		struct sched_entity *se;
@@ -8513,6 +8514,9 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 			update_cfs_shares(group_cfs_rq(se), 0);
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
+#else
+	update_load_set(&tg->se[0]->load, shares);
+#endif
 
 done:
 	mutex_unlock(&shares_mutex);
-- 
1.7.1

