Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0JGRvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:51:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43583 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab0JGRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:51:08 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=cD81UUMRb2IA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=EFT7cKsMyjZApBs6VeUA:9 a=bL25CUimhxtEMqpwdQIA:7 a=pyVheSDJHR62sVCfyBguyvhID1kA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <20101007170716.GB799@Krystal>
References: <20101006175635.GA21652@Krystal>
	 <AANLkTik3MWtEpi=mzf2-_x4_kdrwv-EOjeVHNzbmfian@mail.gmail.com>
	 <20101006190434.GA5783@Krystal>
	 <1286397096.6661.2.camel@gandalf.stny.rr.com>
	 <20101007170716.GB799@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 07 Oct 2010 13:51:04 -0400
Message-ID: <1286473864.6661.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 13:07 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Wed, 2010-10-06 at 15:04 -0400, Mathieu Desnoyers wrote:
> > 
> > > For reference, here is the use-case: The user-space daemon runs typically one
> > > thread per cpu, each with a handle on many file descriptors. Each thread waits
> > > for data to be available using poll(). In order to follow the poll semantic,
> > > when data becomes available on a file descriptor, the kernel wakes up all
> > > threads at once, but in my case only one of them will successfully consume the
> > > data (all other thread's splice or read will fail with -ENODATA). With many
> > > threads, these useless wakeups add an unwanted overhead and scalability
> > > limitation.
> > 
> > Mathieu, I'm curious to why you have multiple threads reading the same
> > fd. Since the threads are per cpu, does the fd handle all CPUs?
> 
> The fd is local to a single ring buffer (which is per-cpu, transporting a group
> of events). The threads consuming the file descriptors are approximately per
> cpu, modulo cpu hotplug events, user preferences, etc. I would prefer not to
> make that a strong 1-1 mapping (with affinity and all), because a typical
> tracing scenario is that a single CPU is heavily used by the OS (thus producing
> trace data), while other CPUs are idle, available to pull the data from the
> buffers. Therefore, I strongly prefer not to affine reader threads to their
> "local" buffers in the general case. That being said, it could be kept as an
> option, since it might make sense in some other use-cases, especially with tiny
> buffers, where it makes sense to keep locality of reference in the L2 cache.

I never mention affinity. As with trace-cmd, it assigns a process per
CPU, but those processes can be on any CPU that the scheduler chooses. I
could probably do it with a single process reading all the CPU fds too.
I might add that as an option.

> 
> > Or do you have an fd per event per CPU, in which case the threads should just
> > poll off of their own fds.
> 
> I have one fd per per-cpu buffer, but there can be many per-cpu buffers, each
> transporting a group of events. Therefore, I don't want to associate one thread
> per event group, because this would be a resource waste.  Typically, only a few
> per-cpu buffers will be very active, and others will be very quiet.

Lets not talk about threads, what about fds? I'm wondering why you have
many threads on the same fd?

-- Steve



