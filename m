Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967298Ab2EPFAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:00:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:40526 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967282Ab2EPFAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:00:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100617120"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] perf: Avoid race between cpu hotplug and installing event
Date: Wed, 16 May 2012 12:59:55 +0800
Message-Id: <1337144403-30841-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
References: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
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
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 91a4459..9fdf394 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6255,6 +6255,8 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
+	get_online_cpus();
+
 	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
 				 NULL, NULL);
 	if (IS_ERR(event)) {
@@ -6394,6 +6396,8 @@ SYSCALL_DEFINE5(perf_event_open,
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
+	put_online_cpus();
+
 	event->owner = current;
 
 	mutex_lock(&current->perf_event_mutex);
@@ -6422,6 +6426,7 @@ SYSCALL_DEFINE5(perf_event_open,
 err_alloc:
 	free_event(event);
 err_task:
+	put_online_cpus();
 	if (task)
 		put_task_struct(task);
 err_group_fd:
-- 
1.7.7.6

