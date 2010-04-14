Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0DNNN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:13:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab0DNNNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:13:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4BACCB4E.7010108@draigBrady.com>
References: <4BACCB4E.7010108@draigBrady.com> <20100326144241.8583.95617.stgit@warthog.procyon.org.uk>
To: P@draigBrady.com
cc: torvalds@osdl.org, matthew@wil.cx, arjan@infradead.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Wed, 14 Apr 2010 14:13:35 +0100
Message-ID: <18695.1271250815@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pádraig Brady <P@draigBrady.com> wrote:

> Benchmarks would be useful for this patch set.

Okay.

Using the attached test program:

	warthog>time ./get_order 
	real    1m37.191s
	user    1m36.313s
	sys     0m0.861s
	warthog>time ./get_order x
	real    0m16.892s
	user    0m16.586s
	sys     0m0.287s
	warthog>time ./get_order x x
	real    0m7.731s
	user    0m7.727s
	sys     0m0.002s

Using the current upstream fls64() as a basis for an inlined get_order() [the
second result above] is much faster than using the current out-of-line
loop-based get_order() [the first result above].

Using my optimised inline fls64()-based get_order() [the third result above]
is even faster still.

I ran the above on my Core2 desktop box running x86_64 Fedora 12.

Also note that I compiled the test program with -O3, so I had to do things to
prevent gcc from optimising the call to fls64() or get_order() away, such as
adding up the results and sticking them in a global variable, and not having
too few values passed to get_order(), lest gcc calculate them in advance.

So it would be useful to decide if we can optimise fls() and fls64() for
x86_64.  Certainly it would be useful to replace the out-of-line get_order()
for x86_64.

David
---
#include <stdlib.h>
#include <stdio.h>

#ifndef __x86_64__
#error
#endif

#define BITS_PER_LONG 64

#define PAGE_SHIFT 12

typedef unsigned long long __u64, u64;
typedef unsigned int __u32, u32;
#define noinline	__attribute__((noinline))

static __always_inline int fls64(__u64 x)
{
	long bitpos = -1;

	asm("bsrq %1,%0"
	    : "+r" (bitpos)
	    : "rm" (x));
	return bitpos + 1;
}

static inline unsigned long __fls(unsigned long word)
{
	asm("bsr %1,%0"
	    : "=r" (word)
	    : "rm" (word));
	return word;
}
static __always_inline int old_fls64(__u64 x)
{
	if (x == 0)
		return 0;
	return __fls(x) + 1;
}

static noinline // __attribute__((const))
int old_get_order(unsigned long size)
{
	int order;

	size = (size - 1) >> (PAGE_SHIFT - 1);
	order = -1;
	do {
		size >>= 1;
		order++;
	} while (size);
	return order;
}

static inline __attribute__((const))
int __get_order_old_fls64(unsigned long size)
{
	int order;
	size--;
	size >>= PAGE_SHIFT;
	order = old_fls64(size);
	return order;
}

static inline __attribute__((const))
int __get_order(unsigned long size)
{
	int order;
	size--;
	size >>= PAGE_SHIFT;
	order = fls64(size);
	return order;
}

#define get_order_old_fls64(n)						\
	(								\
		__get_order_old_fls64(n)				\
	)

#define get_order(n)							\
	(								\
		__get_order(n)						\
	)

unsigned long prevent_optimise_out;

static noinline unsigned long test_old_get_order(void)
{
	unsigned long n, total = 0;
	long rep, loop;

	for (rep = 1000000; rep > 0; rep--) {
		for (loop = 0; loop <= 16384; loop += 4) {
			n = 1UL << loop;
			total += old_get_order(n);
		}
	}
	return total;
}

static noinline unsigned long test_get_order_old_fls64(void)
{
	unsigned long n, total = 0;
	long rep, loop;

	for (rep = 1000000; rep > 0; rep--) {
		for (loop = 0; loop <= 16384; loop += 4) {
			n = 1UL << loop;
			total += get_order_old_fls64(n);
		}
	}
	return total;
}

static noinline unsigned long test_get_order(void)
{
	unsigned long n, total = 0;
	long rep, loop;

	for (rep = 1000000; rep > 0; rep--) {
		for (loop = 0; loop <= 16384; loop += 4) {
			n = 1UL << loop;
			total += get_order(n);
		}
	}
	return total;
}

int main(int argc, char **argv)
{
	unsigned long total;

	switch (argc) {
	case 1:  total = test_old_get_order();		break;
	case 2:  total = test_get_order_old_fls64();	break;
	default: total = test_get_order();		break;
	}
	prevent_optimise_out = total;
	return 0;
}
