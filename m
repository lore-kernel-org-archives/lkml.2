Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2IZRVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:21:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59288 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757575Ab2IZRSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:42 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922245"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 01/12] workqueue: add WORKER_RESCUER
Date: Thu, 27 Sep 2012 01:20:32 +0800
Message-Id: <1348680043-5077-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize complete at 2012/09/27 01:18:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rescuer thread must be a worker which is WORKER_NOT_RUNNING:
	If it is *not* WORKER_NOT_RUNNING, it will increase the nr_running
	and it disables the normal workers wrongly.

So rescuer thread must be WORKER_NOT_RUNNING.

Currently code implement it by always setting WORKER_PREP on rescuer thread,
but this kind of implement is ugly:
A)	It reuses WORKER_PREP which is used for a different meaning.
B)	It does not told us rescuer thread is WORKER_NOT_RUNNING.

So we add WORKER_RESCUER to fix these two sematic.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 737ab01..ec882a6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -73,11 +73,12 @@ enum {
 	WORKER_DIE		= 1 << 1,	/* die die die */
 	WORKER_IDLE		= 1 << 2,	/* is idle */
 	WORKER_PREP		= 1 << 3,	/* preparing to run works */
+	WORKER_RESCUER		= 1 << 4,	/* rescuer thread */
 	WORKER_CPU_INTENSIVE	= 1 << 6,	/* cpu intensive */
 	WORKER_UNBOUND		= 1 << 7,	/* worker is unbound */
 
 	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_UNBOUND |
-				  WORKER_CPU_INTENSIVE,
+				  WORKER_RESCUER | WORKER_CPU_INTENSIVE,
 
 	NR_WORKER_POOLS		= 2,		/* # worker pools per gcwq */
 
@@ -2405,6 +2406,7 @@ static int rescuer_thread(void *__wq)
 	bool is_unbound = wq->flags & WQ_UNBOUND;
 	unsigned int cpu;
 
+	rescuer->flags |= WORKER_RESCUER;
 	set_user_nice(current, RESCUER_NICE_LEVEL);
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
-- 
1.7.7.6

