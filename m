Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab0HLRYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:24:35 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:35410 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0HLRYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:24:33 -0400
Message-Id: <20100812172544.655648128@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 12 Aug 2010 19:25:44 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH/RFC 0/5] sched: add new 'book' scheduling domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds (yet) another scheduling domain to the scheduler. The
reason for this is that the recent (s390) z196 architecture has four cache
levels and uniform memory access (sort of -- see below).
The cpu/cache/memory hierarchy is as follows:

Each cpu has its private L1 (64KB I-cache + 128KB D-cache) and L2 (1.5MB)
cache.
A core consists of four cpus with a 24MB shared L3 cache.
A book consists of six cores with a 192MB shared L4 cache.

The z196 architecture has no SMT.
Also the statement that we have uniform memory access is not entirely
correct. Actually the machine uses memory striping, so it "looks" like
we have UMA until the next slice of memory gets accessed.
However there is no interface which tells us which piece of memory is local
or remote. So we (have to) simplify and assume that the cost of each memory
access with L4 cache miss is the same.

In order to somehow use the information about the cache hierarchy so that
the scheduler can make some decisions that improves cache hits I added the
'BOOK' scheduling domain between the MC and CPU domains.

First performance measurements however show now effect - neither good nor
bad. So it might be that the workloads aren't good enough, or that the
implementation is simply wrong.

Either way, since its currently very hard to get machine time for additional
measurements I thought it might be a good idea to post the patches as an RFC
even if we do not have any convincing arguments.

Also please note that the scheduling domain initializers certainly need some
tuning:
The line
#define SD_BOOK_INIT SD_CPU_INIT
within the arch support patch is just there so it compiles and until we have
something that really works.

As for the patches, I thinks that the first two patches could be merged
anytime since those are only cleanup/preparation patches.
Patch three adds the new scheduling domain and patch four the code needed
to represent books via the cpu topology sysfs interface.
Patch five is just the architecture backend.

A boot of a logical partition with 20 cpus, shared on two books, gives these
initializion output to the console:

Brought up 20 CPUs
CPU0 attaching sched-domain:
 domain 0: span 0-5 level BOOK
  groups: 0 1-3 (cpu_power = 3072) 4-5 (cpu_power = 2048)
  domain 1: span 0-19 level CPU
   groups: 0-5 (cpu_power = 6144) 6-19 (cpu_power = 14336)
CPU1 attaching sched-domain:
 domain 0: span 1-3 level MC
  groups: 1 2 3
  domain 1: span 0-5 level BOOK
   groups: 1-3 (cpu_power = 3072) 4-5 (cpu_power = 2048) 0
   domain 2: span 0-19 level CPU
    groups: 0-5 (cpu_power = 6144) 6-19 (cpu_power = 14336)
CPU2 attaching sched-domain:
 domain 0: span 1-3 level MC
  groups: 2 3 1
  domain 1: span 0-5 level BOOK
   groups: 1-3 (cpu_power = 3072) 4-5 (cpu_power = 2048) 0
   domain 2: span 0-19 level CPU
    groups: 0-5 (cpu_power = 6144) 6-19 (cpu_power = 14336)
CPU3 attaching sched-domain:
 domain 0: span 1-3 level MC
  groups: 3 1 2
  domain 1: span 0-5 level BOOK
   groups: 1-3 (cpu_power = 3072) 4-5 (cpu_power = 2048) 0
   domain 2: span 0-19 level CPU
    groups: 0-5 (cpu_power = 6144) 6-19 (cpu_power = 14336)
CPU4 attaching sched-domain:
 domain 0: span 4-5 level MC
  groups: 4 5
  domain 1: span 0-5 level BOOK
   groups: 4-5 (cpu_power = 2048) 0 1-3 (cpu_power = 3072)
   domain 2: span 0-19 level CPU
    groups: 0-5 (cpu_power = 6144) 6-19 (cpu_power = 14336)
CPU5 attaching sched-domain:
 domain 0: span 4-5 level MC
  groups: 5 4
  domain 1: span 0-5 level BOOK
   groups: 4-5 (cpu_power = 2048) 0 1-3 (cpu_power = 3072)
   domain 2: span 0-19 level CPU
    groups: 0-5 (cpu_power = 6144) 6-19 (cpu_power = 14336)
CPU6 attaching sched-domain:
 domain 0: span 6-9 level MC
  groups: 6 7 8 9
  domain 1: span 6-19 level BOOK
   groups: 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU7 attaching sched-domain:
 domain 0: span 6-9 level MC
  groups: 7 8 9 6
  domain 1: span 6-19 level BOOK
   groups: 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU8 attaching sched-domain:
 domain 0: span 6-9 level MC
  groups: 8 9 6 7
  domain 1: span 6-19 level BOOK
   groups: 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU9 attaching sched-domain:
 domain 0: span 6-9 level MC
  groups: 9 6 7 8
  domain 1: span 6-19 level BOOK
   groups: 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU10 attaching sched-domain:
 domain 0: span 10-11 level MC
  groups: 10 11
  domain 1: span 6-19 level BOOK
   groups: 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072) 6-9 (cpu_power = 4096)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU11 attaching sched-domain:
 domain 0: span 10-11 level MC
  groups: 11 10
  domain 1: span 6-19 level BOOK
   groups: 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072) 6-9 (cpu_power = 4096)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU12 attaching sched-domain:
 domain 0: span 12-13 level MC
  groups: 12 13
  domain 1: span 6-19 level BOOK
   groups: 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072) 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU13 attaching sched-domain:
 domain 0: span 12-13 level MC
  groups: 13 12
  domain 1: span 6-19 level BOOK
   groups: 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072) 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU14 attaching sched-domain:
 domain 0: span 14-16 level MC
  groups: 14 15 16
  domain 1: span 6-19 level BOOK
   groups: 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072) 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU15 attaching sched-domain:
 domain 0: span 14-16 level MC
  groups: 15 16 14
  domain 1: span 6-19 level BOOK
   groups: 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072) 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU16 attaching sched-domain:
 domain 0: span 14-16 level MC
  groups: 16 14 15
  domain 1: span 6-19 level BOOK
   groups: 14-16 (cpu_power = 3072) 17-19 (cpu_power = 3072) 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU17 attaching sched-domain:
 domain 0: span 17-19 level MC
  groups: 17 18 19
  domain 1: span 6-19 level BOOK
   groups: 17-19 (cpu_power = 3072) 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU18 attaching sched-domain:
 domain 0: span 17-19 level MC
  groups: 18 19 17
  domain 1: span 6-19 level BOOK
   groups: 17-19 (cpu_power = 3072) 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
CPU19 attaching sched-domain:
 domain 0: span 17-19 level MC
  groups: 19 17 18
  domain 1: span 6-19 level BOOK
   groups: 17-19 (cpu_power = 3072) 6-9 (cpu_power = 4096) 10-11 (cpu_power = 2048) 12-13 (cpu_power = 2048) 14-16 (cpu_power = 3072)
   domain 2: span 0-19 level CPU
    groups: 6-19 (cpu_power = 14336) 0-5 (cpu_power = 6144)
