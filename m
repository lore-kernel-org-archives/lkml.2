Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372Ab0HFNh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:37:57 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60864 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761333Ab0HFNhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:37:53 -0400
Date: Fri, 6 Aug 2010 09:37:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100806133749.GB29363@Krystal>
References: <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <20100803182556.GA13798@Krystal> <1280904410.1923.700.camel@laptop> <20100804144539.GA4617@Krystal> <1280933788.1923.1281.camel@laptop> <4C5BA937.5010504@hitachi.com> <1281088240.1947.357.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281088240.1947.357.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:10:53 up 195 days, 15:47,  5 users,  load average: 0.27, 0.13,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2010-08-06 at 15:18 +0900, Masami Hiramatsu wrote:
> > Peter Zijlstra wrote:
> > > On Wed, 2010-08-04 at 10:45 -0400, Mathieu Desnoyers wrote:
> > > 
> > >> How do you plan to read the data concurrently with the writer overwriting the
> > >> data while you are reading it without corruption ?
> > > 
> > > I don't consider reading while writing (in overwrite mode) a valid case.
> > > 
> > > If you want to use overwrite, stop the writer before reading it.
> > 
> > For example, would you like to read system audit log always after
> > stop the audit?
> > 
> > NO, that's a most important requirement for tracers, especially for
> > system admins (they're the most important users of Linux) to check
> > the system health and catch system troubles.
> > 
> > For performance measurement and checking hotspot, one-shot tracing
> > is enough. But it's just for developers. But for the real world
> > computing, Linux is just an OS, users want to run their system,
> > middleware and applications, without troubles. But when they hit
> > a trouble, they wanna shoot it ASAP.
> > The flight recorder mode is mainly for those users.
> 
> You cannot over-write and consistently read the buffer, that's plain
> impossible.

If you think it is impossible, then you should really go have a look at the
generic ring buffer library, at LTTng and at Ftrace. It looks like we're all
doing the "impossible".

>             With sub-buffers you can swivel a sub-buffer and
> consistently read that, but there is no guarantee the next sub-buffer
> you steal was indeed adjacent to the previous buffer you stole as that
> might have gotten over-written by the active writer while you were
> stealing the previous one.

We don't care about taking the next adjascent sub-buffer. We care about always
grabbing the oldest sub-buffer that has been written up to the currentmost
one.

> 
> If you want to snapshot buffers, do that, simply swivel the whole trace
> buffer, and continue tracing in a new one, then consume the old trace in
> a consistent manner.

So you need to allocate many trace buffers to accomplish the same and an extra
layer on top that does this buffer exchange, I don't call that "simple". Note
that only two trace buffers might not be enough if you have repeated failures in
a short time window; the consumer might take some time to extract all these.

Compared to that, the sub-buffer scheme only needs a single buffer with 2 (or
more) sub-buffers, plus an extra sub-buffer owned by the reader that we exchange
with the sub-buffer we want to grab for reading. The reader always grabs the
sub-buffer with the oldest data into it. The number of sub-buffers used is the
limit on the number of snapshots that can be taken in a relatively short time
window (the time it takes to the reader to consume the data).

> 
> I really see no value in being able to read unrelated bits and pieces of
> a buffer.

Within a sub-buffer, events are adjascent, and between sub-buffers, events are
guaranteed to be in order (oldest to newest event). It is only in the case where
buffers are relatively small compared to the data throughput that the writer can
overwrite information that would have been useful for a snapshot (e.g.
overwriting relatively recent information while the reader reads the oldest
sub-buffer), but in that case users simply have to tune they buffer size
appropriately to match the trace data throughput.

> 
> So no, I will _not_ support reading an over-write buffer while there is
> an active reader.

(I guess you mean active writer)

Here you argue that you don't need to support this feature at the ring buffer
level because you can have a group of ring buffers that does it instead.
How is your multiple-buffer scheme any simpler than sub-buffers ? Either you
have to allocate many of them up front, or, if you want to do it on-demand, you
have to perform memory allocation in NMI context. I don't see any of these two
solutions as particularly appealing.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
