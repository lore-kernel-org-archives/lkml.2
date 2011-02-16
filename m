Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab1BPBfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:35:23 -0500
Received: from kroah.org ([198.145.64.141]:39166 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab1BPAUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:35 2011
Message-Id: <20110216001435.199181831@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [101/272] tracing: Fix preempt count leak
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Li Zefan <lizf@cn.fujitsu.com>

commit 1dbd1951f39e13da579ffe879cce19586d0462de upstream.

While running my ftrace stress test, this showed up:

BUG: sleeping function called from invalid context at mm/mmap.c:233
...
note: cat[3293] exited with preempt_count 1

The bug was introduced by commit 91e86e560d0b3ce4c5fc64fd2bbb99f856a30a4e
("tracing: Fix recursive user stack trace")

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4D0089AC.1020802@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1313,12 +1313,10 @@ ftrace_trace_userstack(struct ring_buffe
 
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
@@ -1333,8 +1331,8 @@ ftrace_trace_userstack(struct ring_buffe
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
 
+ out_drop_count:
 	__this_cpu_dec(user_stack_count);
-
  out:
 	preempt_enable();
 }


