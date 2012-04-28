Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2D1Iw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:52:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:29098 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab2D1Iwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:52:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="134675347"
From: Alex Shi <alex.shi@intel.com>
To: andi.kleen@intel.com, tim.c.chen@linux.intel.com, jeremy@goop.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com
Cc: riel@redhat.com, luto@mit.edu, alex.shi@intel.com, avi@redhat.com,
        len.brown@intel.com, paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH 0/3] TLB flush range optimization
Date: Sat, 28 Apr 2012 16:51:36 +0800
Message-Id: <1335603099-2624-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. forget cc to lkml just now. Added.

This patcheset change flush_tlb_range from flushing all to one by one
'invlpg'. The following macro benchmark measured the performance improvement.
and the testing result show in the related commit log.

Any comments are appreciated!

Thanks for comments from Andi and Tim in developing!

--------------
/*
   mprotect.c
   This is a macrobenchmark for TLB flush range testing.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

   Copyright (C) Intel 2012
   Coypright Alex Shi alex.shi@intel.com 

   gcc -o mprotect mprotect.c -lrt -lpthread -O2

    #perf stat -e r881,r882,r884 -e r801,r802,r810,r820,r840,r880,r807 -e rc01 -e r4901,r4902,r4910,r4920,r4940,r4980 -e r5f01  -e rbd01,rdb20  -e r4f02 -e r8004,r8201,r8501,r8502,r8504,r8510,r8520,r8540,r8580  -e rae01,rc820,rc102,rc900 -e r8600  -e rcb10  ./mprotect 
*/

#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/mman.h>
#include <time.h>
#include <sys/types.h>
#include <pthread.h>

#define FILE_SIZE	(1024*1024*1024)

#define PAGE_SIZE 	4096

#ifndef MAP_HUGETLB
#define MAP_HUGETLB	0x40000
#endif


long getnsec(clockid_t clockid) {
        struct timespec ts;
        if (clock_gettime(clockid, &ts) == -1)
                perror("clock_gettime failed");
        return (long) ts.tv_sec * 1000000000 + (long) ts.tv_nsec;
}

//data for threads
struct data{
	int *readp;
	void *startaddr;
	int rw;
	int loop;
};
volatile int * threadstart;
//thread for memory accessing
void *accessmm(void *data){
	struct data *d = data;
	long *actimes;
	char x;
	int i, k;
	int randn[PAGE_SIZE];
	
	for (i=0;i<PAGE_SIZE; i++)
		randn[i] = rand();

	actimes = malloc(sizeof(long));

	while (*threadstart == 0 )
		usleep(1);

	if (d->rw == 0)
		for (*actimes=0; *threadstart == 1; (*actimes)++)
			for (k=0; k < *d->readp; k++)
				x = *(volatile char *)(d->startaddr + randn[k]%FILE_SIZE); 
	else
		for (*actimes=0; *threadstart == 1; (*actimes)++)
			for (k=0; k < *d->readp; k++)
				*(char *)(d->startaddr + randn[k]%FILE_SIZE) = 1; 
	return actimes;
}

