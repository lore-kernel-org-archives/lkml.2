Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab0DIMDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 08:03:03 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:33296 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0DIMC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 08:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gP7QZaNmXJZLpzJLiMRC06Jw2CtWAkrFEMJeRY7AYfsOV29dGsVvuJRh1PZTnzLwwy
         wAYrULsLVxDKHAJHXWhoWlNZgunuozoa+Q3iHemUBInsUi7JbOfUG7wBZTZu6icNNYMg
         YindJkK4czGqs7DiPGBJbCHKWnV1czhFXhq1s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] perf: Make clock software events consistent with general exclusion rules
Date: Fri,  9 Apr 2010 14:02:47 +0200
Message-Id: <1270814567-6089-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu/task clock events implement their own version of exclusion
on top of exclude_user and exclude_kernel.

The result is that when the event triggered in the kernel but we
have exclude_kernel set, we try to rewind using task_pt_regs.
There are two side effects of this:

- we call task_pt_regs even on kernel threads, which doesn't give
  us the desired result.
- if the event occured in the kernel, we shouldn't rewind to the
  user context. We want to actually ignore the event.

get_irq_regs() will always give us the right interrupted context, so
use its result and submit it to perf_exclude_context() that knows
when an event must be ignored.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c953cfb..2d8b67c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4163,15 +4163,8 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	perf_sample_data_init(&data, 0);
 	data.period = event->hw.last_period;
 	regs = get_irq_regs();
-	/*
-	 * In case we exclude kernel IPs or are somehow not in interrupt
-	 * context, provide the next best thing, the user IP.
-	 */
-	if ((event->attr.exclude_kernel || !regs) &&
-			!event->attr.exclude_user)
-		regs = task_pt_regs(current);
 
-	if (regs) {
+	if (regs && !perf_exclude_event(event, regs)) {
 		if (!(event->attr.exclude_idle && current->pid == 0))
 			if (perf_event_overflow(event, 0, &data, regs))
 				ret = HRTIMER_NORESTART;
-- 
1.6.2.3

