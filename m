Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab0LGOVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:21:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:54369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab0LGOVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:21:47 -0500
Message-ID: <4CFE4294.30001@kernel.org>
Date: Tue, 07 Dec 2010 15:20:04 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 04/11] x86: Use this_cpu_ops for current_cpu_data
 accesses
References: <20101206171618.302060721@linux.com> <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org>
In-Reply-To: <4CFE41F8.7040400@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 14:20:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 03:17 PM, Tejun Heo wrote:
> On 12/06/2010 06:16 PM, Christoph Lameter wrote:
>> Current_cpu_data accesses are per cpu accesses. We can also use
>> this_cpu_ops if a scalar is retrieved.
>>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Signed-off-by: Christoph Lameter <cl@linux.com>
>>
>> ---
>>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
>>  arch/x86/kernel/cpu/intel_cacheinfo.c     |    4 ++--
>>  arch/x86/kernel/smpboot.c                 |   10 +++++-----
>>  3 files changed, 8 insertions(+), 8 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/smpboot.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/smpboot.c	2010-11-30 11:53:03.000000000 -0600
>> +++ linux-2.6/arch/x86/kernel/smpboot.c	2010-11-30 11:57:02.000000000 -0600
>> @@ -430,7 +430,7 @@ void __cpuinit set_cpu_sibling_map(int c
>>  
>>  	cpumask_set_cpu(cpu, c->llc_shared_map);
>>  
>> -	if (current_cpu_data.x86_max_cores == 1) {
>> +	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
>>  		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
>>  		c->booted_cores = 1;
>>  		return;
>> @@ -1377,7 +1377,7 @@ void play_dead_common(void)
>>  
>>  	mb();
>>  	/* Ack it */
>> -	__get_cpu_var(cpu_state) = CPU_DEAD;
>> +	__this_cpu_write(cpu_state, CPU_DEAD);
> 
> This belongs to the previous patch, right?  I'll move it over and
> apply 03 and 04.  I think routing these through percpu is okay but if
> anyone wants these to go through x86, scream.

Ooh, was too fast.  I think mixing the use of percpu accesses to
cpu_info and the wrapper macro current_cpu_data is quite confusing.
There aren't too many current_cpu_data users in x86 anyway.  Can you
please make the conversion complete?  I'm moving the above misplaced
chunk into 03 and not applying 04 for now.

Thank you.

-- 
tejun
