Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2K3IKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:10:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2674 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab2K3IKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:10:50 -0500
X-IronPort-AV: E=Sophos;i="4.83,347,1352044800"; 
   d="scan'208";a="6306743"
Message-ID: <50B86ACA.2060408@cn.fujitsu.com>
Date: Fri, 30 Nov 2012 16:14:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] srcu: use ACCESS_ONCE() to access sp->completed in
 srcu_read_lock()
References: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com> <1354178770-6028-9-git-send-email-laijs@cn.fujitsu.com> <20121129220525.GD2474@linux.vnet.ibm.com>
In-Reply-To: <20121129220525.GD2474@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/30 16:10:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/30 16:10:17,
	Serialize complete at 2012/11/30 16:10:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 06:05 AM, Paul E. McKenney wrote:
> On Thu, Nov 29, 2012 at 04:46:09PM +0800, Lai Jiangshan wrote:
>> Old srcu implement requires sp->completed is loaded in
>> RCU-sched(preempt_disable()) section.
>>
>> The new srcu is now not RCU-sched based, it doesn't require the load of
>> sp->completed and the access to counter must be in the same RCU-sched
>> read site C.S., so we use ACCESS_ONCE() instead, and move it out of
>> the preempt_disable() section, preempt_disable() section is only used
>> for percpu data, not for RCU-sched.
>>
>> The resulted code is almost as the same as before, but it helps people to
>> understand the code, and it avoids to add surprise to reviewer: "why we need
>> rcu_read_lock_sched_held() here?"
> 
> The first seven patches look good!
> 
> One question about this one -- the current code provided dependency
> ordering between the fetch of idx and the increment, but the code after
> this patch would not provide this ordering (at least not on Alpha,
> and maybe also not in presence of aggressive compiler optimizations).
> 
> In the immortal words of MSDOS, "Are you sure?"

Sure, the update site doesn't modify the percpu counter, so there is
no dependency mb needed in read-site. I can ask "where is the corresponding
mb which is paired with this dependency mb?"


The correctness of SRCU is based on
	the wait in synchrinize_srcu()
	the counter and seq and the mbs between them
	X: sp->completed is not necessary here except for reporting how many GP passed.

The starvation-free of SRCU is based on
	split counter and seq into two index,
	split the wait into two waits for both index
	add sp->completed field
	the flip between the two waits
	-> the index for wait and the index for late-enough-after-flip read-site are different.


Thanks,
Lai



>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>>  kernel/srcu.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/srcu.c b/kernel/srcu.c
>> index 38a762f..224400a 100644
>> --- a/kernel/srcu.c
>> +++ b/kernel/srcu.c
>> @@ -294,9 +294,8 @@ int __srcu_read_lock(struct srcu_struct *sp)
>>  {
>>  	int idx;
>>
>> +	idx = ACCESS_ONCE(sp->completed) & 0x1;
>>  	preempt_disable();
>> -	idx = rcu_dereference_index_check(sp->completed,
>> -					  rcu_read_lock_sched_held()) & 0x1;
>>  	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
>>  	smp_mb(); /* B */  /* Avoid leaking the critical section. */
>>  	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
>> -- 
>> 1.7.4.4
>>
> 
> 

