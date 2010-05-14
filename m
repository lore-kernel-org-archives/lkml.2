Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab0ENK2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:28:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60036 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758855Ab0ENK2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:28:31 -0400
Message-ID: <4BED2620.2070607@colorfullife.com>
Date: Fri, 14 May 2010 12:29:52 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>
Subject: [CFT] System V sem: test app for comparison with other Unices
Content-Type: multipart/mixed;
 boundary="------------070601010907000406010201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070601010907000406010201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

Attached is a test app that checks three details of the system V 
semaphore implementation:
- is forward progress guaranteed before other tasks are woken up?
- is sem_ctime updated by semctl(SETVAL)?
- is it handled that a "decrease" operation can wake up a task that does 
a wait-for-zero, even if the result of the decrease is not 0?

If I read the available sources correctly, Linux
- implements sem_ctime differently from all other Unices I found.
- tries to implement more (hopefully: all) corner cases with complex 
semops's.

Here is the result of my code review:
http://calculix-rpm.sourceforge.net/sysvsem.html

It would be great if someone with access to e.g. FreeBSD or other Unix 
versions could run it and confirm my review.

Chris, Nick: Btw, Linux is the only implementation that guarantees FIFO 
for semop().

Here is the Linux output:
<<<
   ****************************************
   test1: do a non-trivial sleep
  got semaphore array d0002h.
    SETVAL succeeded.
   IPC_RMID returned 0, errno now 0 (expected: 0, 0).
   Child 0(3636): sys 0.000000, user 0.000000.
   Child 1(3637): sys 0.000000, user 0.000000.
   Child 2(3638): sys 0.000000, user 0.000000.
   Child 3(3639): sys 0.000000, user 0.000000.
   Child 4(3640): sys 0.000000, user 0.000999.
  Total time: sys 0.000999, user 0.000000.
+++ test1 success: No Livelock
  got semaphore array d8002h.
   ****************************************
   test2: does SETVAL update sem_ctime?
    before SETVAL: ctime now 1273832652 (3).
    SETVAL succeeded.
    before SETVAL: ctime now 1273832655 (0).
  INFO: OS updates sem_ctime in semctl(SETVAL)
   ****************************************
   test3: check that kernel wakes up child that waits for non-zero value.
    SETVAL succeeded.
    child completed, before exit: GETVAL now 2.
    parent: after sleep: GETVAL now 2.
    parent: after waitpid: GETVAL now 2.
   +++ test3 success: kernel wakes up child correctly.
   ****************************************
   Done, cleanup.
    IPC_RMID returned 0, errno now 0 (expected: 0, 0).

 >>>

And here opensolaris:
<<<
  ./complexdec
   ****************************************
   test1: do a non-trivial sleep
  got semaphore array 2h.
    SETVAL succeeded.
   IPC_RMID returned 0, errno now 0 (expected: 0, 0).
   Child 0(6815): sys 0.000000, user 4.160000.
   Child 1(6816): sys 0.000000, user 4.160000.
   Child 2(6817): sys 0.000000, user 4.130000.
   Child 3(6818): sys 0.000000, user 4.090000.
   Child 4(6819): sys 0.000000, user 4.080000.
  Total time: sys 20.20620000, user 0.000000.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
test 1 bad: OS should hide in shame, Livelock detected.
  got semaphore array 3h.
   ****************************************
   test2: does SETVAL update sem_ctime?
    before SETVAL: ctime now 1273830869 (3).
    SETVAL succeeded.
    before SETVAL: ctime now 1273830869 (3).
  INFO: OS performs no update to sem_ctime in semctl(SETVAL)
   ****************************************
   test3: check that kernel wakes up child that waits for non-zero value.
    SETVAL succeeded.
    parent: after sleep: GETVAL now 1.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Test 3 bad: got unexpected value (child not woken up?).
   ****************************************
   Done, cleanup.
    IPC_RMID returned 0, errno now 0 (expected: 0, 0).
child: semop failed.

 >>>

--
     Manfred

--------------070601010907000406010201
Content-Type: text/plain;
 name="complexdec.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="complexdec.c"

/*
 * Copyright (C) 1999,2001,2010 by Manfred Spraul.
 * 
 * Redistribution of this file is permitted under the terms of the GNU 
 * General Public License (GPL)
 * $Header: /home/manfred/cvs-tree/manfred/ipcsem/undotest.c,v 1.2 2003/06/28 15:19:43 manfred Exp $
 */

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <assert.h>
#include <signal.h>
#include <time.h>
#include <unistd.h>
#include <pthread.h>
#include <wait.h>

