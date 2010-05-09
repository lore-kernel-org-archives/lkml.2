Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0EINHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 09:07:13 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:56648 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0EINHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 09:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ntz5Dt6VrkdSDiaxKaUZgoiyqqEkD2cr9T06yb+yBB/uRisdC0FRXZ+2h/I9cn27uP
         8KwfPx5ov8SmanyN9US1mhV45TlFg8NtMG/Zo4oWLZpGHhdLVEsIPXoHzjAFesSuEzmF
         wm3TWfMij1Fmrm1tLDQ+oojXYF67sZEg+fTxc=
MIME-Version: 1.0
In-Reply-To: <20100509091856.GA29763@n2100.arm.linux.org.uk>
References: <1273377379-18078-1-git-send-email-tom.leiming@gmail.com>
	 <20100509091856.GA29763@n2100.arm.linux.org.uk>
Date: Sun, 9 May 2010 21:07:08 +0800
Message-ID: <i2kd82e647a1005090607w24424d8p4b524007a9c7fe0@mail.gmail.com>
Subject: Re: [PATCH] ARM: fix inbalance of hardirqs trace before return to 
	user or exception
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/9 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Sun, May 09, 2010 at 11:56:19AM +0800, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> This patch introduces macro of trace_ret_hardirqs_on, which will
>> call asm_trace_hardirqs_on if I flag in the stored CPSR is zero.
>>
>> The patch adds trace_ret_hardirqs_on before returning to user
>> or exception mode once disable_irq was called explicitly, which does
>> fix the inbalance of hardirqs trace and make lockdep happy. The patch
>> does fix this kind of lockdep warning below:
>
> I'm not convinced that this is required in all the places you're adding
> it.  Eg, in the return-to-user case, userspace _always_ has IRQs
> enabled, and when we enter kernel space from the exception handler, we
> always enable IRQs.  Returning from any syscall with IRQs disabled is a
> bug, and so that _should_ produce a warning.
>
> In fact, returning to user mode with IRQs disabled in _any_ case is a
> bug.

The patch only adds hardirqs on event to make lockdep see it.
Maybe in this paths, we should not trace the hardirqs off event, then we
will not need to add the hardirqs on event before return to user. If
you agree, I'll
write another patch to do it.

>
> Please provide your reasoning for adding this to every path.

The patch adds this in places which disable_irq is called before returning to
user or kernel mode from sys-call or exception. This can keep hardirqs trace
balance to remove lockdep warning of "unannotated irqs-on" since disable_irq
may call trace_hardirqs_off to trace hardirqs off event and lockdep
will see it.

If lockdep warning is produced, lockdep does not work afterwards. It is the
purpose of the patch.

>
> Finally, using asm_trace_hardirqs_on is extremely expensive, and in
> many cases the register saving is completely wasteful.  That's why
> places were doing this:
>
> #ifdef CONFIG_TRACE_IRQFLAGS
>        tst     r4, #PSR_I_BIT
>        bleq    trace_hardirqs_on
> #endif
>
> which is much more efficient.

Yes, I'll use the efficient way in v2 of the patch.


-- 
Lei Ming
