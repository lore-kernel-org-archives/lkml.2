Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1EFHks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:40:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:52865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab1EFHkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:40:47 -0400
Date: Fri, 6 May 2011 07:40:26 GMT
From: tip-bot for Hillf Danton <dhillf@gmail.com>
Message-ID: <tip-7142d17e8f935fa842e9f6eece2281b6d41625d6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        efault@gmx.de, peterz@infradead.org, dhillf@gmail.com,
        tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, efault@gmx.de, dhillf@gmail.com,
        tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Shorten the construction of the span cpu mask of sched domain
Git-Commit-ID: 7142d17e8f935fa842e9f6eece2281b6d41625d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 May 2011 07:40:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7142d17e8f935fa842e9f6eece2281b6d41625d6
Gitweb:     http://git.kernel.org/tip/7142d17e8f935fa842e9f6eece2281b6d41625d6
Author:     Hillf Danton <dhillf@gmail.com>
AuthorDate: Thu, 5 May 2011 20:53:20 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 May 2011 09:13:05 +0200

sched: Shorten the construction of the span cpu mask of sched domain

For a given node, when constructing the cpumask for its
sched_domain to span, if there is no best node available after
searching, further efforts could be saved, based on small change
in the return value of find_next_best_node().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Link: http://lkml.kernel.org/r/BANLkTi%3DqPWxRAa6%2BdT3ohEP6Z%3D0v%2Be4EXA@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3d8a1b2..da93381 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6807,7 +6807,7 @@ __setup("isolcpus=", isolated_cpu_setup);
  */
 static int find_next_best_node(int node, nodemask_t *used_nodes)
 {
-	int i, n, val, min_val, best_node = 0;
+	int i, n, val, min_val, best_node = -1;
 
 	min_val = INT_MAX;
 
@@ -6831,7 +6831,8 @@ static int find_next_best_node(int node, nodemask_t *used_nodes)
 		}
 	}
 
-	node_set(best_node, *used_nodes);
+	if (best_node != -1)
+		node_set(best_node, *used_nodes);
 	return best_node;
 }
 
@@ -6857,7 +6858,8 @@ static void sched_domain_node_span(int node, struct cpumask *span)
 
 	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
 		int next_node = find_next_best_node(node, &used_nodes);
-
+		if (next_node < 0)
+			break;
 		cpumask_or(span, span, cpumask_of_node(next_node));
 	}
 }
