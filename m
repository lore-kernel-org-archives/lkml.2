Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2LETSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 14:18:17 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:48480 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2LETSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 14:18:14 -0500
Message-ID: <50BF9D98.6060609@linux.vnet.ibm.com>
Date: Thu, 06 Dec 2012 00:46:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"	atomic
 readers to prevent CPU offline
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com> <20121205190703.GA13795@redhat.com>
In-Reply-To: <20121205190703.GA13795@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120519-8878-0000-0000-0000050D260E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 12:37 AM, Oleg Nesterov wrote:
> I'll try to read this series later,
> 
> one minor and almost offtopic nit.
> 
> On 12/06, Srivatsa S. Bhat wrote:
>>
>>  static int __ref take_cpu_down(void *_param)
>>  {
>>  	struct take_cpu_down_param *param = _param;
>> +	unsigned long flags;
>>  	int err;
>>
>> +	/*
>> +	 *  __cpu_disable() is the step where the CPU is removed from the
>> +	 *  cpu_online_mask. Protect it with the light-lock held for write.
>> +	 */
>> +	write_lock_irqsave(&light_hotplug_rwlock, flags);
>> +
>>  	/* Ensure this CPU doesn't handle any more interrupts. */
>>  	err = __cpu_disable();
>> -	if (err < 0)
>> +	if (err < 0) {
>> +		write_unlock_irqrestore(&light_hotplug_rwlock, flags);
>>  		return err;
>> +	}
>> +
>> +	/*
>> +	 * We have successfully removed the CPU from the cpu_online_mask.
>> +	 * So release the light-lock, so that the light-weight atomic readers
>> +	 * (who care only about the cpu_online_mask updates, and not really
>> +	 * about the actual cpu-take-down operation) can continue.
>> +	 *
>> +	 * But don't enable interrupts yet, because we still have work left to
>> +	 * do, to actually bring the CPU down.
>> +	 */
>> +	write_unlock(&light_hotplug_rwlock);
>>
>>  	cpu_notify(CPU_DYING | param->mod, param->hcpu);
>> +
>> +	local_irq_restore(flags);
>>  	return 0;
> 
> This is subjective, but imho _irqsave and the fat comment look confusing.
> 
> Currently take_cpu_down() is always called with irqs disabled, so you
> do not need to play with interrupts.
> 
> 10/10 does s/__stop_machine/stop_cpus/ and that patch could simply add
> local_irq_disable/enable into take_cpu_down().
> 

Hmm, we could certainly do that, but somehow I felt it would be easier to
read if we tinker and fix up the take_cpu_down() logic at one place, as a
whole, instead of breaking up into pieces in different patches. And that
also makes the last patch look really cute: it just replaces stop_machine()
with stop_cpus(), as the changelog intended.

I'll see if doing like what you suggested improves the readability, and
if yes, I'll change it. Thank you!

Regards,
Srivatsa S. Bhat

