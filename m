Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab1LERel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:34:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58638 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab1LERej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:34:39 -0500
Date: Mon, 5 Dec 2011 09:34:22 -0800
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-d3d9acf646679c1981032b0985b386d12fccc60c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, eric.dumazet@gmail.com, rostedt@goodmis.org,
        tj@kernel.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tj@kernel.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <20111123164949.GA29639@google.com>
References: <20111123164949.GA29639@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] trace_events_filter: Use rcu_assign_pointer() when setting ftrace_event_call->filter
Git-Commit-ID: d3d9acf646679c1981032b0985b386d12fccc60c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:34:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3d9acf646679c1981032b0985b386d12fccc60c
Gitweb:     http://git.kernel.org/tip/d3d9acf646679c1981032b0985b386d12fccc60c
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed, 23 Nov 2011 08:49:49 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 1 Dec 2011 22:16:47 -0500

trace_events_filter: Use rcu_assign_pointer() when setting ftrace_event_call->filter

ftrace_event_call->filter is sched RCU protected but didn't use
rcu_assign_pointer().  Use it.

TODO: Add proper __rcu annotation to call->filter and all its users.

-v2: Use RCU_INIT_POINTER() for %NULL clearing as suggested by Eric.

Link: http://lkml.kernel.org/r/20111123164949.GA29639@google.com

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@kernel.org # (2.6.39+)
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 816d3d0..d6e7926 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1686,7 +1686,7 @@ static int replace_system_preds(struct event_subsystem *system,
 		 * replace the filter for the call.
 		 */
 		filter = call->filter;
-		call->filter = filter_item->filter;
+		rcu_assign_pointer(call->filter, filter_item->filter);
 		filter_item->filter = filter;
 
 		fail = false;
@@ -1741,7 +1741,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		filter = call->filter;
 		if (!filter)
 			goto out_unlock;
-		call->filter = NULL;
+		RCU_INIT_POINTER(call->filter, NULL);
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
@@ -1782,7 +1782,7 @@ out:
 	 * string
 	 */
 	tmp = call->filter;
-	call->filter = filter;
+	rcu_assign_pointer(call->filter, filter);
 	if (tmp) {
 		/* Make sure the call is done with the filter */
 		synchronize_sched();
