Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401Ab1FPOqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:46:37 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59605 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758311Ab1FPOqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:46:36 -0400
Date: Thu, 16 Jun 2011 10:46:26 -0400
Message-Id: <E1QXDpy-0007Wr-5V@tytso-glaptop>
To: linux-kernel@vger.kernel.org
Subject: scheduler / perf stat question about CPU-migrations
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone tell me how I'm being confused?

I ran the following command as root:

	perf stat schedtool -a 1 -e e2fsck -ft /dev/funarg/kbuild

This runs e2fsck under perf, with the cpu affinity nailed to a single
CPU.  I therefore expected the CPU-migrations field reported by perf to
be 0.  That was not what I found, though:

Performance counter stats for 'schedtool -a 1 -e e2fsck -ft /dev/funarg/kbuild':

        1169.715766  task-clock-msecs         #      0.180 CPUs 
               9212  context-switches         #      0.008 M/sec
                307  CPU-migrations           #      0.000 M/sec
               1875  page-faults              #      0.002 M/sec
         2737168498  cycles                   #   2340.029 M/sec
         3125632038  instructions             #      1.142 IPC  
          688556730  branches                 #    588.653 M/sec
            7263580  branch-misses            #      1.055 %    
           15222417  cache-references         #     13.014 M/sec
            1488633  cache-misses             #      1.273 M/sec

        6.481483548  seconds time elapsed

How could this be?  The CPU-migrations event counter only gets
incremented if a task changes CPU's, as seen in kernel/sched.c:

	if (task_cpu(p) != new_cpu) {
		p->se.nr_migrations++;
		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
	}

So it should be 0, not 307, right?    What am I missing?

						- Ted
