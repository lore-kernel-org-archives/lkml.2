Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab2EQIly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:41:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:3736 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab2EQIls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:41:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153942844"
Message-ID: <4FB4B964.6050501@intel.com>
Date: Thu, 17 May 2012 16:40:04 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, a.p.zijlstra@chello.nl,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: Re: [PATCH v6 0/7] tlb flush optimization on x86
References: <1337233375-840-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1337233375-840-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 01:42 PM, Alex Shi wrote:

> Thanks Peter Z, Peter Anvin, Nick Piggin, and many others' comments!
> 
> The main change of this version is on generic mmu_gather code.
> It was tested with arm cross-compiler.
> 
> Thanks Rongjie's testing, that show the real case performance gain.
> 
> Alex Shi
> 
> [PATCH v6 1/7] x86/tlb: unify TLB_FLUSH_ALL definition
> [PATCH v6 2/7] x86/tlb_info: get last level TLB entry number of CPU
> [PATCH v6 3/7] x86/flush_tlb: try flush_tlb_single one by one in
> [PATCH v6 4/7] x86/tlb: fall back to flush all when meet a THP large
> [PATCH v6 5/7] x86/tlb: add tlb_flushall_shift for specific CPU
> [PATCH v6 6/7] x86/tlb: enable tlb flush range support for generic
> [PATCH v6 7/7] x86/tlb: add tlb_flushall_shift knob into debugfs




Here is the macro benchmark to measure munmap change:

tlb_flushall_shift = -1
[alexs@lkp-ne04 tlb]$ 
[alexs@lkp-ne04 tlb]$ for t in `echo 4 8 16  `; do echo "=============== t = $t ===================="; for i in `echo  8 16 32  `; do sudo  ./munmap -t $t -n $i; done done
=============== t = 4 ====================
munmap use 164ms 5032ns/time, memory access uses 81605 times/thread/ms, cost 12ns/time
munmap use 86ms 5251ns/time, memory access uses 83378 times/thread/ms, cost 11ns/time
munmap use 46ms 5642ns/time, memory access uses 87212 times/thread/ms, cost 11ns/time
=============== t = 8 ====================
munmap use 197ms 6036ns/time, memory access uses 69295 times/thread/ms, cost 14ns/time
munmap use 96ms 5896ns/time, memory access uses 71895 times/thread/ms, cost 13ns/time
munmap use 62ms 7608ns/time, memory access uses 83895 times/thread/ms, cost 11ns/time
=============== t = 16 ====================
munmap use 274ms 8367ns/time, memory access uses 37860 times/thread/ms, cost 26ns/time
munmap use 139ms 8543ns/time, memory access uses 38137 times/thread/ms, cost 26ns/time
munmap use 74ms 9033ns/time, memory access uses 38349 times/thread/ms, cost 26ns/time
[alexs@lkp-ne04 tlb]$ 
[alexs@lkp-ne04 tlb]$ 
tlb_flushall_shift = 5
[alexs@lkp-ne04 tlb]$ for t in `echo 4 8 16  `; do echo "=============== t = $t ===================="; for i in `echo  8 16 32  `; do sudo  ./munmap -t $t -n $i; done done
=============== t = 4 ====================
munmap use 212ms 6485ns/time, memory access uses 114003 times/thread/ms, cost 8ns/time
munmap use 130ms 7972ns/time, memory access uses 110725 times/thread/ms, cost 9ns/time
munmap use 45ms 5581ns/time, memory access uses 87866 times/thread/ms, cost 11ns/time
=============== t = 8 ====================
munmap use 253ms 7734ns/time, memory access uses 94578 times/thread/ms, cost 10ns/time
munmap use 147ms 9012ns/time, memory access uses 83851 times/thread/ms, cost 11ns/time
munmap use 63ms 7713ns/time, memory access uses 87473 times/thread/ms, cost 11ns/time
=============== t = 16 ====================
munmap use 369ms 11284ns/time, memory access uses 38854 times/thread/ms, cost 25ns/time
munmap use 264ms 16131ns/time, memory access uses 37870 times/thread/ms, cost 26ns/time
munmap use 73ms 8981ns/time, memory access uses 38309 times/thread/ms, cost 26ns/time

