Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab2APR4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:56:01 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57733 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab2APR4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:56:00 -0500
Date: Mon, 16 Jan 2012 22:11:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 3.2 7/9] tracing: uprobes trace_event interface
Message-ID: <20120116164146.GI10189@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <20120110114943.17610.28293.sendpatchset@srdronam.in.ibm.com>
 <20120116131137.GB5265@m.brq.redhat.com>
 <20120116144538.GG10189@linux.vnet.ibm.com>
 <20120116153327.GE5265@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120116153327.GE5265@m.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011617-5930-0000-0000-0000042A9F1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Olsa <jolsa@redhat.com> [2012-01-16 16:33:27]:

> On Mon, Jan 16, 2012 at 08:15:38PM +0530, Srikar Dronamraju wrote:
> > > 
> > > I've tested following event:
> > >         echo "p:probe_libc/free /lib64/libc-2.13.so:0x7a4f0 %ax" > ./uprobe_events
> > > 
> > > and commands like:
> > >         perf record -a -e probe_libc:free  --filter "common_pid == 1127"
> > >         perf record -e probe_libc:free --filter "arg1 == 0xa" ls
> > > 
> > > got me proper results.
> > > 
> > 
> > Okay thanks for the inputs.
> > 
> > > thanks,
> > > jirka
> > > 
> > > ---
> > > The preemption needs to be disabled when submitting data into perf.
> > 
> > I actually looked at other places where perf_trace_buf_prepare and
> > perf_trace_buf_submit are being called. for example perf_syscall_enter
> > and perf_syscall_exit both call the above routines and they didnt seem
> > to be called with premption disabled. Is that the way perf probe is
> > called in our case that needs us to call pre-emption here? Did you see a
> > case where calling these without preemption disabled caused a problem?
> 
> the perf_trace_buf_prepare touches per cpu variables,
> hence the preemption disabling
> 
> the perf_trace_buf_prepare code is used by syscalls,
> kprobes, and trace events
> 
> - both syscalls and trace events are implemented by
>   tracepoints which disable preemption before calling the probe
>   (see __DO_TRACE macro in include/linux/tracepoint.h)
> 
> - kprobes disable preemption as well
>   (kprobe_handler in arch/x86/kernel/kprobes.c)
>   haven't checked the optimalized kprobes,
>   but should be the same case
> 
> jirka
> 

Okay, thanks for the clarification, I will pick the fix.

--
Thanks and Regards
Srikar

