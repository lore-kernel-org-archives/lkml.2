Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab0EMQby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:31:54 -0400
Received: from mail.openrapids.net ([64.15.138.104]:34597 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754691Ab0EMQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:31:53 -0400
Date: Thu, 13 May 2010 12:31:50 -0400
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
Message-ID: <20100513163150.GA13005@Krystal>
References: <20100512175305.GB32496@Krystal> <1273687212.1626.147.camel@laptop> <20100512180438.GE15953@Krystal> <1273687712.1626.151.camel@laptop> <20100512183704.GD21432@Krystal> <1273690012.27703.38.camel@gandalf.stny.rr.com> <20100512202745.GK21432@Krystal> <1273702886.27703.58.camel@gandalf.stny.rr.com> <20100513132029.GA22799@Krystal> <1273765337.27703.1043.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273765337.27703.1043.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:17:34 up 110 days, 18:54,  9 users,  load average: 0.27, 0.26,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-05-13 at 09:20 -0400, Mathieu Desnoyers wrote:
[...]
> > > > 
> > > > ...
> > > > 
> > > > 97 /**
> > > > 98  * ring_buffer_clear_noref_flag - Clear the noref subbuffer flag, for writer.
> > > > 99  */
> > > > 100 static __inline__
> > > > 101 void ring_buffer_clear_noref_flag(struct ring_buffer_backend *bufb,
> > > > 102                                   unsigned long idx)
> > > > 103 {
> > > > 104         struct ring_buffer_backend_page *sb_pages, *new_sb_pages;
> > > > 105
> > > > 106         sb_pages = bufb->buf_wsb[idx].pages;
> > > > 107         for (;;) {
> > > > 108                 if (!RCHAN_SB_IS_NOREF(sb_pages))
> > > > 109                         return; /* Already writing to this buffer */
> > > > 110                 new_sb_pages = sb_pages;
> > > > 111                 RCHAN_SB_CLEAR_NOREF(new_sb_pages);
> > > > 112                 new_sb_pages = cmpxchg(&bufb->buf_wsb[idx].pages,
> > > > 113                         sb_pages, new_sb_pages);
> > > > 114                 if (likely(new_sb_pages == sb_pages))
> > > > 115                         break;
> > > > 116                 sb_pages = new_sb_pages;
> > > 
> > > The writer calls this??
> > 
> > Yes. But the common case (for each event) is simply a
> > "if (!RCHAN_SB_IS_NOREF(sb_pages))" test that returns. The cmpxchg() is only
> > performed at subbuffer boundary.
> 
> Is the cmpxchg only contending with other writers?

No. Would have this been the case, I would have used a cmpxchg_local(). This
cmpxchg used to deal with subbuffer swap is touching the subbuffer "pages"
pointer, which can be updated concurrently by other writers as well as readers.

The writer clears the noref flags when starting to write in a subbuffers, and
sets it when delivering the subbuffer (when it is fully committed).

The reader can only ever swap the subbuffer with the one it owns if the noref
flag is set. The reader uses a cmpxchg() too to perform the swap.

[...]

> > > 
> > > This looks just like the swap with reader_page that I do, except you use
> > > a table and I use the list.  How do you replenish the buf_rsb.pages if
> > > the splice keeps the page you just received active?
> > 
> > I don't allow other reads to proceed as long as splice is holding pages that
> > belong to the reader-owned subbuffer. The read semantic is basically:
> > 
> > ring_buffer_open_read() /* only one reader at a time can open a ring buffer */
> > get_subbuf_size()
> > while (buffer is not finalized and empty) {
> >   poll()
> >   ret = ring_buffer_get_subbuf()
> >   if (!ret)
> >     continue;
> >   /* The splice ops below can be performed in multiple calls, e.g. first splice
> >    * only a portion of a subbuffer to a pipe, then splice to the disk/network,
> >    * and move to the next subbuffer portion until all the subbuffer is sent.
> >    */
> >   splice one subbuffer worth of data to a pipe
> >   splice the data from pipe to disk/network
> >   ring_buffer_put_subbuf()
> > }
> > ring_buffer_close_read()
> > 
> > The reader code above works both with flight recorder and non-overwrite mode.
> > 
> > The code above assumes that upon return from the splice() to disk/network,
> > splice() is not using the pages anymore (I assume that splice() performs the
> > transfer synchronously with the call).
> > 
> > The VFS interface I use for get_subbuf_size(), ring_buffer_get_subbuf() and
> > ring_buffer_put_subbuf() are new ioctls. Note that these can be used for both
> > splice() and mmap() types of backend access, as they only call into the
> > frontend.
> 
> Hmm, so basically you lose pages until they are returned. I guess I can
> trivially add the same thing now to the current ring buffer.

Yep. Having the ability to keep an array of pages (rather that just a single
page at a time) allows splice() to move many pages at once efficiently, while
permitting this "pages owned by the readers, lend to splice() until it returns"
simplification. I also never have to allocate pages while tracing: all the pages
I need are allocated when the buffer is created (and at the special case of cpu
hotplug, but this is expected for per-cpu buffers).

In addition, this would play well with mmap() too: we can simply add a
ring_buffer_get_mmap_offset() method to the backend (exported through another
ioctl) that would let user-space know the start of the mmap'd buffer range
currently owned by the reader. So we can inform user-space of the currently
owned page range without even changing the underlying memory map.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
