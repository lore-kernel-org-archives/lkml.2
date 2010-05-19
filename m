Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab0ESXqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 19:46:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25994 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab0ESXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 19:46:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=uYV00mpWuCRbaapllegz3FOXVASkWtakXNR1vmY7AA5XFW05Xs7owuCi2DfGGd/cQ
	VXciQiA2CEd1b5UEZU8lQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>
Cc: Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
       Nikhil Rao <ncrao@google.com>
Subject: [PATCH] sched: fix updating sd->balance_interval in idle_balance()
Date: Wed, 19 May 2010 16:45:30 -0700
Message-Id: <1274312730-3041-1-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sd->balance_interval is updated incorrectly when SD_BALANCE_NEWIDLE is not set
in sd->flags. This patch updates sd->balance_interval only when we balance the
domain.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 217e4a9..c35fe47 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2996,11 +2996,12 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
-		if (sd->flags & SD_BALANCE_NEWIDLE) {
-			/* If we've pulled tasks over stop searching: */
-			pulled_task = load_balance(this_cpu, this_rq,
-						   sd, CPU_NEWLY_IDLE, &balance);
-		}
+		if (!(sd->flags & SD_BALANCE_NEWIDLE))
+			continue;
+
+		/* If we've pulled tasks over stop searching: */
+		pulled_task = load_balance(this_cpu, this_rq, sd,
+					   CPU_NEWLY_IDLE, &balance);
 
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
-- 
1.7.0.1

