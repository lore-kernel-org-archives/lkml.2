Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1BCW0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:26:48 -0500
Received: from eru.sfritsch.de ([188.40.99.202]:57386 "EHLO eru.sfritsch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab1BCW0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:26:47 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Feb 2011 17:26:47 EST
From: Stefan Fritsch <sf@sfritsch.de>
To: Frederic Weisbecker <fweisbec@gmail.com>, Eric Paris <eparis@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Using ftrace/perf as a basis for generic seccomp
Date: Thu, 3 Feb 2011 23:06:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        agl@google.com, tzanussi@gmail.com, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1294867725.3237.230.camel@localhost.localdomain> <1296665124.3145.17.camel@localhost.localdomain> <20110203190643.GC1769@nowhere>
In-Reply-To: <20110203190643.GC1769@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102032306.34251.sf@sfritsch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 03 February 2011, Frederic Weisbecker wrote:
> I think you won't work with trace events, so you need to make the
> filtering code more tracing-agnostic.
> 
> But I think it's quite workable and shouldn't be too hard to split
> that into a filtering backend. Many parts are already pretty
> standalone.
> 
> Also I suspect the tracepoints are not what you need. Or may be
> they are. But as Masami said, the syscall tracepoint is called
> late. It's workable though. The other problem is that preemption
> is disabled when tracepoints are called, which is probably not
> what you want. One day I think we'll need to unify the tracepoints
> and notifier code but until then, better keep tracepoints for
> tracing.
> 
> Now once you have the filtering code more generic, you still
> need an arch backend to map register contents and layout into
> syscall arguments name and type. On top of which you can finally
> use the filtering code. For that you can use, again, some code we
> use for tracing, which are syscalls metadata: informations
> generated on build time that have syscalls fields and type.
> And that also needs to be split up, but it's more trivial
> than the filtering part.

AFAICS the infrastructure for tracing and metadata of compat syscalls 
is also still missing. That would need to be added, too. Jason Baron 
and Ian Munsie have worked on this in mid 2010, but I don't know about 
the current status.

Considering that all this is still quite a bit of work and that the 
initial suggestion by Adam Langley happened nearly two years ago, 
maybe a two step approach would be better:

Integrate a seccomp mode 2 now, which only supports a bitmask of 
bitmaps and no filtering.

Then, when the infrastructure for the filtering is finished, add a 
seccomp mode 3 with support for filtering.

This would give something in the very near future that is way more 
usable than seccomp mode 1. I think only the following adjustments 
would need to be made to Adam Langley's patch:

- only allow syscalls in the mode (non-compat/compat) that the prctl 
call was made in
- deny exec of setuid/setgid binaries
- deny exec of binaries with filesystem capabilities

What do you think of this proposal? I have a patch lying around 
somewhere that already does the first two of these.

BTW, given that the compat syscall layer tends to have security bugs, 
being able to disable compat syscalls per process would already have 
some value on its own. Is there a way to do this by disabling the int 
80 and compat sysenter()/syscall() vectors per process? In my patch I 
did a check in secure_computing(), which is of course less elegant.

> Note for now, filtering + syscalls metadata only works on top
> of raw arguments value. Syscalls metadata don't know much
> about type semantics and won't help you to dereference
> syscall argument pointers. Only raw syscall parameter values.
> Similarly, the filtering code can't evaluate pointer dereferencing
> expression evaluation, only direct values comprehension.

Pointer dereferencing at syscall entry must be avoided for seccomp 
anyway, or there would be race conditions. Of course if the filtering 
points could be put after the final copy_form_user, it would be ok.

Cheers,
Stefan
