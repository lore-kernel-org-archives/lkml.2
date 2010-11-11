Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0KKS0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:26:00 -0500
Received: from thunk.org ([69.25.196.29]:57471 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab0KKSZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:25:59 -0500
Date: Thu, 11 Nov 2010 13:25:40 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
 reporting)
Message-ID: <20101111182540.GM3099@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>
References: <1289412329.12418.177.camel@gandalf.stny.rr.com>
 <1289413460.2084.27.camel@laptop>
 <20101110184105.GH22410@elte.hu>
 <1289415645.12418.180.camel@gandalf.stny.rr.com>
 <20101110191127.GA6190@nowhere>
 <20101110202316.GA32396@Krystal>
 <987664A83D2D224EAE907B061CE93D5301649A71DC@orsmsx505.amr.corp.intel.com>
 <20101110225115.GB9299@Krystal>
 <alpine.LFD.2.00.1011110004520.2900@localhost6.localdomain6>
 <1289431227.12418.211.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289431227.12418.211.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 06:20:27PM -0500, Steven Rostedt wrote:
> On Thu, 2010-11-11 at 00:12 +0100, Thomas Gleixner wrote:
> 
> > Cramming both into the same session is just insane.
> 
> That just doubled the overhead of the tracer.

At least when I've used ftrace for the "flight recorder" use case, I'm
not tracing as well.  What I do is enable a bunch of trace points,
maybe I've sprinkled in some "trace_printk()'s" into various kernel
code paths, and then I run the workload which locks up the kernel.
When locks up, I've used sysrq-z to dump out the ftrace ring buffer,
and usually _exactly_ what I need to debug the lock up is waiting for
me in the ring buffer.

So, this use case, is incredibly useful, and I hope whatever folks do
with the new-fangled API, that somehow "overwrite mode" is supported.
Even if for speed reasons, what you do is wait until for the head to
overrun the tail, that the tail gets bumped up by 50% and we lose half
the log (so that whatever expensive locking is necessary only happens
once in a while), I at least would find that quite acceptable.

The other feature/requirements request I would make is that there
should be a way that common kernel abstractions, such as converting a
dev_t to either a MAJOR/MINOR number pair, or to a device name, be
made available.  For now I've changed the tracepoints to translate
MAJOR/MINOR and drop integers into the ring buffer, and a generic
workaround in the future is to always drop strings into the ring
buffer instead of allowing the translation to be done in TP_printk
(which doesn't work for perf; it causes the userspace perf client to
fall over and die, without even skipping the problematic tracepoint
record --- boo, hiss).  But that can be relatively inefficient,
because we're now having to drop potentially fairly large text strings
into ring buffer, because of limitations that perf has in its output
transformations step.

I know that because perf is doing its output transformation in
userspace, there are fundamental limitations about what it can do.
But it would be nice if it could be expanded at least _somewhat_, and
either way, there needs to be some clear documentation about what it
can and can not accept.  And if these limitations means that I should
just simply continue using ftrace, and not use perf, it would be nice
if the tracepoints I create that work with ftrace don't cause perf to
just die horribly when it tries to parse them.

						- Ted
