Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935112Ab0KQRba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:31:30 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41029 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935102Ab0KQRb2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:31:28 -0500
Date: Wed, 17 Nov 2010 12:31:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, Andre@firstfloor.org,
        ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        pierre-marc.fournier@polymtl.ca
Subject: Re: [ANNOUNCE] New tools: lttngtrace and lttngreport
Message-ID: <20101117173124.GB13717@Krystal>
References: <20101115134243.GA2772@Krystal> <20101115160745.GA7203@Krystal> <87y68sqiyb.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87y68sqiyb.fsf@basil.nowhere.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:16:08 up 55 days, 21:18,  4 users,  load average: 0.06, 0.10,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> >
> >         --> Blocked in RUNNING, SYSCALL 142 [sys_select+0x0/0xc0], ([...], dur: 0.029567)
> >         |    --> Blocked in RUNNING, SYSCALL 168 [sys_poll+0x0/0xc0], ([...], dur: 1.187935)
> >         |    --- Woken up by an IRQ: IRQ 0 [timer]
> >         --- Woken up in context of 7401 [gnome-power-man] in high-level state RUNNING
> 
> Very nice! Now how can we get that with an unpatched kernel tree?

Well, I'm afraid the collection approach "trace" is currently taking won't allow
this kind of dependency wakeup chain tracking, because they focus on tracing
operations happening on a thread and its children, but the reality is that the
wakeup chains often spread outside of this scope.

This is why lttngtrace gathers a system-wide trace even though we're mostly
intested in the wait/wakeups of a specific PID.

Wakeup dependency analysis depends on a few key events to track these chains.
It's all described in Pierre-Marc Fournier's master thesis and implemented as
a LTTV plugin. Don't worry about the French cover page, the whole chapter 2
(p. 40-74) is in English:

http://publications.polymtl.ca/117/1/2009_Pierre-MarcFournier.pdf

The instrumentation needed for it, excerpt from the thesis:

"We instrumented scheduling changes (and whether they are caused by preemption
or blocking), process wakeups, IRQ entry/exit, softIRQ entry/exit, trap
entry/exit and process forking. Additionally, special state dump events are
generated at the beginning of the trace that indicate in what control flow state
(see section 2.2.3.1) each process is initially. All this instrumentation is
kernel-based, no application instrumentation is necessary.

In order to display detailed information in reports, the Delay Analyzer also
consumes events that give the following information.
– Mapping between IRQ number and name of hardware using it
– Mapping between softIRQ number and the function handling it
– Mapping between a process ID and its name
– Arguments of the open() system call, in order to save the mapping between file
  descriptor and file name
– Arguments of the read() system call, in order to know what file caused the
  system call to block
– What file descriptors caused a poll() system call to wake up
Work is under way to instrument yet more specific system calls."

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
