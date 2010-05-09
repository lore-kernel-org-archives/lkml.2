Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab0EIUoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:44:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32986 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab0EIUn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=noxhHmZbopFWyXfLHiBlU9fxPFbBQazKaOHfC1VyWAjy5YQ0yK5t8z30y2WMV516ZK
         1WE02X8G9JXOhtFC6Le4zrfjXRhMQv+a+VdSz9YAhzO7Rjm3ZOn5dgiJXBUslkaBZRer
         al6qsjeKQx7nijx20lyHL6EaYvZc8QAXq+E/E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 08/10] tracing: Factorize lock events in a lock class
Date: Sun,  9 May 2010 22:43:36 +0200
Message-Id: <1273437818-8130-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_acquired, lock_contended and lock_release now share the
same prototype and format. Let's factorize them into a lock
event class.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/lock.h |   48 +++++++++++++-----------------------------
 1 files changed, 15 insertions(+), 33 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index fde4c38..2821b86 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -35,15 +35,15 @@ TRACE_EVENT(lock_acquire,
 		  __get_str(name))
 );
 
-TRACE_EVENT(lock_release,
+DECLARE_EVENT_CLASS(lock,
 
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
 
 	TP_ARGS(lock, ip),
 
 	TP_STRUCT__entry(
-		__string(name, lock->name)
-		__field(void *, lockdep_addr)
+		__string(	name, 	lock->name	)
+		__field(	void *, lockdep_addr	)
 	),
 
 	TP_fast_assign(
@@ -51,48 +51,30 @@ TRACE_EVENT(lock_release,
 		__entry->lockdep_addr = lock;
 	),
 
-	TP_printk("%p %s",
-		  __entry->lockdep_addr, __get_str(name))
+	TP_printk("%p %s",  __entry->lockdep_addr, __get_str(name))
 );
 
-#ifdef CONFIG_LOCK_STAT
-
-TRACE_EVENT(lock_contended,
+DEFINE_EVENT(lock, lock_release,
 
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
 
-	TP_ARGS(lock, ip),
-
-	TP_STRUCT__entry(
-		__string(name, lock->name)
-		__field(void *, lockdep_addr)
-	),
+	TP_ARGS(lock, ip)
+);
 
-	TP_fast_assign(
-		__assign_str(name, lock->name);
-		__entry->lockdep_addr = lock;
-	),
+#ifdef CONFIG_LOCK_STAT
 
-	TP_printk("%p %s",
-		  __entry->lockdep_addr, __get_str(name))
-);
+DEFINE_EVENT(lock, lock_contended,
 
-TRACE_EVENT(lock_acquired,
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
 
-	TP_ARGS(lock, ip),
+	TP_ARGS(lock, ip)
+);
 
-	TP_STRUCT__entry(
-		__string(name, lock->name)
-		__field(void *, lockdep_addr)
-	),
+DEFINE_EVENT(lock, lock_acquired,
 
-	TP_fast_assign(
-		__assign_str(name, lock->name);
-		__entry->lockdep_addr = lock;
-	),
-	TP_printk("%p %s", __entry->lockdep_addr,
-		  __get_str(name))
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
+
+	TP_ARGS(lock, ip)
 );
 
 #endif
-- 
1.6.2.3

