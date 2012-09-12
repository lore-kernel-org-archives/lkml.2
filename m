Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab2ILH7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:59:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:40826 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab2ILH7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:59:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,408,1344236400"; 
   d="scan'208";a="191934448"
Message-ID: <505040A6.7020608@intel.com>
Date: Wed, 12 Sep 2012 15:58:30 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, venki@google.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] sched: trigger_load_balance clean up
References: <1347261059-24747-1-git-send-email-alex.shi@intel.com>  <1347261059-24747-2-git-send-email-alex.shi@intel.com> <1347388574.26695.135.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1347388574.26695.135.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 02:36 AM, Suresh Siddha wrote:

> On Mon, 2012-09-10 at 15:10 +0800, Alex Shi wrote:
>> Remove a redundant check for on_null_domain(cpu), and rerange the code
>> that make it more readable.
> 
> hmm, but we are now doing the on_null_domain() check always,
> irrespective of whether we need the load balance or not.
> 
> do we really need the on_null_domain() check there? What happens if we
> just remove it?


A very very simple try can not show removing causes crash. But as to
RCU details, I don't know. :(

CC to Paul

> 
> thanks,
> suresh
> 
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  kernel/sched/fair.c |    8 +++++---
>>  1 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 5bbc4bf..529092d 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4934,11 +4934,13 @@ static inline int on_null_domain(int cpu)
>>  void trigger_load_balance(struct rq *rq, int cpu)
>>  {
>>  	/* Don't need to rebalance while attached to NULL domain */
>> -	if (time_after_eq(jiffies, rq->next_balance) &&
>> -	    likely(!on_null_domain(cpu)))
>> +	if (unlikely(on_null_domain(cpu)))
>> +		return;
>> +
>> +	if (time_after_eq(jiffies, rq->next_balance))
>>  		raise_softirq(SCHED_SOFTIRQ);
>>  #ifdef CONFIG_NO_HZ
>> -	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
>> +	if (nohz_kick_needed(rq, cpu))
>>  		nohz_balancer_kick(cpu);
>>  #endif
>>  }
> 
> 


