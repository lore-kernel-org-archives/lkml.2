Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab0FOS0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:26:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:56565 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab0FOS0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:26:23 -0400
Message-ID: <4C17C598.7070303@kernel.org>
Date: Tue, 15 Jun 2010 20:25:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------090807080501030707050706"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Jun 2010 18:25:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090807080501030707050706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello, all.

So, here's the overview I wrote up today.  If anything needs more
clarification, just ask.  Thanks.

== Overview

There are many cases where an execution context is needed and there
already are several mechanisms for them.  The most commonly used one
is workqueue and there are slow_work, async and a few other.  Although
workqueue has been serving the kernel for quite some time now, it has
some limitations.

There are two types of workqueues, single and multi threaded.  MT wq
keeps a bound thread for each online CPU, while ST wq uses single
unbound thread.  With the quickly rising number of CPU cores, there
already are systems in which just booting up saturates the default 32k
PID space.

Frustratingly, although MT wqs end up spending a lot of resources, the
level of concurrency provided is unsatisfactory.  The concurrency
limitation is common to both ST and MT wqs although it's less severe
on MT ones.  Worker pools of wqs are completely separate from each
other.  A MT wq provides one execution context per CPU while a ST wq
one for the whole system.  This leads to various problems.

One such problem is possible deadlock through dependency on the same
execution resource.  These can be detected quite reliably with lockdep
these days but in most cases the only solution is to create a
dedicated wq for one of the parties involved in the deadlock, which
feeds back into the waste of resources.  Also, when creating such
dedicated wq to avoid deadlock, to avoid wasting large number of
threads just for that work, ST wqs are often used but in most cases ST
wqs are suboptimal compared to MT wqs.

The tension between the provided level of concurrency and resource
usage force its users to make unnecessary tradeoffs like libata
choosing to use ST wq for polling PIOs and accepting a silly
limitation that no two polling PIOs can be in progress at the same
time.  As MT wqs don't provide much better concurrency, users which
require higher level of concurrency, like async or fscache, end up
having to implement their own worker pool.

cmwq extends workqueue with focus on the following goals.

* Workqueue is already very widely used.  Maintain compatibility with
  the current API while removing limitations of the current
  implementation.

* Provide single unified worker pool per cpu which can be shared by
  all users.  The worker pool and level of concurrency should be
  regulated automatically so that the API users don't need to worry
  about that.

* Use what's necessary and allocate resources lazily on demand while
  still maintaining forward progress guarantee where necessary.


== Unified worklist

There's a single global cwq, or gcwq, per each possible cpu which
actually serves out the execution contexts.  cpu_workqueues or cwqs of
each wq are mostly simple frontends to the associated gcwq.  Under
normal operation, when a work is queued, it's queued to the gcwq on
the same cpu.  Each gcwq has its own pool of workers bound to the gcwq
which will be used to process all the works queued on the cpu.  For
the most part, works don't care to which wqs they're queued to and
using a unified worklist is pretty straight forward.  There are a
couple of areas where things are a bit more complicated.

First, when queueing works from different wqs on the same queue,
ordering of works needs special care.  Originally, a MT wq allows a
work to be executed simultaneously on multiple cpus although it
doesn't allow the same one to execute simultaneously on the same cpu
(reentrant).  A ST wq allows only single work to be executed on any
cpu which guarantees both non-reentrancy and single-threadedness.

cmwq provides three different ordering modes - reentrant (default),
non-reentrant and single-cpu, where single-cpu can be used to achieve
single-threadedness and full ordering combined with in-flight work
limit of 1.  The default mode is basically the same as the original
implementation.  The distinction between non-reentrancy and single-cpu
were made because some ST wq users didn't really need single
threadedness but just non-reentrancy.

Another area where things get more involved is workqueue flushing as
for flushing to which wq a work is queued matters.  cmwq tracks this
using colors.  When a work is queued to a cwq, it's assigned a color
and each cwq maintains counters for each work color.  The color
assignment changes on each wq flush attempt.  A cwq can tell that all
works queued before a certain wq flush attempt have finished by
waiting for all the colors upto that point to drain.  This maintains
the original workqueue flush semantics without adding unscalable
overhead.


== Automatically regulated shared worker pool

