Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1DILJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 07:09:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab1DILI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 07:08:59 -0400
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1302282130.21026.45.camel@frodo>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
	 <20110407013349.GH1867@nowhere>
	 <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
	 <20110407120608.GB1798@nowhere>
	 <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
	 <20110407213208.GE1798@nowhere>
	 <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
	 <20110408002812.GG1798@nowhere>  <1302248268.21026.18.camel@frodo>
	 <1302271670.9086.154.camel@twins>  <1302282130.21026.45.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 09 Apr 2011 13:08:35 +0200
Message-ID: <1302347315.9086.1246.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 13:02 -0400, Steven Rostedt wrote:
> On Fri, 2011-04-08 at 16:07 +0200, Peter Zijlstra wrote:
> 
> > > As you said perf has a lot of overhead due to data that it saves per
> > > event. 
> > 
> > Someday you should actually read the perf code before you say something.
> 
> I have looked at the code although not as much recently, but I do plan
> on looking at it again in much more detail. But you are correct that I
> did not make this comment on the code itself, but on looking at the
> data:

> 1051776/8766 = 119

> 2957312/38268 = 77
> 
> As you stated, I need to look more into the perf code (which I plan on
> doing), but it seems that perf adds 42 bytes more per event. Perhaps
> this is something we can fix. 

Aside from the 8 byte header everything else is configurable with
PERF_SAMPLE_flags and probably has some overlap with stuff we also have
in the tracepoint data we then get through PERF_SAMPLE_RAW

> I'd love to make both perf and ftrace be
> able to limit its header. There's no reason to record the pid for every
> event if we don't need to. As well as the preempt count and interrupt
> status. But these are legacy from the latency tracer code from -rt.

Right.

> I think there's a lot of work that we can do make tracing in perf more
> compatible with the tracing features of ftrace. I did say the ugly word
> "roadmap" but perhaps it's just direction that we need. I feel we are
> all a bunch of cooks with their own taste, and we don't all like the
> spices used by each other.

Partly yeah, but there's also real functional differences, the last time
I profiled perf with perf (yay for recursion) we spend a lot of time in
conditionals. Due to the fact that perf is mainly sampling based (and
tracing being samples with period==1) and all that output
configurability there's a true forest of if statements to pass through
and I'm fairly sure we totally trash the branch predictor on that.


