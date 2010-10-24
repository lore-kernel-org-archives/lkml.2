Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab0JXAxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 20:53:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35189 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab0JXAxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 20:53:43 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=LuwKl7ggZIAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=NReUeh_FT3k6cPml724A:9 a=Mrjqd2x8bkBZVG6EFgGypK_5ResA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <20101023200216.GA19324@elte.hu>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
	 <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu>
	 <20101020164324.GC7348@redhat.com> <20101020183329.GA12666@elte.hu>
	 <20101021110925.GA27219@elte.hu> <20101022175845.GF6498@redhat.com>
	 <20101022182433.GA24637@elte.hu> <20101022183900.GG6498@redhat.com>
	 <20101023200216.GA19324@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 23 Oct 2010 20:53:38 -0400
Message-ID: <1287881618.16971.657.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-23 at 22:02 +0200, Ingo Molnar wrote:
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > > Not the same config, and it's very spurious - i.e. a slightly different -tip 
> > > version with the same config will boot fine. (this suggests some race)
> > 
> > if possible, can you post that .config?
> 
> I just reproduced it again with tip-1128a72 - config and full bootlog attached.
> 
> The crash picture tends to vary - sometimes it crashes in fork, sometimes in the 
> timer interrupt. Here's the current one:
> 
> [   15.384483] Running tests on trace events:
> [   15.388580] Testing event kfree_skb: 
> [   15.392381] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   15.395408] IP: [<(null)>] (null)

Interesting, the jump was to NULL. I'm thinking it hit a trace point and
jumped to a NULL address. I guess there's some strange race here. Is a
cache flush missing somewhere. I'll look more into this on Monday.

-- Steve


> [   15.395408] *pde = 00000000 
> [   15.395408] Oops: 0000 [#1] SMP 
> [   15.395408] last sysfs file: 
> [   15.395408] 
> [   15.395408] Pid: 2, comm: kthreadd Not tainted 2.6.36-tip-03573-g1128a72-dirty #51926 A8N-E/System Product Name
> [   15.395408] EIP: 0060:[<00000000>] EFLAGS: 00010086 CPU: 0
> [   15.395408] EIP is at 0x0
> [   15.395408] EAX: c1049bb5 EBX: 00000286 ECX: 00000000 EDX: 00000000
> [   15.395408] ESI: 00000000 EDI: f5cd96e0 EBP: 00000063 ESP: f6449f24
> [   15.395408]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   15.395408] Process kthreadd (pid: 2, ti=f6448000 task=f64443d0 task.ti=f6448000)
> [   15.395408] Stack:
> [   15.395408]  c104d4e6 00800711 00000000 00000000 00000000 00000001 f6a09b00 f64443d0
> [   15.395408]  c188a238 c1dffb00 c1f1f200 00000000 c1049c53 b3420a74 00800711 c1061a4b
> [   15.395408]  f6449fc0 f6449f7c c102ea40 00000000 00000000 00000000 00000000 00000000
> [   15.395408] Call Trace:
> [   15.395408]  [<c104d4e6>] ? do_fork+0x205/0x2aa
> [   15.395408]  [<c1049c53>] ? dequeue_task+0x97/0xa6
> [   15.395408]  [<c1061a4b>] ? kthread+0x0/0x68
> [   15.395408]  [<c102ea40>] ? kernel_thread+0x77/0x7f
> [   15.395408]  [<c1061a4b>] ? kthread+0x0/0x68
> [   15.395408]  [<c10299c0>] ? kernel_thread_helper+0x0/0x10
> [   15.395408]  [<c1061b40>] ? kthreadd+0x8d/0xbf
> [   15.395408]  [<c1061ab3>] ? kthreadd+0x0/0xbf
> [   15.395408]  [<c10299c6>] ? kernel_thread_helper+0x6/0x10
> [   15.395408] Code:  Bad EIP value.
> [   15.395408] EIP: [<00000000>] 0x0 SS:ESP 0068:f6449f24
> [   15.395408] CR2: 0000000000000000
> [   15.395408] ---[ end trace 105d75af79111d22 ]---
> 
> (One possibility would be kernel text corruption perhaps.)
> 
> Thanks,
> 
> 	Ingo


