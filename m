Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2HQUyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 16:54:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43515 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2HQUyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 16:54:33 -0400
Message-ID: <502EAF86.2040309@suse.cz>
Date: Fri, 17 Aug 2012 22:54:30 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120731 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: davem@davemloft.net, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ratelimit: check the condition in WARN_RATELIMIT first
References: <1345210942-26906-1-git-send-email-jslaby@suse.cz>  <1345225144.10014.2.camel@joe2Laptop> <502E8A2C.3060606@suse.cz> <1345229139.10014.5.camel@joe2Laptop>
In-Reply-To: <1345229139.10014.5.camel@joe2Laptop>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 08:45 PM, Joe Perches wrote:
> On Fri, 2012-08-17 at 20:15 +0200, Jiri Slaby wrote:
>> On 08/17/2012 07:39 PM, Joe Perches wrote:
>>> On Fri, 2012-08-17 at 15:42 +0200, Jiri Slaby wrote:
>>>> Before calling __ratelimit in __WARN_RATELIMIT, check the condition
>>>> first. When this check was not there, we got constant income of:
>>>> tty_init_dev: 60 callbacks suppressed
>>>> tty_init_dev: 59 callbacks suppressed
>>> []
>>>> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
>>> []
>>>> @@ -49,8 +49,9 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
>>>>  #define __WARN_RATELIMIT(condition, state, format...)		\
>>>>  ({								\
>>>>  	int rtn = 0;						\
>>>> -	if (unlikely(__ratelimit(state)))			\
>>>> -		rtn = WARN(condition, format);			\
>>>> +	int __rtcond = !!condition;				\
>>>> +	if (unlikely(__rtcond && __ratelimit(state)))		\
>>>> +		rtn = WARN(__rtcond, format);			\
>>>>  	rtn;							\
>>>>  })
>>>>  
>>>
>>> Hi Jiri.
>>>
>>> This seems fine to me but are there any conditions that
>>> are computationally expensive?
>>
>> It's not about expensiveness of the computation. The complexity remained
>> the same except I moved the computation one layer up.
> 
> If ratelimit(state) is not true, condition wasn't tested
> or performed at all.  With this change, it's always done.

Ah, you meant this. Actually this was wrong/unexpected. When devs pass
something to a function/macro they expect it to be evaluated. Exactly once.

Like in this (maybe not so good) code:
void put_ref(int refcnt) {
  WARN_RATELIMIT(!--refcnt, "refcnt reached 0 unexpectedly");
}

You want the refcnt to be decremented no matter what ratelimit() returns.

thanks,
-- 
js
suse labs
