Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0GPQsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:48:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab0GPQsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:48:06 -0400
Message-ID: <4C408D0C.5050709@redhat.com>
Date: Fri, 16 Jul 2010 19:47:08 +0300
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
        Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com> <4C405078.20707@redhat.com> <20100716144927.GA22516@Krystal>
In-Reply-To: <20100716144927.GA22516@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 05:49 PM, Mathieu Desnoyers wrote:
>
>> You need to save/restore cr2 in addition, otherwise the following hits you
>>
>> - page fault
>> - processor writes cr2, enters fault handler
>> - nmi
>> - page fault
>> - cr2 overwritten
>>
>> I guess you would usually not notice the corruption since you'd just see
>> a spurious fault on the page the NMI handler touched, but if the first
>> fault happened in a kvm guest, then we'd corrupt the guest's cr2.
>>      
> OK, just to make sure: you mean we'd have to save/restore the cr2 register
> at the beginning/end of the NMI handler execution, right ?

Yes.

> The shouldn't we
> save/restore cr3 too ?
>
>    

No, faults should not change cr3.

>> But the whole thing strikes me as overkill.  If it's 8k per-cpu, what's
>> wrong with using a per-cpu pointer to a kmalloc() area?
>>      
> Well, it seems like all the kernel code calling "vmalloc_sync_all()" (which is
> much more than perf) can potentially cause large latencies, which could be
> squashed by allowing page faults in NMI handlers. This looks like a stronger
> argument to me.

Why is that kernel code calling vmalloc_sync_all()?  If it is only NMI 
which cannot take vmalloc faults, why bother?  If not, why not?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

