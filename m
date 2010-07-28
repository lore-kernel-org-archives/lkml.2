Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab0G1FYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:24:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64322 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0G1FYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:24:12 -0400
Message-ID: <4C4FBE2B.6030606@monstr.eu>
Date: Wed, 28 Jul 2010 07:20:43 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu, linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead local_irq_save/restore
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu>	<1274863724-14906-2-git-send-email-monstr@monstr.eu>	<1274884963.22648.245.camel@gandalf.stny.rr.com>	<20100526100805.171b3c48.akpm@linux-foundation.org>	<4C4D4C2E.8010103@monstr.eu> <20100727161819.cf6feab1.akpm@linux-foundation.org>
In-Reply-To: <20100727161819.cf6feab1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 26 Jul 2010 10:49:50 +0200
> Michal Simek <monstr@monstr.eu> wrote:
> 
>> start/stop_critical_timing function for preemptirqsoff, preemptoff
>> and irqsoff tracers contains atomic_inc and atomic_dec operations.
>>
>> Atomic operations used local_irq_save/restore macros to ensure
>> atomic access but they are traced by the same function which is causing
>> recursion problem.
>>
>> The reason is when these tracers are turn ON then local_irq_save/restore
>> macros are changed in include/linux/irqflags.h to call trace_hardirqs_on/off
>> which call start/stop_critical_timing.
>>
>> Microblaze was affected because use generic atomic implementation.
> 
> Seems that this will also affect blackfin, mn10300 and score.  I guess
> they aren't supporting tracing yet?

If they uses asm-generic/atomic.h, then yes. It seems to me that 
Blackfin uses own asm/atomic.h. nm10300 and score are the same case as 
Microblaze.

In include/linux/irqflags.h is written this commentary.

/*
  * The local_irq_*() APIs are equal to the raw_local_irq*()
  * if !TRACE_IRQFLAGS.
  */

If architecture doesn't enable TRACE_IRQFLAGS then there is no 
difference in behavior. If yes and use asm-generic/atomic.h code, then 
IRQFLAG tracer freeze because it is traced part of irqsoff tracer 
because of recursion as is describe in patch description.

> 
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> hm, I wonder how my signoff got there.  Doesn't matter.

http://lkml.org/lkml/2010/5/26/364

Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
