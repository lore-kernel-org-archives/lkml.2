Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab0JOUMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:12:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43313 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab0JOUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:12:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=PLU9KPVMxAA/wQzh2oqgFm+XHoOyFQzPssyq+86bXH3KwbU9igjDYHYQW8lpI+u15
	YGKiSVgNE4reqfP7VVenQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH 1/4] sched: do not consider SCHED_IDLE tasks to be cache hot
Date: Fri, 15 Oct 2010 13:12:27 -0700
Message-Id: <1287173550-30365-2-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287173550-30365-1-git-send-email-ncrao@google.com>
References: <1287173550-30365-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check in task_hot to return if the task has SCHED_IDLE
policy. SCHED_IDLE tasks have very low weight, and when run with regular
workloads, are typically scheduled many milliseconds apart. There is no
need to consider these tasks hot for load balancing.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dc85ceb..9e01848 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2003,6 +2003,9 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
+	if (unlikely(p->policy == SCHED_IDLE))
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-- 
1.7.1

