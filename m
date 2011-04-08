Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab1DHVmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:42:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1DHVmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BYw/R8kTtCU0cIBdjsb+MdtSGu8T8Kb43tZtlJSMESJITAF8jOvkYFF3cHzp5zHHAi
         vGxjN/qq6SC9/GLMxevA==
MIME-Version: 1.0
In-Reply-To: <20110408203827.GA26667@nowhere>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
 <20110407013349.GH1867@nowhere> <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
 <20110407120608.GB1798@nowhere> <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
 <20110407213208.GE1798@nowhere> <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
 <20110408002812.GG1798@nowhere> <1302248268.21026.18.camel@frodo>
 <20110408190052.GC1967@nowhere> <20110408203827.GA26667@nowhere>
From: David Sharp <dhsharp@google.com>
Date: Fri, 8 Apr 2011 14:41:43 -0700
Message-ID: <BANLkTikg+RE5YqxmnYY5-L6tZ=aMY+6HSw@mail.gmail.com>
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 1:38 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, Apr 08, 2011 at 09:00:56PM +0200, Frederic Weisbecker wrote:
>> On Fri, Apr 08, 2011 at 03:37:48AM -0400, Steven Rostedt wrote:
>> > I actually agree, as perf is more focused on per process (or group) than
>> > ftrace. But that said, I guess the issue is also, if they have a simple
>> > solution that is not invasive and suits their needs, what's the harm in
>> > accepting it?
>>
>> What about a kind of cgroup_of(path) operator that we can use on
>> filters?
>>
>>       common_pid cgroup_of(path)
>> or
>>       common_pid __cgroup_of__ path
>>
>> That way you don't bloat the tracing fast path?
>
> Note in this example, we would simply ignore the common_pid
> value and assume that pid is the one of current. This economizes
> a step to pid -> task resolution.
>

This is a decent idea, but I'm worried about the complexity of using
filters like this. Filters are written to *every* event that you want
the filter to apply to (if you set the top-level filter, it just
copies the filter to all applicable events), and this is a filter you
would mostly only want to apply to *all* events at once. Furthermore,
filters work by discarding the event *after* the event has already
been written, so all tasks will be incurring full tracing overhead.
With cgroup filtering up front, we can avoid ~90% [0] of the overhead
for untraced cgroups.

I'm also thinking that cgroups could be a way to expose tracing to
non-root users. Making it a filter doesn't work for that.


Hmm.. Maybe ftrace needs a "global filters" feature. cgroup and pid
would be prime candidates for this, perhaps there are others. These
would be an optional list of filters applied *before* writing the
event or reserving buffer space, so they could not use the event
fields. Mostly I'm thinking they would use things accessible from the
current task_struct.


If we could work all that out, then I would change a couple things:
one of my grand plans for tracing is to remove pid from every event,
and replace it with a tiny "pid_changed" event (unless "sched_switch"
et al is enabled). So I wouldn't want to attach it to common_pid at
all. Instead, I would make it a unary operator.

It also doesn't work with multiple hieranchies. When you refer to a
cgroup path of "/apps/container_3", are we talking about the cgroup
for cpu, or mem, or blkio, or all, or a subset? This is what the
"tracing_enabled" files in the cgroup filesystem in Vaibhav's proposal
were for. Maybe this could be an optional argument to the unary
operator.

So, the operator becomes:
cgroup_of(/path)  means any subsystem,
cgroup_of(/path, cpu, mem) means cpu or mem.

d#

[0] This figure is made up. Like most statistics. ;)
