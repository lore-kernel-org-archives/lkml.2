Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1EEMxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:53:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47031 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab1EEMxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:53:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=eisEbuWHU4C8AnfwhuJFWLdlx7mDaFxbDrPEIoQ/vuLqRs6SsTQXdypeRtadZgCpSH
         DWa7PR7BZ8ZT4FXesqQNytbXyZuooU1Kfhu4zM+/eOIl3wsnbojdpRw0Gj6EcMM3BqWP
         k52bttQ8mipJqlW/LpZT3WmsjVyjlRGbwtyqg=
MIME-Version: 1.0
Date: Thu, 5 May 2011 20:53:20 +0800
Message-ID: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
Subject: [PATCH] sched: fix constructing the span cpu mask of sched domain
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a given node, when constructing the cpumask for its sched_domain
to span, if there is no best node available after searching, further
efforts could be saved, based on small change in the return value of
find_next_best_node().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched.c	2011-05-05 20:44:52.000000000 +0800
@@ -6787,7 +6787,7 @@ init_sched_build_groups(const struct cpu
  */
 static int find_next_best_node(int node, nodemask_t *used_nodes)
 {
-	int i, n, val, min_val, best_node = 0;
+	int i, n, val, min_val, best_node = -1;

 	min_val = INT_MAX;

@@ -6811,7 +6811,8 @@ static int find_next_best_node(int node,
 		}
 	}

-	node_set(best_node, *used_nodes);
+	if (best_node != -1)
+		node_set(best_node, *used_nodes);
 	return best_node;
 }

@@ -6837,7 +6838,8 @@ static void sched_domain_node_span(int n

 	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
 		int next_node = find_next_best_node(node, &used_nodes);
-
+		if (next_node < 0)
+			break;
 		cpumask_or(span, span, cpumask_of_node(next_node));
 	}
 }
