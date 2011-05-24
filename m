Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab1EXCKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 22:10:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37088 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab1EXCKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 22:10:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB1388.2080102@jp.fujitsu.com>
Date: Tue, 24 May 2011 11:10:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com
Subject: Re: [PATCH v2 3/3] vmscan: implement swap token priority aging
References: <4DD480DD.2040307@jp.fujitsu.com>	<4DD481A7.3050108@jp.fujitsu.com> <20110520123004.e81c932e.akpm@linux-foundation.org>
In-Reply-To: <20110520123004.e81c932e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2011/05/21 4:30), Andrew Morton wrote:
> On Thu, 19 May 2011 11:34:15 +0900
> KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>  wrote:
>
>> While testing for memcg aware swap token, I observed a swap token
>> was often grabbed an intermittent running process (eg init, auditd)
>> and they never release a token.
>>
>> Why?
>>
>> Some processes (eg init, auditd, audispd) wake up when a process
>> exiting. And swap token can be get first page-in process when
>> a process exiting makes no swap token owner. Thus such above
>> intermittent running process often get a token.
>>
>> And currently, swap token priority is only decreased at page fault
>> path. Then, if the process sleep immediately after to grab swap
>> token, the swap token priority never be decreased. That's obviously
>> undesirable.
>>
>> This patch implement very poor (and lightweight) priority aging.
>> It only be affect to the above corner case and doesn't change swap
>> tendency workload performance (eg multi process qsbench load)
>>
>> ...
>>
>> --- a/mm/thrash.c
>> +++ b/mm/thrash.c
>> @@ -25,10 +25,13 @@
>>
>>   #include<trace/events/vmscan.h>
>>
>> +#define TOKEN_AGING_INTERVAL	(0xFF)
>
> Needs a comment describing its units and what it does, please.
> Sufficient for readers to understand why this value was chosen and what
> effect they could expect to see from changing it.

Will do.


>>   static DEFINE_SPINLOCK(swap_token_lock);
>>   struct mm_struct *swap_token_mm;
>>   struct mem_cgroup *swap_token_memcg;
>>   static unsigned int global_faults;
>> +static unsigned int last_aging;
>
> Is this a good name?  Would something like prev_global_faults be better?

Current code is "next-aging = last-aging + 256global-fault". so,
prev_global_faults is slightly misleading to me.


> `global_faults' and `last_aging' could be made static local in
> grab_swap_token().

OK. even though I don't like static in a function.


>
>>   void grab_swap_token(struct mm_struct *mm)
>>   {
>> @@ -47,6 +50,11 @@ void grab_swap_token(struct mm_struct *mm)
>>   	if (!swap_token_mm)
>>   		goto replace_token;
>>
>> +	if ((global_faults - last_aging)>  TOKEN_AGING_INTERVAL) {
>> +		swap_token_mm->token_priority /= 2;
>> +		last_aging = global_faults;
>> +	}
>
> It's really hard to reverse-engineer the design decisions from the
> implementation here, therefore...  ?
>
>>   	if (mm == swap_token_mm) {
>>   		mm->token_priority += 2;
>>   		goto update_priority;
>> @@ -64,7 +72,7 @@ void grab_swap_token(struct mm_struct *mm)
>>   		goto replace_token;
>>
>>   update_priority:
>> -	trace_update_swap_token_priority(mm, old_prio);
>> +	trace_update_swap_token_priority(mm, old_prio, swap_token_mm);
>>
>>   out:
>>   	mm->faultstamp = global_faults;
>> @@ -80,6 +88,7 @@ replace_token:
>>   	trace_replace_swap_token(swap_token_mm, mm);
>>   	swap_token_mm = mm;
>>   	swap_token_memcg = memcg;
>> +	last_aging = global_faults;
>>   	goto out;
>>   }
>
> In fact all of grab_swap_token() and the thrash-detection code in
> general are pretty tricky and unobvious stuff.  So we left it
> undocumented :(

Well, original swap token (designed by Rik) is pretty straight forward
implementation on the theory. Therefore we didn't need too verbose doc.
The paper give us good well documentation.

# Oh, now http://www.cs.wm.edu/~sjiang/token.pdf is dead link.
# we should fix it to http://www.cse.ohio-state.edu/hpcs/WWW/HTML/publications/papers/TR-05-1.pdf,
# maybe, or do anybody know better url?

But following commit rewrite almost all code. and we lost good documentation.
It's a bit sad.


commit 7602bdf2fd14a40dd9b104e516fdc05e1bd17952
Author: Ashwin Chaugule <ashwin.chaugule@celunite.com>
Date:   Wed Dec 6 20:31:57 2006 -0800

     [PATCH] new scheme to preempt swap token





