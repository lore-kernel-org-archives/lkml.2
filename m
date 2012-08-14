Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2HNLoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:44:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:58006 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2HNLoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:44:03 -0400
Message-ID: <502A39FC.4070603@linutronix.de>
Date: Tue, 14 Aug 2012 13:43:56 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        gdb-patches@sourceware.org
Subject: Re: [RFC 5/5] uprobes: add global breakpoints
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-6-git-send-email-bigeasy@linutronix.de> <20120808131457.GA5309@redhat.com> <20120809171802.GB27835@linutronix.de> <20120813131623.GA5269@redhat.com>
In-Reply-To: <20120813131623.GA5269@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 03:16 PM, Oleg Nesterov wrote:
> On 08/09, Sebastian Andrzej Siewior wrote:
>>
>> * Oleg Nesterov | 2012-08-08 15:14:57 [+0200]:
>>
>>>> What I miss right now is an interface to tell the user/gdb that there is a
>>>> program that hit a global breakpoint and is waiting for further instructions.
>>>> A "tail -f trace" does not work and may contain also a lot of other
>>>> informations. I've been thinking about a poll()able file which returns pids of
>>>> tasks which are put on hold. Other suggestions?
>>>
>>> Honestly, I am not sure this is that useful...
>>
>> How would you notify gdb that there is a new task that hit a breakpoint?
>> Or learn yourself?
>
> But why do we need this?

Shouldn't we learn somehow that a process hits a breakpoint? The task
was not yet monitored by gdb.

> OK, you do not need to convince me, I try to never argue with
> new features.

If there is a simple mechanism, I would switch to it. Right now I think
about using this "notification mechanism" to auto-exlude the listener
(and its parents) from the list of possible targets. So I don't freeze
the whole system while I have a breakpoint at malloc() in libc.

> However, I certainly dislike TASK_TRACED in uprobe_wait_traced().
> And sleeping in ->handler() is not fair to other consumers.

I added it as the last task in current consumer. I could move it out of
the consumer loop and freeze it after all consumer are handled but then
I lose the filter member (which is currently NULL, I know).

> And I do not think you should modify ptrace_attach() at all.
> gdb/user can wakeup the task after PTRACE_ATTACH itself.

I see. gdb / strace --pid $num" gdb does PTRACE_ATTACH and waits
afterwords in wait() indefinitely for the SIGSTOP which is blocked
since the process is already in TASK_TRACED. This is nice since the
signals are blocked and are delivered once the task is unfrozed.

> Oleg.

Sebastian
