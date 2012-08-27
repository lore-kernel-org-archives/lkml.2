Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2H0S5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:57:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:46248 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab2H0S5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:57:00 -0400
Message-ID: <503BC2F1.5060003@linutronix.de>
Date: Mon, 27 Aug 2012 20:56:49 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        gdb-patches@sourceware.org
Subject: Re: [RFC 5/5 v2] uprobes: add global breakpoints
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-6-git-send-email-bigeasy@linutronix.de> <1344857686.31459.25.camel@twins> <20120821194200.GA32293@linutronix.de> <20120822134837.GA28878@redhat.com>
In-Reply-To: <20120822134837.GA28878@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 03:48 PM, Oleg Nesterov wrote:
> On 08/21, Sebastian Andrzej Siewior wrote:
>>
>> This patch adds the ability to hold the program once this point has been
>> passed and the user may attach to the program via ptrace.
>
> Sorry Sebastian, I didn't even try to read the patch ;) Fortunately I am
> not maintainer, I can only reapeat that you do not need to convince me.

At least for the ptrace part I would prefer to have your blessing
instead something that seems to work but is wrong.

>> Oleg: The change in ptrace_attach() is still as it was. I tried to
>> address Peter concern here.
>> Now what options do I have here:
>> - not putting the task in TASK_TRACED but simply halt. This would work
>>    without a change to ptrace_attach() but the task continues on any
>>    signal. So a signal friendly task would continue and not notice a
>>    thing.
>
> TASK_KILLABLE

That would help but would require a change in ptrace_attach() or
something in gdb/strace/…

One thing I just noticed: If I don't register a handler for SIGUSR1 and
send one to the application while it is in TASK_KILLABLE then the
signal gets delivered. If I register a signal handler for it than it
gets blocked and delivered once I resume the task.
Shouldn't it get blocked even if I don't register a handler for it?

>> - putting the TASK_TRACED
>
> This is simply wrong, in many ways.
>
> For example, what if the probed task is already ptraced? Or debugger
> attaches via PTRACE_SEIZE? How can debugger know it is stopped?
> uprobe_wait_traced() goes to sleep in TASK_TRACED without notification.
> And it does not set ->exit_code, this means do_wait() won't work.
> And note ptrace_stop()->recalc_sigpending_tsk().

Okay, okay. It looks like it is better to stick with TASK_KILLABLE
instead of fixing the issues you pointed out.

>> --- a/kernel/events/uprobes.c
>> +++ b/kernel/events/uprobes.c
>> @@ -1513,7 +1513,16 @@ static void handle_swbp(struct pt_regs *regs)
>>   			goto cleanup_ret;
>>   	}
>>   	utask->active_uprobe = uprobe;
>> -	handler_chain(uprobe, regs);
>> +	if (utask->skip_handler)
>> +		utask->skip_handler = 0;
>> +	else
>> +		handler_chain(uprobe, regs);
>> +
>> +	if (utask->state == UTASK_TRACE_WOKEUP_TRACED) {
>> +		send_sig(SIGTRAP, current, 0);
>> +		utask->skip_handler = 1;
>> +		goto cleanup_ret;
>> +	}
>>   	if (uprobe->flags&  UPROBE_SKIP_SSTEP&&  can_skip_sstep(uprobe, regs))
>>   		goto cleanup_ret;
>>
>> @@ -1528,7 +1537,7 @@ cleanup_ret:
>>   		utask->active_uprobe = NULL;
>>   		utask->state = UTASK_RUNNING;
>>   	}
>> -	if (!(uprobe->flags&  UPROBE_SKIP_SSTEP))
>> +	if (!(uprobe->flags&  UPROBE_SKIP_SSTEP) || utask->skip_handler)
>
> Am I understand correctly?
>
> If it was woken by PTRACE_ATTACH we set utask->skip_handler = 1 and
> re-execute the instruction (yes, SIGTRAP, but this doesn't matter).
> When the task hits this bp again we skip handler_chain() because it
> was already reported.
>
> Yes? If yes, I don't think this can work. Suppose that the task
> dequeues a signal before it returns to the usermode to re-execute
> and enters the signal handler which can hit another uprobe.

ach, those signals make everything complicated. I though signals are
blocked until the single step is done but my test just showed my
something different. Okay, what now? A simple nested struct uprobe_task
and struct uprobe? Blocking signals isn't probably a good idea.

> And this can race with uprobe_register() afaics.

> Oleg.

Sebastian
