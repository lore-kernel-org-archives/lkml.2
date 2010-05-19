Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0ESNfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab0ESNfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:35:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1274135154-24082-9-git-send-email-walken@google.com>
References: <1274135154-24082-9-git-send-email-walken@google.com> <1274135154-24082-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 08/10] rwsem: down_read_critical infrastructure support
Date: Wed, 19 May 2010 14:34:15 +0100
Message-ID: <4405.1274276055@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

>  #define RWSEM_WAITING_FOR_READ	0x00000001
>  #define RWSEM_WAITING_FOR_WRITE	0x00000002
> +#define RWSEM_UNFAIR            0x00000004

Can I suggest you change this to:

	enum rwsem_waiter_type {
		RWSEM_WAITING_FOR_WRITE,
		RWSEM_WAITING_FOR_READ,
		RWSEM_WAITING_FOR_UNFAIR_READ
	};

and then change:

>  	unsigned int flags;

to:

	enum rwsem_waiter_type type;

and use this throughout.  It simplifies some of the code too.  See attached
patch.

David
---
rwsem: Make waiter type an enum in the slow path of the asm-optimised version

Make the waiter type in the asm-optimised version of the slow path an
enumeration rather than a bitmask.

Signed-off-by: David Howells <dhowells@redhat.com>
---
diff --git a/lib/rwsem.c b/lib/rwsem.c
index b3fe179..8aa2238 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -28,13 +28,16 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 
 EXPORT_SYMBOL(__init_rwsem);
 
+enum rwsem_waiter_type {
+	RWSEM_WAITING_FOR_WRITE,
+	RWSEM_WAITING_FOR_READ,
+	RWSEM_WAITING_FOR_UNFAIR_READ
+};
+
 struct rwsem_waiter {
 	struct list_head list;
 	struct task_struct *task;
-	unsigned int flags;
-#define RWSEM_WAITING_FOR_READ	0x00000001
-#define RWSEM_WAITING_FOR_WRITE	0x00000002
-#define RWSEM_UNFAIR            0x00000004
+	enum rwsem_waiter_type type;
 };
 
 /* Wake types for __rwsem_do_wake().  Note that RWSEM_WAKE_NO_ACTIVE and
@@ -64,7 +67,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	signed long oldcount, woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
+	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
 		goto readers_only;
 
 	if (wake_type == RWSEM_WAKE_READ_OWNED)
@@ -133,10 +136,10 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 		waiter = list_entry(waiter->list.next,
 					struct rwsem_waiter, list);
 
-	} while (waiter->flags & RWSEM_WAITING_FOR_READ);
+	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
 
 	adjustment = woken * RWSEM_ACTIVE_READ_BIAS;
-	if (waiter->flags & RWSEM_WAITING_FOR_READ)
+	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
 		/* hit end of list above */
 		adjustment -= RWSEM_WAITING_BIAS;
 
@@ -172,7 +175,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
  */
 static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
-			 unsigned int flags, signed long adjustment)
+			 enum rwsem_waiter_type type, signed long adjustment)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
@@ -183,13 +186,13 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	/* set up my own style of waitqueue */
 	spin_lock_irq(&sem->wait_lock);
 	waiter.task = tsk;
-	waiter.flags = flags;
+	waiter.type = type;
 	get_task_struct(tsk);
 
 	if (list_empty(&sem->wait_list))
 		adjustment += RWSEM_WAITING_BIAS;
 
-	if (flags & RWSEM_UNFAIR)
+	if (type & RWSEM_WAITING_FOR_UNFAIR_READ)
 		list_add(&waiter.list, &sem->wait_list);
 	else
 		list_add_tail(&waiter.list, &sem->wait_list);
@@ -242,8 +245,7 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
 asmregparm struct rw_semaphore __sched *
 rwsem_down_read_unfair_failed(struct rw_semaphore *sem)
 {
-	return rwsem_down_failed_common(sem,
-					RWSEM_WAITING_FOR_READ | RWSEM_UNFAIR,
+	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_UNFAIR_READ,
 					-RWSEM_ACTIVE_READ_BIAS);
 }
 
