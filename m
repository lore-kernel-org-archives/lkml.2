Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2JELRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:17:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33326 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2JELRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:17:07 -0400
Message-ID: <506EC1AE.6000201@suse.cz>
Date: Fri, 05 Oct 2012 13:17:02 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Borislav Petkov <bp@amd64.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: tty_init_dev: 24 callbacks suppressed
References: <20121004092055.GA21028@aftab.osrc.amd.com> <20121004112347.GA245@x4> <20121004115157.GA245@x4> <20121004124025.GC21028@aftab.osrc.amd.com> <20121004131101.GA245@x4>
In-Reply-To: <20121004131101.GA245@x4>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing Joe.

On 10/04/2012 03:11 PM, Markus Trippelsdorf wrote:
> On 2012.10.04 at 14:40 +0200, Borislav Petkov wrote:
>> On Thu, Oct 04, 2012 at 01:51:57PM +0200, Markus Trippelsdorf wrote:
>>> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
>>> index e11ccb4..d8de255 100644
>>> --- a/include/linux/ratelimit.h
>>> +++ b/include/linux/ratelimit.h
>>> @@ -46,20 +46,17 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
>>>  #define WARN_ON_RATELIMIT(condition, state)			\
>>>  		WARN_ON((condition) && __ratelimit(state))
>>>  
>>> -#define __WARN_RATELIMIT(condition, state, format...)		\
>>> -({								\
>>> -	int rtn = 0;						\
>>> -	if (unlikely(__ratelimit(state)))			\
>>> -		rtn = WARN(condition, format);			\
>>> -	rtn;							\
>>> -})
>>> -
>>> -#define WARN_RATELIMIT(condition, format...)			\
>>> +#define WARN_RATELIMIT(condition, fmt, ...)			\
>>>  ({								\
>>>  	static DEFINE_RATELIMIT_STATE(_rs,			\
>>>  				      DEFAULT_RATELIMIT_INTERVAL,	\
>>>  				      DEFAULT_RATELIMIT_BURST);	\
>>> -	__WARN_RATELIMIT(condition, &_rs, format);		\
>>> +	int rtn = !!(condition);				\
>>> +								\
>>> +	if (unlikely(rtn && __ratelimit(&_rs)))		\
>>> +		WARN(rtn, fmt, ##__VA_ARGS__);			\
>>> +								\
>>> +	rtn;							\
>>>  })
>>
>> Aha, I see it. We need to look at the condition before the __ratelimit,
>> otherwise we WARN unnecessarily, good catch.
>>
>>>  #else
>>> @@ -67,15 +64,9 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
>>>  #define WARN_ON_RATELIMIT(condition, state)			\
>>>  	WARN_ON(condition)
>>>  
>>> -#define __WARN_RATELIMIT(condition, state, format...)		\
>>> -({								\
>>> -	int rtn = WARN(condition, format);			\
>>> -	rtn;							\
>>> -})
>>> -
>>> -#define WARN_RATELIMIT(condition, format...)			\
>>> +#define WARN_RATELIMIT(condition, fmt, ...)			\
>>
>> ... except this change is unrelated and unneeded - there's enough room
>> in 80 cols to leave it as "format" instead of shortening it.
>>
>> Other than that:
>>
>> Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> I'll let Jiri handle this :). It's his patch anyway.

Actually this is Joe's version of the patch. Joe, people started hitting
the bug [1]. Could you resend your patch?

[1] https://patchwork.kernel.org/patch/1339221/

BTW what scares me that nobody noticed that bug until this is in the
Linus's tree. Do people use -next at all or am I the only one user? (I
didn't hit it as I have the patch in my local queue.)

thanks,
-- 
js
suse labs