int main(int argc, char *argv[])
{
        static  char            optstr[] = "n:l:p:w:ht:";
	int n = 32;	/* default flush entries number */
	int l = 1024; 	/* default loop times */
	int p = 512;	/* default accessed page number, after mprotect */
	int er = 0, rw = 0, h = 0, t = 0; /* d: debug; h: use huge page; t thread number */
	int pagesize = PAGE_SIZE; /*default for regular page */
	volatile char x;

	int i, j, k, c;
	void *m1, *startaddr;
	volatile void *tempaddr;
	clockid_t clockid = CLOCK_MONOTONIC;
	unsigned long start, stop, mptime, actime;
	int randn[PAGE_SIZE];

	pthread_t	pid[1024];
	void * res;
	struct data data;

	for (i=0;i<PAGE_SIZE; i++)
		randn[i] = rand();

        while ((c = getopt(argc, argv, optstr)) != EOF)
                switch (c) {
                case 'n':
                        n = atoi(optarg);
                        break;
                case 'l':
                        l = atoi(optarg);
                        break;
                case 'p':
                        p = atoi(optarg);
                        break;
                case 'h':
                        h = 1;
                        break;
                case 'w':
                        rw = atoi(optarg);
                        break;
                case 't':
                        t = atoi(optarg);
                        break;
                case '?':
                        er = 1;
                        break;
                }
        if (er) {
                printf("usage: %s %s\n", argv[0], optstr);
                exit(1);
	}

	printf("my pid is %d n=%d l=%d p=%d t=%d\n", getpid(), n, l, p, t);	
	if (h == 0){
		startaddr = mmap(0, FILE_SIZE, PROT_READ|PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, -1, 0);
	} else {
		startaddr = mmap(0, FILE_SIZE, PROT_READ|PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED | MAP_HUGETLB, -1, 0);
		pagesize = 2*1024*1024;
	}
	if (startaddr == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	start = getnsec(clockid);
	//access whole memory, will generate many page faults 
	for (tempaddr = startaddr; tempaddr < startaddr + FILE_SIZE; tempaddr += pagesize)
		memset((char *)tempaddr, 0, 1);
        stop = getnsec(clockid);
       	printf("get 256K pages with one byte writing uses %lums, %luns/time \n", 
		(stop - start)/1000000, (stop-start)*pagesize/FILE_SIZE);

	//thread created, and goes to sleep
	threadstart = malloc(sizeof(int));
	*threadstart = 0;
	data.readp = &p; data.startaddr = startaddr; data.rw = rw; data.loop = l;
	for (i=0; i< t; i++)
		if(pthread_create(&pid[i], NULL, accessmm, &data))
			perror("pthread create");
	//wait for randn[] filling.
	if (t!=0)	sleep(1);

	mptime = actime = 0;
	if (h == 0) {
		m1 = mmap(0, n * pagesize, PROT_READ|PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, -1, 0);
	} else {
		m1 = mmap(0, n * pagesize, PROT_READ|PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED | MAP_HUGETLB, -1, 0);
	}
	if (m1 == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
	if (t != 0)
		start = getnsec(clockid);
	//kick threads, let them running.
	*threadstart = 1;
	for (j=0; j < l; j++) {
		for (i=1; i <= n; i++) {
			unsigned long prot[2]={PROT_READ, PROT_WRITE|PROT_READ};

			if (t == 0)
				start = getnsec(clockid);

			if(mprotect(m1, i*pagesize, prot[i%2])==-1) {
				perror("mprotect");
				goto end;
			}
			if (t == 0) {
				stop = getnsec(clockid);
				mptime += stop - start;
			}

			if (t == 0) {
				// access p number pages 
				start = stop; 
				if (rw == 0)
					for (k=0; k < p; k++)
						x = *(volatile char *)(startaddr + randn[k]%FILE_SIZE);
				else
					for (k=0; k < p; k++)
						*(char *)(startaddr + randn[k]%FILE_SIZE) = 1;
				actime += getnsec(clockid) - start;
			} 
		}
	}
	//to avoid accessmm miss *threadstart == 1
	usleep(5);
	*threadstart = 0;
	if (t != 0) {
		stop = getnsec(clockid);
		mptime += stop - start;
	}
	munmap(m1, n*pagesize);

	//get threads' result.
	for (i=0; i< t; i++) {
		if (pthread_join(pid[i], &res))
			perror("pthread_join");
		actime += *(long*)res;
	}
end:
	if ( t == 0 ) 
	       	printf("mprotect use %lums %luns/time, memory access uses %lums %luns/time \n",
			 mptime/1000000, mptime/(l*n), actime/1000000, actime/p/l/n);
	else
		printf("mprotect use %lums %luns/time, %ld times/thread/ms, cost %ldns/time\n",
			 mptime/1000000, mptime/(l*n), actime*p*1000000/t/mptime, mptime*t/(actime*p));
	exit(0);
}
