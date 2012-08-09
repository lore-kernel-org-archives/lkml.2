Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab2HIRSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:18:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:37690 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab2HIRSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:18:04 -0400
Date: Thu, 9 Aug 2012 19:18:02 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        gdb-patches@sourceware.org
Subject: Re: [RFC 5/5] uprobes: add global breakpoints
Message-ID: <20120809171802.GB27835@linutronix.de>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
 <1344355952-2382-6-git-send-email-bigeasy@linutronix.de>
 <20120808131457.GA5309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120808131457.GA5309@redhat.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov | 2012-08-08 15:14:57 [+0200]:

>> What I miss right now is an interface to tell the user/gdb that there is a
>> program that hit a global breakpoint and is waiting for further instructions.
>> A "tail -f trace" does not work and may contain also a lot of other
>> informations. I've been thinking about a poll()able file which returns pids of
>> tasks which are put on hold. Other suggestions?
>
>Honestly, I am not sure this is that useful...

How would you notify gdb that there is a new task that hit a breakpoint?
Or learn yourself?

>OK, I'll try to read this patch later. But, at first glance,
Thank you.

>> @@ -286,8 +286,10 @@ static int ptrace_attach(struct task_struct *task, long request,
>>  	__ptrace_link(task, current);
>>
>>  	/* SEIZE doesn't trap tracee on attach */
>> -	if (!seize)
>> +	if (!seize) {
>>  		send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
>> +		uprobe_wakeup_task(task, 1);
>> +	}
>
>Can't understand why uprobe_wakeup_task() depends on !PTRACE_SEIZE

because in the SEIZE case the task isn't halted, it continues to run. Or
do you want to use PTRACE_SEIZE for tasks which hit the global
breakpoint and you have no interrest in them and want them to continue
like nothing happend?

>> +
>> +	set_current_state(TASK_TRACED);
>> +	schedule();
>> +}
>
>Suppose that uprobe_wakeup_task() is called in the WINDOW above.
>
>OTOH, uprobe_wakeup_task() can race with itself if it is called
>twice at the same time, say from uprobes_gp_wakeup_write() and
>ptrace_attach().
Okay, I'm going to close the window.

>
>Oleg.

Sebastian
