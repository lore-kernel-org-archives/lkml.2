Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab0EYNYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:24:04 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55030 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab0EYNYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:24:01 -0400
Date: Tue, 25 May 2010 18:53:46 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: tj@kernel.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3] Make sure timers have migrated before killing
	migration_thread
Message-ID: <20100525132346.GA14986@amitarora.in.ibm.com>
References: <20100519090557.GA15237@amitarora.in.ibm.com> <1274261515.5605.10423.camel@twins> <20100524095951.GA17680@amitarora.in.ibm.com> <1274787095.5882.949.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274787095.5882.949.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 01:31:35PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-24 at 15:29 +0530, Amit K. Arora wrote:
> > 
> > Thus, since above race can never happen, is there any other issue with
> > this patch ?
> 
> It doesn't seem to apply nicely...

Here is the new patch. 

Problem : In a stress test where some heavy tests were running along with
regular CPU offlining and onlining, a hang was observed. The system seems to
be hung at a point where migration_call() tries to kill the migration_thread
of the dying CPU, which just got moved to the current CPU. This migration
thread does not get a chance to run (and die) since rt_throttled is set to 1
on current, and it doesn't get cleared as the hrtimer which is supposed to
reset the rt bandwidth (sched_rt_period_timer) is tied to the CPU which we just
marked dead!

Solution : This patch pushes the killing of migration thread to "CPU_POST_DEAD"
event. By then all the timers (including sched_rt_period_timer) should have got
migrated (along with other callbacks).

Thanks!
Regards,
Amit Arora

Signed-off-by: Amit Arora <aarora@in.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
---
diff -Nuarp linux-2.6-next-20100525.org/kernel/stop_machine.c linux-2.6-next-20100525/kernel/stop_machine.c
--- linux-2.6-next-20100525.org/kernel/stop_machine.c	2010-05-25 14:27:51.000000000 -0400
+++ linux-2.6-next-20100525/kernel/stop_machine.c	2010-05-25 14:30:09.000000000 -0400
@@ -321,7 +321,7 @@ static int __cpuinit cpu_stop_cpu_callba
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
-	case CPU_DEAD:
+	case CPU_POST_DEAD:
 	{
 		struct cpu_stop_work *work;
 
