Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab1HaJmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 05:42:52 -0400
Received: from vuizook.err.no ([85.19.221.46]:37086 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab1HaJmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 05:42:51 -0400
X-Greylist: delayed 2728 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Aug 2011 05:42:51 EDT
Date: Wed, 31 Aug 2011 10:57:18 +0200
From: Mike Hommey <mh@glandium.org>
To: linux-kernel@vger.kernel.org
Subject: Problem with perf hardware counters grouping
Message-ID: <20110831085718.GB13884@glandium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: A479 A824 265C B2A5 FC54  8D1E DE4B DA2C 54FD 2A58
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having two different problems with perf hardware counters with a
group leader:
- perf_event_open()ing more than 3 makes all of them always return a
  value of 0;
- perf_event_open()ing more than 4 fails with ENOSPC.

This doesn't happen with software counters.

The source at the end of this message exhibits the problem:
$ gcc -o test test.c
$ strace -eperf_event_open ./test
perf_event_open(0x7fff7aeb3e00, 0, 0xffffffff, 0xffffffff, 0) = 3
perf_event_open(0x7fff7aeb3e00, 0, 0xffffffff, 0x3, 0) = 4
perf_event_open(0x7fff7aeb3e00, 0, 0xffffffff, 0x3, 0) = 5
Count: 10857
$ gcc -o test test.c -DN=4
$ strace -eperf_event_open ./test
perf_event_open(0x7fff13a16bd0, 0, 0xffffffff, 0xffffffff, 0) = 3
perf_event_open(0x7fff13a16bd0, 0, 0xffffffff, 0x3, 0) = 4
perf_event_open(0x7fff13a16bd0, 0, 0xffffffff, 0x3, 0) = 5
perf_event_open(0x7fff13a16bd0, 0, 0xffffffff, 0x3, 0) = 6
Count: 0
$ gcc -o test test.c -DN=5
$ strace -eperf_event_open ./test
perf_event_open(0x7fff64700c60, 0, 0xffffffff, 0xffffffff, 0) = 3
perf_event_open(0x7fff64700c60, 0, 0xffffffff, 0x3, 0) = 4
perf_event_open(0x7fff64700c60, 0, 0xffffffff, 0x3, 0) = 5
perf_event_open(0x7fff64700c60, 0, 0xffffffff, 0x3, 0) = 6
perf_event_open(0x7fff64700c60, 0, 0xffffffff, 0x3, 0) = -1 ENOSPC (No
space left on device)
Count: 0

I think the latter is due to the hard limit of 4 for the number of slots
for hardware breakpoints. No idea about the former.

Mike

----------------8<-------------------
#define _GNU_SOURCE 1

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <linux/perf_event.h>

int perf_event_open(struct perf_event_attr *hw_event_uptr,
		    pid_t pid, int cpu, int group_fd, unsigned long flags) {
   return syscall(__NR_perf_event_open, hw_event_uptr, pid, cpu, group_fd,flags);
}

int group_leader = -1;

int _perf_event_open(uint64_t config) {
  struct perf_event_attr pe;
  int fd;

  memset(&pe,0,sizeof(struct perf_event_attr));
  pe.type = PERF_TYPE_HARDWARE;
  pe.size = sizeof(struct perf_event_attr);
  pe.config = config;
  if (group_leader == -1)
    pe.disabled = 1;
  pe.mmap = 1;
  pe.comm = 1;
  
  fd = perf_event_open(&pe, 0, -1, group_leader, 0);
  if (fd >= 0 && group_leader == -1)
    group_leader = fd;

  return fd;
}

int main(int argc, char** argv) {
   uint64_t c;
   int fd = _perf_event_open(PERF_COUNT_HW_CPU_CYCLES);
   _perf_event_open(PERF_COUNT_HW_INSTRUCTIONS);
   _perf_event_open(PERF_COUNT_HW_CACHE_REFERENCES);
#if N > 3
   _perf_event_open(PERF_COUNT_HW_CACHE_MISSES);
#endif
#if N > 4
   _perf_event_open(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
#endif
   ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);   
   ioctl(fd, PERF_EVENT_IOC_DISABLE,0);

   read(fd, &c, sizeof(c));

   printf("Count: %ld\n",c);

   return 0;
}