The munmap.c file is here:
---

/*
   munmap.c
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

   gcc -o munmap munmap.c -lrt -lpthread -O2

    #perf stat -e r881,r882,r884 -e r801,r802,r810,r820,r840,r880,r807 -e rc01 -e r4901,r4902,r4910,r4920,r4940,r4980 -e r5f01  -e rbd01,rdb20  -e r4f02 -e r8004,r8201,r8501,r8502,r8504,r8510,r8520,r8540,r8580  -e rae01,rc820,rc102,rc900 -e r8600  -e rcb10  ./munmap 
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
#define HPAGE_SIZE 	4096*512

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
	int n = 8;	/* default flush entries number */
	int l = 1; 	/* default loop times */
	int p = 512;	/* default accessed page number, after munmap */
	int er = 0, rw = 0, h = 0, t = 0; /* d: debug; h: use huge page; t thread number */
	int pagesize = PAGE_SIZE; /*default for regular page */
	volatile char x;
	long protindex = 0;

	int i, j, k, c;
	void *m1, *startaddr;
	unsigned long *startaddr2[1024*512];
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

	//printf("my pid is %d n=%d p=%d t=%d\n", getpid(), n, p, t);	
	if (h == 0){
		startaddr = mmap(0, FILE_SIZE, PROT_READ|PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, -1, 0);
		for (j = 0; j < FILE_SIZE/PAGE_SIZE/n; j++) {
			startaddr2[j] = mmap(0, PAGE_SIZE*n, PROT_READ|PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, -1, 0);
			if (startaddr2[j] == MAP_FAILED) {
				perror("mmap");
				exit(1);
			}
			*startaddr2[j] = 1;
		}
		pagesize = PAGE_SIZE;
	} else {
		startaddr = mmap(0, FILE_SIZE, PROT_READ|PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED | MAP_HUGETLB, -1, 0);
		for (j = 0; j < FILE_SIZE/HPAGE_SIZE/n; j++) {
			startaddr2[j] = mmap(0, HPAGE_SIZE*n, PROT_READ|PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, -1, 0);
			if (startaddr2[j] == MAP_FAILED) {
				perror("mmap");
				exit(1);
			}
			*startaddr2[j] = 1;
		}
		pagesize = HPAGE_SIZE;
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
//	printf("get 256K pages with one byte writing uses %lums, %luns/time \n", 
//		(stop - start)/1000000, (stop-start)*pagesize/FILE_SIZE);

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
	if (t != 0)
		start = getnsec(clockid);
	//kick threads, let them running.
	*threadstart = 1;
	for (j = 0; j < FILE_SIZE/pagesize/n; j++) {

		if (t == 0)
			start = getnsec(clockid);

		if(munmap(startaddr2[j], n*pagesize)==-1) {
			perror("munmap");
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
	//to avoid accessmm miss *threadstart == 1
	usleep(10000);//sleep 10ms
	*threadstart = 0;
	if (t != 0) {
		stop = getnsec(clockid);
		mptime += stop - start;
	}

	//get threads' result.
	for (i=0; i< t; i++) {
		if (pthread_join(pid[i], &res))
			perror("pthread_join");
		actime += *(long*)res;
	}
	l = FILE_SIZE/pagesize/n;
end:
	if ( t == 0 ) 
	       	printf("munmap use %lums %luns/time, memory access uses %lums %luns/time \n",
			 mptime/1000000, mptime/(l), actime/1000000, actime/p/l);
	else
		printf("munmap use %lums %luns/time, memory access uses %ld times/thread/ms, cost %ldns/time\n",
			 mptime/1000000, mptime/(l), actime*p*1000000/t/mptime, mptime*t/(actime*p));
	exit(0);
}
