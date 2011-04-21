Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1DUNhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:37:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33290 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1DUNhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=BYFDXPbp4oPKPDPYqbC7PpUZVkiQ3+OF7xQqRccGey3l4B/2l9kb4FZMj8sfnHE+4J
         Tvm+2DzIMqI/k3C2+SZNmNrAvAErc0JmlLWTndlDlKc5cRsE6JiUVxh8x16RNmjcMMbI
         WVkD7EGwZXn0G8wG55i/BOOGInF36XpJJ8wrs=
MIME-Version: 1.0
Date: Thu, 21 Apr 2011 21:37:03 +0800
Message-ID: <BANLkTin_m2Ygnr8csKo6fJZ4sB6YYvYDGw@mail.gmail.com>
Subject: [PATCH] sched: try to fix mm leak when freeing sched groups
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When freeing sched groups, there is a sg (== sched_group_nodes[i]) not
got freed.
The relevant code is reshuffled to be clearer, and correct.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched.c	2011-03-30 03:09:48.000000000 +0800
+++ b/kernel/sched.c	2011-04-21 21:09:00.000000000 +0800
@@ -7106,7 +7106,7 @@ static void free_sched_groups(const stru
 			continue;

 		for (i = 0; i < nr_node_ids; i++) {
-			struct sched_group *oldsg, *sg = sched_group_nodes[i];
+			struct sched_group *sg = sched_group_nodes[i];

 			cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
 			if (cpumask_empty(nodemask))
@@ -7114,13 +7114,11 @@ static void free_sched_groups(const stru

 			if (sg == NULL)
 				continue;
-			sg = sg->next;
-next_sg:
-			oldsg = sg;
-			sg = sg->next;
-			kfree(oldsg);
-			if (oldsg != sched_group_nodes[i])
-				goto next_sg;
+			do {
+				struct sched_group *next = sg->next;
+				kfree(sg);
+				sg = next;
+			} while (sg != sched_group_nodes[i]);
 		}
 		kfree(sched_group_nodes);
 		sched_group_nodes_bycpu[cpu] = NULL;
