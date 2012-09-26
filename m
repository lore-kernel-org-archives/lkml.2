Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab2IZRTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:19:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10407 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757676Ab2IZRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922256"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 12/12] workqueue: avoid work_on_cpu() to interfere system_wq
Date: Thu, 27 Sep 2012 01:20:43 +0800
Message-Id: <1348680043-5077-13-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:47,
	Serialize complete at 2012/09/27 01:18:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't expect how long the work of work_on_cpu() will run.
So move it to system_long_wq to avoid it interfere system_wq.

Note:
The initial implement(2d3854a3) of work_on_cpu() uses its own workqueue.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ccb1d60..c14d94c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3638,7 +3638,7 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 	struct work_for_cpu wfc = { .fn = fn, .arg = arg };
 
 	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
-	schedule_work_on(cpu, &wfc.work);
+	queue_work_on(cpu, system_long_wq, &wfc.work);
 	flush_work(&wfc.work);
 	return wfc.ret;
 }
-- 
1.7.7.6

