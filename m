Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0JGUoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:44:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47378 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab0JGUoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:44:20 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=cD81UUMRb2IA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=39yDG2v0xOerdJ3yRUEA:9 a=yXSMe9C7URTrYNBFH-kUMXyBjnMA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH] poll(): add poll_wait_set_exclusive()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101007180737.GA4300@Krystal>
References: <20101006175635.GA21652@Krystal>
	 <AANLkTik3MWtEpi=mzf2-_x4_kdrwv-EOjeVHNzbmfian@mail.gmail.com>
	 <20101006190434.GA5783@Krystal>
	 <1286397096.6661.2.camel@gandalf.stny.rr.com>
	 <20101007170716.GB799@Krystal>
	 <1286473864.6661.16.camel@gandalf.stny.rr.com>
	 <20101007180737.GA4300@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 07 Oct 2010 16:44:15 -0400
Message-ID: <1286484255.6661.22.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 14:07 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > I never mention affinity. As with trace-cmd, it assigns a process per
> > CPU, but those processes can be on any CPU that the scheduler chooses. I
> > could probably do it with a single process reading all the CPU fds too.
> > I might add that as an option.
> 
> Your scheme works fine because you have only one stream (and thus one fd) per
> cpu. How would you map that with many streams per cpu ?
> 
> Also, you might want to consider using threads rather than processes, to save
> the unnecessary VM swaps.

I thought about threads and could go back to them. I'd have to benchmark
to see the performance hit.

> 
> > 
> > > 
> > > > Or do you have an fd per event per CPU, in which case the threads should just
> > > > poll off of their own fds.
> > > 
> > > I have one fd per per-cpu buffer, but there can be many per-cpu buffers, each
> > > transporting a group of events. Therefore, I don't want to associate one thread
> > > per event group, because this would be a resource waste.  Typically, only a few
> > > per-cpu buffers will be very active, and others will be very quiet.
> > 
> > Lets not talk about threads, what about fds? I'm wondering why you have
> > many threads on the same fd?
> 
> That's because I have fewer threads than file descriptors. So I can choose to
> either:
> 
> 1) somehow assign each thread to many fds statically or
> 2) make each thread wait for data on all fds
> 
> Option (2) adapts much better to workloads where a lots of data would come from
> many file descriptors from a single CPU: all threads can collaboratively work to
> extract the data.

OK, this is what I wanted to know. Now as Linus suggested, go and ask
other application developers (web server developers?) if this is
something that could be useful for them? If you get positive feedback,
have them Cc LKML and we can go from there.

Or, if you see that this type of programming is being done in Apache,
and if you can demonstrate that adding this features helps Apache (or
some other popular program), that would also be of benefit.

-- Steve


