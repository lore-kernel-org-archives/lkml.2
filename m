Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0JTPfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:35:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44615 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab0JTPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y/xoO5iWsuZEeeHsur+Nmb+qITbLT+OLr8+928KspZaaSIIbwgFDHxJ3bWW01nOZj5
         Ec/cyBPgaZZIwtGS/JgAg0dUEIapn/Ll4pZH4423ZSYpYKBi7ua6PZlwzQvPHeF4zhQR
         PxbFd69nLEP7dhiSFCHLqbpvHNMHv/ENsubW4=
Date: Wed, 20 Oct 2010 17:35:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: Dwarf cfi based user callchains
Message-ID: <20101020153500.GA5387@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com> <y0mmxqi6s88.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mmxqi6s88.fsf@fche.csb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 11:13:27AM -0400, Frank Ch. Eigler wrote:
> 
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > [...]
> > This brings dwarf cfi based callchain for userspace apps that don't have
> > frame pointers.
> 
> Interesting approach!
> 
> > [...]
> > - it's slow. A first improvement to make it faster is to support binary
> >   search from .eh_frame_hdr. 
> 
> In systemtap land, we did find a dramatic improvement from this too.


Yeah, linear walking on .eh_frame is not a good thing other than for
testing and debugging.


 
> Have you measured the cost of transcribing of potentially large chunks
> of the user stacks?  We did not seriously evaluate this path, since we
> encounter megabyte+ stacks in larger userspace apps, and copying THAT
> out seemed absurd.


Actually that's quite affordable. And you don't need to dump all the
stack of a process on every samples, that would indeed be absurd.
A small chunk, starting from the stack pointer, is enough.

What is interesting is that you can play with several different
sizes of dump, the higher it is and the deeper you'll be able to
unwind, that also means more profiling overhead.

I can't measure significant throughput issues with hackbench
for example:


Normal run:

	$ time ./hackbench 10
	Time: 3.415

	real	0m3.506s
	user	0m0.257s
	sys	0m6.519s


With perf record (default is cycles counter with 1000 HZ samples frequency):

	$ time ./perf record ./hackbench 10
	Time: 3.584
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.381 MB perf.data (~16654 samples) ]

	real	0m3.748s
	user	0m0.028s
	sys	0m0.022s


With perf record + frame pointer based callchain capture

	$ time ./perf record -g fp ./hackbench 10
	Time: 3.666
	[ perf record: Woken up 3 times to write data ]
	[ perf record: Captured and wrote 1.426 MB perf.data (~62281 samples) ]

	real	0m3.834s
	user	0m0.033s
	sys	0m0.046s

With perf record + 4096 bytes of stack dump in every sample


	$ time ./perf record -g dwarf,4096 ./hackbench 10
	Time: 3.697
	[ perf record: Woken up 15 times to write data ]
	[ perf record: Captured and wrote 5.156 MB perf.data (~225251 samples) ]

	real	0m3.931s
	user	0m0.026s
	sys	0m0.135s

With perf record + 20000 bytes of stack dump in every sample

	$ time ./perf record -g dwarf,20000 ./hackbench 10
	Time: 3.847
	[ perf record: Woken up 9 times to write data ]
	[ perf record: Captured and wrote 13.349 MB perf.data (~583219 samples) ]

	real	0m4.559s
	user	0m0.028s
	sys	0m0.329s


So there is no big differences. May be hackbench is not a good example
to highlight the possible impact though. And some tuning with higher
frequencies would make the difference more visible.

Perhaps the real impact is more on the amount to record, the data file
tends to grow quickly, obviously.

