Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab2EOSBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:01:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40666 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab2EOSBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:01:03 -0400
Date: Tue, 15 May 2012 20:00:59 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost6.localdomain6
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
In-Reply-To: <1337090625.14207.304.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1205151956500.8461@localhost6.localdomain6>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463806030-1203211352-1337104860=:8461"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806030-1203211352-1337104860=:8461
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT



On Tue, 15 May 2012, Steven Rostedt wrote:

> The RT patch has been having lots of trouble lately with large machines
> and applications running lots of threads. This usually boils down to a
> bottle neck of a single lock: the mm->mmap_sem.
> 
> The mmap_sem is a rwsem, which can sleep, but it also can be taken with
> a read/write lock, where a read lock can be taken by several tasks at
> the same time and the write lock can be only taken by a single task.
> 
> But due to priority inheritance, having multiple readers makes the code
> much more complex, thus the -rt patch converts all rwsems into a single
> mutex, where readers may nest (the same task may grab the same rwsem for
> read multiple times), but only one task may hold the rwsem at any given
> time (for read or write).
> 
> When we have lots of threads, the rwsem may be taken often, either for
> memory allocation or filling in page faults. This becomes a bottle neck
> for threads as only one thread at a time may grab the mmap_sem (which is
> shared by all threads of a process).
> 
> Previous attempts of adding multiple readers became too complex and was
> error prone. This approach takes on a much more simpler technique, one
> that is actually used by per cpu locks.
> 
> The idea here is to have an rwsem create a rt_mutex for each CPU.
> Actually, it creates a rwsem for each CPU that can only be acquired by
> one task at a time. This allows for readers on separate CPUs to take
> only the per cpu lock. When a writer needs to take a lock, it must grab
> all CPU locks before continuing.
> 
> This approach does nothing special with the rt_mutex or priority
> inheritance code. That stays the same, and works normally (thus less
> error prone). The trick here is that when a reader takes a rwsem for
> read, it must disable migration, that way it can unlock the rwsem
> without needing any special searches (which lock did it take?).
> 
> I've tested this a bit, and so far it works well. I haven't found a nice
> way to initialize the locks, so I'm using the silly initialize_rwsem()
> at all places that acquire the lock. But we can work on this later.
> 
> Also, I don't use per_cpu sections for the locks, which means we have
> cache line collisions, but a normal (mainline) rwsem has that as well.
> 
> These are all room for improvement (and why this is just an RFC patch).
> 
> I'll see if I can get some numbers to see how this fixes the issues with
> multi threads on big boxes.
> 
> Thoughts?
> 
> -- Steve
> 
> Not-yet-signed-off-by: Steven Rostedt <rostedt@goodmis.org>

It looks interesting. I wanted to compile it and test it, but started 
running into some problems, I fixed two simple things, but wanted to wait
to see if you would follow Peter's suggestion for lockdep before
proceeding too far.

Thanks
John

>From b70162eaaaa72263d6f13571c1f4675192f4f6cc Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Tue, 15 May 2012 18:25:06 +0200
Subject: [PATCH 1/2] Stringify "name" in __RWSEM_INITIALIZER

This fixes compile errors of the type:
	error: initializer element is not constant

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/rwsem_rt.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rwsem_rt.h b/include/linux/rwsem_rt.h
index cd0c812..dba3b50 100644
--- a/include/linux/rwsem_rt.h
+++ b/include/linux/rwsem_rt.h
@@ -37,7 +37,7 @@ struct rw_semaphore {
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define __RWSEM_INITIALIZER(_name) \
-	{ .name = _name }
+	{ .name = #_name }
 #else
 #define __RWSEM_INITIALIZER(name) \
 	{  }
-- 
1.7.2.3

>From faefd7e9189b29aa8f8c2b3961b1c05889c27cd7 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Tue, 15 May 2012 18:49:36 +0200
Subject: [PATCH 2/2] Fix wrong member name in __initialize_rwsem - change key to __key
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix the following error
linux-rt/kernel/rt.c:320: error: ¡struct rw_semaphore¢ has no member named ¡key¢

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rt.c b/kernel/rt.c
index f8dab27..86efaa6 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -317,7 +317,7 @@ static void __initialize_rwsem(struct rw_semaphore *rwsem)
 		rt_mutex_init(&rwsem->lock[i].lock);
 		__rt_rwsem_init(&rwsem->lock[i],
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-				rwsem->name, &rwsem->key[i]
+				rwsem->name, &rwsem->__key[i]
 #else
 				"", 0
 #endif
-- 
1.7.2.3

---1463806030-1203211352-1337104860=:8461--
