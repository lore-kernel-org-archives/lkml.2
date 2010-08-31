Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab0HaI1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:27:36 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:48541 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab0HaI0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:26:47 -0400
Message-Id: <20100831082814.501484459@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 31 Aug 2010 10:28:14 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH V2 0/4] sched: add new 'book' scheduling domain
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

Also please note that the s390 arch scheduling domain initializers need
tuning:
The line
#define SD_BOOK_INIT SD_CPU_INIT
within the arch support patch is just there so it compiles and until we have
something that really works.


Changes since V1:

Removed powersavings sysfs knob for the new scheduling domain since Peter
objected to it ;)
Actually adding a third sysfs powersavings knob would increase the config
space to 27 possible settings. That's simply too much and indeed no admin
would care about fine tuning that.
What is needed is a single knob which configures the scheduler to do the
'right thing'.
It's up to the powersavings guys to come up with a viable solution here ;)
