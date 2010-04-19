Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0DSLNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 07:13:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab0DSLNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 07:13:09 -0400
Message-ID: <4BCC3AC2.8050601@redhat.com>
Date: Mon, 19 Apr 2010 14:13:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BCA026D.3070309@redhat.com>  <4BCA02D1.2020608@redhat.com>	 <1271673836.1674.757.camel@laptop>  <4BCC34DF.6030702@redhat.com> <1271674575.1674.793.camel@laptop>
In-Reply-To: <1271674575.1674.793.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 01:56 PM, Peter Zijlstra wrote:
>
>    
>>> Right, do bear in mind that the x86 implementation of atomic64_read() is
>>> terrifyingly expensive, it is better to not do that read and simply use
>>> the result of the cmpxchg.
>>>
>>>
>>>        
>> atomic64_read() _is_ cmpxchg64b.  Are you thinking of some clever
>> implementation for smp i386?
>>      
>
> No, what I was suggesting was to rewrite that loop no to need the
> initial read but use the cmpxchg result of the previous iteration.
>
> Something like:
>
>    u64 last = 0;
>
>    /* more stuff */
>
>    do {
>      if (ret<  last)
>        return last;
>      last = cmpxchg64(&last_value, last, ret);
>    } while (last != ret);
>
> That only has a single cmpxchg8 in there per loop instead of two
> (avoiding the atomic64_read() one).
>    

Still have two cmpxchgs in the common case.  The first iteration will 
fail, fetching last_value, the second will work.

It will be better when we have contention, though, so it's worthwhile.

-- 
error compiling committee.c: too many arguments to function

