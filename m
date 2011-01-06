Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1AFCRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:17:23 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41789 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab1AFCQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:16:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 05/12] hrtimer: fix timerqueue conversion flub
Date: Wed,  5 Jan 2011 18:15:52 -0800
Message-Id: <1294280159-2513-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In converting the hrtimers to timerqueue, I missed
a spot in hrtimer_run_queues where we loop running
timers. We end up not pulling the new next value out
and instead just use the last next value, causing
boot time hangs in some cases.

The proper fix is to pull timerqueue_getnext each iteration
instead of using a local next value.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/hrtimer.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f5aaea2..f2429fc 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1420,11 +1420,8 @@ void hrtimer_run_queues(void)
 		return;
 
 	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
-		struct timerqueue_node *next;
-
 		base = &cpu_base->clock_base[index];
-		next = timerqueue_getnext(&base->active);
-		if (!next)
+		if (!timerqueue_getnext(&base->active))
 			continue;
 
 		if (gettime) {
@@ -1434,7 +1431,7 @@ void hrtimer_run_queues(void)
 
 		raw_spin_lock(&cpu_base->lock);
 
-		while ((node = next)) {
+		while ((node = timerqueue_getnext(&base->active))) {
 			struct hrtimer *timer;
 
 			timer = container_of(node, struct hrtimer, node);
-- 
1.7.3.2.146.gca209