For any worker pool, managing the concurrency level (how many workers
are executing simultaneously) is an important issue.  cmwq tries to
keep the concurrency at minimum but sufficient level.

Concurrency management is implemented by hooking into the scheduler.
gcwq is notified whenever a busy worker wakes up or sleeps and thus
can keep track of the current level of concurrency.  Works aren't
supposed to be cpu cycle hogs and maintaining just enough concurrency
to prevent work processing from stalling due to lack of processing
context should be optimal.  gcwq keeps the number of concurrent active
workers to minimum but no less.  As long as there's one or more
running workers on the cpu, no new worker is scheduled so that works
can be processed in batch as much as possible but when the last
running worker blocks, gcwq immediately schedules new worker so that
the cpu doesn't sit idle while there are works to be processed.

This allows using minimal number of workers without losing execution
bandwidth.  Keeping idle workers around doesn't cost much other than
the memory space, so cmwq holds onto idle ones for a while before
killing them.

As multiple execution contexts are available for each wq, deadlocks
around execution contexts is much harder to create.  The default
workqueue, system_wq, has maximum concurrency level of 256 and unless
there is a use case which can result in a dependency loop involving
more than 254 workers, it won't deadlock.

Such forward progress guarantee relies on that workers can be created
when more execution contexts are necessary.  This is guaranteed by
using emergency workers.  All wqs which can be used in allocation path
are required to have emergency workers which are reserved for
execution of that specific workqueue so that allocation needed for
worker creation doesn't deadlock on workers.


== Benefits

* Less to worry about causing deadlocks around execution resources.

* Far fewer number of kthreads.

* More flexibility without runtime overhead.

* As concurrency is no longer a problem, workloads which needed
  separate mechanisms can now use generic workqueue instead.  This
  easy access to concurrency also allows stuff which wasn't worth
  implementing a dedicated mechanism for but still needed flexible
  concurrency.


== Numbers (this is with the third take but nothing which could affect
   performance has changed since then.  Eh well, very little has
   changed since then in fact.)

