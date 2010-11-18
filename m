Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0KRMxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:53:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39746 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab0KRMxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:53:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r19i8To4Q+Ke35rM3C3mcK7eCLTpP+WBfjGsKxpDuei+/84MITdZZ7wOfqT6aEF22i
         TPERHOuEZ7NSETeY02KYkjh13CvcCBS9mhdqrDMEjvFR8TjOHVlw9Z+8blAT4RKfALeA
         /u1Tcm+cDpFPYiSr85VQoBPl5RZt+ERhO3dGM=
Date: Thu, 18 Nov 2010 13:53:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/
	directory
Message-ID: <20101118125307.GB5344@nowhere>
References: <20101118035803.453609353@goodmis.org> <1290076866.2109.1305.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290076866.2109.1305.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:41:06AM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 22:58 -0500, Steven Rostedt wrote:
> > For example, I added a trace_printk() in kernel/sched.c at line 2180
> > and it creates:
> > 
> > # ls /debug/tracing/events/printk/kernel/sched.c/2180/
> > enable  format
> > 
> > The format is the printk format:
> > 
> > # cat /debug/tracing/events/printk/kernel/sched.c/2180/format 
> > "migrate task %s:%d"
> 
> *groan*, so you're creating a tracepoint per instance?
> 
> That's going to be massive pain for perf.. I really don't see the point
> in splitting all that out.


Because it makes it very flexible, makes it easy to display the user
where are his trace_printk() and which one he could interact with.

Why would it be a massive pain for perf? People are not going to play
with thousands trace_printk() at once I guess.

Of course, a problem may arise if dynamic_printk() is handled into this
scheme, because of the number of fds to handle. In this case probably this
scheme should allow a group of trace_printk to be a (virtual) trace_event itself.

I mean if you have two trace_printk() in kernel/sched.c and some
others in kernel/, you could either create once perf_event for
every trace_printk() in kernel/ or one for every trace_prink() in
kernel/sched.c, or one for kernel/sched.c:118

That's easy if you have an id file at each level.

An other solution, which have been talking with Thomas yesterday, would be
to allow having a single fd for several perf_events at once. That would
solve some problems when you have hundreds of events opened (think about
wide tracing, or use of all individual syscalls).

