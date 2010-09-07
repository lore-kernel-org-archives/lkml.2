Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab0IGQC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:02:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab0IGQC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:02:26 -0400
X-Authority-Analysis: v=1.1 cv=kSl6L8luU05z5mpL051isgeeLpAUfowbwuc/WIqEapw= c=1 sm=0 a=X7QPjtwe-8wA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=c9YeY8kDIQcXXN3QzrIA:9 a=YtbkV0ja4RBU0ZTBWo0A:7 a=DOyUdHPu07bu9F0ax3B22z-ZqEsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: disabling group leader perf_event
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C864281.2020907@redhat.com>
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop>
	 <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop>
	 <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu>
	 <4C84E265.1020402@redhat.com> <20100906125905.GA25414@elte.hu>
	 <4C850147.8010908@redhat.com>  <20100906154737.GA4332@elte.hu>
	 <1283866558.5133.73.camel@gandalf.stny.rr.com>
	 <4C864281.2020907@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Sep 2010 12:02:24 -0400
Message-ID: <1283875344.5133.123.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-07 at 16:47 +0300, Avi Kivity wrote:

> > Now here's some of my concerns for any of this. Using the kvm tracepoint
> > as an example:
> >
> > slot->base_gfn + ((hva - slot->userspace_addr)>>  PAGE_SHIFT)
> 
> We can't allow untrusted access to random kernel memory.
> 
> Let's take netfilter as an example.  Userspace downloads bytecode to 
> determine whether to allow a packet or not, or to mangle it.  The kernel 
> exposes APIs to read and write the packet, access the conntrack hash, 
> and whatever else is needed.  The bytecode reads the packet, allows, 
> denies or mangles to taste, and exits.
> 
> > If we were given "slot" and now we need to dereference it to get
> > base_gfn or userspace_addr, how would the kernel know this is a valid
> > address that can be read? Seems to me that this may allow userspace to
> > trivially see parts of the kernel that was never meant to be seen.
> 
> I don't understand this example.  Why would you need such bytecode?

I was just using this as if we were to use this bytecode for filtering
on parameters and we wanted to look at the same stuff that goes into the
buffers, but before we touch the buffer code.

> 
> For untrusted filters, you only allow access to tracepoint arguments.  
> For trusted filters, perhaps, you can allow arbitrary memory access at 
> the user's own risk.

I was thinking this too.

> 
> > One reason that ftrace only allows root access, is that the kernel is
> > best a black box for most userspace.  Letting userspace see how SELinux
> > is treating it, and finding addresses that SELinux is using, can give a
> > large arsenal to black hats that are writing tools to circumvent Linux
> > security.
> >
> > Unless we only let this interpreter access the inputs and its own
> > allocated memory, it will be very difficult to verify what the
> > interpreter is doing. I guess one thing we could do is to have a table
> > of places in the kernel that we let userspace see. This table will need
> > strict scrutinizing to verify that it can't be used to exploit other
> > parts of the kernel.
> 
> The way I see it, we expose a function pointer vector to the untrusted 
> code, similar to the syscall vector.  Trusted code may also see 
> functions to access kernel memory (or we just loosen up the validation 
> rules).

Ah, kind of what the tracepoints already do. Taking the same example:

        TP_fast_assign(
                __entry->hva            = hva;
                __entry->gfn            =
                  slot->base_gfn + ((hva - slot->userspace_addr) >> PAGE_SHIFT);
                __entry->referenced     = ref;
        ),

Have a function does the slot->base_gfn... work for us. It would also be
required that the only input is indeed the slot pointer, otherwise you
could dereference any tracepoint argument. So the arguments to the
tracepoint may get a list of helper functions that allow filtering on
dereferences to them.

This is getting a bit over-engineered IMO. If we want to do something
with the tracepoints, it should start out with simply taking the
arguments that are passed in, and then manipulating them and testing
them. Perhaps we allow a single page of heap to let the algorithms work
with.

Later, we could add functionality that could be triggered with a
condition. The first thing that comes to mind is a way to trigger the
start of tracing or stopping a trace.

-- Steve


