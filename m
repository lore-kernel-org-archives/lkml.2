Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0CWOS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:18:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab0CWOS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:18:58 -0400
Message-ID: <4BA8CE39.8050203@redhat.com>
Date: Tue, 23 Mar 2010 10:20:41 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>	 <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>	 <1269342115.5279.1620.camel@twins>	 <20100323122335.GB26762@linux.vnet.ibm.com> <1269352012.5109.22.camel@twins>
In-Reply-To: <1269352012.5109.22.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2010-03-23 at 17:53 +0530, Srikar Dronamraju wrote:
>> Hi Peter,
>>
>>> On Sat, 2010-03-20 at 19:56 +0530, Srikar Dronamraju wrote:
>>>> +struct uprobe {
>>>> +       /*
>>>> +        * The pid of the probed process.  Currently, this can be the
>>>> +        * thread ID (task->pid) of any active thread in the process.
>>>> +        */
>>>> +       pid_t pid;
>>>> +
>>>> +       /* Location of the probepoint */
>>>> +       unsigned long vaddr;
>>>> +
>>>> +       /* Handler to run when the probepoint is hit */
>>>> +       void (*handler)(struct uprobe*, struct pt_regs*);
>>>> +
>>>> +       /* true if handler runs in interrupt context*/
>>>> +       bool handler_in_interrupt;
>>>> +}; 
>>>
>>> I would still prefer to see something like:
>>>
>>>  vma:offset, instead of tid:vaddr
>>>  
>>> You want to probe a symbol in a DSO, filtering per-task comes after that
>>> if desired.
>>>
> 
>> do you mean the user should be specifying 357c200000:74b80 to denote
>> 000000357c274b80? or /lib64/libc.so.6:74b80
>> And we trace all the process which have mapped this address?
> 
> Well userspace would simply specify something like: /lib/libc.so:malloc,
> we'd probably communicate that to the kernel using a filedesc and
> offset.
> 
> And yes, all processes that share that DSO, consumers can install
> filters.

Hmm, for low-level interface, it will be good. If we provide
a user interface(trace_uprobe.c), we'd better add pid filter
for it.

>>> Also, like we discussed in person, I think we can do away with the
>>> handler_in_interrupt thing by letting the handler have an error return
>>> value and doing something like:
>>>
>>> do_int3:
>>>
>>>   uprobe = find_probe_point(addr);
>>>
>>>   pagefault_disable();
>>>   err = uprobe->handler(uprobe, regs);
>>>   pagefault_enable();
>>>
>>>   if (err == -EFAULT) {
>>>     /* set TIF flag and call the handler again from
>>>        task context */
>>>   }
>>>
>>> This should allow the handler to optimistically access memory from the
>>> trap handler, but in case it does need to fault pages in we'll call it
>>> from task context.
>>
>> Okay but what if the handler is coded to sleep.
> 
> Don't do that ;-)
> 
> What reason would you have to sleep from a int3 anyway? You want to log
> bits and get on with life, right? The only interesting case is faulting
> when some memory references you want are not currently available, and
> that can be done as suggested.

Out of curiously, what does the task-context mean? ('current' is probed
task in int3, isn't it?). I think, uprobe handler can cause page fault
(and should sleep) if the page is swapped out.

>>> Everybody else simply places callbacks in kernel/fork.c and
>>> kernel/exit.c, but as it is I don't think you want per-task state like
>>> this.
>>>
>>> One thing I would like to see is a slot per task, that has a number of
>>> advantages over the current patch-set in that it doesn't have one page
>>> limit in number of probe sites, nor do you need to insert vmas into each
>>> and every address space that happens to have your DSO mapped.
>>>
>>
>> where are the per task slots stored?
>> or Are you looking at a XOL vma area per DSO?
> 
> The per task slot (note the singular, each task needs only ever have a
> single slot since a task can only ever hit one trap at a time) would
> live in the task TLS or task stack.

Hmm, I just worried about whether TLS/task stack can be executable
(no one set NX bit).

>>> Also, I would simply kill the user_bkpt stuff and merge it into uprobes,
>>> we don't have a kernel_bkpt thing either, only kprobes.
>>>
>>
>> We had uprobes as one single layer. However it was suggested that
>> breaking it up into two layers was useful because it would help code
>> reuse. Esp it was felt that a generic user_bkpt layer would be far more
>> useful than being used for just uprobes.
>> Here are links where these discussion happened.
> 
> I'm so not going to read ancient emails on a funky list. What re-use?
> uprobe should be the only interface to this, there's no second interface
> to kprobes either is there?

It will be good when we start working on 'ptrace2' :)
Anyway, the patch order looks a bit odd, because user_bkpt uses XOL
but XOL patch is introduced after user_bkpt patch...

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

