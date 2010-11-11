Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0KKMMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:12:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47552 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab0KKMMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:12:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wuFU4yBwEoIDq753lXah9V8tX6uK+Wu7dBkxS9dXsWqa0eORUnD0/s5UpPIaDXkfxH
         7IzH/Z3d9yvPuD4BHOIqROaEFnDrZeFmLd+bubsl/oQ2EEXEPrueUa88GWBxHB/rVa++
         obUZPbA7lKU3KVo9PMhgpDuPuklwE+QazFdNo=
MIME-Version: 1.0
In-Reply-To: <4CDBD23D.5070107@windriver.com>
References: <1289473307-7965-1-git-send-email-dongdong.deng@windriver.com>
	<20101111111702.GA12644@elte.hu>
	<4CDBD23D.5070107@windriver.com>
Date: Thu, 11 Nov 2010 20:12:29 +0800
Message-ID: <AANLkTikgJUTvrQM6QpHPsHYVy1JjL1HjaRr4UDPoGoW=@mail.gmail.com>
Subject: Re: [V3 PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace() at
 the same time on SMP
From: Dongdong Deng <libfetion@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, dzickus@redhat.com
Cc: DDD <dongdong.deng@windriver.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 7:23 PM, DDD <dongdong.deng@windriver.com> wrote:
> Ingo Molnar wrote:
>>
>> Hm, another thing i noticed is that there's two of these:
>>
>>>  #ifdef ARCH_HAS_NMI_WATCHDOG
>>> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
>>> +static unsigned long backtrace_flag;
>>> +
>>>  void arch_trigger_all_cpu_backtrace(void)
>>>  {
>>>        int i;
>>> +       unsigned long flags;
>>> +
>>> +       /*
>>> +        * Have to disable irq here, as the
>>> +        * arch_trigger_all_cpu_backtrace() could be
>>> +        * triggered by "spin_lock()" with irqs on.
>>> +        */
>>> +       local_irq_save(flags);
>>
>>> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
>>> +static unsigned long backtrace_flag;
>>> +
>>>  void arch_trigger_all_cpu_backtrace(void)
>>>  {
>>>        int i;
>>> +       unsigned long flags;
>>> +
>>> +       /*
>>> +        * Have to disable irq here, as the
>>> +        * arch_trigger_all_cpu_backtrace() could be
>>> +        * triggered by "spin_lock()" with irqs on.
>>> +        */
>>> +       local_irq_save(flags);
>>> +
>>> +       if (test_and_set_bit(0, &backtrace_flag))
>>
>> A fair amount of code is being duplicated in two places - which is not
>> nice. Lets try to create a shared facility instead?
>
> Yep, It is a good idea, I will try to do that. :-)

Hmm, it is hard to create a shared facility for
arch_trigger_all_cpu_backtrace().

The arch_trigger_all_cpu_backtrace() need a local variable(backtrace_mask)
which was used by the other difference functions in nmi.c and hw_nmi.c.

If we want to create a shared facility for arch_trigger_all_cpu_backtrace(),
we have to create an independent .c file for the single one function
arch_trigger_all_cpu_backtrace(). I think it is worse than before...

Maybe Don could say some things here as he is the owner of hw_nmi.c.  :-)

Thanks,
Dongdong
