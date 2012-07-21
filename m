Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab2GUSCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 14:02:34 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57528 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2GUSCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 14:02:33 -0400
Message-ID: <500AEE6C.8060506@linux.vnet.ibm.com>
Date: Sat, 21 Jul 2012 23:31:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 3/7] smpboot: Provide infrastructure for percpu hotplug
 threads
References: <20120716103749.122800930@linutronix.de> <20120716103948.352501068@linutronix.de> <500A75D7.3070706@linux.vnet.ibm.com>
In-Reply-To: <500A75D7.3070706@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12072118-1618-0000-0000-0000021C3246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2012 02:56 PM, Srivatsa S. Bhat wrote:
> On 07/16/2012 04:12 PM, Thomas Gleixner wrote:
>> Provide a generic interface for setting up and tearing down percpu
>> threads.
>>
>> On registration the threads for already online cpus are created and
>> started. On deregistration (modules) the threads are stoppped.
>>
>> During hotplug operations the threads are created, started, parked and
>> unparked. The datastructure for registration provides a pointer to
>> percpu storage space and optional setup, cleanup, park, unpark
>> functions. These functions are called when the thread state changes.
>>
>> Each implementation has to provide a function which is queried and
>> returns whether the thread should run and the thread function itself.
>>
>> The core code handles all state transitions and avoids duplicated code
>> in the call sites.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Elegant design and very beautiful code!
> It was such a pleasure to read and review it :-)
> 
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 

Of course, the preempt imbalance needs to get resolved, as pointed out
by Paul... Your patchset + his fix worked fine, without throwing any
scheduling-while-atomic splats.

Regards,
Srivatsa S. Bhat

> [ A minor nit below ]
> 
>> ---
>>  include/linux/smpboot.h |   43 +++++++++
>>  kernel/cpu.c            |   10 +-
>>  kernel/smpboot.c        |  229 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  kernel/smpboot.h        |    4 
>>  4 files changed, 285 insertions(+), 1 deletion(-)
>>
>> +
>> +/**
>> + * smpboot_thread_fn - percpu hotplug thread loop function
>> + * @void:	thread data pointer
> 
> s/void/data
> 
>> + *
>> + * Checks for thread stop and park conditions. Calls the necessary
>> + * setup, cleanup, park and unpark functions for the registered
>> + * thread.
>> + *
>> + * Returns 1 when the thread should exit, 0 otherwise.
>> + */
>> +static int smpboot_thread_fn(void *data)
>> +{
>> +	struct smpboot_thread_data *td = data;
>> +	struct smp_hotplug_thread *ht = td->ht;
>> +
> 
> Regards,
> Srivatsa S. Bhat
> 


-- 
Regards,
Srivatsa S. Bhat
IBM Linux Technology Center


