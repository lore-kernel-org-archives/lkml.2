Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0GPQ7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:59:01 -0400
Received: from mail.openrapids.net ([64.15.138.104]:36093 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751575Ab0GPQ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:59:00 -0400
Date: Fri, 16 Jul 2010 12:58:55 -0400
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
Message-ID: <20100716165855.GA3836@Krystal>
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com> <4C405078.20707@redhat.com> <20100716144927.GA22516@Krystal> <4C408D0C.5050709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C408D0C.5050709@redhat.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:56:55 up 174 days, 19:33,  6 users,  load average: 0.00, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity (avi@redhat.com) wrote:
> On 07/16/2010 05:49 PM, Mathieu Desnoyers wrote:
>>
>>> You need to save/restore cr2 in addition, otherwise the following hits you
>>>
>>> - page fault
>>> - processor writes cr2, enters fault handler
>>> - nmi
>>> - page fault
>>> - cr2 overwritten
>>>
>>> I guess you would usually not notice the corruption since you'd just see
>>> a spurious fault on the page the NMI handler touched, but if the first
>>> fault happened in a kvm guest, then we'd corrupt the guest's cr2.
>>>      
>> OK, just to make sure: you mean we'd have to save/restore the cr2 register
>> at the beginning/end of the NMI handler execution, right ?
>
> Yes.

OK

>
>> The shouldn't we
>> save/restore cr3 too ?
>>
>>    
>
> No, faults should not change cr3.

Ah, right.

>
>>> But the whole thing strikes me as overkill.  If it's 8k per-cpu, what's
>>> wrong with using a per-cpu pointer to a kmalloc() area?
>>>      
>> Well, it seems like all the kernel code calling "vmalloc_sync_all()" (which is
>> much more than perf) can potentially cause large latencies, which could be
>> squashed by allowing page faults in NMI handlers. This looks like a stronger
>> argument to me.
>
> Why is that kernel code calling vmalloc_sync_all()?  If it is only NMI  
> which cannot take vmalloc faults, why bother?  If not, why not?

Modules come as yet another example of stuff that is loaded in vmalloc'd space
and can be accesses from NMI context. That would include oprofile, tracers, and
probably others I'm forgetting about.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
