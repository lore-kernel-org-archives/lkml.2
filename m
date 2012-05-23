Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab2EWUTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:19:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41986 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab2EWUTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:19:08 -0400
Message-ID: <4FBD4613.7040003@linaro.org>
Date: Wed, 23 May 2012 13:18:27 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai threshold
References: <cover.1337348892.git.richardcochran@gmail.com> <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com> <4FBA84EF.5040506@linaro.org> <20120521190815.GA19812@netboy.at.omicron.at> <20120522173953.GA4177@netboy.at.omicron.at> <4FBBD591.1000103@linaro.org> <20120523082916.GA15627@localhost.localdomain> <4FBD1545.4070408@linaro.org> <20120523191747.GA2348@netboy.at.omicron.at>
In-Reply-To: <20120523191747.GA2348@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052320-3270-0000-0000-00000697D189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 12:17 PM, Richard Cochran wrote:
> On Wed, May 23, 2012 at 09:50:13AM -0700, John Stultz wrote:
>> On 05/23/2012 01:29 AM, Richard Cochran wrote:
>>> Okay, if you want it that way, then you will have to add the other
>>> cases. For example:
>>>
>>> 	switch (code) {
>>> 	case INS:
>>> 		if (U == epoch) {
>>> 			U--;
>>> 			T++;
>>> 			code = OOP;
>>> 		}
>>> 		break;
>>> 	case OOP:
>>> 		if (U == epoch) {
>> epoch + 1 here, right?
> No, I really mean epoch (not the leap second value, but the value when
> the new TAI offset comes into effect).
>
>>> 			code = WAIT;
>>> 		}
>>> 		break;
>>> 	case DEL:
>>> 		if (U == epoch - 1) {
>>> 			U++;
>>> 			T--;
>>> 			code = WAIT;
>>> 		}
>>> 		break;
>>> 	default:
>>> 		break;
>>> 	}
>>> 	return (U, code, T);
>>>
>>> This is beginning to look a lot like the code in my patch. However,
>>> your approach is somewhat simpler, because it assumes the tick will
>>> never miss a second overflow.
>> I'm a little unclear on the above, because it looks like you're
>> modifying the state from the reader.
> Sorry about that. Here is a more exact pseudo code:
>
> 	switch (time_state) {
> 	case INS:
> 		if (U == epoch) {
> 			U--;
> 			T++;
> 			result_code = OOP;
> 		}
> 		break;
> 	case OOP:
> 		if (U == epoch) {
> 			result_code = WAIT;
> 		}
> 		break;
> 	case DEL:
> 		if (U == epoch - 1) {
> 			U++;
> 			T--;
> 			result_code = WAIT;
> 		}
> 		break;
> 	default:
> 		break;
> 	}
> 	return (U, result_code, T);

Again, my issue here is that you're modifying state from the reader. Why 
not leave that to the tick?

>> I still don't think it matters. If we know the when next leap second
>> is supposed to be, if the time_state is INS, then we can still
>> handle things without extra state.
>>
>> if (unlikely(CODE == INS&&    U == next_leap))
>> 	return (U-1, OOP, T+1);
>>
>> if (unlikely(CODE == INS&&    U == next_leap + 1))
>> 	return (U-1, WAIT, T+1);
> And what if (U>  next_leap + 1)?
>
> In that case, you must also return WAIT. Are you going to add a test
> for every second beyond 'next_leap'? I don't think so.
You're quite correct, sorry for the omission there.

if (unlikely((CODE == INS || CODE== OOP)&&    U>= next_leap + 1))
	return (U-1, WAIT, T+1);


>> if (unlikely(CODE == DEL&&    U == next_leap - 1))
>> 	return (U+1, WAIT, T-1);
>>
>>
>> So even if we somehow sleep for two seconds over the leap second,
>> and then an application hits the read critical section before the
>> timer interrupt comes in the update the state, we can still provide
>> correct state transition in the reader.
> No, I think what you wrote above is not correct.
So what's wrong with the corrected line above?

>> Thus the only additional state you might need over what we already
>> have is the next_leap value.
> Again, you will need two things.
>
> 1. the epoch threshold value (not the leap second value)
So I've avoided the term epoch just to try not to confuse things with 
the unix epoch, that's why I've used next_leap, etc.
Even so, I'm not sure you've made clear the subtlety of the difference.


> 2. whether the new epoch has been applied yet, or not
I believe the internal time_state (along with the next leap second) 
already provides this.

 From the reader's perspective:

Not applied:		(INS&&  U<  leap):		return (INS, U)
Applied:		(INS&&   U == leap):		return (OOP, U-1)
Finished applied:	((INS||OOP)&&  U>= (leap+1)):	return (WAIT,U-1)
Delete:			(DEL&&  U>= (leap-1)):		return (WAIT,U+1)


Again, no state change is done by the reader, so we don't have to keep 
track of application state or not.
Then when the tick comes in, it will move the state machine appropriately.

Sorry working this out is so difficult. If we don't come to consensus 
soon, I'll try to find some time to implement what I'm suggesting so you 
aren't up against my unclear hand-waving. :)

thanks
-john

