Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2H2PsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:48:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab2H2PsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:48:05 -0400
Date: Wed, 29 Aug 2012 17:49:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        gdb-patches@sourceware.org
Subject: Re: [RFC 5/5 v2] uprobes: add global breakpoints
Message-ID: <20120829154952.GA29101@redhat.com>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-6-git-send-email-bigeasy@linutronix.de> <1344857686.31459.25.camel@twins> <20120821194200.GA32293@linutronix.de> <20120822134837.GA28878@redhat.com> <503BC2F1.5060003@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <503BC2F1.5060003@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, Sebastian Andrzej Siewior wrote:
>
> On 08/22/2012 03:48 PM, Oleg Nesterov wrote:
>> On 08/21, Sebastian Andrzej Siewior wrote:
>>>
>>> - not putting the task in TASK_TRACED but simply halt. This would work
>>>    without a change to ptrace_attach() but the task continues on any
>>>    signal. So a signal friendly task would continue and not notice a
>>>    thing.
>>
>> TASK_KILLABLE
>
> That would help but would require a change in ptrace_attach() or
> something in gdb/strace/…

Well, I still think you should not touch ptrace_attach() at all.

> One thing I just noticed: If I don't register a handler for SIGUSR1 and
> send one to the application while it is in TASK_KILLABLE then the
> signal gets delivered.

Not really delivered... OK, it can be delivered (dequeued) before
the task sees SIGKILL, but this can be changed.

In short: in this case the task is correctly SIGKILL'ed. See sig_fatal()
in complete_signal().

> If I register a signal handler for it than it
> gets blocked and delivered once I resume the task.

Sure, if you have a handler, the signal is not fatal.

> Shouldn't it get blocked even if I don't register a handler for it?

No.

>> Am I understand correctly?
>>
>> If it was woken by PTRACE_ATTACH we set utask->skip_handler = 1 and
>> re-execute the instruction (yes, SIGTRAP, but this doesn't matter).
>> When the task hits this bp again we skip handler_chain() because it
>> was already reported.
>>
>> Yes? If yes, I don't think this can work. Suppose that the task
>> dequeues a signal before it returns to the usermode to re-execute
>> and enters the signal handler which can hit another uprobe.
>
> ach, those signals make everything complicated. I though signals are
> blocked until the single step is done

Yes, see uprobe_deny_signal().

> but my test just showed my
> something different.

I guess you missed the UTASK_SSTEP_TRAPPED logic.

But this doesn't matter. Surely we must not "block" signals _after_
the single step is done, and this is the problem.

> Okay, what now?

IMHO: don't do this ;)

> Blocking signals isn't probably a good idea.

This is bad and wrong idea, I think.

And, once again. Whatever you do, you can race with uprobe_register().
I mean, you must never expect that the task will hit the same uprobe
again, even if you are going to re-execute the same insn.

Oleg.

