Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2FDRBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:01:32 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45037 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2FDRB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:01:28 -0400
Message-ID: <4FCCE9AF.6080309@linux.vnet.ibm.com>
Date: Mon, 04 Jun 2012 22:30:31 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: peterz@infradead.org, paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        mingo@kernel.org, yong.zhang0@gmail.com, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Don Zickus <dzickus@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 07/27] x86, smpboot: Use generic SMP booting infrastructure
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091148.31979.53116.stgit@srivatsabhat.in.ibm.com> <alpine.LFD.2.02.1206041613380.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206041613380.3086@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060417-5564-0000-0000-00000311262D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 07:59 PM, Thomas Gleixner wrote:

> On Fri, 1 Jun 2012, Srivatsa S. Bhat wrote:
>> From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
>>
>> Convert x86 to use the generic framework to boot secondary CPUs.
>>
>> Notes:
>> 1. x86 manipulates the cpu_online_mask under vector_lock. So, while
>> converting over to the generic smp booting code, override arch_vector_lock()
>> and arch_vector_unlock() to lock_vector_lock() and unlock_vector_lock()
>> respectively.
>>
>> 2. In smp_callin(), we allow the master to continue as soon as the physical
>> booting of the secondary processor is done. That is, we don't wait till the
>> CPU_STARTING notifications are sent.
>>
>> Implications:
>>  - This does not alter the order in which the notifications are sent (i.e.,
>>    still CPU_STARTING is followed by CPU_ONLINE) because the master waits till
>>    the new cpu is set in the cpu_online_mask before returning to generic code.
>>
>>  - This approach is better because of 2 reasons:
>>    a. It makes more sense: the master has a timeout for waiting on the
>>       cpu_callin_map - which means we should report back as soon as possible.
>>       The whole idea of having a timeout is to estimate the maximum time that
>>       could be taken for physical booting. This approach separates out the
>>       physical booting vs running CPU hotplug callbacks and reports back to
>>       the master as soon as physical booting is done.
> 
> How do you deal with the problem that the master does not come back in
> time?


Sorry, I didn't quite get your point... This doesn't completely solve the timeout
problem, but makes the situation a little bit better, that's all.

> There is a timeout on the booting side as well.


Yes, the wait for the cpu_callout_mask.

> I haven't found
> out why this timeout exists at all, but we need to take care of that
> and there is a patch on LKML which removes the panic as this can
> happen on virt.


Oh! Ok..

> I really wonder whether the hardware for which this
> timeout stuff was introduced still exists or whether we can simply get
> rid of it completely.
>


Sounds good :-)

 
> Also the whole callin/callout mask business wants to be in the generic
> code. It can be replaced completely by cpu_state, at least that's what
> I was aiming for. There is no need for several variables tracking the
> same thing in different ways.
> 


Exactly! I was thinking of consolidating the callin/callout/commenced/whatever
mask in various architectures in a future patchset. I haven't touched them
in this one. And using cpu_state for that is a very good point. I'll keep
that in mind, thanks!

 

Regards,
Srivatsa S. Bhat

