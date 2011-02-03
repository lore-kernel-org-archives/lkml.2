Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1BCXLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:11:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54304 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1BCXK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:10:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vVhAyz4RoOzLQLWYqPEzPxcEfzoU6zCFU+C+7ljH1b0GdEgO+LxV1xtcAMuvquD098
         ZF6KkEurBqib/YMH/if09IwkQeldrlsWctQ4d9ydu1JIKDY0DwLFjMOYa5SKicaSidRq
         grEEYaZDH7OmHv6FarDveqDtrqPocLEE9wfZg=
Date: Fri, 4 Feb 2011 00:10:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stefan Fritsch <sf@sfritsch.de>
Cc: Eric Paris <eparis@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        agl@google.com, tzanussi@gmail.com, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Using ftrace/perf as a basis for generic seccomp
Message-ID: <20110203231051.GA1840@nowhere>
References: <1294867725.3237.230.camel@localhost.localdomain>
 <1296665124.3145.17.camel@localhost.localdomain>
 <20110203190643.GC1769@nowhere>
 <201102032306.34251.sf@sfritsch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102032306.34251.sf@sfritsch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:06:33PM +0100, Stefan Fritsch wrote:
> Hi,
> 
> On Thursday 03 February 2011, Frederic Weisbecker wrote:
> > I think you won't work with trace events, so you need to make the
> > filtering code more tracing-agnostic.
> > 
> > But I think it's quite workable and shouldn't be too hard to split
> > that into a filtering backend. Many parts are already pretty
> > standalone.
> > 
> > Also I suspect the tracepoints are not what you need. Or may be
> > they are. But as Masami said, the syscall tracepoint is called
> > late. It's workable though. The other problem is that preemption
> > is disabled when tracepoints are called, which is probably not
> > what you want. One day I think we'll need to unify the tracepoints
> > and notifier code but until then, better keep tracepoints for
> > tracing.
> > 
> > Now once you have the filtering code more generic, you still
> > need an arch backend to map register contents and layout into
> > syscall arguments name and type. On top of which you can finally
> > use the filtering code. For that you can use, again, some code we
> > use for tracing, which are syscalls metadata: informations
> > generated on build time that have syscalls fields and type.
> > And that also needs to be split up, but it's more trivial
> > than the filtering part.
> 
> AFAICS the infrastructure for tracing and metadata of compat syscalls 
> is also still missing. That would need to be added, too. Jason Baron 
> and Ian Munsie have worked on this in mid 2010, but I don't know about 
> the current status.

Oh we have these features for a while now. Jason and others have
made a great work on it.
For example you can accept only read() calls when fd = 7 with perf:

./perf record -a -e syscalls:sys_enter_read --filter "fd==7"
./perf script

	    perf-2956  [000]  6427.757791: sys_enter_read: fd: 0x00000007, buf: 0x7fdd2c095000, count: 0x00000400
            perf-2956  [000]  6427.757858: sys_enter_read: fd: 0x00000007, buf: 0x7fdd2c095000, count: 0x00000400
            perf-2956  [000]  6427.757877: sys_enter_read: fd: 0x00000007, buf: 0x7fdd2c095000, count: 0x00000400
            perf-2956  [000]  6427.757949: sys_enter_read: fd: 0x00000007, buf: 0x7fdd2c095000, count: 0x00000400
            perf-2956  [000]  6427.757968: sys_enter_read: fd: 0x00000007, buf: 0x7fdd2c095000, count: 0x00000400

Or you can do it with ftrace.

Now what Jason and Ian have worked on lately was rather about compat syscalls support and power pc
support amongst other things.
 
> Considering that all this is still quite a bit of work and that the 
> initial suggestion by Adam Langley happened nearly two years ago, 
> maybe a two step approach would be better:
> 
> Integrate a seccomp mode 2 now, which only supports a bitmask of 
> bitmaps and no filtering.
> 
> Then, when the infrastructure for the filtering is finished, add a 
> seccomp mode 3 with support for filtering.

Infrastructure for filtering will never be finished. IMO there will
always be many ways to make it better, simply because using such
conditional expressions offer tons of possibilities and is extendable
by nature.

Actually having seccomp as a user of filter expressions is a opportunity
to improve it and bring new ideas.

> This would give something in the very near future that is way more 
> usable than seccomp mode 1. I think only the following adjustments 
> would need to be made to Adam Langley's patch:
> 
> - only allow syscalls in the mode (non-compat/compat) that the prctl 
> call was made in
> - deny exec of setuid/setgid binaries
> - deny exec of binaries with filesystem capabilities
> 
> What do you think of this proposal? I have a patch lying around 
> somewhere that already does the first two of these.

IMHO this is an unnecessary intermediate state. It will actually make
things worse by bringing a new non-flexible ABI that we'll need to
maintain forever.

I'm no expert in security but I think it's not flexible.

> > of raw arguments value. Syscalls metadata don't know much
> > about type semantics and won't help you to dereference
> > syscall argument pointers. Only raw syscall parameter values.
> > Similarly, the filtering code can't evaluate pointer dereferencing
> > expression evaluation, only direct values comprehension.
> 
> Pointer dereferencing at syscall entry must be avoided for seccomp 
> anyway, or there would be race conditions. Of course if the filtering 
> points could be put after the final copy_form_user, it would be ok.

Makes sense yeah.
