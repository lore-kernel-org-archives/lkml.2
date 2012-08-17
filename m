Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab2HQSPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:15:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53441 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645Ab2HQSPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:15:13 -0400
Message-ID: <502E8A2C.3060606@suse.cz>
Date: Fri, 17 Aug 2012 20:15:08 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120731 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: davem@davemloft.net, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ratelimit: check the condition in WARN_RATELIMIT first
References: <1345210942-26906-1-git-send-email-jslaby@suse.cz> <1345225144.10014.2.camel@joe2Laptop>
In-Reply-To: <1345225144.10014.2.camel@joe2Laptop>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 07:39 PM, Joe Perches wrote:
> On Fri, 2012-08-17 at 15:42 +0200, Jiri Slaby wrote:
>> Before calling __ratelimit in __WARN_RATELIMIT, check the condition
>> first. When this check was not there, we got constant income of:
>> tty_init_dev: 60 callbacks suppressed
>> tty_init_dev: 59 callbacks suppressed
> []
>> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
> []
>> @@ -49,8 +49,9 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
>>  #define __WARN_RATELIMIT(condition, state, format...)		\
>>  ({								\
>>  	int rtn = 0;						\
>> -	if (unlikely(__ratelimit(state)))			\
>> -		rtn = WARN(condition, format);			\
>> +	int __rtcond = !!condition;				\
>> +	if (unlikely(__rtcond && __ratelimit(state)))		\
>> +		rtn = WARN(__rtcond, format);			\
>>  	rtn;							\
>>  })
>>  
> 
> Hi Jiri.
> 
> This seems fine to me but are there any conditions that
> are computationally expensive?

It's not about expensiveness of the computation. The complexity remained
the same except I moved the computation one layer up.

> ratelimit(state) isn't
> and this will now always do condition.
> 
> (looks instead of speculates)
> 
> There's 1 current use of WARN_RATELIMIT and there's
> a condition of 1 so there's no problem here.

There is going to be one more in monday's -next. I've just added one to
the TTY code. The thing is that when you call ratelimit(state) it will
emit how many times you have called that function like I described in
the changelog:
tty_init_dev: 60 callbacks suppressed

Even when the condition is always false. Hence I added the condition to
the if and lazy evaluation will take care and ratelimit() won't be
called at all...

> __WARN_RATELIMIT is pretty stupid.
> It's only called from WARN_RATELIMIT.
> I think it shouldn't exist at all.
> 
> Maybe something like this?

Yup, something like that looks OK to me.

thanks,
-- 
js
suse labs
