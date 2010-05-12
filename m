Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0ELDYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:24:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42707 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0ELDWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:22:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=CjVKgTFavWyO2f/a6LIw/sRCdoTaWsy4fyCLcNSanVwjxCQGHbkd9R0nD9/rwREm6
	LrGdx7xR3CaRyM7hxRxMg==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 00/12] rwsem changes + down_read_unfair() proposal
Date: Tue, 11 May 2010 20:20:50 -0700
Message-Id: <1273634462-2672-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to sollicit comments regarding the following changes
against 2.6.34-rc7. The motivation for this change was some cluster
monitoring software we use at google; which reads /proc/<pid>/maps files
for all running processes. When the machines are under load, the mmap_sem
is often acquire for reads for long periods of time since do_page_fault()
holds it while doing disk accesses; and fair queueing behavior often ends
up in the monitoring software making little progress. By introducing unfair
behavior in a few selected places, are are able to let the monitoring
software make progress without impacting performance for the rest of
the system.

In general, I've made sure to implement this proposal without touching the
rwsem fast paths. Also, the first 8 patches of this series should be of
general applicability even if not taking the down_read_unfair() changes,
addressing minor issues such as situations where reader threads can get
blocked at the head of the waiting list even though the rwsem is currently
owned for reads.

Michel Lespinasse (12):
  rwsem: test for no active locks in __rwsem_do_wake undo code
  rwsem: use single atomic update for sem count when waking up readers
  rwsem: let RWSEM_WAITING_BIAS represent any number of waiting threads
  rwsem: consistently use adjustment variable
  x86 rwsem: take advantage of new RWSEM_WAITING_BIAS semantics
  rwsem: wake queued readers when other readers are active
  rwsem: wake queued readers when writer blocks on active read lock
  rwsem: smaller wrappers around rwsem_down_failed_common
  generic rwsem: implement down_read_unfair
  rwsem: down_read_unfair infrastructure support
  x86 rwsem: down_read_unfair implementation
  Use down_read_unfair() for /sys/<pid>/exe and /sys/<pid>/maps files

 arch/x86/include/asm/rwsem.h   |   66 ++++++++++++++-----
 arch/x86/lib/rwsem_64.S        |   14 +++-
 arch/x86/lib/semaphore_32.S    |   21 +++++-
 fs/proc/base.c                 |    2 +-
 fs/proc/task_mmu.c             |    2 +-
 fs/proc/task_nommu.c           |    2 +-
 include/linux/rwsem-spinlock.h |   10 +++-
 include/linux/rwsem.h          |   10 +++
 kernel/rwsem.c                 |   17 +++++
 lib/rwsem-spinlock.c           |   10 ++-
 lib/rwsem.c                    |  145 ++++++++++++++++++++++++---------------
 11 files changed, 213 insertions(+), 86 deletions(-)


Also following here is the down_read_unfair.c test mentionned in
last patch of the series:

#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

struct thread_data {
	unsigned long count_A, count_B, count_C;
	int done;
	int pid;
	char *mapped;
	unsigned long mapped_size;
	int dummy;
	int barrier_count;
	pthread_mutex_t barrier_mutex;
	pthread_cond_t barrier_cond;
};

static void barrier(struct thread_data *data)
{
	pthread_mutex_lock(&data->barrier_mutex);
	if (--(data->barrier_count) == 0)
		pthread_cond_broadcast(&data->barrier_cond);
	while (data->barrier_count)
		pthread_cond_wait(&data->barrier_cond, &data->barrier_mutex);
	pthread_mutex_unlock(&data->barrier_mutex);
}

static void *func_A(void *tmp)
{
	int dummy = 0;
	struct thread_data *data = tmp;

	srand48(time(NULL));
        barrier(data);

	while (!data->done) {
		unsigned long pos = (lrand48() << 31) | lrand48();
		dummy += data->mapped[pos % data->mapped_size];
		data->count_A++;
        }

	data->dummy = dummy;
	return NULL;
}

static void *func_B(void *tmp)
{
	char *dummy;
	struct thread_data *data = tmp;

        barrier(data);

	while (!data->done) {
		dummy = mmap(NULL, 1, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS,
			     -1, 0);
		if (dummy == MAP_FAILED || munmap(dummy, 1)) break;
		data->count_B++;
	}

	return NULL;
}

static void *func_C(void *tmp)
{
	char procfile[64];
	struct thread_data *data = tmp;
	int fd, size;
	char buf[4096];

	size = sprintf(procfile, "/proc/%d/maps", data->pid);
        barrier(data);
	if (size < 0) return NULL;

	while (!data->done) {
		fd = open(procfile, O_RDONLY);
		if (fd < 0) break;
		do {
			size = read(fd, buf, sizeof buf);
		} while (size == sizeof buf);
		if (close(fd) || size < 0) break;
		data->count_C++;
	}

	return NULL;
}

int main(int argc, char **argv)
{
	int fd;
	struct stat sb;
        char *mapped;
	struct thread_data data;
	pthread_t thread_A, thread_B, thread_C;

	if (argc != 2) {
		fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
		exit(1);
	}

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "open %s: %s\n", argv[1], strerror(errno));
		exit(1);
	}
	if (fstat(fd, &sb) < 0) {
		fprintf(stderr, "fstat: %s\n", strerror(errno));
		exit(1);
	}
        mapped = mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
        if (mapped == MAP_FAILED) {
		fprintf(stderr, "mmap: %s\n", strerror(errno));
		exit(1);
        }
	if (close(fd)) {
		fprintf(stderr, "close: %s\n", strerror(errno));
		exit(1);
	}

	data.count_A = data.count_B = data.count_C = 0;
	data.done = 0;
	data.pid = getpid();
	data.mapped = mapped;
	data.mapped_size = sb.st_size;
	data.dummy = 0;
	data.barrier_count = 4;
        if (pthread_mutex_init(&data.barrier_mutex, NULL) ||
            pthread_cond_init(&data.barrier_cond, NULL)) {
		fprintf(stderr, "pthread_*_init: %s\n", strerror(errno));
		exit(1);
        }

	if (pthread_create(&thread_A, NULL, func_A, &data) ||
	    pthread_create(&thread_B, NULL, func_B, &data) ||
	    pthread_create(&thread_C, NULL, func_C, &data)) {
		fprintf(stderr, "pthread_create: %s\n", strerror(errno));
                exit(1);
	}
        barrier(&data);
	sleep(10);
	data.done = 1;
	if (pthread_join(thread_A, NULL) ||
	    pthread_join(thread_B, NULL) ||
	    pthread_join(thread_C, NULL)) {
		fprintf(stderr, "pthread_join: %s\n", strerror(errno));
	}
	printf ("Counts: %lu A, %lu B, %lu C\n",
		data.count_A, data.count_B, data.count_C);
	return 0;
}
