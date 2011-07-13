Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab1GMSXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 14:23:16 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:51411 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1GMSXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 14:23:15 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Bianca Lutz <sowilo@cs.tu-berlin.de>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 6/6] sched: Do not attempt to destroy uninitialized rt_bandwidth
Date: Wed, 13 Jul 2011 20:13:36 +0200
Message-Id: <1310580816-10861-7-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bianca Lutz <sowilo@cs.tu-berlin.de>

If a task group is to be created and alloc_fair_sched_group() fails,
then the rt_bandwidth of the corresponding task group is not yet
initialized. The caller, sched_create_group(), starts a clean up
procedure which calls free_rt_sched_group() which unconditionally
destroys the not yet initialized rt_bandwidth.

This crashes or hangs the system in lock_hrtimer_base(): UP systems
dereference a NULL pointer, while SMP systems loop endlessly on a
condition that cannot become true.

This patch simply avoids the destruction of rt_bandwidth when the
initialization code path was not reached.

(This was discovered by accident with a custom kernel modification.)

Signed-off-by: Bianca Lutz <sowilo@cs.tu-berlin.de>
Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9a5f4c7..f29077c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8268,7 +8268,8 @@ static void free_rt_sched_group(struct task_group *tg)
 {
 	int i;
 
-	destroy_rt_bandwidth(&tg->rt_bandwidth);
+	if (tg->rt_se)
+		destroy_rt_bandwidth(&tg->rt_bandwidth);
 
 	for_each_possible_cpu(i) {
 		if (tg->rt_rq)
-- 
1.7.3.4

