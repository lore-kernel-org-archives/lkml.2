Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab2JQVSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 17:18:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53228 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab2JQVSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 17:18:48 -0400
Message-ID: <507F20AC.6000308@canonical.com>
Date: Wed, 17 Oct 2012 23:18:36 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: allow unsetting SCHED_RESET_ON_FORK when new policy
 is not realtime
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When implementing SIGXCPU handling for a thread boosted with rtkit to realtime
priority, I noticed that sched_setscheduler(somepid, SCHED_OTHER) would return
-EPERM because the thread was previously SCHED_RR | SCHED_RESET_ON_FORK,
and looking from the code that flag cannot be reset without sufficient rights.

sched_setscheduler(somepid, SCHED_OTHER | SCHED_RESET_ON_FORK) which worked,
and seems to be the only way to remove realtime priority set by rtkit on all
kernels since the patch was introduced.

This patch allows SCHED_RESET_ON_FORK to be removed when the user sets a new
policy on itself without realtime.

Cc: Stable <stable@vger.kernel.org> [v2.6.32+]
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..4c0712a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3757,6 +3757,12 @@ recheck:
 			if (param->sched_priority > p->rt_priority &&
 			    param->sched_priority > rlim_rtprio)
 				return -EPERM;
+
+			/* Normal users shall not reset the
+			 * sched_reset_on_fork flag
+			 */
+			if (p->sched_reset_on_fork && !reset_on_fork)
+				return -EPERM;
 		}
 
 		/*
@@ -3771,10 +3777,6 @@ recheck:
 		/* can't change other user's priorities */
 		if (!check_same_owner(p))
 			return -EPERM;
-
-		/* Normal users shall not reset the sched_reset_on_fork flag */
-		if (p->sched_reset_on_fork && !reset_on_fork)
-			return -EPERM;
 	}
 
 	if (user) {

