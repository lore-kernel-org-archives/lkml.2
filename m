Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1DVTrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 15:47:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64630 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1DVTrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 15:47:10 -0400
Message-ID: <4DB1DB16.4090100@kernel.org>
Date: Fri, 22 Apr 2011 12:46:30 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Chris Samuel <chris@csamuel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad
 Pentium Pro system
References: <201104222333.25546.chris@csamuel.org> <20110422134648.GB23965@elte.hu> <BANLkTin7mXkuUm=p49WJcw_PiFH5K7TsmA@mail.gmail.com> <20110422192908.GA17975@elte.hu>
In-Reply-To: <20110422192908.GA17975@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DB1DB27.0014,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 12:29 PM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> with Chris's config for 2.6.39-rc4, current tip tree says:
>>
>> kernel/sched.c: In function ‘sched_init’:
>> kernel/sched.c:7845:28: error: ‘load_balance_tmpmask’ undeclared
>> (first use in this function)
>> kernel/sched.c:7845:28: note: each undeclared identifier is reported
>> only once for each function it appears in
>> kernel/sched.c:7845:3: warning: type defaults to ‘int’ in type name
>> kernel/sched.c:7845:28: warning: initialization makes pointer from
>> integer without a cast
>> kernel/sched.c:7845:3: warning: type defaults to ‘int’ in type name
> 
> Which sha1? It builds fine here on:
> 
>   ae1e16c: Merge branch 'perf/urgent'
> 

one local patch caused the problem.

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7808,9 +7808,6 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
 #endif
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	alloc_size += num_possible_cpus() * cpumask_size();
-#endif
 	if (alloc_size) {
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
@@ -7830,14 +7827,12 @@ void __init sched_init(void)
 		ptr += nr_cpu_ids * sizeof(void **);
 
 #endif /* CONFIG_RT_GROUP_SCHED */
-#ifdef CONFIG_CPUMASK_OFFSTACK
-		for_each_possible_cpu(i) {
-			per_cpu(load_balance_tmpmask, i) = (void *)ptr;
-			ptr += cpumask_size();
-		}
-#endif /* CONFIG_CPUMASK_OFFSTACK */
 	}
 
+	for_each_possible_cpu(i)
+		zalloc_cpumask_var_node(&per_cpu(load_balance_tmpmask, i),
+					GFP_NOWAIT, cpu_to_node(i));
+
 #ifdef CONFIG_SMP
 	init_defrootdomain();
 #endif


Sorry for noisy.

Thanks

Yinghai
