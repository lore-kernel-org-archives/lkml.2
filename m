Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984Ab0IKJUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 05:20:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:47699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0IKJUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 05:20:54 -0400
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
	 <1284116817.402.33.camel@laptop>
	 <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 11 Sep 2010 11:20:38 +0200
Message-ID: <1284196838.2251.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 17:28 -0700, Andrew Morton wrote:
> Where is this scheduler bug?  Did it occur because someone didn't
> understand __smp_call_function_single()?  Or did it occur because the
> scheduler code is doing something which its implementors did not expect
> or intend? 


It comes from 83cd4fe2 (sched: Change nohz idle load balancing logic to
push model), where nohz_balance_kick() simply needs to kick the
designated driver into action.

I take it Venki assumed __smp_call_function_single() works like
smp_call_function_single() where you can use it for the local cpu as
well.

I guess we could do something like the below as well, which would be
slightly faster since we don't actually need to call raise_softirq()
since we already set it for self a bit earlier in order to have it do
the regular load-balance actions.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9b5b4f8..c8ca1cb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3404,11 +3404,13 @@ static void nohz_balancer_kick(int cpu)
 	}
 
 	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
-		struct call_single_data *cp;
-
 		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
-		cp = &per_cpu(remote_sched_softirq_cb, cpu);
-		__smp_call_function_single(ilb_cpu, cp, 0);
+
+		if (ilb_cpu != cpu) {
+			struct call_single_data *cp;
+			cp = &per_cpu(remote_sched_softirq_cb, cpu);
+			__smp_call_function_single(ilb_cpu, cp, 0);
+		}
 	}
 	return;
 }

