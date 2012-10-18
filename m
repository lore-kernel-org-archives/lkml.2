Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2JRCQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 22:16:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab2JRCQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 22:16:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,604,1344182400"; 
   d="scan'208";a="6019312"
Message-ID: <507F66F6.20704@cn.fujitsu.com>
Date: Thu, 18 Oct 2012 10:18:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] percpu-rwsem: use barrier in unlock path
References: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com> <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com> <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com> <507E48ED.8060809@cn.fujitsu.com> <Pine.LNX.4.64.1210171046130.26481@file.rdu.redhat.com> <20121017202806.GA7282@home.goodmis.org>
In-Reply-To: <20121017202806.GA7282@home.goodmis.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 10:15:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 10:15:31,
	Serialize complete at 2012/10/18 10:15:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 04:28 AM, Steven Rostedt wrote:
> On Wed, Oct 17, 2012 at 11:07:21AM -0400, Mikulas Patocka wrote:
>>>
>>> Even the previous patch is applied, percpu_down_read() still
>>> needs mb() to pair with it.
>>
>> percpu_down_read uses rcu_read_lock which should guarantee that memory 
>> accesses don't escape in front of a rcu-protected section.
> 
> You do realize that rcu_read_lock() does nothing more that a barrier(),
> right?
> 
> Paul worked really hard to get rcu_read_locks() to not call HW barriers.
> 
>>
>> If rcu_read_unlock has only an unlock barrier and not a full barrier, 
>> memory accesses could be moved in front of rcu_read_unlock and reordered 
>> with this_cpu_inc(*p->counters), but it doesn't matter because 
>> percpu_down_write does synchronize_rcu(), so it never sees these accesses 
>> halfway through.
> 
> Looking at the patch, you are correct. The read side doesn't need the
> memory barrier as the worse thing that will happen is that it sees the
> locked = false, and will just grab the mutex unnecessarily.

---------------------
A memory barrier can be added iff these two things are known:
	1) it disables the disordering between what and what.
	2) what is the corresponding mb() that it pairs with.

You tried to add a mb() in percpu_up_write(), OK, I know it disables the disordering
between the writes to the protected data and the statement "p->locked = false",
But I can't find out the corresponding mb() that it pairs with.

percpu_down_read()					writes to the data
	The cpu cache/prefetch the data			writes to the data
	which is chaos					writes to the data
							percpu_up_write()
								mb()
								p->locked = false;
	unlikely(p->locked)
		the cpu see p->lock = false,
		don't discard the cached/prefetch data
	this_cpu_inc(*p->counters);
	the code of read-access to the data
	****and we use the chaos data*****

So you need to add a mb() after "unlikely(p->locked)".

-------------------------

The RCU you use don't protect any data. It protects codes of the fast path:
	unlikely(p->locked);
	this_cpu_inc(*p->counters);

and synchronize_rcu() ensures all previous fast path had fully finished
"this_cpu_inc(*p->counters);".

It don't protect other code/data, if you want to protect other code or other
data, please add more synchronizations or mb()s.

---------------

I extremely hate a synchronization protects code instead of data.
but sometimes I also have to do it.

---------------

a very draft example of paired-mb()s is here:


diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index cf80f7e..84a93c0 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -12,6 +12,14 @@ struct percpu_rw_semaphore {
 	struct mutex mtx;
 };
 
+#if 1
+#define light_mb() barrier()
+#define heavy_mb() synchronize_sched()
+#else
+#define light_mb() smp_mb()
+#define heavy_mb() smp_mb();
+#endif
+
 static inline void percpu_down_read(struct percpu_rw_semaphore *p)
 {
 	rcu_read_lock();
@@ -24,22 +32,12 @@ static inline void percpu_down_read(struct percpu_rw_semaphore *p)
 	}
 	this_cpu_inc(*p->counters);
 	rcu_read_unlock();
+	light_mb(); /* A, between read of p->locked and read of data, paired with D */
 }
 
 static inline void percpu_up_read(struct percpu_rw_semaphore *p)
 {
-	/*
-	 * On X86, write operation in this_cpu_dec serves as a memory unlock
-	 * barrier (i.e. memory accesses may be moved before the write, but
-	 * no memory accesses are moved past the write).
-	 * On other architectures this may not be the case, so we need smp_mb()
-	 * there.
-	 */
-#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
-	barrier();
-#else
-	smp_mb();
-#endif
+	light_mb(); /* B, between read of the data and write to p->counter, paired with C */
 	this_cpu_dec(*p->counters);
 }
 
@@ -61,11 +59,12 @@ static inline void percpu_down_write(struct percpu_rw_semaphore *p)
 	synchronize_rcu();
 	while (__percpu_count(p->counters))
 		msleep(1);
-	smp_rmb(); /* paired with smp_mb() in percpu_sem_up_read() */
+	heavy_mb(); /* C, between read of p->counter and write to data, paired with B */
 }
 
 static inline void percpu_up_write(struct percpu_rw_semaphore *p)
 {
+	heavy_mb(); /* D, between write to data and write to p->locked, paired with A */
 	p->locked = false;
 	mutex_unlock(&p->mtx);
 }
