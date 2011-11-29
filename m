Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1K2WPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 17:15:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab1K2WPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 17:15:00 -0500
Date: Tue, 29 Nov 2011 17:14:20 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
Subject: Re: Perhaps a side effect regarding NMI returns
Message-ID: <20111129221419.GE6610@redhat.com>
References: <1322539673.17003.45.camel@frodo>
 <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
 <m2r50qlmgk.fsf@firstfloor.org>
 <CA+55aFxyBYFbx=AGgJ35Dx+U8KVPktesHetYnQrYpt1QGKTrbQ@mail.gmail.com>
 <20111129203111.GQ24062@one.firstfloor.org>
 <CA+55aFxUFkHGXk_eEN1GYsZWe5_G9uoCP6DkL6bw9+wWP2_fcw@mail.gmail.com>
 <1322600301.17003.84.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322600301.17003.84.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 03:58:21PM -0500, Steven Rostedt wrote:
> On Tue, 2011-11-29 at 12:36 -0800, Linus Torvalds wrote:
> > On Tue, Nov 29, 2011 at 12:31 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > >
> > > As a simple fix your proposal of forcing IRET sounds good.
> > 
> > We could of course use iret to return to the regular kernel stack, and
> > do the schedule from there.
> > 
> > So instead of doing the manual stack switch, just build a fake iret
> > stack on our exception stack. Subtle and somewhat complicated. I'd
> > almost rather just do a blind iret, and leave the 'iret to regular
> > stack' as a possible future option.
> 
> Note, the reason that I've been looking at this code, is because I'm
> looking at implementing your idea to handle irets in NMIs, caused by
> faults, exceptions, and the reason I really care about: debugging.
> 
> Your proposal is here:
> 
>   https://lkml.org/lkml/2010/7/14/264
> 
> But to make this work, it would be really nice if the NMI routine wasn't
> convoluted with the paranoid_exit code.
> 
> For things like static_branch()/jump_label and modifying ftrace nops to
> calls and back, we currently use the big hammer approach stop_machine().
> This keeps another CPU from executing code that is being modified.
> There's also tricks to handle NMIs that may be running on the stopped
> CPUs.
> 
> But people don't like the overhead that stop_machine() causes, and I
> have code that can make the modifications for ftrace with break points.
> By adding a break point, syncing, then modifying the code and break

But if there's still has to be some sort of 'syncing' after we add a break
point, how much are we going to save? Or I guess your're using an IPI? 

Thanks,

-Jason

> point to a new op will greatly reduce the overhead. At least the latency
> will be much less.
> 
> The problem is that ftrace affects code in NMIs. We tried to not trace
> NMIs, but there's so many functions that NMIs call, it ended up being a
> losing battle. But if we can fix the NMI enabled on iret, we can then
> use the break point scheme for both static_branch() and ftrace, and
> remove the overhead of stop_machine. I think there's a possibility to
> use kprobes in NMIs too, with this fix.
> 
> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
