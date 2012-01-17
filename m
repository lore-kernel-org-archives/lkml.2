Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2AQOhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:37:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43179 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab2AQOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:37:52 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=KHR86nk1PkcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Euhhyv0r5AZiZoB-3pcA:9 a=eh2XkXn2RNeatvm_6l0A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=KjaEQMvDZaXeJHUU:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326811069.17534.46.camel@gandalf.stny.rr.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 17 Jan 2012 09:37:49 -0500
In-Reply-To: <20120117124023.GA13969@elte.hu>
References: <20120110174509.GA30802@redhat.com>
	 <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com>
	 <20120116074540.GE15641@elte.hu>
	 <1326717070.7642.144.camel@gandalf.stny.rr.com>
	 <20120116125329.GB31667@elte.hu>
	 <1326729123.7642.146.camel@gandalf.stny.rr.com>
	 <20120117100222.GH10397@elte.hu>
	 <1326801811.7642.188.camel@gandalf.stny.rr.com>
	 <20120117124023.GA13969@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 13:40 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> Any tool that requests the signal trace event, and copies the 
> full (and now larger) record it got in the ring-buffer, without 
> expanding the target record's size accordingly will *BREAK*. 

I'm curious to where it gets the size?

This is not like the kernel writing to a pointer in userspace memory,
where it can indeed break code by writing too much. This is the
userspace program writing from a shared memory location.


> 
> I do not claim that tools will break in practice - i'm raising 
> the *possibility* out of caution and i'm frustrated that you 
> *STILL* don't understand how ABIs are maintained in Linux. 

You are defending code that would do:

	size = read_size(ring_buffer_event);
	memcpy(data, buffer, size);

over code that would most likely do:

	memcpy(data, buffer, sizeof(*data));

???

According to this logic, we should never increase the size
of /proc/stat, because someone might do:

	i = 0;
	fd = open("/proc/stat", O_RDONLY);
	do {
		r = read(fd, buff+i, BUFSIZ);
		i += r;
	} while (r > 0);



> 
> You arguing about defined semantics is *MEANINGLESS*. What 
> matters is what the apps do in practice.

Exactly, to depend on the ring buffer size to do all copies to fixed
size data structures seems to be backwards to what would be done in
practice.


>  If the apps we know 
> about do it robustly and adapt (or don't care) about the 
> expansion, and if no-one reports a regression in tools we don't 
> know about, then it's probably fine.

It's not about robustness, it's about the easy way to copy.

	memcpy(data, buffer, sizeof(*data));

wont break.


> But your argument that expansion is somehow part of the ABI is 
> patently false and misses the point. Seeing your arguments make 
> me *very* nervous about applying any ABI affecting patch from 
> you.

Well you already think I'm stupid, I wont change the ABI anymore.
Obviously I know nothing, because I created a flexible interface that's
not used by anything except perf and trace-cmd, but because there's no
library, we are stuck with fixed tracepoints, which will come to haunt
us in the not so distant future.

This will bloat the kernel. Tracepoints are not free. They bloat the
kernel's text section. Every tracepoint still adds a bit of code in the
"unlikely" part inlined where they are called. So they do have an affect
on icache, as well as the code to process the tracepoint (around 5k per
tracepoint).

People are adding tracepoints all over the kernel without much thought.
We take much more care when we add a system call. By making tracepoints
have as strict a ABI as system calls will cause a maintenance nightmare
in the future. I guarantee that!


           compiled in my box       in include/trace/events  in rest of kernel
In v3.0:         250                        259                  330
In v3.1:         311                        349                  338
in v3.2:         335                        393                  351
latest Linus:    340                        401                  345

(Interesting that tracepoints have disappeared outside the events
directory)

Note, these do not include the syscall tracepoints.

There's already more tracepoints (compiled for my box) than syscalls.

Tracepoints are being added like the US deficit. We need to set some
rules somewhere. Either by making a library that can handle small
changes (like the one we are discussing, even though a memcpy should
cope), or we need to put a kabosh to adding new tracepoints like they
are the new fad app. Perhaps we should put the same requirements on new
tracepoints as we do with new syscalls.

-- Steve


