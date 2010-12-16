Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0LPDfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 22:35:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8943 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0LPDfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 22:35:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:newsgroups:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aAb6ZOWw/X0A9hTVv2jeARjdu1U/B9IO4gwwqSZ9b8PUf48PqdevEWF5faMc9yj+Dp
         2Sli6EcIttio++osD/KA==
Message-ID: <4D0988E9.2000808@google.com>
Date: Wed, 15 Dec 2010 19:35:05 -0800
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/2] sched: charge unaccounted run-time on entity re-weight
References: <20101216031016.186364650@google.com> <20101216031038.159704378@google.com>
In-Reply-To: <20101216031038.159704378@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hum -- forgot to refresh mbx file, slightly cleaner version (we can 
still charge unaccounted time against our queuing cfs_rq).

- Paul

-----

sched: move periodic share updates to entity_tick()

Long running entities that do not block (dequeue) require periodic 
updates to
maintain accurate share values.  (Note: group entities with several 
threads are
quite likely to be non-blocking in many circumstances).

By virtue of being long-running however, we will see entity ticks 
(otherwise
the required update occurs in dequeue/put and we are done).  Thus we can 
move
the detection (and associated work) for these updates into the periodic 
path.

This restores the 'atomicity' of update_curr() with respect to accounting.

Signed-off-by: Paul Turner <pjt@google.com>

---
  kernel/sched_fair.c |   21 +++++++++++++++++----
  1 file changed, 17 insertions(+), 4 deletions(-)

Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -564,11 +564,8 @@ __update_curr(struct cfs_rq *cfs_rq, str

  #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
  	cfs_rq->load_unacc_exec_time += delta_exec;
-	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
-		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
-	}
  #endif
  }

  static void update_curr(struct cfs_rq *cfs_rq)
@@ -809,6 +806,15 @@ static void update_cfs_shares(struct cfs

  	reweight_entity(cfs_rq_of(se), se, shares);
  }
+
+static void update_cfs_rq_shares_tick(struct cfs_rq *cfs_rq)
+{
+	/* rate limit updates by the averaging window */
+	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
+		update_cfs_load(cfs_rq, 0);
+		update_cfs_shares(cfs_rq, 0);
+	}
+}
  #else /* CONFIG_FAIR_GROUP_SCHED */
  static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
  {
@@ -1133,6 +1139,13 @@ entity_tick(struct cfs_rq *cfs_rq, struc
  	 */
  	update_curr(cfs_rq);

+#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
+	/*
+	 * Update share accounting for long-running entities.
+	 */
+	update_cfs_rq_shares_tick(cfs_rq);
+#endif
+
  #ifdef CONFIG_SCHED_HRTICK
  	/*
  	 * queued ticks are scheduled to match the slice, so don't bother
