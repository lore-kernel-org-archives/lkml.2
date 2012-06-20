Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2FTKvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:51:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2FTKvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:51:07 -0400
Date: Wed, 20 Jun 2012 03:50:52 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-fbfc623f8231c8d8c78aab5841e9c6e5811ab638@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1339741902-8449-3-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-3-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Avoid race between cpu hotplug and installing event
Git-Commit-ID: fbfc623f8231c8d8c78aab5841e9c6e5811ab638
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 03:50:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbfc623f8231c8d8c78aab5841e9c6e5811ab638
Gitweb:     http://git.kernel.org/tip/fbfc623f8231c8d8c78aab5841e9c6e5811ab638
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Fri, 15 Jun 2012 14:31:31 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 12:13:20 +0200

perf: Avoid race between cpu hotplug and installing event

perf_event_open() requires the cpu on which to install event is online,
but the cpu can go offline after perf_event_open checks that. Add a
get_online_cpus()/put_online_cpus() pair to avoid the race.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1339741902-8449-3-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d7d71d6..31d182e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6252,6 +6252,8 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
+	get_online_cpus();
+
 	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
 				 NULL, NULL);
 	if (IS_ERR(event)) {
@@ -6391,6 +6393,8 @@ SYSCALL_DEFINE5(perf_event_open,
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
+	put_online_cpus();
+
 	event->owner = current;
 
 	mutex_lock(&current->perf_event_mutex);
@@ -6419,6 +6423,7 @@ err_context:
 err_alloc:
 	free_event(event);
 err_task:
+	put_online_cpus();
 	if (task)
 		put_task_struct(task);
 err_group_fd:
