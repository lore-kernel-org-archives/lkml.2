Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0DQKYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 06:24:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:9929 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab0DQKYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 06:24:39 -0400
Message-ID: <4BC98C70.50904@colorfullife.com>
Date: Sat, 17 Apr 2010 12:24:48 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: zach.brown@oracle.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/2] ipc semaphores: order wakeups based on waiter CPU
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com> <1271098163-3663-3-git-send-email-chris.mason@oracle.com>
In-Reply-To: <1271098163-3663-3-git-send-email-chris.mason@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------020001060006000803070806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020001060006000803070806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Chris,

On 04/12/2010 08:49 PM, Chris Mason wrote:
> @@ -599,6 +622,13 @@ again:
>   		list_splice_init(&new_pending,&work_list);
>   		goto again;
>   	}
> +
> +	list_sort(NULL,&wake_list, list_comp);
> +	while (!list_empty(&wake_list)) {
> +		q = list_entry(wake_list.next, struct sem_queue, list);
> +		list_del_init(&q->list);
> +		wake_up_sem_queue(q, 0);
> +	}
>   }
>    
What about moving this step much later?

There is no need to hold any locks for the actual wake_up_process().

I've updated my patch:
- improved update_queue that guarantees no O(N^2) for your workload.
- move the actual wake-up after dropping all locks
- optimize setting sem_otime
- cacheline align the ipc spinlock.

But the odd thing:
It doesn't improve the sembench result at all (AMD Phenom X4)
The only thing that is reduced is the system time:
 From ~1 min system time for "sembench -t 250 -w 250 -r 30 -o 0" to ~30 sec.

cpu binding the sembench threads results in an improvement of ~50% - at 
the cost of a significant increase of the system time (from 30 seconds 
to 1 min) and the user time (from 2 seconds to 14 seconds).

Are you sure that the problem is contention on the semaphore array spinlock?
With the above changes, the code that is under the spin_lock is very short.
Especially:
- Why does optimizing ipc/sem.c only reduce the system time [reported by 
time] and not the sembench output?
- Why is there no improvement from the ___cache_line_align?
If there would be  contention, then there should be trashing from 
accessing the lock and writing sem_otime and reading sem_base.
- Additionally: you wrote that reducing the array size does not help much.
But: The arrays are 100% independant, the ipc code scales linearly.
Spreading the work over multiple spinlocks is - like cache line aligning 
- usually a 100% guaranteed improvement if there is contention.

I've attached a modified sembench.c and the proposal for ipc/sem.c
Could you try it?
What do you think?
How many cores do you have in your test system?

--
     Manfred

--------------020001060006000803070806
Content-Type: text/plain;
 name="patch-ipc-optimize_bulkwakeup-3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch-ipc-optimize_bulkwakeup-3"

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 8a4adbe..66b5fc6 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -78,6 +78,7 @@ struct  seminfo {
 
 #ifdef __KERNEL__
 #include <asm/atomic.h>
+#include <linux/cache.h>
 #include <linux/rcupdate.h>
 
 struct task_struct;
@@ -91,7 +92,8 @@ struct sem {
 
 /* One sem_array data structure for each set of semaphores in the system. */
 struct sem_array {
-	struct kern_ipc_perm	sem_perm;	/* permissions .. see ipc.h */
+	struct kern_ipc_perm ____cacheline_aligned_in_smp
+				sem_perm;	/* permissions .. see ipc.h */
 	time_t			sem_otime;	/* last semop time */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
diff --git a/ipc/sem.c b/ipc/sem.c
index dbef95b..34ae151 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -381,7 +381,6 @@ static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
 		sop--;
 	}
 	
-	sma->sem_otime = get_seconds();
 	return 0;
 
 out_of_range:
@@ -404,25 +403,41 @@ undo:
 	return result;
 }
 
-/*
- * Wake up a process waiting on the sem queue with a given error.
- * The queue is invalid (may not be accessed) after the function returns.
+/** wake_up_sem_queue_prepare(q, error): Prepare wake-up
+ * @q: queue entry that must be signaled
+ * @error: Error value for the signal
+ *
+ * Prepare the wake-up of the queue entry q.
  */
-static void wake_up_sem_queue(struct sem_queue *q, int error)
+static void wake_up_sem_queue_prepare(struct list_head *pt, struct sem_queue *q, int error)
 {
-	/*
-	 * Hold preempt off so that we don't get preempted and have the
-	 * wakee busy-wait until we're scheduled back on. We're holding
-	 * locks here so it may not strictly be needed, however if the
-	 * locks become preemptible then this prevents such a problem.
-	 */
-	preempt_disable();
+	if (list_empty(pt)) {
+		/*
+		 * Hold preempt off so that we don't get preempted and have the
+		 * wakee busy-wait until we're scheduled back on.
+		 */
+		preempt_disable();
+	}
 	q->status = IN_WAKEUP;
-	wake_up_process(q->sleeper);
-	/* hands-off: q can disappear immediately after writing q->status. */
-	smp_wmb();
-	q->status = error;
-	preempt_enable();
+	q->pid = error;
+
+	list_add_tail(&q->simple_list, pt);
+}
+
+static void wake_up_sem_queue_do(struct list_head *pt)
+{
+	struct sem_queue *q, *t;
+	int did_something;
+
+	did_something = !list_empty(pt);
+	list_for_each_entry_safe(q, t, pt, simple_list) {
+		wake_up_process(q->sleeper);
+		/* hands-off: q can disappear immediately after writing q->status. */
+		smp_wmb();
+		q->status = q->pid;
+	}
+	if (did_something)
+		preempt_enable();
 }
 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
@@ -434,22 +449,90 @@ static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
 		sma->complex_count--;
 }
 
+/** check_restart(sma, q)
+ * @sma: semaphore array
+ * @q: the operation that just completed
+ *
+ * update_queue is O(N^2) when it restarts scanning the whole queue of
+ * waiting operations. Therefore this function checks if the restart is
+ * really necessary. It is called after a previously waiting operation
+ * was completed.
+ */
+static int check_restart(struct sem_array *sma, struct sem_queue *q)
+{
+	struct sem * curr;
+	struct sem_queue *h;
+
+	/* if the operation didn't modify the array, then no restart */
+	if (q->alter == 0)
+		return 0;
+
+	/* pending complex operations are too difficult to analyse */
+	if (sma->complex_count)
+		return 1;
+
+	/* we were a sleeping complex operation. Too difficult */
+	if (q->nsops > 1)
+		return 1;
+
+	curr = sma->sem_base + q->sops[0].sem_num;
+
+	/* No-one waits on this queue */
+	if (list_empty(&curr->sem_pending))
+		return 0;
+
+	/* the new semaphore value */
+	if (curr->semval) {
+		/* It is impossible that someone waits for the new value:
+		 * - q is a previously sleeping simple operation that
+		 *   altered the array. It must be a decrement, because
+		 *   simple increments never sleep.
+		 * - The value is not 0, thus wait-for-zero won't proceed.
+		 * - If there are older (higher priority) decrements
+		 *   in the queue, then they have observed the original
+		 *   semval value and couldn't proceed. The operation
+		 *   decremented to value - thus they won't proceed either.
+		 */
+		BUG_ON(q->sops[0].sem_op >= 0);
+		return 0;
+	}
+	/*
+	 * semval is 0. Check if there are wait-for-zero semops.
+	 * They must be the first entries in the per-semaphore simple queue
+	 */
+	h=list_first_entry(&curr->sem_pending, struct sem_queue, simple_list);
+	BUG_ON(h->nsops != 1);
+	BUG_ON(h->sops[0].sem_num != q->sops[0].sem_num);
+	
+	/* Yes, there is a wait-for-zero semop. Restart */	
+	if (h->sops[0].sem_op == 0)
+		return 1;
+
+	/* Again - no-one is waiting for the new value. */
+	return 0;
+}		
+
 
 /**
  * update_queue(sma, semnum): Look for tasks that can be completed.
  * @sma: semaphore array.
  * @semnum: semaphore that was modified.
+ * @pt: list head for the tasks that must be woken up.
  *
  * update_queue must be called after a semaphore in a semaphore array
  * was modified. If multiple semaphore were modified, then @semnum
  * must be set to -1.
+ * The tasks that must be woken up are added to @pt. The return code
+ * is stored in q->pid.
+ * The function return 1 if at least one array variable was modified.
  */
-static void update_queue(struct sem_array *sma, int semnum)
+static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 {
 	struct sem_queue *q;
 	struct list_head *walk;
 	struct list_head *pending_list;
 	int offset;
+	int retval;
 
 	/* if there are complex operations around, then knowing the semaphore
 	 * that was modified doesn't help us. Assume that multiple semaphores
@@ -469,7 +552,7 @@ static void update_queue(struct sem_array *sma, int semnum)
 again:
 	walk = pending_list->next;
 	while (walk != pending_list) {
-		int error, alter;
+		int error, restart;
 
 		q = (struct sem_queue *)((char *)walk - offset);
 		walk = walk->next;
@@ -493,23 +576,57 @@ again:
 			continue;
 
 		unlink_queue(sma, q);
+		if (q->alter)
+			retval = 1;
 
-		/*
-		 * The next operation that must be checked depends on the type
-		 * of the completed operation:
-		 * - if the operation modified the array, then restart from the
-		 *   head of the queue and check for threads that might be
-		 *   waiting for the new semaphore values.
-		 * - if the operation didn't modify the array, then just
-		 *   continue.
-		 */
-		alter = q->alter;
-		wake_up_sem_queue(q, error);
-		if (alter && !error)
+		if (error)
+			restart = 0;
+		else
+			restart = check_restart(sma, q);
+
+		wake_up_sem_queue_prepare(pt, q, error);
+		if (restart)
 			goto again;
 	}
+	return retval;
 }
 
+/** do_smart_update(sma, sops, nsops, otime, pt): Optimized update_queue
+ * @sma: semaphore array
+ * @sops: operations that were performed
+ * @nsops: number of operations
+ * @otime: force setting otime
+ * @pt: list head of the tasks that must be woken up.
+ *
+ * do_smart_update() does the required called to update_queue, based on the
+ * actual changes that were performed on the semaphore array.
+ * Note that the function does not do the actual wake-up: the caller is
+ * responsible for calling wake_up_sem_queue_do(@pt).
+ * It is safe to perform this call after dropping all locks.
+ */
+void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops,
+			int otime, struct list_head *pt)
+{
+	int i;
+
+	if (sma->complex_count) {
+		if (update_queue(sma, -1, pt))
+			otime = 1;
+		goto done;
+	}
+				
+	for (i=0;i<nsops;i++) {
+		if (sops[i].sem_op > 0 ||
+			(sops[i].sem_op < 0 && sma->sem_base[sops[i].sem_num].semval == 0))
+			if (update_queue(sma, sops[i].sem_num, pt))
+				otime = 1;
+	}
+done:
+	if (otime)
+		sma->sem_otime = get_seconds();
+}
+
+
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
@@ -572,6 +689,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct sem_undo *un, *tu;
 	struct sem_queue *q, *tq;
 	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
+	struct list_head tasks;
 
 	/* Free the existing undo structures for this semaphore set.  */
 	assert_spin_locked(&sma->sem_perm.lock);
@@ -585,15 +703,17 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
+	INIT_LIST_HEAD(&tasks);
 	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
 		unlink_queue(sma, q);
-		wake_up_sem_queue(q, -EIDRM);
+		wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
 	}
 
 	/* Remove the semaphore set from the IDR */
 	sem_rmid(ns, sma);
 	sem_unlock(sma);
 
+	wake_up_sem_queue_do(&tasks);
 	ns->used_sems -= sma->sem_nsems;
 	security_sem_free(sma);
 	ipc_rcu_putref(sma);
@@ -715,11 +835,13 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	ushort fast_sem_io[SEMMSL_FAST];
 	ushort* sem_io = fast_sem_io;
 	int nsems;
+	struct list_head tasks;
 
 	sma = sem_lock_check(ns, semid);
 	if (IS_ERR(sma))
 		return PTR_ERR(sma);
 
+	INIT_LIST_HEAD(&tasks);
 	nsems = sma->sem_nsems;
 
 	err = -EACCES;
@@ -807,7 +929,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma, -1);
+		do_smart_update(sma, NULL, 0, 0, &tasks);
 		err = 0;
 		goto out_unlock;
 	}
@@ -849,13 +971,15 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma, semnum);
+		do_smart_update(sma, NULL, 0, 0, &tasks);
 		err = 0;
 		goto out_unlock;
 	}
 	}
 out_unlock:
 	sem_unlock(sma);
+	wake_up_sem_queue_do(&tasks);
+
 out_free:
 	if(sem_io != fast_sem_io)
 		ipc_free(sem_io, sizeof(ushort)*nsems);
@@ -1129,6 +1253,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	struct sem_queue queue;
 	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
+	struct list_head tasks;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -1177,6 +1302,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	} else
 		un = NULL;
 
+	INIT_LIST_HEAD(&tasks);
+
 	sma = sem_lock_check(ns, semid);
 	if (IS_ERR(sma)) {
 		if (un)
@@ -1225,7 +1352,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
-			update_queue(sma, (nsops == 1) ? sops[0].sem_num : -1);
+			do_smart_update(sma, sops, nsops, 1, &tasks);
 
 		goto out_unlock_free;
 	}
@@ -1302,6 +1429,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 out_unlock_free:
 	sem_unlock(sma);
+
+	wake_up_sem_queue_do(&tasks);
 out_free:
 	if(sops != fast_sops)
 		kfree(sops);
@@ -1362,6 +1491,7 @@ void exit_sem(struct task_struct *tsk)
 	for (;;) {
 		struct sem_array *sma;
 		struct sem_undo *un;
+		struct list_head tasks;
 		int semid;
 		int i;
 
@@ -1425,10 +1555,11 @@ void exit_sem(struct task_struct *tsk)
 				semaphore->sempid = task_tgid_vnr(current);
 			}
 		}
-		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma, -1);
+		INIT_LIST_HEAD(&tasks);
+		do_smart_update(sma, NULL, 0, 1, &tasks);
 		sem_unlock(sma);
+		wake_up_sem_queue_do(&tasks);
 
 		call_rcu(&un->rcu, free_un);
 	}

--------------020001060006000803070806
Content-Type: text/plain;
 name="sembench.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sembench.c"

/*
 * copyright Oracle 2007.  Licensed under GPLv2
 * To compile: gcc -Wall -o sembench sembench.c -lpthread
 *
 * usage: sembench -t thread count -w wakenum -r runtime -o op
 * op can be: 0 (ipc sem) 1 (nanosleep) 2 (futexes)
 *
 * example:
 *	sembench -t 1024 -w 512 -r 60 -o 2
 * runs 1024 threads, waking up 512 at a time, running for 60 seconds using
 * futex locking.
 *
 */
#define  _GNU_SOURCE
#define _POSIX_C_SOURCE 199309
#include <fcntl.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/sem.h>
#include <sys/ipc.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <sys/syscall.h>
#include <errno.h>

#define VERSION "0.2"

static int g_cpu_bind = 0;
/* futexes have been around since 2.5.something, but it still seems I
 * need to make my own syscall.  Sigh.
 */
#define FUTEX_WAIT              0
#define FUTEX_WAKE              1
#define FUTEX_FD                2
#define FUTEX_REQUEUE           3
#define FUTEX_CMP_REQUEUE       4
#define FUTEX_WAKE_OP           5
static inline int futex (int *uaddr, int op, int val,
			 const struct timespec *timeout,
			 int *uaddr2, int val3)
{
	return syscall(__NR_futex, uaddr, op, val, timeout, uaddr2, val3);
}

static int all_done = 0;
static int timeout_test = 0;

#define SEMS_PERID 250

struct sem_operations;

struct lockinfo {
	unsigned long id;
	unsigned long index;
	int data;
	pthread_t tid;
	struct lockinfo *next;
	struct sem_operations *ops;
};

struct sem_wakeup_info {
	int wakeup_count;
	struct sembuf sb[SEMS_PERID];
};

struct sem_operations {
	void (*wait)(struct lockinfo *l);
	int (*wake)(struct sem_wakeup_info *wi, int num_semids, int num);
	void (*setup)(struct sem_wakeup_info **wi, int num_semids);
	void (*cleanup)(int num_semids);
	char *name;
};

int *semid_lookup = NULL;

#if 0
pthread_mutex_t worklist_mutex = PTHREAD_MUTEX_INITIALIZER;

void do_lock(void)
{
	pthread_mutex_lock(&worklist_mutex);
}

void do_unlock(void)
{
	pthread_mutex_unlock(&worklist_mutex);
}

#else
static volatile long lock = 1;

void do_lock(void)
{
	int res;

again:
	res = 0;
	asm volatile(
		"lock; xchgb %b0,%1\n\t"
		: "=q" (res)
		: "m" (lock), "0" (res)
		: "memory");
	if (res == 1) {
		if(lock == 1) {
			printf("Lock error 1.\n");
			exit(1);
		}
		return;
	}
	asm volatile("rep; nop \n\t" : : :);
	goto again;
}

void do_unlock(void)
{
	int res = 1;
	
	if(lock) {
		printf("Lock error 2a.\n");
		exit(1);
	}

	asm volatile(
		"lock; xchgb %b0,%1\n\t"
		: "=q" (res)
		: "m" (lock), "0" (res)
		: "memory");
	if (res == 1) {
		printf("lock error 2b.\n");
		exit(1);
	}
}
#endif

static unsigned long total_burns = 0;
static unsigned long min_burns = ~0UL;
static unsigned long max_burns = 0;
static int thread_count = 0;
struct lockinfo *worklist_head = NULL;
struct lockinfo *worklist_tail = NULL;

static void worklist_add(struct lockinfo *l)
{
	do_lock();
	l->next = NULL;
	if (!worklist_head)
		worklist_head = l;
	else
		worklist_tail->next = l;
	worklist_tail = l;
	do_unlock();
}

static struct lockinfo *worklist_rm(void)
{
	struct lockinfo *ret;
	do_lock();
	if (!worklist_head) {
		ret = NULL;
	} else {
		ret = worklist_head;
		worklist_head = ret->next;
		if (!worklist_head)
			worklist_tail = NULL;
	}
	do_unlock();
	return ret;
}

static void do_cpu_bind(int master)
{
	if (g_cpu_bind)
	{
		cpu_set_t cpus;
		pthread_t thread;
		int ret;

		CPU_ZERO(&cpus);

		thread = pthread_self();		

		if (master) {
			CPU_SET(0, &cpus);
		} else {
			ret = pthread_getaffinity_np(thread, sizeof(cpus), &cpus);
			if (ret < 0) {
				printf("pthread_getaffinity_np() failed for thread %p with errno %d.\n",
						thread, errno);
				fflush(stdout);
				return;
			}
 			CPU_CLR(0, &cpus);
		}

		ret = pthread_setaffinity_np(thread, sizeof(cpus), &cpus);
		if (ret < 0) {
			printf("pthread_setaffinity_np failed for thread %p with errno %d.\n",
					thread, errno);
			fflush(stdout);
			return;
		}

		ret = pthread_getaffinity_np(thread, sizeof(cpus), &cpus);
		if (ret < 0) {
			printf("pthread_getaffinity_np() failed for thread %p with errno %d.\n",
					thread, errno);
		} else {
			printf("thread %p: type %d bound to %04lxh\n",thread, master,
					cpus.__bits[0]);
		}
		fflush(stdout);
	}
}

