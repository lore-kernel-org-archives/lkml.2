Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1DHRCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:02:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52968 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1DHRCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:02:18 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=-Ykyf7MhCaYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=wFWsYFuaScaC5iI88-QA:9 a=jFKDIaiL4pqJq-0214IA:7 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1302271670.9086.154.camel@twins>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
	 <20110407013349.GH1867@nowhere>
	 <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
	 <20110407120608.GB1798@nowhere>
	 <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
	 <20110407213208.GE1798@nowhere>
	 <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
	 <20110408002812.GG1798@nowhere>  <1302248268.21026.18.camel@frodo>
	 <1302271670.9086.154.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 13:02:10 -0400
Message-ID: <1302282130.21026.45.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 16:07 +0200, Peter Zijlstra wrote:

> > As you said perf has a lot of overhead due to data that it saves per
> > event. 
> 
> Someday you should actually read the perf code before you say something.

I have looked at the code although not as much recently, but I do plan
on looking at it again in much more detail. But you are correct that I
did not make this comment on the code itself, but on looking at the
data:

I ran:

# perf record -a -e sched:sched_switch sleep 10
# mv perf.data perf.data.10
# perf record -a -e sched:sched_switch sleep 20
# mv perf.data perf.data.20
# ls -l perf.data.*
-rw-------. 1 root root 4480655 2011-04-08 12:36 perf.data.10
-rw-------. 1 root root 5532431 2011-04-08 12:37 perf.data.20
# perf script -i perf.data.10 | wc -l
9909
# perf script -i perf.data.20 | wc -l
18675

Then I did some deltas to figure out he size per event:

5532431-4480655 = 1051776
18675-9909 = 8766
1051776/8766 = 119

Which shows that the sched switch event takes up 119 bytes per event.

Then I looked at what ftrace does:

# trace-cmd record -e sched_switch -o trace.dat.10 sleep 10
# trace-cmd record -e sched_switch -o trace.dat.20 sleep 20
# trace-cmd report trace.dat.10 | wc -l
38856
# trace-cmd report trace.dat.20 | wc -l
77124
# ls -l trace.dat.*
-rw-r--r--. 1 root root 5832704 2011-04-08 12:41 trace.dat.10
-rw-r--r--. 1 root root 8790016 2011-04-08 12:41 trace.dat.20

8790016-5832704 = 2957312
77124-38856 = 38268
2957312/38268 = 77

As you stated, I need to look more into the perf code (which I plan on
doing), but it seems that perf adds 42 bytes more per event. Perhaps
this is something we can fix. I'd love to make both perf and ftrace be
able to limit its header. There's no reason to record the pid for every
event if we don't need to. As well as the preempt count and interrupt
status. But these are legacy from the latency tracer code from -rt.

I think there's a lot of work that we can do make tracing in perf more
compatible with the tracing features of ftrace. I did say the ugly word
"roadmap" but perhaps it's just direction that we need. I feel we are
all a bunch of cooks with their own taste, and we don't all like the
spices used by each other.

-- Steve


