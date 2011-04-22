Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1DVIBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:01:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46629 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1DVIBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:01:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xnFoqqz/XAoBwCx9UmwnKuYpsiR6qAr76wRLvlW2a3FQPzFfqpPXDdHYkP4S509PD5
         1dEl0CDdLVuznf5yXD0vuxtQvGopwZiWWDIskQxf8D3JyYdR7RRAoEC9g+KrbAk4KmU3
         ALIjGhY/rYFX/NmtCjWkHlEbBaPgiX/m1VMLQ=
MIME-Version: 1.0
In-Reply-To: <201104220744.p3M7indA004922@www262.sakura.ne.jp>
References: <20110417094505.865828233@chello.nl>
	<201104180341.p3I3fnxc000638@www262.sakura.ne.jp>
	<BANLkTikYwWe6E6mb3PLE3L7a3VHWdtEvfQ@mail.gmail.com>
	<201104220744.p3M7indA004922@www262.sakura.ne.jp>
Date: Fri, 22 Apr 2011 16:01:05 +0800
Message-ID: <BANLkTikXSz-AK6BFvnDGEr6Qhx-dekzOQg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/7] lockdep: Support recurise-read locks
From: Yong Zhang <yong.zhang0@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/22 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
> Yong Zhang wrote:
>> > Also, something is still wrong because lockdep fails to detect the problem
>> > for "cat /proc/locktest1 /proc/locktest2" and
>> > "cat /proc/locktest3 /proc/locktest4" cases.
>>
>> It fails because we never add the recursive read to prev->after evev if
>> it passed the validation.
>>
> Thanks. But why "cat /proc/locktest1 /proc/locktest2" is "the recursive read"
> and "cat /proc/locktest2 /proc/locktest1" is not "the recursive read"?
> Both are serialized. Both hold and release the same lock.
> The only difference is which function was called first,

When you are using rwlock_acquire*(), your four testcases are
all failed, the reason I have explained.

When you are using spin_acquire()/spin_release() in read_seqbegin2()/
read_seqretry2(), if you call locktest2/locktest4 firstly, the chain will
be established, so when call locktest1/locktest3, lockdep warns on it.
But if you call locktest1/locktest2 firstly, the chain will not be established
just because recursive read is not added to prev->after.

> and lockdep alart depends on which function was called first.

No, it's not related with which function is called firstly, instead it's
the current behavior of lockdep.

>
> It sounds to me that Documentation/lockdep-design.txt says
> timing (i.e. which function was called first) is not important.
>
> 172 Proof of 100% correctness:
> 173 --------------------------
> 174
> 175 The validator achieves perfect, mathematical 'closure' (proof of locking
> 176 correctness) in the sense that for every simple, standalone single-task
> 177 locking sequence that occurred at least once during the lifetime of the
> 178 kernel, the validator proves it with a 100% certainty that no
> 179 combination and timing of these locking sequences can cause any class of
> 180 lock related deadlock. [*]
> 181
> 182 I.e. complex multi-CPU and multi-task locking scenarios do not have to
> 183 occur in practice to prove a deadlock: only the simple 'component'
> 184 locking chains have to occur at least once (anytime, in any
> 185 task/context) for the validator to be able to prove correctness. (For
> 186 example, complex deadlocks that would normally need more than 3 CPUs and
> 187 a very unlikely constellation of tasks, irq-contexts and timings to
> 188 occur, can be detected on a plain, lightly loaded single-CPU system as
> 189 well!)

This is true, but currently we take different action on recursive read
validation
which seems needed to be improved. :)

Thanks,
Yong



-- 
Only stand for myself
