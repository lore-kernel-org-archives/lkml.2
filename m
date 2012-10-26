Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2JZCfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 22:35:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33839 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2JZCfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 22:35:38 -0400
MIME-Version: 1.0
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
Date: Fri, 26 Oct 2012 08:05:36 +0530
Message-ID: <CAM4v1pP2V9Rc9jQkEmsb5D-Mvq73naBj6BJq5Y+eWQNt1v08OA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] sched: Integrating Per-entity-load-tracking
 with the core scheduler
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The benchmark:

/*
 * test.c - Simulate workloads that load the CPU differently
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

/*
 * This workload spawns threads which request for allocation of a
 * memory chunk,write to it and free it.The duty cycle of these threads
 * can be varied.The idea is to simulate tasks which load the cpu
 * to different extents.
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

    /* The below two parameters ensure that it is 10% workload
     * with a duty cycle of 10ms.The number of records read in
     * 1s without sleep was observed and appropriately calculated
     * for 1ms.This number turned out to be 1228.
     */
    sleep_at = 1228; /* sleep for every 1228 records */
    sleep_interval = 9000; /* sleep for 9 ms */

    for (i=0; start == 1; i++)
    {
        scratch_pad = (mem_slot_t *)malloc(mem_chunk_size);
        if (scratch_pad == NULL) {
            fprintf(stderr,"Could not allocate memory\n");
            exit(1);
        }
        end = scratch_pad + (mem_chunk_size / slot_size);
        for (temp = scratch_pad, j=0; temp < end; temp++, j++)
            *temp = (mem_slot_t)j;

        free(scratch_pad);

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

Regards
Preeti U Murthy
