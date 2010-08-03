Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab0HCUy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:54:28 -0400
Received: from mail.openrapids.net ([64.15.138.104]:57772 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756403Ab0HCUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:54:26 -0400
Date: Tue, 3 Aug 2010 16:54:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100803205423.GA687@Krystal>
References: <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <20100803194553.GA27688@Krystal> <AANLkTinW34tSZ0gLyRb4mjh1UX4w=34pNcjU=fY+y_oT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinW34tSZ0gLyRb4mjh1UX4w=34pNcjU=fY+y_oT@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:49:03 up 192 days, 23:25,  6 users,  load average: 0.31, 0.13,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Tue, Aug 3, 2010 at 12:45 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > The real issue here, IMHO, is that Perf has tied gory ring buffer implementation
> > details to the userspace perf ABI, and there is now strong unwillingness from
> > Perf developers to break this ABI.
> 
> The thing is - I think my outlined buffer fragmentation model would
> work fine with the perf ABI too.  Exactly because there is no deep
> structure, just the same "stream of small events" both from a kernel
> and a user model standpoint. Sure, the stream would now contain a new
> event type, but that's trivial. It would still be _entirely_
> reasonable to have the actual data in the exact same ring buffer,
> including the whole mmap'ed area.

Yes, indeed. Your scheme (using a "cookie" to identify multiple related events,
each of them being the "continuation" of the previous event with the same
cookie) would work on top of basically all ring buffers implementations. We
already use something similar to follow socket buffers and block device buffers
across the kernel in LTTng.

> 
> Of course, when user space actually parses it, user space would have
> to eventually defragment the event by allocating a new area and
> copying the fragments together in the right order, but that's pretty
> trivial to do. It certainly doesn't affect the current mmap'ed
> interface in the least.
> 
> Now, whether the perf people feel they want that kind of
> functionality, I don't know. It's possible that they simply do not
> want to handle events that are complex enough that they would have
> arbitrary size.

I agree. Although I think the scheme you propose can sit on top of the ring
buffer and does not necessarily need to be at the bottom layer. The sub-buffer
disagreement Peter and I have is related to the ring buffer core.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
