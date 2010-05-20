Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab0ETFIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 01:08:24 -0400
Received: from ozlabs.org ([203.10.76.45]:47753 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab0ETFIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 01:08:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into ring itself
Date: Thu, 20 May 2010 14:38:16 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
References: <20100505205814.GA7090@redhat.com> <4BF39C12.7090407@redhat.com> <201005201431.51142.rusty@rustcorp.com.au>
In-Reply-To: <201005201431.51142.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005201438.17010.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 02:31:50 pm Rusty Russell wrote:
> On Wed, 19 May 2010 05:36:42 pm Avi Kivity wrote:
> > > Note that this is a exclusive->shared->exclusive bounce only, too.
> > >    
> > 
> > A bounce is a bounce.
> 
> I tried to measure this to show that you were wrong, but I was only able
> to show that you're right.  How annoying.  Test code below.

This time for sure!

#define _GNU_SOURCE
#include <unistd.h>
#include <sched.h>
#include <err.h>
#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <sys/mman.h>

/* We share memory via an mmap. */
struct counter {
	unsigned int cacheline1;
	char pad[256];
	unsigned int cacheline2;
};

#define MAX_BOUNCES 100000000

enum mode {
	SHARE,
	UNSHARE,
	LOCKSHARE,
	LOCKUNSHARE,
};

int main(int argc, char *argv[])
{
	cpu_set_t cpuset;
	volatile struct counter *counter;
	struct timeval start, stop;
	bool child;
	unsigned int count;
	uint64_t usec;
	enum mode mode;

	if (argc != 4)
		errx(1, "Usage: cachebounce share|unshare|lockshare|lockunshare <cpu0> <cpu1>");

	if (strcmp(argv[1], "share") == 0)
		mode = SHARE;
	else if (strcmp(argv[1], "unshare") == 0)
		mode = UNSHARE;
	else if (strcmp(argv[1], "lockshare") == 0)
		mode = LOCKSHARE;
	else if (strcmp(argv[1], "lockunshare") == 0)
		mode = LOCKSHARE;
	else
		errx(1, "Usage: cachebounce share|unshare|lockshare|lockunshare <cpu0> <cpu1>");

	CPU_ZERO(&cpuset);

	counter = mmap(NULL, getpagesize(), PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_SHARED, -1, 0);
	if (counter == MAP_FAILED)
		err(1, "Mapping page");

	/* Fault it in. */
	counter->cacheline1 = counter->cacheline2 = 0;

	child = (fork() == 0);

	CPU_SET(atoi(argv[2 + child]), &cpuset);
	if (sched_setaffinity(getpid(), sizeof(cpu_set_t), &cpuset) != 0)
		err(1, "Calling sched_setaffinity()");

	gettimeofday(&start, NULL);

	if (child) {
		count = 1;
		switch (mode) {
		case SHARE:
			while (count < MAX_BOUNCES) {
				/* Spin waiting for other side to change it. */
				while (counter->cacheline1 != count);
				count++;
				counter->cacheline1 = count;
				count++;
			}
			break;
		case UNSHARE:
			while (count < MAX_BOUNCES) {
				/* Spin waiting for other side to change it. */
				while (counter->cacheline1 != count);
				count++;
				counter->cacheline2 = count;
				count++;
			}
			break;
		case LOCKSHARE:
			while (count < MAX_BOUNCES) {
				/* Spin waiting for other side to change it. */
				while (__sync_val_compare_and_swap(&counter->cacheline1, count, count+1)
				       != count);
				count += 2;
			}
			break;
		case LOCKUNSHARE:
			while (count < MAX_BOUNCES) {
				/* Spin waiting for other side to change it. */
				while (counter->cacheline1 != count);
				__sync_val_compare_and_swap(&counter->cacheline2, count, count+1);
				count += 2;
			}
			break;
		}
	} else {
		count = 0;
		switch (mode) {
		case SHARE:
			while (count < MAX_BOUNCES) {
				/* Spin waiting for other side to change it. */
				while (counter->cacheline1 != count);
				count++;
				counter->cacheline1 = count;
				count++;
			}
			break;
		case UNSHARE:
			while (count < MAX_BOUNCES) {
				/* Spin waiting for other side to change it. */
				while (counter->cacheline2 != count);
				count++;
				counter->cacheline1 = count;
				count++;
			}
			break;
		case LOCKSHARE:
			while (count < MAX_BOUNCES) {
				/* Spin waiting for other side to change it. */
				while (__sync_val_compare_and_swap(&counter->cacheline1, count, count+1)
				       != count);
				count += 2;
			}
			break;
		case LOCKUNSHARE:
			while (count < MAX_BOUNCES) {
				/* Spin waiting for other side to change it. */
				while (counter->cacheline2 != count);
				__sync_val_compare_and_swap(&counter->cacheline1, count, count+1);
				count += 2;
			}
			break;
		}
	}
	gettimeofday(&stop, NULL);
	usec = (stop.tv_sec * 1000000LL + stop.tv_usec)
		- (start.tv_sec * 1000000LL + start.tv_usec);
	printf("CPU %s: %s cacheline: %llu usec\n", argv[2+child], argv[1], usec);
	return 0;
}