/* ipc semaphore post& wait */
void wait_ipc_sem(struct lockinfo *l)
{
	struct sembuf sb;
	int ret;
	struct timespec *tvp = NULL;
	struct timespec tv = { 0, 1 };

	sb.sem_num = l->index;
	sb.sem_flg = 0;

	sb.sem_op = -1;
	l->data = 1;

	if (timeout_test && (l->id % 5) == 0)
		tvp = &tv;

	worklist_add(l);
	ret = semtimedop(semid_lookup[l->id], &sb, 1, tvp);

	while(l->data != 0 && tvp) {
		struct timespec tv2 = { 0, 500 };
		nanosleep(&tv2, NULL);
	}

	if (l->data != 0) {
		if (tvp)
			return;
		fprintf(stderr, "wakeup without data update\n");
		exit(1);
	}
	if (ret) {
		if (errno == EAGAIN && tvp)
			return;
		perror("semtimed op");
		exit(1);
	}
}

int ipc_wake_some(struct sem_wakeup_info *wi, int num_semids, int num)
{
	int i;
	int ret;
	struct lockinfo *l;
	int found = 0;

	for (i = 0; i < num_semids; i++) {
		wi[i].wakeup_count = 0;
	}
	while(num > 0) {
		struct sembuf *sb;
		l = worklist_rm();
		if (!l)
			break;
		if (l->data != 1)
			fprintf(stderr, "warning, lockinfo data was %d\n",
				l->data);
		l->data = 0;
		sb = wi[l->id].sb + wi[l->id].wakeup_count;
		sb->sem_num = l->index;
		sb->sem_op = 1;
		sb->sem_flg = IPC_NOWAIT;
		wi[l->id].wakeup_count++;
		found++;
		num--;
	}
	if (!found)
		return 0;
	for (i = 0; i < num_semids; i++) {
		int wakeup_total;
		int cur;
		int offset = 0;
		if (!wi[i].wakeup_count)
			continue;
		wakeup_total = wi[i].wakeup_count;
		while(wakeup_total > 0) {
			cur = wakeup_total > 64 ? 64 : wakeup_total;
			ret = semtimedop(semid_lookup[i], wi[i].sb + offset,
					 cur, NULL);
			if (ret) {
				perror("semtimedop");
				exit(1);
			}
			offset += cur;
			wakeup_total -= cur;
		}
	}
	return found;
}

void setup_ipc_sems(struct sem_wakeup_info **wi, int num_semids)
{
	int i;
	*wi = malloc(sizeof(**wi) * num_semids);
	semid_lookup = malloc(num_semids * sizeof(int));
	for(i = 0; i < num_semids; i++) {
		semid_lookup[i] = semget(IPC_PRIVATE, SEMS_PERID,
					 IPC_CREAT | 0777);
		if (semid_lookup[i] < 0) {
			perror("semget");
			exit(1);
		}
	}
	usleep(200);
}

void cleanup_ipc_sems(int num)
{
	int i;
	for (i = 0; i < num; i++) {
		semctl(semid_lookup[i], 0, IPC_RMID);
	}
}

struct sem_operations ipc_sem_ops = {
	.wait = wait_ipc_sem,
	.wake = ipc_wake_some,
	.setup = setup_ipc_sems,
	.cleanup = cleanup_ipc_sems,
	.name = "ipc sem operations",
};

