Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab0KQNJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:09:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:48226 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0KQNJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:09:40 -0500
Subject: Re: [patch] trace: Add user-space event tracing/injection
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20101117125827.GB27063@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <4CE38C53.8090606@kernel.org> <20101117120740.GA24972@elte.hu>
	 <4CE3C7C2.7000200@kernel.org> <20101117123055.GA27063@elte.hu>
	 <4CE3CB8A.8060608@kernel.org> <1289997733.2109.743.camel@laptop>
	 <20101117125827.GB27063@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 14:09:12 +0100
Message-ID: <1289999352.2109.757.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 13:58 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:

> > I don't much like it, Jato already does its own tracing for the anon_vma
> > symbols, it might as well write its own event log too (would need a
> > proper VDSO clock thingy though).
> 
> The problem is that it then does not properly mix with other events outside of the 
> control of the application.
> 
> For example if there are two apps both generating user events, but there's no 
> connection with them, a system-wide tracer wont get a properly ordered set of events 
> - both apps will trace into their own buffers. So if we have:
> 
>   CPU1
> 
>   app1: "user event X"
>   app2: "user event Y"
> 
> Then a 'trace --all' system-wide tracing session will not get proper ordering 
> between app1 and app2's events. It only gets timestamps - which may or may not be 
> correct.

I claim we can do a VDSO to the quality of the kernel/sched_clock.c
code, which basically means we can do it as good as the kernel can.

> User-space tracing schemes tend to be clumsy and limiting. There's other 
> disadvantages as well: approaches that expose a named pipe in /tmp or an shmem 
> region are not transparent and robust either: if user-space owns a pending buffer 
> then bugs in the apps can corrupt the trace buffer, can prevent its flushing when 
> the app goes down due to an app bug (and when the trace would be the most useful), 
> etc. etc.

Sure, but you're not considering the fact that Jato already needs an
interface to communicate its generated symbols, also writing its own
events really isn't a big deal after that.

> Also, in general their deployment isnt particularly fast nor lightweight - while 
> prctl() is available everywhere.

I know your reasoning, but deployment isn't everything. Technical sanity
does, I hope, still count for something as well.

> And when it comes to tracing/instrumentation, if we make deployment too complex, 
> people will simply not use it - and we all use. A prctl() isnt particularly sexy 
> design, but it's a task/process event that we are generating (so related to prctls), 
> plus it's available everywhere and is very easy to deploy.

Different tools for different people, complex applications like JITs can
use a more complex interface to communicate all their various data.

A simple printk() style interface through a syscall (preferably not
prctl) if fine too, it just doesn't suffice for everything, nor should
we want it to.
