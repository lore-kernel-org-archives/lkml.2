Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2JYFkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:40:15 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53822 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2JYFkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:40:12 -0400
Message-ID: <5088D0B2.3050208@linux.vnet.ibm.com>
Date: Thu, 25 Oct 2012 13:40:02 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Charles Wang <muming.wq@gmail.com>
Subject: The idea about scheduler test module(STM)
Content-Type: multipart/mixed;
 boundary="------------010405040505010608020702"
x-cbid: 12102505-5564-0000-0000-000005067E3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010405040505010608020702
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi, Folks

Charles has raised a problem that we don't have any tool yet
for testing the scheduler with out any disturb from other
subsystem, and I also found it's hard to test scheduler optimize
patch, since the improvement could be easily eaten by other
subsystem like IO.

So Let's check the tools we have currently:
1. perf sched

	we can use it to trace the threads we interested, and
	the info it provided is very good, but one issue is,
	it could not create the workload we want, also collect
	the info and do summary is not so easy.

2. linsched

	It's a very good tool to create the test environment,
	but it's implementation is to ideal, so it could not
	present the real world problem.

Since both perf and linsched could not meet our requirement, we
decided to develop a new tool, let's currently call it
scheduler test module(STM).

It's propose is:
1. create the workload we want.
2. test the pure scheduler.
3. collect info we need and do summary.

This tool should be very easy to use and not depends on
the implementation of scheduler.

We can use it to check the pure scheduler performance on
our system.

We can use it to check whether there are regression in 
scheduler when testing patches.

And other usage I've not figure out yet.

In order to explain the idea more directly, I have wrote a
prototype STM, it's a separate module, and you can use it
just like 'rcutorture'.

I attached a small script 'play.sh' to help you easily
run the test, put 'schedtm.c' and 'play.sh' in same directory
and run 'play.sh', you will see out put like:

schedtm: summary
schedtm: 	cpu count:	cpu	run	preempt
schedtm: 			0	1381	1381
schedtm: 			1	957	955
schedtm: 			2	900	900
schedtm: 			3	1035	1034
schedtm: 			4	991	990
schedtm: 			5	940	939
schedtm: 			6	900	897
schedtm: 			7	942	948
schedtm: 			8	852	850
schedtm: 			9	931	938
schedtm: 			10	936	934
schedtm: 			11	951	950
schedtm: 	total time(us):	10138172
schedtm: 	run time(us):	5055223(49.86%)
schedtm: 	wait time(us):	5082949
schedtm: 	latency(us):	10489
schedtm: stmt22 got highest run time 5604941(+10%)
schedtm: stmt3 got lowest run time 4852057(-4%)
schedtm: stmt12 got highest latency 11482(+9%)
schedtm: stmt0 got lowest latency 7561(-27%)

And you can enable/disable CONFIG_PREEMPT to see magnificent
change on latency.

This is nothing but a demo, and please "RUN IT ON A TEST MACHINE"...

It will create 24 kernel threads and run 10 seconds, you can change
it by module param.

I will be appreciate if I could get some feedback from the scheduler
experts like you, whatever you think it's good or junk, please let
me know :)

Regards,
Michael Wang



play.sh:

DURATION=10
NORMAL_THREADS=24
PERIOD=10

make clean
make
insmod ./schedtm.ko normalnr=$NORMAL_THREADS period=$PERIOD
sleep $DURATION
rmmod ./schedtm.ko
dmesg | grep schedtm

schedtm.c:

/*
 * scheduler test module
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Copyright (C) IBM Corporation, 2012
 *
 * Authors: Michael Wang <wangyun@linux.vnet.ibm.com>
 *
 */
#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/slab.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Michael Wang <wangyun@linux.vnet.ibm.com>");

