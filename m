Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965756Ab0GPOtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 10:49:32 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58881 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752123Ab0GPOta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 10:49:30 -0400
Date: Fri, 16 Jul 2010 10:49:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Avi Kivity <avi@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
Message-ID: <20100716144927.GA22516@Krystal>
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com> <4C405078.20707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C405078.20707@redhat.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:40:27 up 174 days, 17:17,  6 users,  load average: 0.01, 0.03,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity (avi@redhat.com) wrote:
> On 07/14/2010 06:49 PM, Mathieu Desnoyers wrote:
>> Implements an alternative iret with popf and return so trap and exception
>> handlers can return to the NMI handler without issuing iret. iret would cause
>> NMIs to be reenabled prematurely. x86_32 uses popf and far return. x86_64 has to
>> copy the return instruction pointer to the top of the previous stack, issue a
>> popf, loads the previous esp and issue a near return (ret).
>>
>> It allows placing dynamically patched static jumps in asm gotos, which will be
>> used for optimized tracepoints, in NMI code since returning from a breakpoint
>> would be valid. Accessing vmalloc'd memory, which allows executing module code
>> or accessing vmapped or vmalloc'd areas from NMI context, would also be valid.
>> This is very useful to tracers like LTTng.
>>
>> This patch makes all faults, traps and exception safe to be called from NMI
>> context*except*  single-stepping, which requires iret to restore the TF (trap
>> flag) and jump to the return address in a single instruction. Sorry, no kprobes
>> support in NMI handlers because of this limitation. This cannot be emulated
>> with popf/lret, because lret would be single-stepped. It does not apply to
>> "immediate values" because they do not use single-stepping. This code detects if
>> the TF flag is set and uses the iret path for single-stepping, even if it
>> reactivates NMIs prematurely.
>>    
>
> You need to save/restore cr2 in addition, otherwise the following hits you
>
> - page fault
> - processor writes cr2, enters fault handler
> - nmi
> - page fault
> - cr2 overwritten
>
> I guess you would usually not notice the corruption since you'd just see  
> a spurious fault on the page the NMI handler touched, but if the first  
> fault happened in a kvm guest, then we'd corrupt the guest's cr2.

OK, just to make sure: you mean we'd have to save/restore the cr2 register
at the beginning/end of the NMI handler execution, right ? The shouldn't we
save/restore cr3 too ?

> But the whole thing strikes me as overkill.  If it's 8k per-cpu, what's  
> wrong with using a per-cpu pointer to a kmalloc() area?

Well, it seems like all the kernel code calling "vmalloc_sync_all()" (which is
much more than perf) can potentially cause large latencies, which could be
squashed by allowing page faults in NMI handlers. This looks like a stronger
argument to me.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
