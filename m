Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1HLFqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 01:46:22 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44638 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab1HLFqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 01:46:20 -0400
Date: Fri, 12 Aug 2011 11:16:06 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 5/5][RFC] kprobes: Use ftrace hooks when probing ftrace
	nops
Message-ID: <20110812054606.GA6975@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20110810162222.017387055@goodmis.org> <20110810163039.000615163@goodmis.org> <4E4387A7.7040200@hitachi.com> <1313068956.18583.309.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313068956.18583.309.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 09:22:36AM -0400, Steven Rostedt wrote:
> On Thu, 2011-08-11 at 16:41 +0900, Masami Hiramatsu wrote:

...

> > > +#ifdef CONFIG_FUNCTION_TRACER
> > > +static notrace void
> > > +kprobe_ftrace_callback(unsigned long ip, unsigned long parent_ip,
> > > +		       struct ftrace_ops *op, struct pt_regs *pt_regs)
> > > +{
> > > +	struct kprobe *p = container_of(op, struct kprobe, fops);
> > > +
> > 
> > Here, we need to set up kprobe_ctlblk and some of pt_regs members,
> > ip, cs and orig_ax as optimized_callback()@arch/x86/kernel/kprobes.c
> > does.
> 
> I'm curious to what this is used for? It doesn't seem to be needed for
> the generic kprobes. Because we know the probe was on a nop, there's no
> need to simulate the operation. IOW, there's no need for singlestep() or
> other gdb like operations.

It is needed to handle recursion, for instance. If in the rare case a
kprobe handler calls another routine which also has a kprobe installed
(and so on), we just bypass calling the 2nd kprobe's handlers. To do
this and to set back the original kprobe context, we track the kprobe
state in the per_cpu kprobe_ctlblk.

Ananth
