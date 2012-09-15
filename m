Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2IOIpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 04:45:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63329 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2IOIpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 04:45:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,427,1344182400"; 
   d="scan'208";a="5850811"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 6/6] workqueue: use hotcpu_notifier() for workqueue_cpu_down_callback()
Date: Sat, 15 Sep 2012 16:13:39 +0800
Message-Id: <1347696825-24622-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347696825-24622-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347696825-24622-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/15 16:12:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/15 16:12:52,
	Serialize complete at 2012/09/15 16:12:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workqueue_cpu_down_callback() is only used when HOTPLUG_CPU=y.
so it will be better if we use hotcpu_notifier() to register it.

When HOTPLUG_CPU=y, hotcpu_notifier() and cpu_notifier() are the same.

When HOTPLUG_CPU=n, if we use cpu_notifier(), workqueue_cpu_down_callback()
will be called(no-op) when booting and the memory of workqueue_cpu_down_callback()
and gcwq_unbind_fn() will be discard after boot.

But if we use hotcpu_notifier(), we can avoid the no-op calls of
workqueue_cpu_down_callback(). And the memory of workqueue_cpu_down_callback()
and gcwq_unbind_fn() will be discard at build time:

$ ls -l kernel/workqueue.o.cpu_notifier kernel/workqueue.o.hotcpu_notifier 
-rw-rw-r-- 1 laijs laijs 484080 Sep 15 11:31 kernel/workqueue.o.cpu_notifier
-rw-rw-r-- 1 laijs laijs 478240 Sep 15 11:31 kernel/workqueue.o.hotcpu_notifier

$ size kernel/workqueue.o.cpu_notifier kernel/workqueue.o.hotcpu_notifier
   text	   data	    bss	    dec	    hex	filename
  18513	   2387	   1221	  22121	   5669	kernel/workqueue.o.cpu_notifier
  18082	   2355	   1221	  21658	   549a	kernel/workqueue.o.hotcpu_notifier


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e8d3c95..fc4208a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3791,7 +3791,7 @@ static int __init init_workqueues(void)
 		     WORK_CPU_LAST);
 
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
-	cpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
+	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
 
 	/* initialize gcwqs */
 	for_each_gcwq_cpu(cpu) {
-- 
1.7.4.4

