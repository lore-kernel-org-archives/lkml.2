Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1AQTf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:35:29 -0500
Received: from mail.openrapids.net ([64.15.138.104]:46230 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751781Ab1AQTf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:35:28 -0500
Date: Mon, 17 Jan 2011 14:35:25 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110117193525.GD16154@Krystal>
References: <4D3074FE.3030707@oldelvet.org.uk> <20110115.211722.39173519.davem@davemloft.net> <1295187469.22527.13.camel@duncow> <20110116.113944.48514452.davem@davemloft.net> <1295273486.16479.15.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295273486.16479.15.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:28:48 up 54 days, 23:31,  6 users,  load average: 0.06, 0.09,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> [ Added Mathieu on Cc, since he likes alignments ;-) ]

Oh yes, alignments are so much fun! (for some definitions of fun) ;)

> 
> On Sun, 2011-01-16 at 11:39 -0800, David Miller wrote:
> > From: Richard Mortimer <richm@oldelvet.org.uk>
> > Date: Sun, 16 Jan 2011 14:17:49 +0000
> > 
> > > I'm wondering if gcc is just getting better at honouring the source
> > > code. The DEFINE_EVENT macros in include/trace/ftrace.h have a
> > > __aligned__(4) attribute in them. Maybe that should be 8 on sparc64
> > > systems.
> > > The aligned 4 seems to be unchanged since include/trace/ftrace.h was
> > > created in f42c85e74faa422cf0bc747ed808681145448f88 in April 2009.
> > 
> > That needs to be at least "8" on 64-bit systems.  Why is this aligned
> > directive there at all?
> 
> IIRC, the problem showed up in 64-bit systems. OK, x86-64 (but of
> course ;-).
> 
> The problem comes when the linker puts these sections together. We read
> all the sections as one big array. If the linker puts in holes, then
> this breaks the array, and the kernel crashes while reading the section.
> 
> I guess one solution is to remove the alignment at the allocation and
> place it at the structure. This will mean all accesses to this structure
> will need to be on an alignment.

The problem with these alignments is that they are just a hint to gcc, telling
it what the minimum alignment of a type should be. gcc is free to align on a
larger boundary if it wants to.

But the following test program is very instructive:

#include <stdio.h>

struct test {
        void *a;
        void *b;
        void *c;
        void *d;
        void *e;
        void *f;
        void *g;
        void *h;
        void *i;
        void *j;
        void *k;
        void *l;
        void *m;
        void *n;
        void *o;
        void *p;
        void *q;
};

int main()
{
        struct test __attribute__((aligned(4))) v;
        printf("%d\n", __alignof__(v));
        return 0;
}

(on x86_64, with gcc 4.5.1 and gcc 4.4.4)

if we put the "__attribute__((aligned(4)))" at the v definition (variable
attribute), the program returns an alignment of 4. If we move it after struct
test declaration (type attribute), the program returns an alignment of 8 (thus
taking the max between the attribute alignment and the largest field).

But that's a real problem, because in include/trace/ftrace.h, we have an
alignment of 4 forced on the definition, but there is a mismatch with
trace_events.c:

extern struct ftrace_event_call __start_ftrace_events[];
extern struct ftrace_event_call __stop_ftrace_events[];

for which the alignment attribute is missing (so an alignment of 8 will be
used there).

So it all worked as long as the size of struct ftrace_event_call was a multiple
of 8 bytes (struct ftrace_event_call constains 2 integers if we exclude the perf
fields), but the new fields added by perf contain a supplementary 4-byte
integer, which seems to be causing the breakage: the structures are appended one
next to another when defined, but the iteration on these structures thinks they
are 8-byte aligned.

Steven, what were you trying to fix in the first place when you added the
aligned(4) to the definition ? It might have just been that the _ftrace_events
section needed to be aligned on at least 8 bytes in the linker scripts, but was
only aligned on 4-bytes. Forcing the definition alignment down to 4 possibly
fixed the problem you experienced on x86_64, but seems to be causing other
problems.

I would recommend to:

- Keep the linker script _ftrace_events alignment as it is now (aligned on 32
  bytes).
- Remove the aligned(4) attributes from all struct ftrace_event_call
  definitions.

And see how this works. The only problem that might come up is if gcc decides to
align struct ftrace_event_call (which is about 136 bytes in size) on an
alignment larger than 32 bytes, which would be really surprising.

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
