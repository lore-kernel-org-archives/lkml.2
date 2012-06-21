Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2FUF1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 01:27:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:35052 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab2FUF1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 01:27:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183044930"
Message-ID: <4FE2B047.503@intel.com>
Date: Thu, 21 Jun 2012 13:25:27 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        seto.hidetoshi@jp.fujitsu.com, borislav.petkov@amd.com,
        tony.luck@intel.com, luto@mit.edu, riel@redhat.com, avi@redhat.com,
        len.brown@intel.com, tj@kernel.org, akpm@linux-foundation.org,
        cl@gentwo.org, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, cpw@sgi.com, penberg@kernel.org,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com,
        rientjes@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 8/8] x86/tlb: do flush_tlb_kernel_range by 'invlpg'
References: <1339492005-20241-1-git-send-email-alex.shi@intel.com> <1339492005-20241-9-git-send-email-alex.shi@intel.com> <20120613145656.GB32604@tassilo.jf.intel.com> <4FD939F2.3090605@intel.com> <4FD93DC7.8020501@intel.com>
In-Reply-To: <4FD93DC7.8020501@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 09:26 AM, Alex Shi wrote:

> On 06/14/2012 09:10 AM, Alex Shi wrote:
> 
>> On 06/13/2012 10:56 PM, Andi Kleen wrote:
>>
>>> On Tue, Jun 12, 2012 at 05:06:45PM +0800, Alex Shi wrote:
>>>> This patch do flush_tlb_kernel_range by 'invlpg'. The performance pay
>>>> and gain was analysed in my patch (x86/flush_tlb: try flush_tlb_single
>>>> one by one in flush_tlb_range). Now we move this logical into kernel
>>>> part. The pay is multiple 'invlpg' execution cost, that is same. but
>>>>  the gain(cost reducing of TLB entries refilling) is absolutely
>>>> increased.
>>>
>>> The subtle point is whether INVLPG flushes global pages or not.
>>> After some digging I found a sentence in the SDM that says it does.
>>> So it may be safe.
>>
>>
>> Many thanks for your time!
>>
>>>
>>> What does it improve?
>>
>>




I just write a rough kernel modules that alloc some page arrays in kernel and then map to vaddr by 'vmap'. 

Then my macro benchmark inject a 'unmap_kernel_range' request from a sysfs interface, and doing random memory access in user level during the time.

On my NHM EP 2P * 4 Cores * HT.

Without this patch, the memory access with 4 threads is ~12ns/time.
With this patch, the memory access with 4 threads is ~9ns/time.

With threads number increasing the benefit becomes small and nearly disappeared after thread number up to 256.

But no any regression. 


The rough user macro-benchmark and kernel module is here:

--- kernel module--

#include <linux/init.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/spinlock.h>
#include <linux/slab.h>
#include <linux/vmalloc.h>
#include <linux/gfp.h>
#include <linux/fs.h>
#include <linux/mman.h>
#include <linux/uaccess.h>
#include <linux/sysfs.h>
#include <linux/hrtimer.h>
#include <linux/device.h>
#include <linux/cpu.h>

MODULE_LICENSE("Dual BSD/GPL");

/* 
 * $cat Makefile 
 * obj-m := modvmalloc.o
 *
 * compile command:
 *  #cd linux; make /home/alexs/exec/modules/modvmalloc.ko 
 */
#define NR_PAGES	(4)
#define NR_BLOCKS	(1024)

struct block {
	struct page ** page_array; 
	void *vaddr;
	int page_count;
};
struct block *block;

static int blocks = NR_BLOCKS;
module_param(blocks, uint, 0400);
MODULE_PARM_DESC(blocks, "map unmap blocks number ");

static struct page **relay_alloc_page_array(unsigned int nr_pages) 
{ 
	const size_t pa_size = NR_PAGES * sizeof(struct page *); 
	if (pa_size > PAGE_SIZE) 
		return vzalloc(pa_size); 
	return kzalloc(pa_size, GFP_KERNEL); 
} 

static void relay_free_page_array(struct page **array) 
{ 
	if (is_vmalloc_addr(array)) 
		vfree(array); 
	else
		kfree(array);
}

static void vmap_unmap(void)
{
	//purge_vmap_area_lazy();
	//vm_unmap_aliases();
	int i;
	for (i=0; i< blocks; i++)
		unmap_kernel_range((unsigned long)(block->vaddr), NR_PAGES*PAGE_SIZE);
}

// ---------------
long vmap_num = 0;

static ssize_t __vmap_num_store(const char *buf,
		size_t count, int smt)
{
	long factor = 0;
	long i;
	unsigned long start, stop;

	if (sscanf(buf, "%ld", &factor) != 1)
		return -EINVAL;

	vmap_num = factor;
	start = ktime_to_ns(ktime_get());

	vmap_unmap();

	stop = ktime_to_ns(ktime_get());
	i = blocks;
	printk(KERN_ERR "vunmap %ld times cost %ld ns/time\n", 
			i, (stop - start)/i);
	return count;
}

static ssize_t vmap_num_show(struct device *dev,
		struct device_attribute *attr,
		char *buf)
{
	return sprintf(buf, "%ld\n", vmap_num);
}
static ssize_t vmap_num_store(struct device *dev,
		struct device_attribute *attr,
		const char *buf, size_t count)
{
	return __vmap_num_store(buf, count, 0);
}

DEVICE_ATTR(vmap_num, 0644,
		vmap_num_show,
		vmap_num_store);

int create_sysfs_vmap_num(struct device *dev)
{
	return device_create_file(dev, &dev_attr_vmap_num);
}

