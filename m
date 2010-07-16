Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356Ab0GPMaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:30:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965337Ab0GPMaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:30:17 -0400
Message-ID: <4C405078.20707@redhat.com>
Date: Fri, 16 Jul 2010 15:28:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: LKML <linux-kernel@vger.kernel.org>,
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
        Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, akpm@osdl.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com>
In-Reply-To: <20100714155804.252253097@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 06:49 PM, Mathieu Desnoyers wrote:
> Implements an alternative iret with popf and return so trap and exception
> handlers can return to the NMI handler without issuing iret. iret would cause
> NMIs to be reenabled prematurely. x86_32 uses popf and far return. x86_64 has to
> copy the return instruction pointer to the top of the previous stack, issue a
> popf, loads the previous esp and issue a near return (ret).
>
> It allows placing dynamically patched static jumps in asm gotos, which will be
> used for optimized tracepoints, in NMI code since returning from a breakpoint
> would be valid. Accessing vmalloc'd memory, which allows executing module code
> or accessing vmapped or vmalloc'd areas from NMI context, would also be valid.
> This is very useful to tracers like LTTng.
>
> This patch makes all faults, traps and exception safe to be called from NMI
> context*except*  single-stepping, which requires iret to restore the TF (trap
> flag) and jump to the return address in a single instruction. Sorry, no kprobes
> support in NMI handlers because of this limitation. This cannot be emulated
> with popf/lret, because lret would be single-stepped. It does not apply to
> "immediate values" because they do not use single-stepping. This code detects if
> the TF flag is set and uses the iret path for single-stepping, even if it
> reactivates NMIs prematurely.
>    

You need to save/restore cr2 in addition, otherwise the following hits you

- page fault
- processor writes cr2, enters fault handler
- nmi
- page fault
- cr2 overwritten

I guess you would usually not notice the corruption since you'd just see 
a spurious fault on the page the NMI handler touched, but if the first 
fault happened in a kvm guest, then we'd corrupt the guest's cr2.

But the whole thing strikes me as overkill.  If it's 8k per-cpu, what's 
wrong with using a per-cpu pointer to a kmalloc() area?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