/* futex post & wait */
void wait_futex_sem(struct lockinfo *l)
{
	int ret;
	l->data = 1;
	worklist_add(l);
	while(l->data == 1) {
		ret = futex(&l->data, FUTEX_WAIT, 1, NULL, NULL, 0);
		if (ret && ret != EWOULDBLOCK) {
			perror("futex wait");
			exit(1);
		}
	}
}

int futex_wake_some(struct sem_wakeup_info *wi, int num_semids, int num)
{
	int i;
	int ret;
	struct lockinfo *l;
	int found = 0;

	for (i = 0; i < num; i++) {
		l = worklist_rm();
		if (!l)
			break;
		if (l->data != 1)
			fprintf(stderr, "warning, lockinfo data was %d\n",
				l->data);
		l->data = 0;
		ret = futex(&l->data, FUTEX_WAKE, 1, NULL, NULL, 0);
		if (ret < 0) {
			perror("futex wake");
			exit(1);
		}
		found++;
	}
	return found;
}

void setup_futex_sems(struct sem_wakeup_info **wi, int num_semids)
{
	return;
}

void cleanup_futex_sems(int num)
{
	return;
}

struct sem_operations futex_sem_ops = {
	.wait = wait_futex_sem,
	.wake = futex_wake_some,
	.setup = setup_futex_sems,
	.cleanup = cleanup_futex_sems,
	.name = "futex sem operations",
};

/* nanosleep sems here */
void wait_nanosleep_sem(struct lockinfo *l)
{
	int ret;
	struct timespec tv = { 0, 1000000 };
	int count = 0;

	l->data = 1;
	worklist_add(l);
	while(l->data) {
		ret = nanosleep(&tv, NULL);
		if (ret) {
			perror("nanosleep");
			exit(1);
		}
		count++;
	}
}

int nanosleep_wake_some(struct sem_wakeup_info *wi, int num_semids, int num)
{
	int i;
	struct lockinfo *l;

	for (i = 0; i < num; i++) {
		l = worklist_rm();
		if (!l)
			break;
		if (l->data != 1)
			fprintf(stderr, "warning, lockinfo data was %d\n",
				l->data);
		l->data = 0;
	}
	return i;
}

void setup_nanosleep_sems(struct sem_wakeup_info **wi, int num_semids)
{
	return;
}

void cleanup_nanosleep_sems(int num)
{
	return;
}

struct sem_operations nanosleep_sem_ops = {
	.wait = wait_nanosleep_sem,
	.wake = nanosleep_wake_some,
	.setup = setup_nanosleep_sems,
	.cleanup = cleanup_nanosleep_sems,
	.name = "nano sleep sem operations",
};

void *worker(void *arg)
{
	struct lockinfo *l = (struct lockinfo *)arg;
	int burn_count = 0;
	pthread_t tid = pthread_self();
	size_t pagesize = getpagesize();
	char *buf = malloc(pagesize);
	struct lockinfo *node_local_l;

	if (!buf) {
		perror("malloc");
		exit(1);
	}

	node_local_l = malloc(sizeof(struct lockinfo));
	if (!node_local_l) {
		perror("malloc");
		exit(1);
	}
	memcpy(node_local_l, l, sizeof(*l));
	l = node_local_l;
	node_local_l = (struct lockinfo *)arg;

	do_cpu_bind(0);

	do_lock();
	thread_count++;
	do_unlock();

	l->tid = tid;
	while(!all_done) {
		l->ops->wait(l);
		if (all_done)
			break;
		burn_count++;
	}
	do_lock();
	total_burns += burn_count;
	if (burn_count < min_burns)
		min_burns = burn_count;
	if (burn_count > max_burns)
		max_burns = burn_count;
	thread_count--;
	do_unlock();

	free(node_local_l);
	return (void *)0;
}

void print_usage(void)
{
	printf("usage: sembench [-t threads] [-w wake incr] [-r runtime]");
	printf("                [-o num] (0=ipc, 1=nanosleep, 2=futex)\n");
	printf("                [-b] (cpu bind) [-T] (time test)\n");
	exit(1);
}

