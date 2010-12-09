Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0LIHqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 02:46:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58984 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab0LIHqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 02:46:18 -0500
Message-ID: <4D0089AC.1020802@cn.fujitsu.com>
Date: Thu, 09 Dec 2010 15:47:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] tracing: Fix preempt count leak
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-09 15:46:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-09 15:46:21,
	Serialize complete at 2010-12-09 15:46:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running my ftrace stress test, this showed up:

BUG: sleeping function called from invalid context at mm/mmap.c:233
...
note: cat[3293] exited with preempt_count 1

The bug was introduced by commit 91e86e560d0b3ce4c5fc64fd2bbb99f856a30a4e
("tracing: Fix recursive user stack trace")

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c380612..5767457 100644
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
1.6.3
