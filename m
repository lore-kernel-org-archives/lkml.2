Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079Ab1GOIFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:05:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32826 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965024Ab1GOIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 04:05:46 -0400
From: Shan Hai <haishan.bai@gmail.com>
To: benh@kernel.crashing.org, paulus@samba.org
Cc: tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
Date: Fri, 15 Jul 2011 16:07:17 +0800
Message-Id: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following test case could reveal a bug in the futex_lock_pi()

BUG: On FUTEX_LOCK_PI, there is a infinite loop in the futex_lock_pi() 
	on Powerpc e500 core.
Cause: The linux kernel on the e500 core has no write permission on
	the COW page, refer the head comment of the following test code.
 
ftrace on test case:
[000]   353.990181: futex_lock_pi_atomic <-futex_lock_pi
[000]   353.990185: cmpxchg_futex_value_locked <-futex_lock_pi_atomic
[snip]
[000]   353.990191: do_page_fault <-handle_page_fault
[000]   353.990192: bad_page_fault <-handle_page_fault
[000]   353.990193: search_exception_tables <-bad_page_fault
[snip]
[000]   353.990199: get_user_pages <-fault_in_user_writeable
[snip]
[000]   353.990208: mark_page_accessed <-follow_page
[000]   353.990222: futex_lock_pi_atomic <-futex_lock_pi
[snip]
[000]   353.990230: cmpxchg_futex_value_locked <-futex_lock_pi_atomic
[ a loop occures here ]


/* 
 * A test case for revealing an infinite loop in the futex_lock_pi().
 * - there are 2 processes, parent and a child
 * - the parent process allocates and initializes a pthread_mutex MUTEX in a 
 *	shared memory region
 * - the parent process holds the MUTEX and do long time computing
 * - the child process tries to hold the MUTEX during the parent holding it and 
 *	traps into the kernel for waiting on the MUTEX because of contention
 * - the kernel loops in futex_lock_pi()
 * - result of 'top' command reveals that the system usage of CPU is 100%
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/mman.h>

enum { SHM_INIT, SHM_GET };
enum { PARENT, CHILD };

#define FIXED_MMAP_ADDR 0x20000000
#define MMAP_SIZE	0x2000000

static int shmid;
static char shm_name[100];
static int sleep_period = 100000;

void * shmem_init(int flag)
{
	int start = FIXED_MMAP_ADDR;
	int memory_size = MMAP_SIZE;
	int mode = 0666;
	void *addr;
	int ret;

	sprintf(shm_name, "/shmem_1234");

	shmid = shm_open (shm_name, O_RDWR | O_EXCL | O_CREAT | O_TRUNC, mode);

	if (shmid < 0) {
    		if (errno == EEXIST) {
			printf ("shm_open: %s\n", strerror(errno)); 
      			shmid = shm_open (shm_name, O_RDWR, mode);
		} else {
    			printf("failed to shm_open, err=%s\n", strerror(errno));
			return NULL;
  		}
	}

  	ret = fcntl (shmid, F_SETFD, FD_CLOEXEC);
  	if (ret < 0) {
    		printf("fcntl: %s\n", strerror(errno));
		return NULL;
  	}

	ret = ftruncate (shmid, memory_size);
	if (ret < 0) {
    		printf("ftruncate: %s\n", strerror(errno));
		return NULL;
  	}

	addr = mmap ((void *)start, memory_size, PROT_READ | PROT_WRITE, 
			MAP_SHARED | MAP_FIXED, shmid, 0);

  	if (addr == MAP_FAILED) {
		printf ("mmap: %s\n", strerror(errno)); 
    		close (shmid);
    		shm_unlink (shm_name);
		return NULL;
  	}
	
	if (flag == SHM_INIT)
		memset(addr, 0, memory_size);
	
	return (void *)start;
}

pthread_mutex_t * shmem_mutex_init(int flag)
{
	pthread_mutex_t * pmutex = (pthread_mutex_t *)shmem_init(flag);
	pthread_mutexattr_t attr;

	if (flag == SHM_INIT) {
		pthread_mutexattr_init (&attr);
		pthread_mutexattr_setpshared (&attr, PTHREAD_PROCESS_SHARED);
		pthread_mutexattr_setprotocol (&attr, PTHREAD_PRIO_INHERIT);
		pthread_mutexattr_setrobust_np (&attr, 
						PTHREAD_MUTEX_STALLED_NP);
		pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_ERRORCHECK);
		if (pthread_mutex_init (pmutex, &attr) != 0) {
    			printf("Init mutex failed, err=%s\n", strerror(errno));
			pthread_mutexattr_destroy (&attr);
			return NULL;
		}
	}

	return pmutex;
}

void long_running_task(int flag)
{
	static int counter = 0;

	if (flag == PARENT) 
		usleep(5*sleep_period);
	else
		usleep(3*sleep_period);

	counter = (counter + 1) % 100;
	printf("%d: completed %d computing\n", getpid(), counter);
}

void sig_handler(int signum)
{
	close(shmid);
	shm_unlink(shm_name);
	
	exit(0);
}

int main(int argc, char *argv[])
{
	pthread_mutex_t *mutex_parent, *mutex_child;

	signal(SIGUSR1, sig_handler);

	if (fork()) { /* parent process */
		if ((mutex_parent = shmem_mutex_init(SHM_INIT)) == NULL) {
			printf("failed to get the shmem_mutex\n");
			exit(-1);
		}
	
		while (1) {
			printf("%d: try to hold the lock\n", getpid()); 
			pthread_mutex_lock(mutex_parent);
			printf("%d: got the lock\n", getpid()); 
			long_running_task(PARENT);
			pthread_mutex_unlock(mutex_parent);
			printf("%d: released the lock\n", getpid());
		}
	} else { /* child process */
		usleep(sleep_period);
		if ((mutex_child = shmem_mutex_init(SHM_GET)) == NULL) {
			printf("failed to get the shmem_mutex\n");
			exit(-1);
		}
	
		while (1) {
			printf("%d: try to hold the lock\n", getpid()); 
			pthread_mutex_lock(mutex_child);
			printf("%d: got the lock\n", getpid()); 
			long_running_task(CHILD);
			pthread_mutex_unlock(mutex_child);
			printf("%d: released the lock\n", getpid());
		}
	}	

	return 0;
}

---
 arch/powerpc/include/asm/futex.h |   11 ++++++++++-
 arch/powerpc/include/asm/tlb.h   |   25 +++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletions(-)

