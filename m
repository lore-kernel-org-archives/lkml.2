Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1AHUSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 15:18:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1AHUQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 15:16:47 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=qTKyyP81ZpcA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=b7Hv58zx8xWRB-HYK-MA:9 a=UCRDLsGb3T3r8Upl5S6ezSR8OrIA:4 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110108201645.768731043@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 08 Jan 2011 15:16:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/7] tracing: Fix preempt count leak
References: <20110108201559.130182944@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Fix-preempt-count-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

While running my ftrace stress test, this showed up:

BUG: sleeping function called from invalid context at mm/mmap.c:233
...
note: cat[3293] exited with preempt_count 1

The bug was introduced by commit 91e86e560d0b3ce4c5fc64fd2bbb99f856a30a4e
("tracing: Fix recursive user stack trace")

Cc: <stable@kernel.org>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4D0089AC.1020802@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f8cf959..dc53ecb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1313,12 +1313,10 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 
 	__this_cpu_inc(user_stack_count);
 
-
-
 	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
 					  sizeof(*entry), flags, pc);
 	if (!event)
-		return;
+		goto out_drop_count;
 	entry	= ring_buffer_event_data(event);
 
 	entry->tgid		= current->tgid;
@@ -1333,8 +1331,8 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
 
+ out_drop_count:
 	__this_cpu_dec(user_stack_count);
-
  out:
 	preempt_enable();
 }
-- 
1.7.2.3


