Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab2K1PXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:23:43 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34071 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab2K1PXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:23:42 -0500
Message-ID: <50B62C6E.4010202@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 09:23:26 -0600
From: Michael Wolf <mjw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: linux-kernel@vger.kernel.org, riel@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com
Subject: Re: [PATCH 2/5] Expand the steal time msr to also contain the consigned
 time.
References: <20121126203603.28840.38736.stgit@lambeau> <20121126203645.28840.56280.stgit@lambeau> <20121127210331.GA2710@phenom.dumpdata.com>
In-Reply-To: <20121127210331.GA2710@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12112815-5816-0000-0000-000005965714
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 03:03 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Nov 26, 2012 at 02:36:45PM -0600, Michael Wolf wrote:
>> Add a consigned field.  This field will hold the time lost due to capping or overcommit.
>> The rest of the time will still show up in the steal-time field.
>>
>> Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
>> ---
>>   arch/x86/include/asm/paravirt.h       |    4 ++--
>>   arch/x86/include/asm/paravirt_types.h |    2 +-
>>   arch/x86/kernel/kvm.c                 |    7 ++-----
>>   kernel/sched/core.c                   |   10 +++++++++-
>>   kernel/sched/cputime.c                |    2 +-
>>   5 files changed, 15 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
>> index a0facf3..a5f9f30 100644
>> --- a/arch/x86/include/asm/paravirt.h
>> +++ b/arch/x86/include/asm/paravirt.h
>> @@ -196,9 +196,9 @@ struct static_key;
>>   extern struct static_key paravirt_steal_enabled;
>>   extern struct static_key paravirt_steal_rq_enabled;
>>   
>> -static inline u64 paravirt_steal_clock(int cpu)
>> +static inline u64 paravirt_steal_clock(int cpu, u64 *steal)
> So its u64 here.
>>   {
>> -	return PVOP_CALL1(u64, pv_time_ops.steal_clock, cpu);
>> +	PVOP_VCALL2(pv_time_ops.steal_clock, cpu, steal);
>>   }
>>   
>>   static inline unsigned long long paravirt_read_pmc(int counter)
>> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
>> index 142236e..5d4fc8b 100644
>> --- a/arch/x86/include/asm/paravirt_types.h
>> +++ b/arch/x86/include/asm/paravirt_types.h
>> @@ -95,7 +95,7 @@ struct pv_lazy_ops {
>>   
>>   struct pv_time_ops {
>>   	unsigned long long (*sched_clock)(void);
>> -	unsigned long long (*steal_clock)(int cpu);
>> +	void (*steal_clock)(int cpu, unsigned long long *steal);
> But not u64 here? Any particular reason?
>
It should be void everywhere, thanks for catching that I will change the 
code.


