Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2LDIRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:17:40 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41671 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2LDIRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:17:39 -0500
Message-ID: <50BDB174.9070405@linux.vnet.ibm.com>
Date: Tue, 04 Dec 2012 13:46:52 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC v2 PATCH 0/2] sched: Integrating Per-entity-load-tracking
 with the core scheduler
References: <20121115164730.17426.36051.stgit@preeti.in.ibm.com>
In-Reply-To: <20121115164730.17426.36051.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120408-5564-0000-0000-000005A039B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone

I conducted a few experiments with a workload to compare the following
parameters with this patchset and without this patchset:
1.The performance of the workload
2.The sum of the waitime to run of the processes queued on each cpu-the
  cumulative latency.
3.The number of migrations of tasks between cpus.

Experimental setup:
1.The workload is at the end of the mail.Every run of the workload was for
  10s.
2.Different number of long running and short running threads were run.
3.The setup was on a two socket Pre-Nehalam machine,but one socket had all its cpus
  offlined.Thus only one socket was active throughout the experiment.The socket
  consisted of 4 cores.
4.The statistics below have been collected from /proc/schedstats except
  throughput which is output by the workload.
  -Latency has been observed from the eighth field in the cpu statistics
   in /proc/schedstat
   cpu<N> 1 2 3 4 5 6 7 "8" 9
  -Number of migrations has been calculated by summing up the #pulls during
   the idle,busy and newly_idle states of all the cpus.This is also given by
   /proc/schedstats

5.FieldA->#short-running-tasks [For every 10ms passed sleep for 9ms,work for
  1ms]-10% task.
  FieldB->#long-running-tasks
  Field1->Throughput with patch (records/s read)
  Field2->Throughput without patch (records/s read)
  Field3->#Pull tasks with patch
  Field4->#Pull tasks without patch
  Field5->Latency with patch
  Field6->Latency without patch

    A     B	  1             2	  3	  4       5        6
------------------------------------------------------------------------------
    5     5    49,93,368    48,68,351    108      28      22s     18.3s
    4     2    34,37,669    34,37,547     58      50       0.6s    0.17s
   16     0    38,66,597    38,74,580   1151    1014       1.88s   1.65s

*Inferences*:
1.Clearly an increase in the number of pulls can be seen with this patch,this
  has resulted in an increase in the latency.This *should have* resulted in a
  decrease in throughput but in the first two cases this is not reflected.This
  could be due to some error in the benchmark itself or the way I am calculating
  the throughput.Keeping this issue aside,I focus on the #pulls and latency effect.

2.On integrating PJT's metric with the load balancer,#pulls/#Migrations
  increase due to the following reason, which I figured out by going through the
  traces.

 					Task1		Task3
					Task2		Task4
					------		------
					Group1		Group2

  Case1:Load_as_per_pjt			1028		1121
  Case2:Load_without_pjt		2048		2048

						Fig1.

  During load balancing
  Case1: Group2 is overloaded,one of the tasks is moved to Group1
  Case2: Group1 and Group2 are equally loaded,hence no migrations

  This is observed so many times,that it is no wonder that the #migrations have
  increased with this patch.Here Group refers to sched_group.

3.The next obvious step was be to see if so many migrations with my patch is
  prudent or not.The latency numbers reflect that it is not.

4.As I said earlier,I keep throughput out of these inferences because it
  distracts us from something that is stark clear
  *Migrations incurred due to PJT's metric is not affecting the tasks
   positively.*

5.The above is my first observation.This does not however say that using PJT's
  metric with the load balancer might be a bad idea.This could mean many things
  out which the correct one has to be figured out.Among them I list out a few.

  a)Simply replacing the existing metric used by Load Balancer with PJT's
    metric might not really derive the benefit that PJT's metric has to offer.
  b)I have not been able to figure out what kind of workloads actually
    benefit from the way we have applied the PJT's metric.Maybe we are using
    a workload which is adversely getting affected.

