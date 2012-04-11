Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab2DKBG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:06:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:45033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759880Ab2DKBG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:06:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="127540603"
Subject: load balancing regression since commit 367456c7
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Huang@vger.kernel.org, Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Apr 2012 18:06:16 -0700
Message-ID: <1334106376.19157.89.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

We noticed in a hackbench test (./hackbench 100 process 2000)
on a Sandy bridge 2 socket server, there has been a slow down
by a factor of 4 since commit 367456c7 was applied
(sched: Ditch per cgroup task lists for load-balancing).

The commit 5d6523e (sched: Fix load-balance wreckage) did
not fix the regression.

In the profile, there is heavy spin lock contention in the load_balance path of 3.4-rc2
where it was less than .003% of cpu before commit 367456c7.

When we looked into /proc/schedstat for 3.4-rc2 for the run duration, 
on cpu0 schedule was called 13x more often, and schedule call which
left the processor idle was 530x as much.

There was also a big increase in try to wake up remote (sd->ttwu_wake_remote) count.
		
		increase in sd->ttwu_wake_remote for cpu0
domain 0	540%
domain 1 	7570%
domain 2	4426%

Wonder if there is unnecessary load balancing to remote cpu?

Tim


profile for 3.4-rc2

     7.16%     hackbench  [kernel.kallsyms]      [k] _raw_spin_lock
               |
               --- _raw_spin_lock
                  |
                  |--56.52%-- load_balance
                  |          idle_balance
                  |          __schedule
                  |          schedule
                  |          |
                  |          |--98.73%-- schedule_timeout
                  |          |          |
                  |          |          |--97.80%-- unix_stream_recvmsg
                  |          |          |          sock_aio_read.part.7
                  |          |          |          sock_aio_read
                  |          |          |          do_sync_read
                  |          |          |          vfs_read
                  |          |          |          sys_read
                  |          |          |          system_call
                  |          |          |          __read_nocancel
                  |          |          |          create_worker
                  |          |          |          group
                  |          |          |          main
                  |          |          |          __libc_start_main
                  |          |          |






