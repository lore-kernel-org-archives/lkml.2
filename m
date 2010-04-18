Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab0DRRHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 13:07:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:64209 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab0DRRHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 13:07:37 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [RFC PATCH 0/3] ipc/sem.c: Optimization for reducing spinlock contention
Date: Sun, 18 Apr 2010 19:07:14 +0200
Message-Id: <1271610437-2312-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches tries to fix the spinlock contention
reported by Chris Manson: His benchmark exposes problems of the current
code:

- In the worst case, the algorithm used by update_queue() is O(N^2).
  Bulk wake-up calls can enter this worst case.
  The patch series fix that.
  Note that the benchmark app doesn't expose the problem, it just should
  be fixed: Real world apps might do the wake-ups in another order
  than perfect FIFO.

- The part of the code that runs within the semaphore array spinlock
  is significantly larger than necessary.
  The patch series fixes that. This change is responsible for the
  main improvement.

- The cacheline with the spinlock is also used for a variable that
  is read in the hot path (sem_base) and for a variable that is
  unnecessarily written to multiple times (sem_otime).
  The last step of the series cacheline-aligns the spinlock.

With regards to the last patch:
I'm not sure if this should be performed:
Cacheline aligning a spinlock helps to avoid cacheline trashing
among multiple cpus, at the cost of wasting memory.
Testing on a large system might show if it's worth the memory.

I've tested the series with a modified version of Chris' benchmark
app [1]:

- before:
echo "512 32000 512 512" > /proc/sys/kernel/sem
./sembench -t 250 -w 64 -o 0 -r 30 -b:
<<<
250 threads, waking 64 at a time
using ipc sem operations
main thread burns: 2194274
worker burn count total 6352691 min 21505 max 29230 avg 25410
run time 30 seconds 211756 worker burns per second
lifetime 30 seconds 58573142769 ticks.
free 745344 contended 7801967
wait 110278262115 avg 14134 1/1000 cpu time 470
<<<

- after:
echo "512 32000 512 512" > /proc/sys/kernel/sem
./sembench -t 250 -w 64 -o 0 -r 30 -b:
<<<
250 threads, waking 64 at a time
using ipc sem operations
main thread burns: 112890
worker burn count total 7084335 min 27869 max 28769 avg 28337
run time 30 seconds 236144 worker burns per second
lifetime 30 seconds 59518717621 ticks.
free 6704845 contended 490448
wait 2625106215 avg 5352 1/1000 cpu time 11
<<<

i.e.:
- 1.1 % cpu time lost by spinning instead of 47.0 %
- 6% of the spinlocks spin instead of 91%
- 236144 worker burns/sec instead of 211756
	<< I do not understand that yet. Why not more?
	<< Perhaps an test app interaction:
	<< With the optimization, only 112890 main thread burns
	<< happen. Without, 2194374.

The tests were performed on a 4-core AMD Phenom system.
Test results from larger systems are apreciated.
Attached is the benchmark patch that I've used: With the patch applied,
the kernel prints statistics about the semaphore spinlock when a
semaphore array is released. Unfortunately, the patch is x86-only
(both 32-bit and 64-bit), it uses rdtscll.

The main advantage compared to Chris ipc sem patch series is that it
doesn't add special codepaths: All operations are optimized, e.g. even
operations that use SEM_UNDO.

Note that there is room for further improvement, without resorting to
per-semaphore spinlocks: It would be possible to:
- first add a task to a global sorted list of pending operations.
  Just a list_add().
- spin_trylock an 2nd per-array spinlock (e.g. "semop_lock")
- then drop the existing ipc spinlock.
  If the spin_trylock was successful: try_atomic_semop() and update_queue().
  Otherwise: schedule_work() a worker thread and schedule().
- the worker thread scans the list of pending operations and does
  the try_atomic_semop()/update_queue() calls.

That way, only list_add() and list_del() would be under the existing
"big" spinlock. The second spinlock would be accessed with spin_trylock,
i.e. no time would be lost due to spinning.

But: This would be a separate improvement, I think we should check first
if it is really necessary.

--
	Manfred

[1]: There is an interaction between the benchmark app and the scheduler:
Obviosly, there is zero contention when everything happens on one core.
On my system, the scheduler sometimes keeps everything on one core.
Speeding up ipc/sem.c didn't increase the burn count from sembench at all,
the scheduler was just able to keep even more tasks on the same cpu.

With cpu binding, the behavior is simple to describe:
- the wake-up task spends most of the time in semtimedop(), holding the
semaphore array spinlock.
- the other cpus try to acquire it as well - and spin for a long time,
because waking up 64 tasks is a long operation.
- the patch series reduce the time that the spinlock is held.

I've posted Chris' app with cpu binding before:
https://patchwork.kernel.org/patch/93299/

And below is the statistics patch:

--------
diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 3b1594d..85b914a 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -96,6 +96,12 @@ struct kern_ipc_perm
 	mode_t		mode; 
 	unsigned long	seq;
 	void		*security;
+
+	int start_sec;
+	unsigned long long start_tics;
+	unsigned long long free;
+	unsigned long long contended;
+	unsigned long long wait_sum;
 };
 
 #endif /* __KERNEL__ */
diff --git a/ipc/sem.c b/ipc/sem.c
index dbef95b..c9c24a3 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -187,6 +187,29 @@ static inline void sem_putref(struct sem_array *sma)
 
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
 {
+	int sc = get_seconds();
+	unsigned long long tics_now;
+
+	rdtscll(tics_now);
+	tics_now -= s->sem_perm.start_tics;
+	sc -= s->sem_perm.start_sec;
+
+	printk(KERN_ERR "sem_rmid for %p:\n",s);
+	printk(KERN_ERR "lifetime %d sec %Ld ticks.\n",
+		sc, tics_now);
+	printk(KERN_ERR "free %Ld contended %Ld\n",
+		s->sem_perm.free, s->sem_perm.contended);
+	if (s->sem_perm.contended != 0) {
+		unsigned long long fraction;
+		tics_now *= num_online_cpus();
+
+		fraction = (s->sem_perm.wait_sum*1000)/tics_now;
+		printk(KERN_ERR "wait %Ld avg %Ld 1/1000 cpu time %Ld\n",
+			s->sem_perm.wait_sum,
+			s->sem_perm.wait_sum/s->sem_perm.contended,
+			fraction);
+	}
+
 	ipc_rmid(&sem_ids(ns), &s->sem_perm);
 }
 
diff --git a/ipc/util.c b/ipc/util.c
index 79ce84e..3bc31f9 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -260,6 +260,13 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 		return -ENOSPC;
 
 	spin_lock_init(&new->lock);
+
+	new->free = 0;
+	new->contended = 0;
+	new->wait_sum = 0;
+	new->start_sec = get_seconds();
+	rdtscll(new->start_tics);
+
 	new->deleted = 0;
 	rcu_read_lock();
 	spin_lock(&new->lock);
@@ -701,7 +708,16 @@ struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 		return ERR_PTR(-EINVAL);
 	}
 
-	spin_lock(&out->lock);
+	if (spin_trylock(&out->lock)) {
+		out->free++;
+	} else {
+		unsigned long long t1, t2;
+		rdtscll(t1);
+		spin_lock(&out->lock);
+		rdtscll(t2);
+		out->contended++;
+		out->wait_sum += (t2-t1);
+	}
 	
 	/* ipc_rmid() may have already freed the ID while ipc_lock
 	 * was spinning: here verify that the structure is still valid
