Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab0HQJct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:32:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54422 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0HQJcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:32:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=V7VUISDJy10l+8y2uYauUGl6kcm4rTkIg0/gIf3RK7ju9ABall7McY7LYBq/NObs2F
         Jd30S0Vkp7cw2LcR3t+y2aPfSZXP6/PG2ayWeJvDIo/M9OstvqgZoX8rfIvmIhXtODPa
         BPRcZXl37EU6caN1FyHTa7ln9BO0zULMnR4HU=
MIME-Version: 1.0
In-Reply-To: <1282035715.2448.24.camel@edumazet-laptop>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
 <1282033817.2448.18.camel@edumazet-laptop> <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
 <1282035715.2448.24.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Tue, 17 Aug 2010 17:32:26 +0800
Message-ID: <AANLkTi=oP989w2pO8j5fdzOYhWCeSNEQuZLHefAgGa_Y@mail.gmail.com>
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 5:01 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 17 août 2010 à 16:46 +0800, Changli Gao a écrit :
>> On Tue, Aug 17, 2010 at 4:30 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> >
>> > Three variables ?
>> >
>> > static atomic_t rnd __read_mostly;
>> >
>> > if (unlikely(!atomic_read(&rnd))) {
>> >        unsigned int val;
>> >
>> >        get_random_bytes(&val, sizeof(val));
>> >        if (!val)
>> >                val = 1;
>> >        atomic_cmpxchg(&rnd, 0, val);
>> > }
>> >
>>
>>
>> Good idea. However, atomic_t is a volatile variable, and it prevent
>> ILP. I think maybe it hurts the likely case. cmpxchg() is an atomic
>> operations, so is the bellow code better?
>>
>
> I am not sure what you mean by ILP.

I mean http://en.wikipedia.org/wiki/Instruction_level_parallelism

and volatile will suppress compiler optimization.

>
> On x86, reading twice same memory location is faster than
> reading it and store in temp variable (on stack)
> reading from stack

Thanks for this info. But compiler may store it in a register. In
fact, we can't control the behavior of compiler in C.

>
>>  static unsigned long rnd __read_mostly;
>>
>>  if (unlikely(!rnd)) {
>>         unsigned long val;
>>
>>         get_random_bytes(&val, sizeof(val));
>>         if (!val)
>>                 val = 1;
>>         cmpxchg(&rnd, 0, val);
>>  }
>>
>> Thanks.
>>
>
> I am not sure we must use a long (we really need 4 bytes only),

Yea, 4 bytes is enough.

> and last
> time I tried to use cmpxchg(), I was being told it was not available on
> all arches.
>
> But seeing it used in kernel/pid.c, maybe its not true anymore (that is,
> __HAVE_ARCH_CMPXCHG is always defined to 1)
>
> Since its a recent change (in kernel/pid.c), I would wait a bit and see
> if an arch maintainer complains ;)
>

Thanks. I saw it. These are two cmpxchg() in file:

include/asm-generic/cmpxchg.h

include/asm-generic/system.h

static inline unsigned long __cmpxchg(volatile unsigned long *m,
                                      unsigned long old, unsigned long new)
{
        unsigned long retval;
        unsigned long flags;

        local_irq_save(flags);
        retval = *m;
        if (retval == old)
                *m = new;
        local_irq_restore(flags);
        return retval;
}

#define cmpxchg(ptr, o, n)                                      \
        ((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), \
                                        (unsigned long)(o),     \
                                        (unsigned long)(n)))

This one seems buggy when using it to non unsigned long variables. And
in kernel/pid.c, the last_pid variable is int.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
