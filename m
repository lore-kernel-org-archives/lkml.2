Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0EMRKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:10:21 -0400
Received: from mail.openrapids.net ([64.15.138.104]:38096 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754150Ab0EMRKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:10:18 -0400
Date: Thu, 13 May 2010 13:10:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
Subject: Re: Perf and ftrace [was Re: PyTimechart]
Message-ID: <20100513171015.GA13698@Krystal>
References: <20100512180438.GE15953@Krystal> <1273687712.1626.151.camel@laptop> <20100512183704.GD21432@Krystal> <1273690012.27703.38.camel@gandalf.stny.rr.com> <20100512202745.GK21432@Krystal> <1273702886.27703.58.camel@gandalf.stny.rr.com> <20100513132029.GA22799@Krystal> <1273765337.27703.1043.camel@gandalf.stny.rr.com> <20100513163150.GA13005@Krystal> <1273769178.27703.1119.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273769178.27703.1119.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:51:10 up 110 days, 19:28,  9 users,  load average: 0.29, 0.26,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-05-13 at 12:31 -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > On Thu, 2010-05-13 at 09:20 -0400, Mathieu Desnoyers wrote:
> > [...]
> > > > > > 
> > > > > > ...
> > > > > > 
> > > > > > 97 /**
> > > > > > 98  * ring_buffer_clear_noref_flag - Clear the noref subbuffer flag, for writer.
> > > > > > 99  */
> > > > > > 100 static __inline__
> > > > > > 101 void ring_buffer_clear_noref_flag(struct ring_buffer_backend *bufb,
> > > > > > 102                                   unsigned long idx)
> > > > > > 103 {
> > > > > > 104         struct ring_buffer_backend_page *sb_pages, *new_sb_pages;
> > > > > > 105
> > > > > > 106         sb_pages = bufb->buf_wsb[idx].pages;
> > > > > > 107         for (;;) {
> > > > > > 108                 if (!RCHAN_SB_IS_NOREF(sb_pages))
> > > > > > 109                         return; /* Already writing to this buffer */
> > > > > > 110                 new_sb_pages = sb_pages;
> > > > > > 111                 RCHAN_SB_CLEAR_NOREF(new_sb_pages);
> > > > > > 112                 new_sb_pages = cmpxchg(&bufb->buf_wsb[idx].pages,
> > > > > > 113                         sb_pages, new_sb_pages);
> > > > > > 114                 if (likely(new_sb_pages == sb_pages))
> > > > > > 115                         break;
> > > > > > 116                 sb_pages = new_sb_pages;
> > > > > 
> > > > > The writer calls this??
> > > > 
> > > > Yes. But the common case (for each event) is simply a
> > > > "if (!RCHAN_SB_IS_NOREF(sb_pages))" test that returns. The cmpxchg() is only
> > > > performed at subbuffer boundary.
> > > 
> > > Is the cmpxchg only contending with other writers?
> > 
> > No. Would have this been the case, I would have used a cmpxchg_local(). This
> > cmpxchg used to deal with subbuffer swap is touching the subbuffer "pages"
> > pointer, which can be updated concurrently by other writers as well as readers.
> > 
> > The writer clears the noref flags when starting to write in a subbuffers, and
> > sets it when delivering the subbuffer (when it is fully committed).
> > 
> > The reader can only ever swap the subbuffer with the one it owns if the noref
> > flag is set. The reader uses a cmpxchg() too to perform the swap.
> > 
> 
> So the writer can loop because of a reader? And theoretically, a
> aggressive reader that is constantly swapping pages can halt a writer?

Hehe, I'm glad you ask :) This has been one of my major concerns with this
algorithm.

Taken from my thesis:

8.6 Formal Verification of LTTng
8.6.3 Real-Time Impact

"The second synchronization added by the overwrite mode involves letting the
reader thread exchange individual sub-buffers with its own extra sub-buffer
before reading them. This exchange is performed with a CAS instruction which
verified if the use flag is set by the writer. If the sub-buffer is in use, the
reader will retry later.  On the writer side, a CAS instruction is used in a
busy-loop to set and clear the use flag (for portability, because an atomic
instruction to set a mask is not available for all architecture in the Linux
kernel). Given that the reader can only ever exchange a sub-buffer and cause the
writer to restart once (further accesses to that sub-buffers are impossible,
because the reader will block on the writer position), the reader thread cannot
starve the writer."

IOW, if the reader is trying to get subbuffers like crazy, it will maybe cause
one loop restart when taking the subbuffer the writer was about to write to, but
after that, the reader will be forced to exchange the next subbuffer, and so on
until it wraps-around and comes back to the subbuffer preceding the writer
position, as stop there. Note that during all this execution, the reader could
only cause a single retry of the writer. In summary, the frontend range
restrictions guarantee that the writer will retry at most once.

Note that we could also use an atomic "set bit/clear bit" for the writer, along
with write memory barriers, when available on the architecture, and that would
remove all need for loops. However, architectures that need to emulate set
bit/clear bit with a cmpxchg() would behave pretty much in the same way as my
current code does.

> 
> I thought you said you did not have loops in the writers?

Well, while technically a loop, it is a bounded single-retry, so it's OK as far
as wait-free guarantees are concerned. We could even put a WARN_ON() there to
ensure that we catch double retry that should never happen, but that would be at
the cost of a runtime veritication. A DEBUG_TRACER_RT config option could select
this though.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
