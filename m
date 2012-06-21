Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab2FUAqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:46:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56261 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab2FUAqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <1340231192.21745.154.camel@twins>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
	<1340231192.21745.154.camel@twins>
Date: Thu, 21 Jun 2012 02:46:29 +0200
Message-ID: <CAFTL4hz9UZr0Xfd4m3WTBma8vSvbm0Lg8o=oXsjFbpPfG9RxjQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/21 Peter Zijlstra <peterz@infradead.org>:
> On Tue, 2012-06-19 at 15:43 +0200, Frederic Weisbecker wrote:
>>
>> I wish we could do more vtime cputime accounting consolidation
>> but archs do the things pretty differently although I bet the
>> behaviour could be more unified.
>>
> Yes.. so s390,ia64 use thread_info, ppc uses their paca (arch private
> precursor to per-cpu data).
>
> So I understand why s390,ia64 want the sched hook, but I don't see why
> ppc would need it, their account_process_tick() can fold whatever they
> need on the tick.

I think in any case you need to flush the time on a descheduling task otherwise
its pending time will be accounted later to the next task when it
receives an irq.

So I fear we still need that sched switch hook even with per cpu data. This
may be a simple account_system_vtime() call.

> So I think reworking s390,ia64 to use per-cpu storage should get rid of
> this switch hook altogether.
>
>
> Now everybody using VIRT_CPU_ACCOUNTING has the
> syscall/__irq_{enter,exit} hooks and uses 64bit cputime_t.
>
> IRQ_TIME_ACCOUNTING only has the __irq_{enter,exit} hook and uses
> unsigned long cputime_t, it adds cputime_one_jiffy every tick when the
> per-cpu counter is ahead of the cputime.
>
>
> We could merge both and do away with the 64bit cputime thing by keeping
> a (2nd) per-cpu kernel_cpustat which we fill with optional syscall/irq
> hooks and have account_process_tick() first check if any of the
> fine-grained fields overflow and if not, fall back to the regular tick
> accounting (much like an extended irqtime_account_process_tick).
>
>
> This would merge the fine-grain and tick based code-paths and do away
> with the whole cputime_t mess, it would also merge the VIRT and IRQ
> paths and make Frederic's optional syscall accounting trivial.
>
> Or am I missing something obvious here? -- its late after all.

No that looks pretty sensible.

> I'll try and write some code tomorrow.

Thanks!
