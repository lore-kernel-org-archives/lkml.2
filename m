Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1AIVLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:11:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:38426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1AIVLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:11:51 -0500
Date: Sun, 9 Jan 2011 21:11:37 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, lizf@cn.fujitsu.com, stable@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lizf@cn.fujitsu.com, rostedt@goodmis.org, stable@kernel.org,
        tglx@linutronix.de
In-Reply-To: <4D0089AC.1020802@cn.fujitsu.com>
References: <4D0089AC.1020802@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix preempt count leak
Message-ID: <tip-1dbd1951f39e13da579ffe879cce19586d0462de@git.kernel.org>
Git-Commit-ID: 1dbd1951f39e13da579ffe879cce19586d0462de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 09 Jan 2011 21:11:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dbd1951f39e13da579ffe879cce19586d0462de
Gitweb:     http://git.kernel.org/tip/1dbd1951f39e13da579ffe879cce19586d0462de
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 9 Dec 2010 15:47:56 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 7 Jan 2011 23:20:02 -0500

tracing: Fix preempt count leak

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
