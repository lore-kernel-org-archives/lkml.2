Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1DGVcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:32:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55641 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1DGVcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:32:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hMLoR2EM3C7bznLjG0pX3ghL+a+OFDDdw3YI6SVKP2GwEjWtxooMXjstBrjRdQ3wv4
         9OmxirpEg725etPns6px4HrYPkRR/cEkBux4588mYgWREDFqfJ9ihMrMzNl+MmixkZIf
         n5FP9rqn9jjjqPEy+a6x1etbE96COBW55FELc=
Date: Thu, 7 Apr 2011 23:32:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
Message-ID: <20110407213208.GE1798@nowhere>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
 <20110407013349.GH1867@nowhere>
 <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
 <20110407120608.GB1798@nowhere>
 <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 01:22:30PM -0700, David Sharp wrote:
> On Thu, Apr 7, 2011 at 5:06 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Perf doesn't have the same latency characteristics as ftrace. It costs
> a full microsecond for every trace event.
> 
> https://lkml.org/lkml/2010/10/28/261
> 
> It's possible these results need to be updated. Has any effort been
> made to improve the tracing latency of perf?

Nothing significant since then, I believe. But the hotspots are known
and some are relatively low hanging fruits if you want to get closer to
ftrace throughput:

* When an event triggers, we do a double copy. A first one in a temporary
buffer and a second one from the temporary buffer to the event'ss one.
This is because we don't have the same discard feature than in ftrace
buffer. We need to first filter on the temporary buffer and give up if the filter
matched instead of copying to the main buffer.

As a short term solution: have a fast path tracing for the case where we
don't have a filter: directly copy to the main buffer.

In the longer term I think we want to filter on tracepoint parameters
rather than in the ending trace.

* We save more things in perf, because we have the perf headers. So we
save the pid twice: once in trace event headers, second in perf headers.
We need to drop the one from the trace event.
Also in the case of pure tracing, we don't need to save the ip in the perf
headers.

* We have lots of conditionals in the fast path, due to some exclusion options,
overflow count tracking, etc... We probably want a fastpath tracing function
for the high volume tracing case, something that goes quickly to the buffer
saving.

And there are things common to ftrace and perf that we probably want to have:
like tracking of pids using sched switch event if one is running, instead
of saving the pid on each traces. And get rid of the preempt_count in the
trace event headers, at least have the possibility to choose whether we want
it.


Any help in any of these tasks would be very welcome.
