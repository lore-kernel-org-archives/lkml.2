Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1DGJ4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:56:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50236 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751827Ab1DGJ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:56:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/UYYk4Gl/UMUhwbRr8zXCQSuu/rSGIoxqiVZUoI5
	dtYVULpXQ+MUfq
Subject: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Menage <menage@google.com>, Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 11:55:53 +0200
Message-ID: <1302170153.12304.31.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Wrt these patches:

https://lkml.org/lkml/2010/11/24/14 [PATCH 1/2] cgroup: Set CGRP_RELEASABLE when adding to a cgroup
https://lkml.org/lkml/2010/11/24/15 [PATCH 2/2] cgroup: Remove call to synchronize_rcu in cgroup_attach_task

I received a query regarding 2/2 because a large database company is
apparently moving tasks between cgroups frequently enough that their
database initialization time dropped from ~11 hours to ~4 hours when
they applied this patch.

Curious why these got no traction.

Regardless of the wisdom of frequent cgroup moves, Joe User launching
light tasks via cgexec would gain quite a bit as well it seems.

Q/D measurement of cgexec -g cpu:test sh -c exit.

Unpatched:

marge:~ # time perf stat --repeat=1000 cgexec -g cpu:test sh -c exit

 Performance counter stats for 'cgexec -g cpu:test sh -c exit' (1000 runs):

          2.686149 task-clock-msecs         #      0.119 CPUs    ( +-   0.067% )
                 2 context-switches         #      0.001 M/sec   ( +-   0.100% )
                 0 CPU-migrations           #      0.000 M/sec   ( +-  35.231% )
               633 page-faults              #      0.236 M/sec   ( +-   0.003% )
           6292755 cycles                   #   2342.668 M/sec   ( +-   0.062% )
           4844702 instructions             #      0.770 IPC     ( +-   0.004% )
            974011 branches                 #    362.605 M/sec   ( +-   0.005% )
             35187 branch-misses            #      3.613 %       ( +-   0.027% )
     <not counted> cache-references        
     <not counted> cache-misses            

        0.022597372  seconds time elapsed   ( +-   0.981% )


real    0m23.054s
user    0m0.380s
sys     0m0.000s

Patched:

marge:~ # time perf stat --repeat=1000 cgexec -g cpu:test sh -c exit

 Performance counter stats for 'cgexec -g cpu:test sh -c exit' (1000 runs):

          2.639303 task-clock-msecs         #      0.915 CPUs    ( +-   0.051% )
                 1 context-switches         #      0.000 M/sec   ( +-   1.048% )
                 0 CPU-migrations           #      0.000 M/sec   ( +-  21.602% )
               633 page-faults              #      0.240 M/sec   ( +-   0.003% )
           3883572 cycles                   #   1471.439 M/sec   ( +-   1.767% )
           4830809 instructions             #      1.244 IPC     ( +-   0.191% )
            975204 branches                 #    369.493 M/sec   ( +-   0.009% )
             35314 branch-misses            #      3.621 %       ( +-   0.060% )
     <not counted> cache-references        
     <not counted> cache-misses            

        0.002884424  seconds time elapsed   ( +-   0.055% )


real    0m3.329s
user    0m0.012s
sys     0m0.352s



