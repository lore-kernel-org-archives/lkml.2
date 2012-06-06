Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2FFKRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:17:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57549 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751199Ab2FFKRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:17:46 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+k9wxwx8Ck06SlSlyJb7mjnhjKwta3EG1c81QXjH
	ZmmPxEUAWVYHYJ
Message-ID: <1338977861.28497.36.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
Date: Wed, 06 Jun 2012 12:17:41 +0200
In-Reply-To: <1337865431.9783.148.camel@laptop>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 15:17 +0200, Peter Zijlstra wrote:

> Did you do you numbers with the distro NR_CPUS=4096 bloat?

4 socket Westmere-EX 40 core box.. ouch^ouch. 

3.0 has none of the below, 3.0x all, 3.0xx all but the ones commented
out.  Most of the deltas are sibling avoidance, though throttle-nohz
plays a role in 3.0 vs 3.0x, as does knob tweakery, though very very
small for these particular tests.  The rest are ~meaningless.

sched-use-rt-nr_cpus_allowed-to-recover-select_task_rq-cycles.patch
sched-set-skip_clock_update-when-yielding.patch
sched-throttle-nohz.patch
sched-Wrap-scheduler-p--cpus_allowed-access.patch
sched-Avoid-SMT-siblings-in-select_idle_sibling-if-possible.patch
sched-Clean-up-domain-traversal-in-select_idle_sibling.patch
sched-Remove-rcu_read_lock-unlock-from-select_idle_sibling.patch
sched-Fix-the-sched-group-node-allocation-for-SD_OVERLAP-domains.patch
sched-domain-flags-proc-handler.patch
# sched-tweak-select_idle_sibling.patch
sched-tweak-knobs.patch
# sched-ratelimit-affine-wakeup-migrations.patch

thench      1         2         4          8         16         32         64        128
3.0       225       451       911       1573       2723       3501      11189      13951
3.0x      299       603      1211       2418       4697       6847      11606      14557
vs 3.0  1.328     1.337     1.329      1.537      1.724       1.955     1.037      1.043

3.0xx      30        41       118        645       3769       6214      12233      14312
vs 3.0x 0.100     0.067     0.097      0.266      0.802       0.907     1.054      0.983
                                                                        hmmm 
aim7 ~low load.. not saturating.

Benchmark       Version Machine Run Date
AIM Multiuser Benchmark - Suite VII     "1.1"   3.0x      Jun  6 09:29:20 2012

Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
64      26223.1         98      14.8    293.3   6.8289

Benchmark       Version Machine Run Date
AIM Multiuser Benchmark - Suite VII     "1.1"   3.0xx     Jun  6 11:12:21 2012

Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
64      18845.5         82      20.6    254.8   4.9077       vs 3.0x  0.718


