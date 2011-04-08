Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1DHA22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 20:28:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42609 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab1DHA21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=isEGgfudy+4LWeBuVzadKGogqntTM3Qn79eCdQZyMba/2DHcNPe7gQqOcNYzgMUiMN
         H1au19wDTAIzTpHwIep+7BjWWi9+uqDPONbDkK9qocOmUWdNgSGQuK56XB2ER4zBI95V
         l+MTNJ2RLrtdZUY1XsIA3gO83gyEqHh/28s8M=
Date: Fri, 8 Apr 2011 02:28:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
Message-ID: <20110408002812.GG1798@nowhere>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
 <20110407013349.GH1867@nowhere>
 <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
 <20110407120608.GB1798@nowhere>
 <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
 <20110407213208.GE1798@nowhere>
 <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 03:42:08PM -0700, David Sharp wrote:
> On Thu, Apr 7, 2011 at 2:32 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Nothing significant since then, I believe. But the hotspots are known
> > and some are relatively low hanging fruits if you want to get closer to
> > ftrace throughput:
> >
> > * When an event triggers, we do a double copy. A first one in a temporary
> > buffer and a second one from the temporary buffer to the event'ss one.
> > This is because we don't have the same discard feature than in ftrace
> > buffer. We need to first filter on the temporary buffer and give up if the filter
> > matched instead of copying to the main buffer.
> >
> > As a short term solution: have a fast path tracing for the case where we
> > don't have a filter: directly copy to the main buffer.
> >
> > In the longer term I think we want to filter on tracepoint parameters
> > rather than in the ending trace.
> >
> > * We save more things in perf, because we have the perf headers. So we
> > save the pid twice: once in trace event headers, second in perf headers.
> > We need to drop the one from the trace event.
> > Also in the case of pure tracing, we don't need to save the ip in the perf
> > headers.
> >
> > * We have lots of conditionals in the fast path, due to some exclusion options,
> > overflow count tracking, etc... We probably want a fastpath tracing function
> > for the high volume tracing case, something that goes quickly to the buffer
> > saving.
> >
> > And there are things common to ftrace and perf that we probably want to have:
> > like tracking of pids using sched switch event if one is running, instead
> > of saving the pid on each traces. And get rid of the preempt_count in the
> > trace event headers, at least have the possibility to choose whether we want
> > it.
> >
> >
> > Any help in any of these tasks would be very welcome.
> >
> 
> This is all very interesting, but doesn't really help us. I'd prefer
> to focus on the proposal itself than discuss the merits of perf and
> ftrace. We're using ftrace for the foreseeable future, and afaik, it's
> still a maintained part of the kernel. If perf improves its
> performance for tracing, then we can consider switching to it. We
> could invest time improving perf, and that might be worthwhile, but
> ftrace is here now.

You are investing upstream for your tracing needs. And that's really
a nice step that I appreciate, as IIRC, Google had its own internal tracing
(ktrace?) before. Nonetheless you can't be such a significant
user/developer of the upstream kernel tracing and at the same time ignore some
key problems of the actual big picture of it.

You need to be aware that we are not going anywhere if we duplicate
every features between perf and ftrace. We want to merge the common
pieces, keep the best of them and not expand the two tier tracing of today.

I wish people stop thinking about perf and ftrace as
competitors. Probably developers could start having a sane view
once both will have close performances and then we can start
thinking about a common backend (a buffer abstraction, which development
can be iterated incrementally, usable with a syscall) and eliminate the
overlapping pieces.

I'm not asking you to unify the kernel tracing all alone. But you need to
start to enlarge your view.

I tend to think perf is more suitable for finegrained context definition
in general.