union semun {
	int val;
	struct semid_ds *buf;
	unsigned short int *array;
	struct seminfo* __buf;
};

int getval(char *str, int id)
{
	union semun arg;
	int res;

	res = semctl(id,0,GETVAL,arg);
	if(res==-1) {
		printf("GETVAL failed for %s.\n", str);
		exit(4);
	}
	printf("   %s: GETVAL now %d.\n",str, res);
	return res;
}

void setval(int id, int val)
{
	union semun arg;
	int res;

	arg.val = val;
	res = semctl(id,0,SETVAL,arg);
	if(res==-1) {
		printf("SETVAL failed, errno %d.\n", errno);
		exit(4);
	}
	printf("   SETVAL succeeded.\n");
}

long int print_ctime(char *str, int id)
{
	union semun arg;
	struct semid_ds info;
	time_t cur = time(NULL);
	int res;

	arg.buf = &info;
	res = semctl(id,0,IPC_STAT,arg);

	if(res==-1) {
		printf("semctl(IPC_STAT) failed (%d).\n",errno);
		exit(5);
	}
	printf("%s: ctime now %ld (%ld).\n", str, 
			(long int) info.sem_ctime, (long int) cur - info.sem_ctime);
	return info.sem_ctime;
}

#define CHILD_COUNT		5
#define EXIT_SUCCESS_MAGIC	0x42

/* test1: check cpu consumption for complex sleeps */
void test1()
{
	int childs[CHILD_COUNT];
	unsigned long long total_sys, total_user;
	int res;
	int i;
	int id;

	printf("  ****************************************\n");
	printf("  test1: do a non-trivial sleep\n");

	/* create array */
	res = semget(IPC_PRIVATE, 1, 0700 | IPC_CREAT);
	printf(" got semaphore array %xh.\n",res);
	if(res == -1) {
		printf(" create failed.\n");
		return;
	}
	id = res;

	setval(id, 3);

	/* create sub-process */
	for (i=0;i<CHILD_COUNT;i++) {
		res = fork();
		if (res < 0) {
			printf("Fork failed (errno=%d). Aborting.\n", errno);
			res = semctl(id,1,IPC_RMID,NULL);
			exit(1);
		}
		fflush(stdout);
		if (!res) {
			struct sembuf sop[15];

			/* child: */
			/* Do an "increase by 15, decrease by 30" in step size 3*/
			for (i=0;i<sizeof(sop)/sizeof(sop[0]);i++) {
				sop[i].sem_num=0;
				if (i<sizeof(sop)/sizeof(sop[0])/3)
					sop[i].sem_op=3;
				else
					sop[i].sem_op=-3;
				sop[i].sem_flg=0;
			}

			errno = 0;

			res = semop(id,sop,sizeof(sop)/sizeof(sop[0]));
			if(res!=-1 || errno !=EIDRM) {
				printf("child: semop returned %d, errno %d, expected %d/%d.\n", res, errno, -1, EIDRM);
				exit(1);
			}
			fflush(stdout);
			exit(EXIT_SUCCESS_MAGIC);
		}
		childs[i] = res;
	}
	sleep(5);

	errno = 0;
	res = semctl(id,1,IPC_RMID,NULL);
	printf("  IPC_RMID returned %d, errno now %d (expected: 0, 0).\n", res, errno);

	total_user = 0;
	total_sys = 0;
	for (i=0;i<CHILD_COUNT;i++) {
		int retval;
		struct rusage r;

		retval = wait4(childs[i], &res, 0, &r);

		if (retval != childs[i]) {
			printf("wait4 returned unexpeted value %d (expected %d), errno now %d.\n", 
					retval, childs[i], errno);
		}
		if (WIFEXITED(res) == 0 || WEXITSTATUS(res) != EXIT_SUCCESS_MAGIC) {
			printf("unexpected child exit code %d (raw 0x%x. Expected: %d).\n",
				WEXITSTATUS(res), res, EXIT_SUCCESS_MAGIC);
		}
		printf("  Child %d(%d): sys %ld.%06ld, user %ld.%06ld.\n",
			i, childs[i],
			(long)r.ru_utime.tv_sec, (long)r.ru_utime.tv_usec, 
			(long)r.ru_stime.tv_sec, (long)r.ru_stime.tv_usec);
		total_user += r.ru_utime.tv_sec*1000000;
		total_user += r.ru_utime.tv_usec;
		total_sys += r.ru_stime.tv_sec*1000000;
		total_sys += r.ru_stime.tv_usec;
		fflush(stdout);
	}
	printf(" Total time: sys %ld.%06ld, user %ld.%06ld.\n",
			(long)total_sys/1000000, (long)total_sys,
			(long)total_user/1000000, (long)total_user);

	if (total_user < 100000 && total_sys < 100000) {
		printf("+++ test1 success: No Livelock\n");
		fflush(stdout);
	} else {
		printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
		printf("test 1 bad: OS should hide in shame, Livelock detected.\n");
		fflush(stdout);
	}
}

