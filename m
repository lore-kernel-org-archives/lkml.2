Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0ESUpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:45:09 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:33069 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0ESUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:45:07 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix uninitialized spinlock of printk_ratelimited()
References: <87hbm7e6x9.fsf@devron.myhome.or.jp>
	<20100519132659.b787d17f.akpm@linux-foundation.org>
Date: Thu, 20 May 2010 05:44:59 +0900
In-Reply-To: <20100519132659.b787d17f.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 19 May 2010 13:26:59 -0700")
Message-ID: <871vd7oc38.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>>  #ifdef CONFIG_PRINTK
>> -#define printk_ratelimited(fmt, ...)  ({		\
>> -	static struct ratelimit_state _rs = {		\
>> -		.interval = DEFAULT_RATELIMIT_INTERVAL, \
>> -		.burst = DEFAULT_RATELIMIT_BURST,       \
>> -	};                                              \
>> -							\
>> -	if (__ratelimit(&_rs))                          \
>> -		printk(fmt, ##__VA_ARGS__);		\
>> +#define printk_ratelimited(fmt, ...)  ({				\
>> +	static DEFINE_RATELIMIT_STATE(_rs,				\
>> +				      DEFAULT_RATELIMIT_INTERVAL,	\
>> +				      DEFAULT_RATELIMIT_BURST);		\
>> +									\
>> +	if (__ratelimit(&_rs))						\
>> +		printk(fmt, ##__VA_ARGS__);				\
>>  })
>
> hm, yes, that spinlock will get the all-zeroes pattern.
>
> It's been like this since December 2009.  I'm a bit surprised that none
> of our spinlock-debugging goodies picked this up.  All the
> CONFIG_DEBUG_SPINLOCK spinlock fields end up zeroed out also.

The reason that dynamic analysis didn't pick up is simple - nobody is
using this for now :)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
