Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab2LKOHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:07:22 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:50880 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab2LKOHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:07:18 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 9/9] cpu: No more __stop_machine() in _cpu_down()
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Dec 2012 19:35:47 +0530
Message-ID: <20121211140541.23621.72514.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com>
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121114-9574-0000-0000-000005B6A811
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The _cpu_down() function invoked as part of the CPU-hotplug offlining
process currently invokes __stop_machine(), which is slow and inflicts
substantial real-time latencies on the entire system.  This patch
substitutes stop_one_cpu() for __stop_machine() in order to improve
both performance and real-time latency.

This is currently unsafe, because there are a number of uses of
preempt_disable() that are intended to block CPU-hotplug offlining.
These will be fixed by using get/put_online_cpus_atomic(), but in the
meantime, this commit is one way to help locate them.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
[ srivatsa.bhat@linux.vnet.ibm.com: Refer to the new sync primitives for
  readers (in the changelog), and s/stop_cpus/stop_one_cpu ]
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 5a63296..3f9498e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -484,7 +484,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	}
 	smpboot_park_threads(cpu);
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = stop_one_cpu(cpu, take_cpu_down, &tcd_param);
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		smpboot_unpark_threads(cpu);

