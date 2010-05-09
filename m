Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab0EIUo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:44:58 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58970 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0EIUny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=BqPnzHAo8ulCPV+4U0EtKcG6TPISIgmgCLqPcJYmQL1pLV9ryrY03py2LH61ASHjZv
         udmuEDc0z7Be4YEnfP6eD8CZkS/UJorygDFlOIDeYbFVPEgFW0E7sNfUrJ4vHBGIl47e
         iZUcrE65KPjCi144RCmKs+joOfxmJQPdwbPig=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 06/10] tracing: Drop lock_acquired waittime field
Date: Sun,  9 May 2010 22:43:34 +0200
Message-Id: <1273437818-8130-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the waittime field from the lock_acquired event, we can
calculate it by substracting the lock_acquired event timestamp
with the matching lock_acquire one.

It is not needed and takes useless space in the traces.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/lock.h |   11 ++++-------
 kernel/lockdep.c            |    2 +-
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 5c1dcfc..17ca287 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -78,24 +78,21 @@ TRACE_EVENT(lock_contended,
 );
 
 TRACE_EVENT(lock_acquired,
-	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
 
-	TP_ARGS(lock, ip, waittime),
+	TP_ARGS(lock, ip),
 
 	TP_STRUCT__entry(
 		__string(name, lock->name)
-		__field(s64, wait_nsec)
 		__field(void *, lockdep_addr)
 	),
 
 	TP_fast_assign(
 		__assign_str(name, lock->name);
-		__entry->wait_nsec = waittime;
 		__entry->lockdep_addr = lock;
 	),
-	TP_printk("%p %s (%llu ns)", __entry->lockdep_addr,
-		  __get_str(name),
-		  __entry->wait_nsec)
+	TP_printk("%p %s", __entry->lockdep_addr,
+		  __get_str(name))
 );
 
 #endif
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2594e1c..31e22e7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3380,7 +3380,7 @@ found_it:
 		hlock->holdtime_stamp = now;
 	}
 
-	trace_lock_acquired(lock, ip, waittime);
+	trace_lock_acquired(lock, ip);
 
 	stats = get_lock_stats(hlock_class(hlock));
 	if (waittime) {
-- 
1.6.2.3

