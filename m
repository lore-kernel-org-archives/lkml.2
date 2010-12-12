Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab0LLCNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 21:13:17 -0500
Received: from borg.medozas.de ([188.40.89.202]:58374 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab0LLCNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 21:13:16 -0500
Date: Sun, 12 Dec 2010 03:13:14 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Large-region mmap unexpectedly fails with ENOMEM
Message-ID: <alpine.LNX.2.01.1012120302360.25602@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.


When working with large files, such as git has to when dealing with 
packs, I noticed that mmap fails when the requested length of the 
mapping is approaching the size of physical memory (no swap configured). 
It is impossible to — even just read-only — call mmap on a file or 
anonymous object and requesting a region despite 64-bit architectures 
having the address space for it.

This looks like a bug to me.
I presume that mapping a, say 2 GB file on a system with 2 GB RAM does 
not require 2 GB just for the PTEs.
Observed on 2.6.33, 2.6.36.

---
$ ls -log devqa.dsk 
-rw-r----- 1  8589934592 Nov 30 02:58 devqa.dsk
$ ./mmap devqa.dsk $[1048576*2048]
sizeof(size_t) = 8
devqa.dsk for 2147483648
mmap: Cannot allocate memory
0xffffffffffffffff

$ free
             total    used    free  shared buffers  cached
Mem:       2051340  113076 1938264       0   10928   67776
-/+ buffers/cache:   34372 2016968
Swap:            0       0       0

/proc/meminfo:
MemTotal:        2051340 kB
MemFree:         1938264 kB
Buffers:           10936 kB
Cached:            58848 kB
SwapCached:            0 kB
Active:            35560 kB
Inactive:          45696 kB
Active(anon):      11828 kB
Inactive(anon):        0 kB
Active(file):      23732 kB
Inactive(file):    45696 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 8 kB
Writeback:             0 kB
AnonPages:         11468 kB
Mapped:             8964 kB
Shmem:               360 kB
Slab:              16976 kB
SReclaimable:       8932 kB
SUnreclaim:         8044 kB
KernelStack:        1032 kB
PageTables:         2120 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1025668 kB
Committed_AS:      82680 kB
VmallocTotal:   34359738367 kB
VmallocUsed:        2672 kB
VmallocChunk:   34359730812 kB
DirectMap4k:        8128 kB
DirectMap2M:     2088960 kB
---
#include <sys/mman.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>

int main(int argc, const char **argv)
{
	int fd = open(argv[1], O_RDONLY);
	if (fd < 0)
		abort();
	size_t len = strtoull(argv[2], NULL, 0);
	printf("sizeof(size_t) = %zu\n", sizeof(size_t));
	if (sizeof(size_t) < 8)
		abort();
	printf("%s for %zu\n", argv[1], len);
	void *x = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
	if (x == (void *)-1)
		perror("mmap");
	printf("%p\n", x);
	return 0;
}
