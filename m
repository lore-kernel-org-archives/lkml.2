Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553Ab2EWQwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:52:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34435 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2EWQwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:52:11 -0400
Message-ID: <4FBD1545.4070408@linaro.org>
Date: Wed, 23 May 2012 09:50:13 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai threshold
References: <cover.1337348892.git.richardcochran@gmail.com> <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com> <4FBA84EF.5040506@linaro.org> <20120521190815.GA19812@netboy.at.omicron.at> <20120522173953.GA4177@netboy.at.omicron.at> <4FBBD591.1000103@linaro.org> <20120523082916.GA15627@localhost.localdomain>
In-Reply-To: <20120523082916.GA15627@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052316-3270-0000-0000-00000696001C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 01:29 AM, Richard Cochran wrote:
> On Tue, May 22, 2012 at 11:06:09AM -0700, John Stultz wrote:
>> It seems currently we have:
>>
>>     U   CODE    T
>>   ----------------
>>     9   INS     1
>>   ----------------
>>    10   INS     1     pre tick, post leap second edge (this is the technically incorrect interval)
>>   ~~~~~~~~~~~~~~~~
>>     9   OOP     2     post tick, post leap second edge
>>   ----------------
>>    10   WAIT    2     new epoch
>>
>>
>> If you're trying to correct the pre-tick, post leap second edge, the above provides all you need.
>>
>> In the adjtimex code, all you have to do is:
>>
>>
>> if (unlikely(CODE == INS&&   U == 10))
>>
>> 	/*note, we're not modifying state here, just returning corrected local values*/
>>
>> 	return (U-1, OOP, T+1);
>>
>> return (U,CODE, T);
> Okay, if you want it that way, then you will have to add the other
> cases. For example:
>
> 	switch (code) {
> 	case INS:
> 		if (U == epoch) {
> 			U--;
> 			T++;
> 			code = OOP;
> 		}
> 		break;
> 	case OOP:
> 		if (U == epoch) {
epoch + 1 here, right?
> 			code = WAIT;
> 		}
> 		break;
> 	case DEL:
> 		if (U == epoch - 1) {
> 			U++;
> 			T--;
> 			code = WAIT;
> 		}
> 		break;
> 	default:
> 		break;
> 	}
> 	return (U, code, T);
>
> This is beginning to look a lot like the code in my patch. However,
> your approach is somewhat simpler, because it assumes the tick will
> never miss a second overflow.

I'm a little unclear on the above, because it looks like you're 
modifying the state from the reader.


>> Since when the tick triggers, we'll move the CODE state appropriately.
>>
>> Or am I still missing something?
> Considering the tickless options, is it safe to assume that the CODE
> state update will never be an entire second too late?  If so, then
> I'll rework the patch as above. If not, then I think the patch I
> posted already handles all the cases.
>

I still don't think it matters. If we know the when next leap second is 
supposed to be, if the time_state is INS, then we can still handle 
things without extra state.

if (unlikely(CODE == INS&&   U == next_leap))
	return (U-1, OOP, T+1);

if (unlikely(CODE == INS&&   U == next_leap + 1))
	return (U-1, WAIT, T+1);

if (unlikely(CODE == DEL&&   U == next_leap - 1))
	return (U+1, WAIT, T-1);


So even if we somehow sleep for two seconds over the leap second, and then an application hits the read critical section before the timer interrupt comes in the update the state, we can still provide correct state transition in the reader.

Thus the only additional state you might need over what we already have is the next_leap value.

thanks
-john