6.My next step in my opinion will be to resolve the following issues in the
  decreasing order of priority:

  a)Run some other benchmark like kernbench and find out if the
    throughput reflects increase in latency correctly.If it does,then I will need
    to find out why the current benchmark was behaving weird,else I will need to
    go through the traces to figure out this issue.
  b)If I find out that the throughput is consistent with the latency,then we need
    to modify the strictness(the granularity of time at which the load is
    getting updated) with which PJT's metric is calculating load,or use it
    in some other way in load balancing.

Looking forward to your feedback on this :)

--------------------------BEGIN WORKLOAD---------------------------------
/*
 * test.c - Two instances of this program is run.One instance where sleep
 * time is 0 and another instance which sleeps between regular instances
 * of time.This is done to create both long running and short running tasks
 * on the cpu.
 *
 * Multiple threads are created of each instance.The threads request for a
 * memory chunk,write into it and then free it.This is done throughout the
 * period of the run.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
 * USA
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <sys/resource.h>
#include "malloc.h"

/* Variable entities */
static unsigned int seconds;
static unsigned int threads;
static unsigned int mem_chunk_size;
static unsigned int sleep_at;
static unsigned int sleep_interval;


/* Fixed entities */
typedef size_t mem_slot_t;/* 8 bytes */
static unsigned int slot_size = sizeof(mem_slot_t);

/* Other parameters */
static volatile int start;
static time_t start_time;
static unsigned int records_read;
pthread_mutex_t records_count_lock = PTHREAD_MUTEX_INITIALIZER;


static unsigned int write_to_mem(void)
{
	int i, j;
	mem_slot_t *scratch_pad, *temp;
	mem_chunk_size = slot_size * 256;
	mem_slot_t *end;
	sleep_at = 0; /* sleep for every 2800 records */
	sleep_interval = 9000; /* sleep for 9 ms */

	for (i=0; start == 1; i++)
	{
		/* ask for a memory chunk */
		scratch_pad = (mem_slot_t *)malloc(mem_chunk_size);
		if (scratch_pad == NULL) {
			fprintf(stderr,"Could not allocate memory\n");
			exit(1);
		}
		end = scratch_pad + (mem_chunk_size / slot_size);
		/* write into this chunk */
		for (temp = scratch_pad, j=0; temp < end; temp++, j++)
			*temp = (mem_slot_t)j;

		/* Free this chunk */
		free(scratch_pad);

		/* Decide the duty cycle;currently 10 ms */
		if (sleep_at && !(i % sleep_at))
			usleep(sleep_interval);

	}
	return (i);
}

static void *
thread_run(void *arg)
{

	unsigned int records_local;

	/* Wait for the start signal */

	while (start == 0);

	records_local = write_to_mem();

	pthread_mutex_lock(&records_count_lock);
	records_read += records_local;
	pthread_mutex_unlock(&records_count_lock);

	return NULL;
}

static void start_threads()
{
	double diff_time;
	unsigned int i;
	int err;
	threads = 8;
	seconds = 10;

	pthread_t thread_array[threads];
	for (i = 0; i < threads; i++) {
		err = pthread_create(&thread_array[i], NULL, thread_run, NULL);
		if (err) {
			fprintf(stderr, "Error creating thread %d\n", i);
			exit(1);
		}
	}
	start_time = time(NULL);
	start = 1;
	sleep(seconds);
	start = 0;
	diff_time = difftime(time(NULL), start_time);

	for (i = 0; i < threads; i++) {
		err = pthread_join(thread_array[i], NULL);
		if (err) {
			fprintf(stderr, "Error joining thread %d\n", i);
			exit(1);
		}
	}
	 printf("%u records/s\n",
		(unsigned int) (((double) records_read)/diff_time));

}
int main()
{
	start_threads();
	return 0;
}

------------------------END WORKLOAD------------------------------------
Regards
Preeti U Murthy


