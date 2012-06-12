Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2FLFiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 01:38:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:9195 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab2FLFh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 01:37:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111014175"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        eranian@google.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V5 02/13] perf: Avoid race between cpu hotplug and installing event
Date: Tue, 12 Jun 2012 13:37:37 +0800
Message-Id: <1339479468-3815-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

perf_event_open requires the cpu on which to install event is online,
but the cpu can go offline after perf_event_open checks that. Add
get_online_cpus()/put_online_cpus() pair to avoid the race.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 kernel/events/core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f85c015..d71a2d6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6248,6 +6248,8 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
+	get_online_cpus();
+
 	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
 				 NULL, NULL);
 	if (IS_ERR(event)) {
@@ -6387,6 +6389,8 @@ SYSCALL_DEFINE5(perf_event_open,
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
+	put_online_cpus();
+
 	event->owner = current;
 
 	mutex_lock(&current->perf_event_mutex);
@@ -6415,6 +6419,7 @@ err_context:
 err_alloc:
 	free_event(event);
 err_task:
+	put_online_cpus();
 	if (task)
 		put_task_struct(task);
 err_group_fd:
-- 
1.7.10.2

