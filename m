Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2I0BCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:02:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2I0BCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:02:43 -0400
MIME-Version: 1.0
In-Reply-To: <28857.1345091034@neuling.org>
References: <28857.1345091034@neuling.org>
Date: Thu, 27 Sep 2012 09:02:43 +0800
Message-ID: <CACV3sbKZ1B2qOFPC7WJ7k28FbcSV-cWk=OA4f7Fy5mdLRfZEhA@mail.gmail.com>
Subject: Re: powerpc/perf: hw breakpoints return ENOSPC
From: Jovi Zhang <bookjovi@gmail.com>
To: Michael Neuling <mikey@neuling.org>
Cc: K Prasad <prasad@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 12:23 PM, Michael Neuling <mikey@neuling.org> wrote:
> Hi,
>
> I've been trying to get hardware breakpoints with perf to work on POWER7
> but I'm getting the following:
>
>   % perf record -e mem:0x10000000 true
>
>     Error: sys_perf_event_open() syscall returned with 28 (No space left on device).  /bin/dmesg may provide additional information.
>
>     Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
>
>   true: Terminated
>
> (FWIW adding -a and it works fine)
>
> Debugging it seems that __reserve_bp_slot() is returning ENOSPC because
> it thinks there are no free breakpoint slots on this CPU.
>
> I have a 2 CPUs, so perf userspace is doing two perf_event_open syscalls
> to add a counter to each CPU [1].  The first syscall succeeds but the
> second is failing.
>
> On this second syscall, fetch_bp_busy_slots() sets slots.pinned to be 1,
> despite there being no breakpoint on this CPU.  This is because the call
> the task_bp_pinned, checks all CPUs, rather than just the current CPU.
> POWER7 only has one hardware breakpoint per CPU (ie. HBP_NUM=1), so we
> return ENOSPC.
>
> The following patch fixes this by checking the associated CPU for each
> breakpoint in task_bp_pinned.  I'm not familiar with this code, so it's
> provided as a reference to the above issue.
>
> Mikey
>
> 1. not sure why it doesn't just do one syscall and specify all CPUs, but
> that's another issue.  Using two syscalls should work.
>
This problem let me recall what I reported several months ago.

https://lkml.org/lkml/2012/6/27/631

At that time, I thought it is caused by uses_mmap field in record sub
command which
added by commit d1cb9f(perf target: Add uses_mmap field).

In that testcase, it's fine to use stat sub command, but failed with
record sub command.

As Namhyung metioned in that thread, [perf record xxx] use
per-task-per-cpu for fix
scalability issues.
