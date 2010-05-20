Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0ETLgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:36:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35754 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab0ETLgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:36:49 -0400
Date: Thu, 20 May 2010 13:36:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [RFD] Future tracing/instrumentation directions
Message-ID: <20100520113615.GA7224@elte.hu>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
 <20100520093131.GA30929@elte.hu>
 <20100520100732.GD5309@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520100732.GD5309@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, May 20, 2010 at 11:31:31AM +0200, Ingo Molnar wrote:
> >  - [ While it's still a long way off, if this trend continues
> >      we eventually might even be able to get rid of the 
> >      /debug/tracing/ temporary debug API and get rid of 
> >      the ugly in-kernel pretty-printing bits. This is 
> >      good: it may make Andrew very happy for a change ;-)
> > 
> >      The main detail here to be careful of is that lots of
> >      people are fond of the simplicity of the 
> >      /debug/tracing/ debug UI, so when we replace it we 
> >      want to do it by keeping that simple workflow (or 
> >      best by making it even simpler). I have a few ideas 
> >      how to do this.
> 
> How? We can emulate the /debug/tracing result with 
> something like perf trace, still that won't replace the 
> immediate availability of the result of any trace, which 
> makes it valuable for any simplest workflows.

Firstly, one thing is sure: until there's no full 
replacement we obviously dont want to phase out 
/sys/kernel/debug/tracing. This was more of a 'our future' 
email (as i see it), the process that will lead to solve 
some of our more strategic problems in tracing land.

Regarding the issues you raised, there are several 
solutions that dont need /sys/kernel/debug/tracing but 
still support the very useful and usable 'immediate 
tracing' workflow that ftrace prototyped. We can have a 
combination of several things:

 - Have a simple 'ftrace' command aliased to perf trace.

   Means less typing, and it also allows a much more 
   finegrained tracing workflow: per user and per task/job 
   workflows, instead of the global/exclusive tracing mode 
   that /sys/kernel/debug/tracing. There would be ready 
   equivalents:

     ftrace --available-tracers
     ftrace --current-tracer
     ftrace --start
     ftrace --stop

     ... etc ...

 - Immediate availability of a trace: persistent events
   combined with roundrobin ('flight-recorder') recording
   would solve this.

   If events are active then if type 'ftrace' you get the 
   current trace. Simple to scrip and simple to use - no 
   need to have access to /sys/kernel/debug/tracing, also 
   can evidently be turned into a per user facility, 
   supports multiple plugins active at once, etc.

 - For lightweight embedded tracing there are two separate
   solutions that would work:

    - we already have perf 'minimal builds' (when certain 
      libraries are not available), we could push that 
      concept some more to create a 'lightweight' command
      that embedded systems can run just fine.

    - extend our proxy recording and proxy execution/analysis
      concepts. We can already run a perf trace recording 
      through a pipe and netcat, and we have perf archive
      and cross-arch analysis code.

      If there's interest, then this could be made more 
      convenient and the functionality around this could 
      be collected into a handy proxy tool:

        ftrace --proxy smallbox --start
        ftrace --proxy smallbox --stop
        ftrace --proxy smallbox           # prints trace

        ... etc ...

      Thus the recording is done on the small box, while 
      all the analysis (and even all the commands) is 
      typed/executed on the bigger box.

So there are lots of possibilities - and there are other 
options as well.

Does this address your worries?

Thanks,

	Ingo
