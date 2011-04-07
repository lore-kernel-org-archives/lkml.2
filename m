Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1DGWmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:42:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2464 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab1DGWmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AoHwGoHOeepC53mLK5Hg+SASc9zad+/MJGXf4Cm78oBnuZr27E4K2rgzDzxzVYFpOP
         cpqFInciLaiIzEebiQng==
MIME-Version: 1.0
In-Reply-To: <20110407213208.GE1798@nowhere>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
 <20110407013349.GH1867@nowhere> <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
 <20110407120608.GB1798@nowhere> <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
 <20110407213208.GE1798@nowhere>
From: David Sharp <dhsharp@google.com>
Date: Thu, 7 Apr 2011 15:42:08 -0700
Message-ID: <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 2:32 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Apr 07, 2011 at 01:22:30PM -0700, David Sharp wrote:
>> On Thu, Apr 7, 2011 at 5:06 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> Perf doesn't have the same latency characteristics as ftrace. It costs
>> a full microsecond for every trace event.
>>
>> https://lkml.org/lkml/2010/10/28/261
>>
>> It's possible these results need to be updated. Has any effort been
>> made to improve the tracing latency of perf?
>
> Nothing significant since then, I believe. But the hotspots are known
> and some are relatively low hanging fruits if you want to get closer to
> ftrace throughput:
>
> * When an event triggers, we do a double copy. A first one in a temporary
> buffer and a second one from the temporary buffer to the event'ss one.
> This is because we don't have the same discard feature than in ftrace
> buffer. We need to first filter on the temporary buffer and give up if the filter
> matched instead of copying to the main buffer.
>
> As a short term solution: have a fast path tracing for the case where we
> don't have a filter: directly copy to the main buffer.
>
> In the longer term I think we want to filter on tracepoint parameters
> rather than in the ending trace.
>
> * We save more things in perf, because we have the perf headers. So we
> save the pid twice: once in trace event headers, second in perf headers.
> We need to drop the one from the trace event.
> Also in the case of pure tracing, we don't need to save the ip in the perf
> headers.
>
> * We have lots of conditionals in the fast path, due to some exclusion options,
> overflow count tracking, etc... We probably want a fastpath tracing function
> for the high volume tracing case, something that goes quickly to the buffer
> saving.
>
> And there are things common to ftrace and perf that we probably want to have:
> like tracking of pids using sched switch event if one is running, instead
> of saving the pid on each traces. And get rid of the preempt_count in the
> trace event headers, at least have the possibility to choose whether we want
> it.
>
>
> Any help in any of these tasks would be very welcome.
>

This is all very interesting, but doesn't really help us. I'd prefer
to focus on the proposal itself than discuss the merits of perf and
ftrace. We're using ftrace for the foreseeable future, and afaik, it's
still a maintained part of the kernel. If perf improves its
performance for tracing, then we can consider switching to it. We
could invest time improving perf, and that might be worthwhile, but
ftrace is here now.

So with that in mind, are there any suggestions regarding cgroup
functionality in ftrace?