static int mapunmap_init(void){
	long i,j,k;

	create_sysfs_vmap_num(cpu_subsys.dev_root);
	block = kmalloc(sizeof(struct block)*blocks, GFP_KERNEL);

	for (k=0; k< blocks; k++) {
		block[k].page_count = 0;
		block[k].page_array = relay_alloc_page_array(NR_PAGES);
		if (!block[k].page_array)
			return -1;

		for (i = 0; i < NR_PAGES; i++) {
			block[k].page_array[i] = alloc_page(GFP_KERNEL);
			if (unlikely(!block[k].page_array[i])) {
				printk(KERN_ERR "\talloc page error \n");
				goto depopulate;
			}
		}

		if (i!=NR_PAGES)	goto depopulate;

		block[k].page_count = i;
		block[k].vaddr = vmap(block[k].page_array, NR_PAGES, VM_MAP, PAGE_KERNEL);
		if (!(block[k].vaddr)) {
			printk(KERN_ERR "\t\t vmap error !\n");
			goto depopulate;
		}
	}
	printk(KERN_INFO "vmalloc module init OK \n");
	return 0;

depopulate:
	for (i=0; i< k; i++)
		if (block[i].page_count !=0) {
			for (j = 0; j < block[i].page_count; j++)
				__free_page((block[j].page_array[j]));
			relay_free_page_array(block[j].page_array);
		}
	printk(KERN_INFO "vmalloc module init fail\n");
	return -1;
}


static void mapunmap_exit(void){
	long i, j;

	printk(KERN_INFO "bye! this is test module\n");
	device_remove_file(cpu_subsys.dev_root, &dev_attr_vmap_num);

	for (i=0; i< blocks; i++)
		if (block[i].page_count !=0) {
			for (j = 0; j < block[i].page_count; j++)
				__free_page((block[j].page_array[j]));
			relay_free_page_array(block[j].page_array);
		}
}


module_init(mapunmap_init);
module_exit(mapunmap_exit);

--- benchmark ---

/*
   maccess.c
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

   gcc -o maccess maccess.c -lrt -lpthread -O2

    #perf stat -e r881,r882,r884 -e r801,r802,r810,r820,r840,r880,r807 -e rc01 -e r4901,r4902,r4910,r4920,r4940,r4980 -e r5f01  -e rbd01,rdb20  -e r4f02 -e r8004,r8201,r8501,r8502,r8504,r8510,r8520,r8540,r8580  -e rae01,rc820,rc102,rc900 -e r8600  -e rcb10  ./maccess 
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

#define PAGE_SIZE 	(4096)
#define HPAGE_SIZE 	(4096*512)

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
	int pagenum;
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
			for (k=0; k < d->pagenum; k++)
				x = *(volatile char *)(d->startaddr + randn[k]%FILE_SIZE); 
	else
		for (*actimes=0; *threadstart == 1; (*actimes)++)
			for (k=0; k < d->pagenum; k++)
				*(char *)(d->startaddr + randn[k]%FILE_SIZE) = 1; 
	return actimes;
}

int main(int argc, char *argv[])
{
        static  char            optstr[] = "p:w:ht:s:";
	int s = 1;	/* */
	int p = 512;	/* default accessed page number, after maccess */
	int er = 0, rw = 0, h = 0, t = 2; /* d: debug; h: use huge page; t thread number */
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

	char command[1024];

	for (i=0;i<PAGE_SIZE; i++)
		randn[i] = rand();

        while ((c = getopt(argc, argv, optstr)) != EOF)
                switch (c) {
                case 's':
                        s = atoi(optarg);
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

	printf("pid is %d, thread number %d active %d seconds, access page num %d\n", getpid(), t, s, p);
	if (h == 0){
		startaddr = mmap(0, FILE_SIZE, PROT_READ|PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, -1, 0);
		pagesize = PAGE_SIZE;
	} else {
		startaddr = mmap(0, FILE_SIZE, PROT_READ|PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED | MAP_HUGETLB, -1, 0);
		pagesize = HPAGE_SIZE;
	}

	start = getnsec(clockid);
	//access whole memory, will generate many page faults 
	for (tempaddr = startaddr; tempaddr < startaddr + FILE_SIZE; tempaddr += pagesize)
		memset((char *)tempaddr, 0, 1);
        stop = getnsec(clockid);

	threadstart = malloc(sizeof(int));
	*threadstart = 0;
	data.pagenum = p; data.startaddr = startaddr; data.rw = rw;
	for (i=0; i< t; i++)
		if(pthread_create(&pid[i], NULL, accessmm, &data))
			perror("pthread create");
	//wait for randn[] filling.
	sleep(1);

	mptime = actime = 0;
	sprintf(command, "sudo sh -c 'echo %d > /sys/devices/system/cpu/vmap_num'", s);
	printf("%s\n", command);

	start = getnsec(clockid);
	//kick threads, let them running.
	*threadstart = 1;

	system(command);
	*threadstart = 0;

	stop = getnsec(clockid);
	mptime += stop - start;

	//get threads' result.
	for (i=0; i< t; i++) {
		if (pthread_join(pid[i], &res))
			perror("pthread_join");
		actime += *(long*)res;
	}
end:
	printf("maccess %ld ms, memory access %ld times/thread/ms, cost %ldns/time\n",
		 mptime/1000000, actime*p*1000000/t/mptime, mptime*t/(actime*p));
	exit(0);
}

> 
>>
>>> -Andi
>>
>>
> 
> 




