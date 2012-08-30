Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2H3UmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 16:42:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:33429 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2H3UmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 16:42:24 -0400
Message-ID: <503FD021.6060804@linutronix.de>
Date: Thu, 30 Aug 2012 22:42:09 +0200
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
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-6-git-send-email-bigeasy@linutronix.de> <1344857686.31459.25.camel@twins> <20120821194200.GA32293@linutronix.de> <20120822134837.GA28878@redhat.com> <503BC2F1.5060003@linutronix.de> <20120829154952.GA29101@redhat.com>
In-Reply-To: <20120829154952.GA29101@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 05:49 PM, Oleg Nesterov wrote:
>> That would help but would require a change in ptrace_attach() or
>> something in gdb/strace/…
>
> Well, I still think you should not touch ptrace_attach() at all.

Okay.

>> One thing I just noticed: If I don't register a handler for SIGUSR1 and
>> send one to the application while it is in TASK_KILLABLE then the
>> signal gets delivered.
>
> Not really delivered... OK, it can be delivered (dequeued) before
> the task sees SIGKILL, but this can be changed.
>
> In short: in this case the task is correctly SIGKILL'ed. See sig_fatal()
> in complete_signal().
>
>> If I register a signal handler for it than it
>> gets blocked and delivered once I resume the task.
>
> Sure, if you have a handler, the signal is not fatal.
>
>> Shouldn't it get blocked even if I don't register a handler for it?
>
> No.

Now, that I read again it looks like a brain fart on my side.

>> ach, those signals make everything complicated. I though signals are
>> blocked until the single step is done
>
> Yes, see uprobe_deny_signal().
>
>> but my test just showed my
>> something different.
>
> I guess you missed the UTASK_SSTEP_TRAPPED logic.
>
> But this doesn't matter. Surely we must not "block" signals _after_
> the single step is done, and this is the problem.
>
>> Okay, what now?
>
> IMHO: don't do this ;)
>
>> Blocking signals isn't probably a good idea.
>
> This is bad and wrong idea, I think.
>
> And, once again. Whatever you do, you can race with uprobe_register().
> I mean, you must never expect that the task will hit the same uprobe
> again, even if you are going to re-execute the same insn.

After witting why I think you are wrong I understood what you meant :)
So let me try to get this right…

>
> Oleg.

Sebastian
