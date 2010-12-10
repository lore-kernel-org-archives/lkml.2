Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab0LJRS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:18:26 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:46279 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab0LJRSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:18:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=v1kNbDDGQ1aGdXleM2GdDBZ1yyR8V/QmwLdDrQhp0LAg6PWOibS5zLpN5eZaBEzSYF
         7hn++R6sO7s9uTaldTrIs+lyqHgoHonbPK0IKmAejS3jxTYxzSIdxGIhYdXng9AEwU+X
         qELjEy8ozkwC7dPw6fKbx0OtYPpTM6QZ8SZss=
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1291988866.6803.171.camel@twins>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	 <1291851079-27061-1-git-send-email-venki@google.com>
	 <1291899120.29292.7.camel@twins>
	 <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
	 <1291917330.6803.7.camel@twins>
	 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
	 <1291920939.6803.38.camel@twins>
	 <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
	 <1291936593.13513.3.camel@laptop>
	 <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
	 <1291975704.6803.59.camel@twins>  <1291987065.6803.151.camel@twins>
	 <1291987635.6803.161.camel@twins>  <1291988866.6803.171.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 18:18:20 +0100
Message-ID: <1292001500.3580.268.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 10 décembre 2010 à 14:47 +0100, Peter Zijlstra a écrit :
> Full patch..

> unt_system_vtime(struct task_struct *curr)
>  {
>  	unsigned long flags;
> +	s64 delta;
>  	int cpu;
> -	u64 now, delta;
>  
>  	if (!sched_clock_irqtime)
>  		return;
>  
>  	local_irq_save(flags);
> -
>  	cpu = smp_processor_id();
> -	now = sched_clock_cpu(cpu);
> -	delta = now - per_cpu(irq_start_time, cpu);
> -	per_cpu(irq_start_time, cpu) = now;
> -	/*
> -	 * We do not account for softirq time from ksoftirqd here.
> -	 * We want to continue accounting softirq time to ksoftirqd thread
> -	 * in that case, so as not to confuse scheduler with a special task
> -	 * that do not consume any time, but still wants to run.
> -	 */
> +	delta = sched_clock_cpu(cpu) - per_cpu(irq_start_time, cpu);
> +	per_cpu(irq_start_time, cpu) += delta;

We should add some checkpatch warning to any new per_cpu() use.


	delta = sched_clock_cpu(cpu) - __this_cpu_read(irq_start_time);
	__this_cpu_add(irq_start_time, delta);



Also irq_time_write_begin() and irq_time_write_end() could be faster
(called for current cpu)

static inline void irq_time_write_begin(void)
{
	__this_cpu_inc(irq_time_seq.sequence);
	smp_wmb();
}
 
static inline void irq_time_write_end(void)
{
	smp_wmb();
	__this_cpu_inc(irq_time_seq.sequence);
}
 