#define NUM_OPERATIONS 3
struct sem_operations *allops[NUM_OPERATIONS] = { &ipc_sem_ops,
						&nanosleep_sem_ops,
						&futex_sem_ops};

int main(int ac, char **av) {
	int ret;
	int i;
	int semid = 0;
	int sem_num = 0;
	int burn_count = 0;
	struct sem_wakeup_info *wi = NULL;
	struct timeval start;
	struct timeval now;
	int num_semids = 0;
	int num_threads = 2048;
	int wake_num = 256;
	int run_secs = 30;
	int pagesize = getpagesize();
	char *buf = malloc(pagesize);
	struct sem_operations *ops = allops[0];

	if (!buf) {
		perror("malloc");
		exit(1);
	}
	for (i = 1; i < ac; i++) {
		if (strcmp(av[i], "-t") == 0) {
			if (i == ac -1)
				print_usage();
			num_threads = atoi(av[i+1]);
			i++;
		} else if (strcmp(av[i], "-w") == 0) {
			if (i == ac -1)
				print_usage();
			wake_num = atoi(av[i+1]);
			i++;
		} else if (strcmp(av[i], "-r") == 0) {
			if (i == ac -1)
				print_usage();
			run_secs = atoi(av[i+1]);
			i++;
		} else if (strcmp(av[i], "-o") == 0) {
			int index;
			if (i == ac -1)
				print_usage();
			index = atoi(av[i+1]);
			if (index >= NUM_OPERATIONS) {
				fprintf(stderr, "invalid operations %d\n",
					index);
				exit(1);
			}
			ops = allops[index];
			i++;
		} else if (strcmp(av[i], "-b") == 0) {
			g_cpu_bind = 1;
		}  else if (strcmp(av[i], "-T") == 0) {
			timeout_test = 1;
		} else if (strcmp(av[i], "-h") == 0) {
			print_usage();
		}
	}
	num_semids = (num_threads + SEMS_PERID - 1) / SEMS_PERID;
	ops->setup(&wi, num_semids);

	for (i = 0; i < num_threads; i++) {
		struct lockinfo *l;
		pthread_t tid;

		l = malloc(sizeof(*l));
		if (!l) {
			perror("malloc");
			exit(1);
		}
		l->id = semid;
		l->index = sem_num++;
		l->ops = ops;
		if (sem_num >= SEMS_PERID) {
			semid++;
			sem_num = 0;
		}
		ret = pthread_create(&tid, NULL, worker, (void *)l);
		if (ret) {
			perror("pthread_create");
			exit(1);
		}
		ret = pthread_detach(tid);
		if (ret) {
			perror("pthread_detach");
			exit(1);
		}
	}
	do_cpu_bind(1);
	while(thread_count != num_threads)
		usleep(200);

	while(!worklist_head)
		usleep(200);

	gettimeofday(&start, NULL);
	fprintf(stderr, "main loop going\n");
	while(1) {
		ops->wake(wi, num_semids, wake_num);
		burn_count++;
		gettimeofday(&now, NULL);
		if (now.tv_sec - start.tv_sec >= run_secs)
			break;
	}
	fprintf(stderr, "all done\n");
	all_done = 1;
	while(thread_count > 0) {
		ops->wake(wi, num_semids, wake_num);
		usleep(200);
	}
	printf("%d threads, waking %d at a time\n", num_threads, wake_num);
	printf("using %s\n", ops->name);
	printf("main thread burns: %d\n", burn_count);
	printf("worker burn count total %lu min %lu max %lu avg %lu\n",
	       total_burns, min_burns, max_burns, total_burns / num_threads);
	printf("run time %d seconds %lu worker burns per second\n",
		(int)(now.tv_sec - start.tv_sec),
		total_burns / (now.tv_sec - start.tv_sec));
	ops->cleanup(num_semids);
	return 0;
}

--------------020001060006000803070806--