#define pr_schedtm(fmt, ...)				\
	do {						\
		pr_alert("schedtm: ");			\
		printk(pr_fmt(fmt), ##__VA_ARGS__);	\
	} while (0)

struct schedtm_data {
	struct task_struct *t;
	unsigned long run_count[NR_CPUS];
	unsigned long preempt_count[NR_CPUS];
	unsigned long start_time;
	unsigned long total_time;
	unsigned long wait_time;
	unsigned long run_time;
	unsigned long run_time_tmp;
	unsigned long latency;
	unsigned long latency_tmp;
	unsigned long latency_count;
	struct list_head list;
	struct preempt_notifier pn;
};

LIST_HEAD(schedtm_data_list);
static struct schedtm_data *highest_run_time;
static struct schedtm_data *lowest_run_time;
static struct schedtm_data *highest_latency;
static struct schedtm_data *lowest_latency;

static unsigned int normalnr = 1;
static unsigned int period = 10;

module_param(normalnr, uint, 0444);
MODULE_PARM_DESC(normalnr, "Number of normal threads");

module_param(period, uint, 0444);
MODULE_PARM_DESC(period, "Running period in jiffies");

void schedtm_sched_in(struct preempt_notifier *pn, int cpu)
{
	struct schedtm_data *data  = container_of(pn, struct schedtm_data, pn);
	WARN_ON(data->t != current);

	data->run_time_tmp = ktime_to_us(ktime_get());
	data->latency += ktime_to_us(ktime_get()) - data->latency_tmp;
	data->latency_count++;
	data->run_count[cpu]++;
}

void schedtm_sched_out(struct preempt_notifier *pn, struct task_struct *next)
{
	int cpu = smp_processor_id();
	struct schedtm_data *data  = container_of(pn, struct schedtm_data, pn);
	WARN_ON(data->t != current);

	data->run_time += ktime_to_us(ktime_get()) - data->run_time_tmp;
	data->latency_tmp = ktime_to_us(ktime_get());
	data->preempt_count[cpu]++;
}

struct preempt_ops schedtm_po = {
	.sched_in = schedtm_sched_in,
	.sched_out = schedtm_sched_out,
};

static int schedtm_thread_fn(void *arg)
{
	struct schedtm_data *data = (struct schedtm_data *)arg;
	unsigned long checkp = jiffies;

	data->start_time = ktime_to_us(ktime_get());
	data->run_time_tmp = ktime_to_us(ktime_get());
	data->pn.ops = &schedtm_po;
	preempt_notifier_register(&data->pn);

	do {
		WARN_ON(current != data->t);
		if (jiffies - checkp > period) {
			checkp = jiffies;
			schedule();
		}
	} while (!kthread_should_stop());

	preempt_notifier_unregister(&data->pn);
	data->total_time = ktime_to_us(ktime_get()) - data->start_time;
	data->wait_time = data->total_time - data->run_time;
	data->latency = data->latency / (data->latency_count + 1);

	return 0;
}

static void schedtm_report_cpu(struct schedtm_data *data)
{
	int cpu = 0;

	pr_schedtm("\tcpu count:\tcpu\trun\tpreempt\n");

	for_each_online_cpu(cpu) {
		pr_schedtm("\t\t\t%d\t%ld\t%ld\n", cpu,
				data->run_count[cpu],
				data->preempt_count[cpu]);
	}
}

static void schedtm_print_time(unsigned long us)
{
/*
	unsigned long s = us / 1000000;
	unsigned long ms = (us - s * 1000000) / 1000;
	us = us - s * 1000000 - ms * 1000;
	pr_schedtm("\t\t\t%lds%ldms%ldus\n", s, ms, us);
*/
}

static void schedtm_report_run(struct schedtm_data *data)
{
	unsigned long rp = (10000 * data->run_time) / (data->total_time + 1);
	unsigned long rpa = rp / 100;
	unsigned long rpb = rp - rpa * 100;

	pr_schedtm("\ttotal time(us):\t%ld\n", data->total_time);
	schedtm_print_time(data->total_time);

	pr_schedtm("\trun time(us):\t%ld(%ld.%ld%%)\n",
						data->run_time, rpa, rpb);
	schedtm_print_time(data->run_time);

	pr_schedtm("\twait time(us):\t%ld\n", data->wait_time);
	schedtm_print_time(data->wait_time);
}

static void schedtm_report_latency(struct schedtm_data *data)
{
	pr_schedtm("\tlatency(us):\t%ld\n", data->latency);
	schedtm_print_time(data->latency);
}

static void schedtm_report_all(void)
{
/*
	struct schedtm_data *data = NULL;
	list_for_each_entry(data, &schedtm_data_list, list) {
		pr_schedtm("%s\n", data->t->comm);

		schedtm_report_cpu(data);
		schedtm_report_run(data);
		schedtm_report_latency(data);
	}
*/
}

static void schedtm_summary_calculate(struct schedtm_data *summary)
{
	int cpu = 0;
	struct schedtm_data *data = NULL;

	list_for_each_entry(data, &schedtm_data_list, list) {
		for_each_online_cpu(cpu) {
			summary->run_count[cpu] += data->run_count[cpu];
			summary->preempt_count[cpu] += data->preempt_count[cpu];
		}

		summary->total_time += data->total_time;
		summary->run_time += data->run_time;
		summary->wait_time += data->wait_time;
		summary->latency += data->latency;

		if (!highest_run_time ||
				highest_run_time->run_time < data->run_time)
			highest_run_time = data;
		if (!lowest_run_time ||
				lowest_run_time->run_time > data->run_time)
			lowest_run_time = data;
		if (!highest_latency ||
				highest_latency->latency < data->latency)
			highest_latency = data;
		if (!lowest_latency ||
				lowest_latency->latency > data->latency)
			lowest_latency = data;
	}

	summary->total_time /= normalnr;
	summary->run_time /= normalnr;
	summary->wait_time /= normalnr;
	summary->latency /= normalnr;
}

static void schedtm_report_special(struct schedtm_data *summary)
{
	pr_schedtm("%s got highest run time %ld(+%ld%%)\n",
					highest_run_time->t->comm,
					highest_run_time->run_time,
		(100 * (highest_run_time->run_time - summary->run_time))
						/ (summary->run_time + 1));

	pr_schedtm("%s got lowest run time %ld(-%ld%%)\n",
					lowest_run_time->t->comm,
					lowest_run_time->run_time,
		(100 * (summary->run_time - lowest_run_time->run_time))
						/ (summary->run_time + 1));

	pr_schedtm("%s got highest latency %ld(+%ld%%)\n",
					highest_latency->t->comm,
					highest_latency->latency,
		(100 * (highest_latency->latency - summary->latency))
						/ (summary->latency + 1));

	pr_schedtm("%s got lowest latency %ld(-%ld%%)\n",
					lowest_latency->t->comm,
					lowest_latency->latency,
		(100 * (summary->latency - lowest_latency->latency))
						/ (summary->latency + 1));
}

static void schedtm_summary_all(void)
{
	struct schedtm_data *summary =
			kzalloc(sizeof(struct schedtm_data), GFP_KERNEL);
	if (!summary) {
		pr_schedtm("failed to summary\n");
		return;
	}

	schedtm_summary_calculate(summary);

	pr_schedtm("summary\n");

	schedtm_report_cpu(summary);
	schedtm_report_run(summary);
	schedtm_report_latency(summary);
	schedtm_report_special(summary);

	kfree(summary);
}

static int schedtm_succeed(void)
{
	int threadnr = 0;
	struct schedtm_data *data = NULL;

	list_for_each_entry(data, &schedtm_data_list, list) {
		kthread_stop(data->t);
		threadnr++;
	}

	return threadnr == normalnr;
}

static void schedtm_exit(void)
{
	struct schedtm_data *data = NULL;

	if (schedtm_succeed()) {
		schedtm_report_all();
		schedtm_summary_all();
	}

	list_for_each_entry(data, &schedtm_data_list, list)
		kfree(data);

	pr_schedtm("scheduler test module off\n");
}

static int __init schedtm_check_param(void)
{
	if (normalnr == 0) {
		pr_schedtm("illegal normalnr %d\n", normalnr);
		return 0;
	}

	if (normalnr >= nr_cpu_ids * 100) {
		pr_schedtm("too big normalnr %d for %d cpu system\n",
						normalnr, nr_cpu_ids);
		return 0;
	}

#ifndef CONFIG_PREEMPT
	if (period >= 100) {
		pr_schedtm("too big period %d for none kernel-preempt system\n",
						period);
		return 0;
	}
#endif

	return 1;
}

static int __init schedtm_init(void)
{
	int threadnr = normalnr;
	struct schedtm_data *data = NULL;

	if (!schedtm_check_param())
		return -EAGAIN;

	pr_schedtm("scheduler test module on\n");

	while (threadnr--) {
		data = kzalloc(sizeof(struct schedtm_data), GFP_KERNEL);
		if (!data)
			goto failed;

		data->t = kthread_create(schedtm_thread_fn, data,
					"stmt%d", threadnr);
		if (!data->t) {
			kfree(data);
			goto failed;
		}

		list_add_tail(&data->list, &schedtm_data_list);
	}

	list_for_each_entry(data, &schedtm_data_list, list)
		wake_up_process(data->t);

	return 0;

failed:
	list_for_each_entry(data, &schedtm_data_list, list) {
		kthread_stop(data->t);
		kfree(data);
	}

	return -ENOMEM;
}

module_init(schedtm_init);
module_exit(schedtm_exit);


--------------010405040505010608020702
Content-Type: text/x-csrc;
 name="schedtm.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="schedtm.c"

/*
 * scheduler test module
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Copyright (C) IBM Corporation, 2012
 *
 * Authors: Michael Wang <wangyun@linux.vnet.ibm.com>
 *
 */
#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/slab.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Michael Wang <wangyun@linux.vnet.ibm.com>");

#define pr_schedtm(fmt, ...)				\
	do {						\
		pr_alert("schedtm: ");			\
		printk(pr_fmt(fmt), ##__VA_ARGS__);	\
	} while (0)

struct schedtm_data {
	struct task_struct *t;
	unsigned long run_count[NR_CPUS];
	unsigned long preempt_count[NR_CPUS];
	unsigned long start_time;
	unsigned long total_time;
	unsigned long wait_time;
	unsigned long run_time;
	unsigned long run_time_tmp;
	unsigned long latency;
	unsigned long latency_tmp;
	unsigned long latency_count;
	struct list_head list;
	struct preempt_notifier pn;
};

LIST_HEAD(schedtm_data_list);
static struct schedtm_data *highest_run_time;
static struct schedtm_data *lowest_run_time;
static struct schedtm_data *highest_latency;
static struct schedtm_data *lowest_latency;

static unsigned int normalnr = 1;
static unsigned int period = 10;

module_param(normalnr, uint, 0444);
MODULE_PARM_DESC(normalnr, "Number of normal threads");

module_param(period, uint, 0444);
MODULE_PARM_DESC(period, "Running period in jiffies");

void schedtm_sched_in(struct preempt_notifier *pn, int cpu)
{
	struct schedtm_data *data  = container_of(pn, struct schedtm_data, pn);
	WARN_ON(data->t != current);

	data->run_time_tmp = ktime_to_us(ktime_get());
	data->latency += ktime_to_us(ktime_get()) - data->latency_tmp;
	data->latency_count++;
	data->run_count[cpu]++;
}

void schedtm_sched_out(struct preempt_notifier *pn, struct task_struct *next)
{
	int cpu = smp_processor_id();
	struct schedtm_data *data  = container_of(pn, struct schedtm_data, pn);
	WARN_ON(data->t != current);

	data->run_time += ktime_to_us(ktime_get()) - data->run_time_tmp;
	data->latency_tmp = ktime_to_us(ktime_get());
	data->preempt_count[cpu]++;
}

struct preempt_ops schedtm_po = {
	.sched_in = schedtm_sched_in,
	.sched_out = schedtm_sched_out,
};

static int schedtm_thread_fn(void *arg)
{
	struct schedtm_data *data = (struct schedtm_data *)arg;
	unsigned long checkp = jiffies;

	data->start_time = ktime_to_us(ktime_get());
	data->run_time_tmp = ktime_to_us(ktime_get());
	data->pn.ops = &schedtm_po;
	preempt_notifier_register(&data->pn);

	do {
		WARN_ON(current != data->t);
		if (jiffies - checkp > period) {
			checkp = jiffies;
			schedule();
		}
	} while (!kthread_should_stop());

	preempt_notifier_unregister(&data->pn);
	data->total_time = ktime_to_us(ktime_get()) - data->start_time;
	data->wait_time = data->total_time - data->run_time;
	data->latency = data->latency / (data->latency_count + 1);

	return 0;
}

static void schedtm_report_cpu(struct schedtm_data *data)
{
	int cpu = 0;

	pr_schedtm("\tcpu count:\tcpu\trun\tpreempt\n");

	for_each_online_cpu(cpu) {
		pr_schedtm("\t\t\t%d\t%ld\t%ld\n", cpu,
				data->run_count[cpu],
				data->preempt_count[cpu]);
	}
}

static void schedtm_print_time(unsigned long us)
{
/*
	unsigned long s = us / 1000000;
	unsigned long ms = (us - s * 1000000) / 1000;
	us = us - s * 1000000 - ms * 1000;
	pr_schedtm("\t\t\t%lds%ldms%ldus\n", s, ms, us);
*/
}

static void schedtm_report_run(struct schedtm_data *data)
{
	unsigned long rp = (10000 * data->run_time) / (data->total_time + 1);
	unsigned long rpa = rp / 100;
	unsigned long rpb = rp - rpa * 100;

	pr_schedtm("\ttotal time(us):\t%ld\n", data->total_time);
	schedtm_print_time(data->total_time);

	pr_schedtm("\trun time(us):\t%ld(%ld.%ld%%)\n",
						data->run_time, rpa, rpb);
	schedtm_print_time(data->run_time);

	pr_schedtm("\twait time(us):\t%ld\n", data->wait_time);
	schedtm_print_time(data->wait_time);
}

static void schedtm_report_latency(struct schedtm_data *data)
{
	pr_schedtm("\tlatency(us):\t%ld\n", data->latency);
	schedtm_print_time(data->latency);
}

static void schedtm_report_all(void)
{
/*
	struct schedtm_data *data = NULL;
	list_for_each_entry(data, &schedtm_data_list, list) {
		pr_schedtm("%s\n", data->t->comm);

		schedtm_report_cpu(data);
		schedtm_report_run(data);
		schedtm_report_latency(data);
	}
*/
}

static void schedtm_summary_calculate(struct schedtm_data *summary)
{
	int cpu = 0;
	struct schedtm_data *data = NULL;

	list_for_each_entry(data, &schedtm_data_list, list) {
		for_each_online_cpu(cpu) {
			summary->run_count[cpu] += data->run_count[cpu];
			summary->preempt_count[cpu] += data->preempt_count[cpu];
		}

		summary->total_time += data->total_time;
		summary->run_time += data->run_time;
		summary->wait_time += data->wait_time;
		summary->latency += data->latency;

		if (!highest_run_time ||
				highest_run_time->run_time < data->run_time)
			highest_run_time = data;
		if (!lowest_run_time ||
				lowest_run_time->run_time > data->run_time)
			lowest_run_time = data;
		if (!highest_latency ||
				highest_latency->latency < data->latency)
			highest_latency = data;
		if (!lowest_latency ||
				lowest_latency->latency > data->latency)
			lowest_latency = data;
	}

	summary->total_time /= normalnr;
	summary->run_time /= normalnr;
	summary->wait_time /= normalnr;
	summary->latency /= normalnr;
}

static void schedtm_report_special(struct schedtm_data *summary)
{
	pr_schedtm("%s got highest run time %ld(+%ld%%)\n",
					highest_run_time->t->comm,
					highest_run_time->run_time,
		(100 * (highest_run_time->run_time - summary->run_time))
						/ (summary->run_time + 1));

	pr_schedtm("%s got lowest run time %ld(-%ld%%)\n",
					lowest_run_time->t->comm,
					lowest_run_time->run_time,
		(100 * (summary->run_time - lowest_run_time->run_time))
						/ (summary->run_time + 1));

	pr_schedtm("%s got highest latency %ld(+%ld%%)\n",
					highest_latency->t->comm,
					highest_latency->latency,
		(100 * (highest_latency->latency - summary->latency))
						/ (summary->latency + 1));

	pr_schedtm("%s got lowest latency %ld(-%ld%%)\n",
					lowest_latency->t->comm,
					lowest_latency->latency,
		(100 * (summary->latency - lowest_latency->latency))
						/ (summary->latency + 1));
}

static void schedtm_summary_all(void)
{
	struct schedtm_data *summary =
			kzalloc(sizeof(struct schedtm_data), GFP_KERNEL);
	if (!summary) {
		pr_schedtm("failed to summary\n");
		return;
	}

	schedtm_summary_calculate(summary);

	pr_schedtm("summary\n");

	schedtm_report_cpu(summary);
	schedtm_report_run(summary);
	schedtm_report_latency(summary);
	schedtm_report_special(summary);

	kfree(summary);
}

static int schedtm_succeed(void)
{
	int threadnr = 0;
	struct schedtm_data *data = NULL;

	list_for_each_entry(data, &schedtm_data_list, list) {
		kthread_stop(data->t);
		threadnr++;
	}

	return threadnr == normalnr;
}

static void schedtm_exit(void)
{
	struct schedtm_data *data = NULL;

	if (schedtm_succeed()) {
		schedtm_report_all();
		schedtm_summary_all();
	}

	list_for_each_entry(data, &schedtm_data_list, list)
		kfree(data);

	pr_schedtm("scheduler test module off\n");
}

static int __init schedtm_check_param(void)
{
	if (normalnr == 0) {
		pr_schedtm("illegal normalnr %d\n", normalnr);
		return 0;
	}

	if (normalnr >= nr_cpu_ids * 100) {
		pr_schedtm("too big normalnr %d for %d cpu system\n",
						normalnr, nr_cpu_ids);
		return 0;
	}

#ifndef CONFIG_PREEMPT
	if (period >= 100) {
		pr_schedtm("too big period %d for none kernel-preempt system\n",
						period);
		return 0;
	}
#endif

	return 1;
}

static int __init schedtm_init(void)
{
	int threadnr = normalnr;
	struct schedtm_data *data = NULL;

	if (!schedtm_check_param())
		return -EAGAIN;

	pr_schedtm("scheduler test module on\n");

	while (threadnr--) {
		data = kzalloc(sizeof(struct schedtm_data), GFP_KERNEL);
		if (!data)
			goto failed;

		data->t = kthread_create(schedtm_thread_fn, data,
					"stmt%d", threadnr);
		if (!data->t) {
			kfree(data);
			goto failed;
		}

		list_add_tail(&data->list, &schedtm_data_list);
	}

	list_for_each_entry(data, &schedtm_data_list, list)
		wake_up_process(data->t);

	return 0;

failed:
	list_for_each_entry(data, &schedtm_data_list, list) {
		kthread_stop(data->t);
		kfree(data);
	}

	return -ENOMEM;
}

module_init(schedtm_init);
module_exit(schedtm_exit);

--------------010405040505010608020702
Content-Type: application/x-shellscript;
 name="play.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="play.sh"

RFVSQVRJT049MTAKTk9STUFMX1RIUkVBRFM9MjQKUEVSSU9EPTEwCgptYWtlIGNsZWFuCm1h
a2UKaW5zbW9kIC4vc2NoZWR0bS5rbyBub3JtYWxucj0kTk9STUFMX1RIUkVBRFMgcGVyaW9k
PSRQRVJJT0QKc2xlZXAgJERVUkFUSU9OCnJtbW9kIC4vc2NoZWR0bS5rbwpkbWVzZyB8IGdy
ZXAgc2NoZWR0bQo=
--------------010405040505010608020702--

