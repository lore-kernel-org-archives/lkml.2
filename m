Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab1LGQ0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:26:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757901Ab1LGQZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:22 2011
Message-Id: <20111207161222.586002859@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:37 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Eric Dumazet <eric.dumazet@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Tejun Heo <tj@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [095/104] trace_events_filter: Use rcu_assign_pointer() when setting ftrace_event_call->filter
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit d3d9acf646679c1981032b0985b386d12fccc60c upstream.

ftrace_event_call->filter is sched RCU protected but didn't use
rcu_assign_pointer().  Use it.

TODO: Add proper __rcu annotation to call->filter and all its users.

-v2: Use RCU_INIT_POINTER() for %NULL clearing as suggested by Eric.

Link: http://lkml.kernel.org/r/20111123164949.GA29639@google.com

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace_events_filter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1766,7 +1766,7 @@ static int replace_system_preds(struct e
 		 * replace the filter for the call.
 		 */
 		filter = call->filter;
-		call->filter = filter_item->filter;
+		rcu_assign_pointer(call->filter, filter_item->filter);
 		filter_item->filter = filter;
 
 		fail = false;
@@ -1821,7 +1821,7 @@ int apply_event_filter(struct ftrace_eve
 		filter = call->filter;
 		if (!filter)
 			goto out_unlock;
-		call->filter = NULL;
+		RCU_INIT_POINTER(call->filter, NULL);
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
@@ -1862,7 +1862,7 @@ out:
 	 * string
 	 */
 	tmp = call->filter;
-	call->filter = filter;
+	rcu_assign_pointer(call->filter, filter);
 	if (tmp) {
 		/* Make sure the call is done with the filter */
 		synchronize_sched();


