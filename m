Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab1I3Xcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:32:51 -0400
Received: from claw.goop.org ([74.207.240.146]:46460 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab1I3Xcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:32:45 -0400
Message-ID: <4E865198.1070901@goop.org>
Date: Fri, 30 Sep 2011 16:32:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] stop_machine: make stop_machine safe and efficient
 to call early
References: <4E85EE1F.7050508@goop.org> <20110930230635.GA2658@mtj.dyndns.org>
In-Reply-To: <20110930230635.GA2658@mtj.dyndns.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 04:06 PM, Tejun Heo wrote:
> Hello, Jeremy.
>
> On Fri, Sep 30, 2011 at 09:28:15AM -0700, Jeremy Fitzhardinge wrote:
>> Make stop_machine() safe to call early in boot, before SMP has been
>> set up, by simply calling the callback function directly if there's
>> only one CPU online.
> ...
>> @@ -485,6 +485,9 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>>  					    .num_threads = num_online_cpus(),
>>  					    .active_cpus = cpus };
>>  
>> +	if (smdata.num_threads == 1)
>> +		return (*fn)(data);
>> +
> As others have pointed out, you'll need to call both local and hardirq
> disables.  Also, I think the description and the code are a bit
> misleading.  How aobut setting cpu_stop_initialized in cpu_stop_init()
> and testing it from __stop_machine() instead?  I think it would be
> better to keep the behavior as uniform as possible once things are up
> and running.

Yes, I was wondering about that.  Do you think the patch (with irq fixes
in place) would affect the behaviour of an SMP kernel running UP?

    J

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index f5855fe3..70b3be4 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -41,6 +41,7 @@ struct cpu_stopper {
 };
 
 static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
+static bool stop_machine_initialized = false;
 
 static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
 {
@@ -386,6 +387,8 @@ static int __init cpu_stop_init(void)
 	cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_ONLINE, bcpu);
 	register_cpu_notifier(&cpu_stop_cpu_notifier);
 
+	stop_machine_initialized = true;
+
 	return 0;
 }
 early_initcall(cpu_stop_init);
@@ -485,7 +488,7 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
-	if (smdata.num_threads == 1) {
+	if (!stop_machine_initialized) {
 		/*
 		 * Handle the case where stop_machine() is called early in boot
 		 * before SMP startup.


