Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab0FWJNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:13:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:48386 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab0FWJNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:13:12 -0400
Date: Wed, 23 Jun 2010 11:13:07 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Darren Hart <dvhltc@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: futex: race in lock and unlock&exit for robust futex with PI?
Message-ID: <20100623091307.GA11072@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

attached you can find a simple test case which fails quite easily on the
following glibc assert:
"SharedMutexTest: pthread_mutex_lock.c:289: __pthread_mutex_lock:
  Assertion `(-(e)) != 3 || !robust' failed." "

AFAIU, this assertion says that futex syscall cannot fail with ESRCH 
for robust futex because it should either succeed or fail with
EOWNERDEAD.

We have seen this problem on SLES11 and SLES11SP1 but I was able to
reproduce it with the 2.6.34 kernel as well.

The test case is quite easy. 

Executed with a parameter it creates a test file and initializes shared,
robust pthread mutex (optionaly compile time configured with priority
inheritance) backed by the mmapped test file. Without a parameter it
mmaps the file and just locks, unlocks mutex and checks for EOWNERDEAD
(this should never happen during the test as the process never dies with
the lock held) in the loop.

If I run this application for multiple users in parallel I can see the
above assertion. However, if priority inheritance is turned off then
there is no problem. I am not able to reproduce also if the test case is
run under a single user.

I am using the attached runSimple.sh script to run the test case like
this:

rm test.file simple
for i in `seq 10` 
do 
	sh runSimple.sh
done

To disable IP just comment out USE_PI variable in the script.
You need to change USER1 and USER2 variables to match you system. You
will need to run the script as root if you do not set any special
setting to run su on behalf of those users.

I have tried to look at futex_{un}lock_pi but it is really hard to
understand. I assume that lookup_pi_state is the one which sets ESRCH
after it is not able to find the pid of the current owner. 

This would suggest that we are racing with the unlock of the current
lock holder but I don't see how is this possible as both lock and unlock
paths hold fshared lock for all operations over the lock value. I have
noticed that the lock path drops fshared if the current holder is dying
but then it retries the whole process again.

Any advice would be highly appreciated.

Let me know if you need any further information

Thanks
-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--n8g4imXOkfNTN/H1
Content-Type: application/x-sh
Content-Disposition: attachment; filename="runSimple.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0AUSER1=3Dtestuser=0AUSER2=3Dtestuser1=0AUSE_PI=3D"-D USE_PI=
"=0A=0ABIN=3Dsimple=0A[ ! -x $BIN ] && gcc $USE_PI -pthread $BIN.c -o $BIN=
=0A=0A# initialize=0Aif [ ! -f test.file ]=0Athen=0A	# initialize test file=
 and mutex=0A	./$BIN 1=0A=0A	# test file has to be world read&writable if y=
ou don't=0A	# have any special group setting for USER1 and USER2=0A	chmod 6=
66 test.file=0Afi=0A=0Aecho Here we go=0Afor i in `seq 10`=0Ado=0A	(echo ./=
$BIN | su $USER1)&=0A	(echo ./$BIN | su $USER1)&=0A	(echo ./$BIN | su $USER=
1)&=0A	(echo ./$BIN | su $USER1)&=0A	(echo ./$BIN | su $USER1)&=0A	(echo ./=
$BIN | su $USER1)&=0A	(echo ./$BIN | su $USER1)&=0A	(echo ./$BIN | su $USER=
1)&=0A	(echo ./$BIN | su $USER1)&=0A	(echo ./$BIN | su $USER1)&=0A	(echo ./=
$BIN | su $USER2)&=0A	(echo ./$BIN | su $USER2)&=0A	(echo ./$BIN | su $USER=
2)&=0A	(echo ./$BIN | su $USER2)&=0A	(echo ./$BIN | su $USER2)&=0A	(echo ./=
$BIN | su $USER2)&=0A	(echo ./$BIN | su $USER2)&=0A	(echo ./$BIN | su $USER=
2)&=0A	(echo ./$BIN | su $USER2)&=0A	(echo ./$BIN | su $USER2)=0Adone=0A=0A
--n8g4imXOkfNTN/H1
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="simple.c"

#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sys/file.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#define __USE_UNIX98
#include <pthread.h>

#define  TEST_FILE "test.file"

int init_mutex(pthread_mutex_t *mutex) {

	pthread_mutexattr_t mattr;
	if (pthread_mutexattr_init(&mattr)) {
		perror("pthread_mutexattr_init: ");
		exit(1);
	}
	if (pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED)) {
		perror("pthread_mutexattr_setpshared: ");
		exit(1);
	}
#ifdef USE_PI
	if (pthread_mutexattr_setprotocol(&mattr, PTHREAD_PRIO_INHERIT)) {
		perror("pthread_mutexattr_setprotocol PI: ");
		exit(1);
	}
#endif
	if (pthread_mutexattr_setrobust_np(&mattr, PTHREAD_MUTEX_ROBUST_NP)) {
		perror("pthread_mutexattr_setrobust_np: ");
		exit(1);
	}

	memset(mutex, 0, sizeof(pthread_mutex_t));
	if (pthread_mutex_init(mutex, &mattr)) {
		perror("mutex_init: ");
		exit(1);
	}
}

int init_test_file(const char *fname) {
	int fd = open(fname, O_RDWR|O_CREAT, S_IREAD|S_IWRITE);
	if (fd == -1) {
		perror("file open:");
		exit(1);
	}
	if (ftruncate(fd, 4096)) {
		perror("truncate: ");
		exit(1);
	}
}

pthread_mutex_t *get_mutex_from_file(const char *fname) {
	int fd = open(fname, O_RDWR, S_IREAD|S_IWRITE);
	if (fd == -1) {
		perror("file open: ");
		exit(1);
	}

	void * addr = mmap(0, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if (addr == MAP_FAILED) {
		perror("mmap failed: ");
		exit(1);
	}
	/* prefault the shared page */
	asm volatile ("" : : "r" (*((unsigned char *)addr)));
	return (pthread_mutex_t *)addr;
}

void check_locked_mutex(pthread_mutex_t *mutex) {
	if (!pthread_mutex_trylock(mutex)) {
		fprintf(stderr, "mutex is not held\n");
		exit(1);
	}
}

void sleep_up_to_sec(int sec) {
/*
	srandom(time(NULL));
	usleep((random()%sec) * 1000000);
*/
}

int main(int argc, char **argv) {
	if (argc > 1) {
		/* First run is just an initialization */
		init_test_file(TEST_FILE);
		pthread_mutex_t * mutex = get_mutex_from_file(TEST_FILE);
		init_mutex(mutex);
		exit(0);
	}

	pthread_mutex_t * mutex = get_mutex_from_file(TEST_FILE);
	int i;
	sleep_up_to_sec(5);
	for (i = 0; i < 1000; ++i)
	{
		int state = pthread_mutex_lock(mutex);
		if (state == EOWNERDEAD)
		{
			// We always perform check for dead process
			// Therefore may safely mark mutex as recovered
			printf("ownerdead\n");
			pthread_mutex_consistent_np(mutex);
		}else if (state) {
			perror("pthread_mutex_lock");
			exit(1);
		}

		check_locked_mutex(mutex);
		sleep_up_to_sec(10);
		if (pthread_mutex_unlock(mutex)) {
			perror("pthread_mutex_unlock");
			exit(1);
		}
	}

	exit(0);
}

--n8g4imXOkfNTN/H1--