wq workload is generated by perf-wq.c module which is a very simple
synthetic wq load generator (I'll attach it to this message).  A work
is described by five parameters - burn_usecs, mean_sleep_msecs,
mean_resched_msecs and factor.  It randomly splits burn_usecs into
two, burns the first part, sleeps for 0 - 2 * mean_sleep_msecs, burns
what's left of burn_usecs and then reschedules itself in 0 - 2 *
mean_resched_msecs.  factor is used to tune the number of cycles to
match execution duration.

It issues three types of works - short, medium and long, each with two
burn durations L and S.

	burn/L(us)	burn/S(us)	mean_sleep(ms)	mean_resched(ms) cycles
 short	50		1		1		10		 454
 medium	50		2		10		50		 125
 long	50		4		100		250		 42

And then these works are put into the following workloads.  The lower
numbered workloads have more short/medium works.

 workload 0
 * 12 wqs with 4 short works
 *  2 wqs with 2 short  and 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

 workload 1
 *  8 wqs with 4 short works
 *  2 wqs with 2 short  and 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

 workload 2
 *  4 wqs with 4 short works
 *  2 wqs with 2 short  and 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

 workload 3
 *  2 wqs with 4 short works
 *  2 wqs with 2 short  and 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

 workload 4
 *  2 wqs with 4 short works
 *  2 wqs with 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

 workload 5
 *  2 wqs with 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

The above wq loads are run in parallel with mencoder converting 76M
mjpeg file into mpeg4 which takes 25.59 seconds with standard
deviation of 0.19 without wq loading.  The CPU was intel netburst
celeron running at 2.66GHz (chosen for its small cache size and
slowness).  wl0 and 1 are only tested for burn/S.  Each test case was
run 11 times and the first run was discarded.

	 vanilla/L	cmwq/L		vanilla/S	cmwq/S
 wl0					26.18 d0.24	26.27 d0.29
 wl1					26.50 d0.45	26.52 d0.23
 wl2	26.62 d0.35	26.53 d0.23	26.14 d0.22	26.12 d0.32
 wl3	26.30 d0.25	26.29 d0.26	25.94 d0.25	26.17 d0.30
 wl4	26.26 d0.23	25.93 d0.24	25.90 d0.23	25.91 d0.29
 wl5	25.81 d0.33	25.88 d0.25	25.63 d0.27	25.59 d0.26

There is no significant difference between the two.  Maybe the code
overhead and benefits coming from context sharing are canceling each
other nicely.  With longer burns, cmwq looks better but it's nothing
significant.  With shorter burns, other than wl3 spiking up for
vanilla which probably would go away if the test is repeated, the two
are performing virtually identically.

The above is exaggerated synthetic test result and the performance
difference will be even less noticeable in either direction under
realistic workloads.

cmwq extends workqueue such that it can serve as robust async
mechanism which can be used (mostly) universally without introducing
any noticeable performance degradation.

Thanks.

--
tejun

--------------090807080501030707050706
Content-Type: text/x-csrc;
 name="perf-wq.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf-wq.c"

#include <linux/module.h>
#include <linux/workqueue.h>
#include <linux/jiffies.h>
#include <linux/delay.h>
#include <linux/sched.h>
#include <linux/wait.h>
#include <linux/cpu.h>
#include <linux/kthread.h>
#include <linux/random.h>
#include <linux/completion.h>

#define MAX_TEST_SECS			300

struct workload_spec {
	const char			*name;
	unsigned int			burn_usecs;
	unsigned int			mean_sleep_msecs;
	unsigned int			mean_resched_msecs;
	unsigned int			factor;
};

struct test_spec {
	const struct workload_spec	*workload;
	unsigned int			wq_id;
	unsigned int			nr_works;
};

struct test_run {
	char				name[64];
	struct delayed_work		dwork;
	struct workqueue_struct		*wq;
	const struct workload_spec	*spec;
	unsigned int			cycles_left;
	unsigned long			start;
	unsigned long			end;
	struct completion		done;
};

static const struct workload_spec workload_short = {
	.name				= "sht",
	.burn_usecs			= 50,
	.mean_sleep_msecs		= 1,
	.mean_resched_msecs		= 10,
	.factor				= 3,
};

static const struct workload_spec workload_medium = {
	.name				= "med",
	.burn_usecs			= 50,
	.mean_sleep_msecs		= 10,
	.mean_resched_msecs		= 50,
	.factor				= 2,
};

static const struct workload_spec workload_long = {
	.name				= "lng",
	.burn_usecs			= 50,
	.mean_sleep_msecs		= 100,
	.mean_resched_msecs		= 250,
	.factor				= 1,
};

static const struct test_spec test_specs[] = {
	/*       workload     wq_id  nr_works */
	{ &workload_short,        0,        4 },
	{ &workload_short,        1,        4 },
	{ &workload_short,        2,        4 },
	{ &workload_short,        3,        4 },

	{ &workload_short,        4,        2 },
	{ &workload_medium,       4,        2 },
	{ &workload_short,        5,        2 },
	{ &workload_medium,       5,        2 },

	{ &workload_medium,       6,        2 },
	{ &workload_long,         6,        1 },
	{ &workload_medium,       7,        2 },
	{ &workload_long,         7,        1 },
	{ &workload_medium,       8,        2 },
	{ &workload_long,         8,        1 },
	{ &workload_medium,       9,        2 },
	{ &workload_long,         9,        1 },

	{ &workload_long,	 10,        1 },
	{ &workload_long,	 11,        1 },
	{ &workload_long,        12,        1 },
	{ &workload_long,        13,        1 },
	{ &workload_long,	 14,        1 },
	{ &workload_long,	 15,        1 },
	{ &workload_long,        16,        1 },
	{ &workload_long,        17,        1 },

	{ &workload_short,       18,        4 },
	{ &workload_short,	 19,        4 },
	{ &workload_short,	 20,        4 },
	{ &workload_short,	 21,        4 },
	{ &workload_short,       22,        4 },
	{ &workload_short,	 23,        4 },
	{ &workload_short,	 24,        4 },
	{ &workload_short,	 25,        4 },
};

static const int nr_test_specs = ARRAY_SIZE(test_specs);

static unsigned int nr_wqs;
static unsigned int nr_test_runs;

static struct workqueue_struct **wqs;
static struct test_run *test_runs;

static void perf_wq_func(struct work_struct *work)
{
	struct delayed_work *dwork = to_delayed_work(work);
	struct test_run *run = container_of(dwork, struct test_run, dwork);
	const struct workload_spec *spec = run->spec;
	unsigned int sleep, tmp, delay;

	sleep = (spec->mean_sleep_msecs * (random32() % 200)) / 100;
	tmp = sleep * (random32() % 100) / 100;
	msleep(tmp);
	sleep -= tmp;

	udelay(spec->burn_usecs);

	msleep(sleep);

	if (--run->cycles_left) {
		delay = (spec->mean_resched_msecs * (random32() % 200)) / 100;
		queue_delayed_work(run->wq, dwork, msecs_to_jiffies(delay));
	} else {
		run->end = jiffies;
		complete(&run->done);
	}
}

static int param_set_trigger(const char *val, struct kernel_param *kp)
{
	static DEFINE_MUTEX(mutex);
	int i, dur;

	if (!mutex_trylock(&mutex))
		return -EBUSY;

	dur = simple_strtoul(val, NULL, 0);
	if (dur <= 0 || dur > MAX_TEST_SECS) {
		pr_err("perf-wq: invalid duration %s\n", val);
		return -EINVAL;
	}

	pr_info("perf-wq: duration %d\n", dur);

	for (i = 0; i < nr_test_runs; i++) {
		struct test_run *run = &test_runs[i];
		const struct workload_spec *spec = run->spec;
		unsigned int cycle_msec =
			spec->mean_sleep_msecs + spec->mean_resched_msecs;

		run->start = jiffies;
		run->cycles_left = dur * 1000 / cycle_msec;
		if (spec->factor)
			run->cycles_left /= spec->factor;
		INIT_COMPLETION(run->done);
		queue_delayed_work(run->wq, &run->dwork, 0);
	}

	for (i = 0; i < nr_test_runs; i++) {
		struct test_run *run = &test_runs[i];

		wait_for_completion(&run->done);
		pr_info("perf-wq: test %s ran for %u msecs\n",
			run->name, jiffies_to_msecs(run->end - run->start));
	}

	mutex_unlock(&mutex);

	return 0;
}

module_param_call(trigger, param_set_trigger, NULL, NULL, 0600);

static int __init perf_wq_init(void)
{
	struct test_run *run;
	int i, j;

	for (i = 0; i < nr_test_specs; i++) {
		nr_wqs = max(nr_wqs, test_specs[i].wq_id + 1);
		nr_test_runs += test_specs[i].nr_works;
	}

	wqs = kzalloc(sizeof(wqs[0]) * nr_wqs, GFP_KERNEL);
	test_runs = kzalloc(sizeof(test_runs[0]) * nr_test_runs, GFP_KERNEL);

	if (!wqs || !test_runs) {
		pr_err("perf-wq: allocation failed\n");
		goto fail;
	}

	for (i = 0; i < nr_wqs; i++) {
		char buf[32];

		snprintf(buf, sizeof(buf), "pwq-%02d", i);
		wqs[i] = create_workqueue(buf);
		if (!wqs[i])
			goto fail;
	}

	run = test_runs;
	for (i = 0; i < nr_test_specs; i++) {
		const struct test_spec *spec = &test_specs[i];

		for (j = 0; j < spec->nr_works; j++) {
			snprintf(run->name, sizeof(run->name), "%s-%d:%d@%d",
				 spec->workload->name, i, j, spec->wq_id);
			INIT_DELAYED_WORK(&run->dwork, perf_wq_func);
			init_completion(&run->done);
			run->wq = wqs[spec->wq_id];
			run->spec = spec->workload;
			run++;
		}
	}

	pr_info("perf-wq initialized, echo duration in seconds to "
		"/sys/module/perf_wq/parameters/trigger to start test cycles\n");

	return 0;

fail:
	if (wqs)
		for (i = 0; i < nr_wqs; i++)
			if (wqs[i])
				destroy_workqueue(wqs[i]);
	kfree(wqs);
	kfree(test_runs);
	return -ENOMEM;
}

static void __exit perf_wq_exit(void)
{
	int i;

	for (i = 0; i < nr_wqs; i++)
		destroy_workqueue(wqs[i]);
	kfree(wqs);
	kfree(test_runs);
}

module_init(perf_wq_init);
module_exit(perf_wq_exit);
MODULE_LICENSE("GPL");

--------------090807080501030707050706--
