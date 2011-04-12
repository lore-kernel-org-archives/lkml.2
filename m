Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1DLViO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:38:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43696 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab1DLViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=OuKJCeixDKeyc/NVgU8ZiA47amedjaL23h854RWvw+ncWBuSXTIxTJf/1VuotyTFWn
         O83cYzN9mWHE0VaYSmF1gB9VDVeuRX7JzKO68z7A1/hYjH0567KoGnA8C3tEoyfoifgI
         bHQmQCiaCph5+WG20WBBf4YgMttnltiF0GNYc=
Date: Tue, 12 Apr 2011 23:38:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
Message-ID: <20110412213802.GA3016@nowhere>
References: <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
 <20110407120608.GB1798@nowhere>
 <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
 <20110407213208.GE1798@nowhere>
 <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
 <20110408002812.GG1798@nowhere>
 <1302248268.21026.18.camel@frodo>
 <20110408190052.GC1967@nowhere>
 <20110408203827.GA26667@nowhere>
 <BANLkTikg+RE5YqxmnYY5-L6tZ=aMY+6HSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikg+RE5YqxmnYY5-L6tZ=aMY+6HSw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 02:41:43PM -0700, David Sharp wrote:
> On Fri, Apr 8, 2011 at 1:38 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Fri, Apr 08, 2011 at 09:00:56PM +0200, Frederic Weisbecker wrote:
> >> On Fri, Apr 08, 2011 at 03:37:48AM -0400, Steven Rostedt wrote:
> >> > I actually agree, as perf is more focused on per process (or group) than
> >> > ftrace. But that said, I guess the issue is also, if they have a simple
> >> > solution that is not invasive and suits their needs, what's the harm in
> >> > accepting it?
> >>
> >> What about a kind of cgroup_of(path) operator that we can use on
> >> filters?
> >>
> >>       common_pid cgroup_of(path)
> >> or
> >>       common_pid __cgroup_of__ path
> >>
> >> That way you don't bloat the tracing fast path?
> >
> > Note in this example, we would simply ignore the common_pid
> > value and assume that pid is the one of current. This economizes
> > a step to pid -> task resolution.
> >
> 
> This is a decent idea, but I'm worried about the complexity of using
> filters like this. Filters are written to *every* event that you want
> the filter to apply to (if you set the top-level filter, it just
> copies the filter to all applicable events), and this is a filter you
> would mostly only want to apply to *all* events at once.

Hmm, but this complexity doesn't happen at tracing time. It happens before
and once. So I'm not sure there is a real harm there. Besides the whole
infrastructure for that is already in place.

You only need a global effect because your worklow only involves that.
But someone else may come with some more complicated usecase.


> Furthermore,
> filters work by discarding the event *after* the event has already
> been written, so all tasks will be incurring full tracing overhead.
> With cgroup filtering up front, we can avoid ~90% [0] of the overhead
> for untraced cgroups.

In fact we desire pre-record time filtering for every filters, or most
of them.

No strong idea about how we can fix that though. Perhaps we can start
by dividing filtering in two parts: a pre and post tracing.

> I'm also thinking that cgroups could be a way to expose tracing to
> non-root users. Making it a filter doesn't work for that.

Hmm, as an example, perf doesn't expose trace events to non-root users
because that can leak kernel internal informations to users,
although this permission can be tweaked through a sysfs file.
Ah we make an exception for syscall events, in the context of a process.
We may provide more exceptions in the future, like page faults.
Anyway we need to enable this non-root tracing mode case by case.

Look at TRACE_EVENT_FL_CAP_ANY. I don't know if we want ftrace
to support non-root users in the future, but if we do this
should be done on top of this flag.

> Hmm.. Maybe ftrace needs a "global filters" feature. cgroup and pid
> would be prime candidates for this, perhaps there are others. These
> would be an optional list of filters applied *before* writing the
> event or reserving buffer space, so they could not use the event
> fields. Mostly I'm thinking they would use things accessible from the
> current task_struct.

I still don't understand why such filter really need to be global. But
providing pre-record time filters and put inside any filters that
is built on a unary operator (cgroup_of "path" can be unary and refer
to current).

Except from supporting unary operators, the debugfs interface doesn't
need to change to support that. Only ftrace has to sort it out between
pre and post filtering, depending on the operator nature.

And may be in the future we can pull more filtering in pre-record time.

> If we could work all that out, then I would change a couple things:
> one of my grand plans for tracing is to remove pid from every event,
> and replace it with a tiny "pid_changed" event (unless "sched_switch"
> et al is enabled). So I wouldn't want to attach it to common_pid at
> all. Instead, I would make it a unary operator.

pid_changed is basically a sched switch event. But otherwise, agreed.

> It also doesn't work with multiple hieranchies. When you refer to a
> cgroup path of "/apps/container_3", are we talking about the cgroup
> for cpu, or mem, or blkio, or all, or a subset? This is what the
> "tracing_enabled" files in the cgroup filesystem in Vaibhav's proposal
> were for. Maybe this could be an optional argument to the unary
> operator.
> 
> So, the operator becomes:
> cgroup_of(/path)  means any subsystem,
> cgroup_of(/path, cpu, mem) means cpu or mem.

Yeah, why not.
