Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1EEPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:25:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28802 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab1EEPZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:25:56 -0400
Message-ID: <4DC2C12E.1070101@oracle.com>
Date: Thu, 05 May 2011 10:24:30 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110503 Lightning/1.0b2 OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/UAFCAFCATUAFLAF_1301673577011-962016341 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, paulmck@us.ibm.com
Subject: Re: idle issues running sembench on 128 cpus II
References: <4DC1C95B.4040706@gmail.com> <m2pqnyyva8.fsf@firstfloor.org> <alpine.LFD.2.02.1105050023070.3005@ionos> <20110504230349.GC2925@one.firstfloor.org> <alpine.LFD.2.02.1105050110440.3005@ionos> <20110504234241.GD2925@one.firstfloor.org> <20110504234806.GF2925@one.firstfloor.org>
In-Reply-To: <20110504234806.GF2925@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DC2C13E.00B2:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 06:48 PM, Andi Kleen wrote:
>> Here's a new patch without the raw. Boots on my Westmere.
>
> Sorry appended the old patch. Here's really the new version.
>
> From: Andi Kleen<ak@linux.intel.com>
> Date: Wed, 4 May 2011 15:09:27 -0700
> Subject: [PATCH] Move C3 stop test outside lock
>
> Avoid taking locks in the idle path for systems where the timer
> doesn't stop in C3.
>
> Signed-off-by: Andi Kleen<ak@linux.intel.com>
>
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index da800ff..7f565b7 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -456,23 +456,22 @@ void tick_broadcast_oneshot_control(unsigned long reason)
>   	unsigned long flags;
>   	int cpu;
>
> -	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
> -
>   	/*
>   	 * Periodic mode does not care about the enter/exit of power
>   	 * states
>   	 */
>   	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
> -		goto out;
> +		return;
>
> -	bc = tick_broadcast_device.evtdev;
>   	cpu = smp_processor_id();
> +	bc = tick_broadcast_device.evtdev;
>   	td =&per_cpu(tick_cpu_device, cpu);
>   	dev = td->evtdev;
>
>   	if (!(dev->features&  CLOCK_EVT_FEAT_C3STOP))
> -		goto out;
> +		return;

out: is now defined but not used in this function.

>
> +	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
>   	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
>   		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
>   			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
>