/* test2: test sem_ctime updates */
void test2(int id)
{
	unsigned long ctime_before, ctime_after;

	printf("  ****************************************\n");
	printf("  test2: does SETVAL update sem_ctime?\n");

	sleep(3);
	ctime_before = print_ctime("   before SETVAL", id);
	setval(id, 2);
	ctime_after = print_ctime("   before SETVAL", id);

	if (ctime_after != ctime_before)
		printf(" INFO: OS updates sem_ctime in semctl(SETVAL)\n");
	else
		printf(" INFO: OS performs no update to sem_ctime in semctl(SETVAL)\n");
}

/* test3: test wait for non-zero */
void test3(int id)
{
	int res;

	printf("  ****************************************\n");
	printf("  test3: check that kernel wakes up child that waits for non-zero value.\n");

	setval(id, 2);

	/* create sub-process */
	res = fork();
	if (res < 0) {
		printf("Fork failed (errno=%d). Aborting.\n", errno);
		res = semctl(id,1,IPC_RMID,NULL);
		exit(1);
	}
	fflush(stdout);
	if (!res) {
		struct sembuf sop[3];

		/* child: */
		/* Do an "increase by 1 if value is 1" operation */
		sop[0].sem_num=0;
		sop[0].sem_op=-1;
		sop[0].sem_flg=0;

		sop[1].sem_num=0;
		sop[1].sem_op=0;
		sop[1].sem_flg=0;

		sop[2].sem_num=0;
		sop[2].sem_op=2;
		sop[2].sem_flg=0;


		res = semop(id,sop,3);
		if(res==-1) {
			printf("child: semop failed.\n");
			exit(1);
		}
		res = getval("child completed, before exit", id);
		if (res != 2) {
			printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
			printf("Bad: got unexpected value.\n");
			exit(99);
		}
		fflush(stdout);
		exit(EXIT_SUCCESS_MAGIC);
	} else {
		struct sembuf sop[1];
		int retval;
		int childid;

		childid = res;
		sleep(1);

		/* Do an "decrease by 1" operation */
		sop[0].sem_num=0;
		sop[0].sem_op=-1;
		sop[0].sem_flg=0;

		res = semop(id,sop,1);
		if(res==-1) {
			printf("parent: semop failed.\n");
			exit(1);
		}

		sleep(1);

		res = getval("parent: after sleep", id);
		if (res != 2) {
			printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
			printf("Test 3 bad: got unexpected value (child not woken up?).\n");
			return;
		}

		retval = waitpid(childid, &res, 1);
		if (retval != childid) {
			printf("waitpid returned unexpeted value %d (expected %d), errno now %d.\n", 
					retval, childid, errno);
		}
		if (WIFEXITED(res) == 0 || WEXITSTATUS(res) != EXIT_SUCCESS_MAGIC) {
			printf("unexpected child exit code %d (raw 0x%x. Expected: %d).\n",
				WEXITSTATUS(res), res, EXIT_SUCCESS_MAGIC);
		}
		res = getval("parent: after waitpid", id);
		if (res != 2) {
			printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
			printf("Bad: got unexpected value.\n");
			return;
		}
	}
	printf("  +++ test3 success: kernel wakes up child correctly.\n");
}

int main(int argc,char** argv)
{
	int res;
	int id;

	/* test 1 (array created/destroyed in test1()) */
	test1();

	/* test 2 */

	/* create array */
	res = semget(IPC_PRIVATE, 1, 0700 | IPC_CREAT);
	printf(" got semaphore array %xh.\n",res);
	if(res == -1) {
		printf(" create failed.\n");
		return 1;
	}
	id = res;
	test2(id);
	test3(id);

	printf("  ****************************************\n");
	printf("  Done, cleanup.\n");
	errno = 0;
	res = semctl(id,1,IPC_RMID,NULL);
	printf("   IPC_RMID returned %d, errno now %d (expected: 0, 0).\n", res, errno);


	return 0;
}

--------------070601010907000406010201--
