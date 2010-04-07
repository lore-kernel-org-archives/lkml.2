Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab0DGRbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:31:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60026 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0DGRbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:31:47 -0400
Message-ID: <4BBCC174.7020409@us.ibm.com>
Date: Wed, 07 Apr 2010 10:31:32 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 5/6] futex: handle timeout inside adaptive lock spin
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <1270499039-23728-6-git-send-email-dvhltc@us.ibm.com> <alpine.LFD.2.00.1004061022080.32352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004061022080.32352@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 5 Apr 2010, Darren Hart wrote:
> 
>> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
>> ---
>>  kernel/futex.c |   24 +++++++++++++++++++++---
>>  1 files changed, 21 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index c33ac2a..af61dcd 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -2385,6 +2385,7 @@ out:
>>  /**
>>   * trylock_futex_adaptive() - Try to acquire the futex lock in a busy loop
>>   * @uaddr: the futex user address
>> + * @timeout: absolute timeout or NULL if none
>>   *
>>   * Try to acquire a futex lock in a loop until the owner changes or the owner
>>   * is descheduled. To lock the futex, set the value to the current TID.
>> @@ -2394,10 +2395,11 @@ out:
>>   *  1 - Futex lock acquired
>>   * <0 - On error
>>   */
>> -static int trylock_futex_adaptive(u32 __user *uaddr)
>> +static int trylock_futex_adaptive(u32 __user *uaddr, ktime_t *timeout)
>>  {
>>  	int ret = 0;
>>  	u32 curval;
>> +	ktime_t now;
>>  
>>  	for (;;) {
>>  		struct thread_info *owner;
>> @@ -2433,6 +2435,22 @@ static int trylock_futex_adaptive(u32 __user *uaddr)
>>  		if (need_resched())
>>  			break;
>>  
>> +		if (timeout) {
>> +			now = ktime_get();
> 
>   Hmm. Calling that in every iteration might hurt especially on non
>   TSC systems, but well...

I haven't come across a better alternative since arming the timer before 
setting TASK_INTERRUPTIBLE isn't appropriate.

> 
>> +/* FIXME: consider creating ktime_less_than(lhs, rhs) */
> 
>   No need. The .tv64 comparison works in both cases. :)

Ah, for some reason I was thinking that was only the case if 
CONFIG_KTIME_SCALAR was set. Very nice, thanks.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
