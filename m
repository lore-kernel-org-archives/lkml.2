Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab0EMPmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:42:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0EMPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:42:20 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=yiYnlo-UJTIA:10 a=ood2b7iyd8MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=a5LkSv8FAAAA:8 a=VwQbUJbxAAAA:8 a=eUqiT1qZrw1m7Py306IA:9 a=7jBijxqScYqcr7CRKM8A:7 a=9d-bnr4SlaqTpaj_5YzE7BX2OyIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rTVfYWTrAPNEVQ4e:21 a=z00iR_87B5YmMc1r:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Perf and ftrace [was Re: PyTimechart]
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
In-Reply-To: <20100513132029.GA22799@Krystal>
References: <20100512170734.GA15953@Krystal>
	 <1273686425.1626.142.camel@laptop> <20100512175305.GB32496@Krystal>
	 <1273687212.1626.147.camel@laptop> <20100512180438.GE15953@Krystal>
	 <1273687712.1626.151.camel@laptop> <20100512183704.GD21432@Krystal>
	 <1273690012.27703.38.camel@gandalf.stny.rr.com>
	 <20100512202745.GK21432@Krystal>
	 <1273702886.27703.58.camel@gandalf.stny.rr.com>
	 <20100513132029.GA22799@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 13 May 2010 11:42:17 -0400
Message-ID: <1273765337.27703.1043.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 09:20 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Wed, 2010-05-12 at 16:27 -0400, Mathieu Desnoyers wrote:
> > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > On Wed, 2010-05-12 at 14:37 -0400, Mathieu Desnoyers wrote:
> > > > 
> > > > > OK, I see. In LTTng, I dropped the mmap() support when I integrated splice(). In
> > > > > both case, I can share the pages between the "output" (mmap or splice) and the
> > > > > ring buffer because my ring buffer does not care about
> > > > > page->mapping/->index/etc, so I never have to swap them.
> > > > 
> > > > I'm curious, how do you handle the overwrite mode without swapping?
> > > 
> > > Explanation extracted from:
> > > 
> > > http://www.lttng.org/pub/thesis/desnoyers-dissertation-2009-12.pdf
> > > 
> > > 5.4 Atomic Buffering Scheme
> > > 5.4.3 Algorithms
> > > 
> > > "This is achieved by adding a supplementary sub-buffer, owned by the reader. A
> > > table with pointers to the sub-buffers being used by the writer allows the
> > > reader to change the reference to each sub-buffer atomically. The
> > > ReadGetSubbuf() algorithm is responsible for atomically exchanging the reference
> > > to the sub-buffer about to be read with the sub-buffer currently owned by the
> > > reader.
> > 
> > AKA - swapping
> > 
> > As I asked, this seems to do exactly what my ring buffer does, except
> > you use a table where I swap out the list.  But this is still swapping.
> 
> Yes, we could use the word swapping to explain this scheme I guess. Yes, it is
> in some sense similar, with the distinction that here the ring buffer
> reserve/commit (reader/writer synchronization) is all performed in the frontend,
> thus independent from this page swapping.


The difference is only in the semantics.

> 
> When the buffer is in non-overwrite mode, I simply don't allocate a separate
> subbuffer for the reader and don't need to perform swapping: the
> producer/consumer offsets deal with reader/writer concurrency by mutually
> excluding readers from the writer offset range and vice-versa.

Yeah, I thought about doing the same, but 1) I didn't want to add
different code, 2) ftrace has yet had a need to use non-overwrite mode.

> 
> > 
> > 
> > >  If the CAS operation fails, the reader does not get access to the buffer
> > > for reading."
> > > 
> > > I know your mother tongue is C, not English, so I just prepared a git repo with
> > > the current state of my work (please note that I'm currently in the process of
> > > cleaning up this code).
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-ringbuffer.git
> > > 
> > > Interesting bits below.
> > > 
> > > Thanks,
> > > 
> > > Mathieu
> > > 
> > > Note: The "frontend" refers to the buffer writer/reader synchronization
> > > algorithm. The "backend" deals with allocation of the memory buffers. This
> > > frontend/backend separation permits to use the same ring buffer synchronization
> > > code to write data to kernel pages, to video memory, to serial ports, etc etc,
> > > without having to deal with different synchronization schemes.
> > 
> > OK
> > 
> > > 
> > > Where the reader grabs the sub-buffer :
> > > 
> > > kernel/trace/ring_buffer_frontend.c: ring_buffer_get_subbuf()
> > > 
> > > 396         ret = update_read_sb_index(&buf->backend, &chan->backend, consumed_idx);
> > > 397         if (ret)
> > > 398                 return ret;
> > > 
> > > and releases it:
> > > 
> > > kernel/trace/ring_buffer_frontend.c: ring_buffer_put_subbuf()
> > > 
> > > 415         RCHAN_SB_SET_NOREF(buf->backend.buf_rsb.pages);
> > > 
> > > The writer clears the "noref" flag when it starts writing to a subbuffer, and
> > > clears that flag when it has fully committed a subbuffer.
> > 
> > Should one of the "clears" above be a set?
> 
> Yes, the second "clears" in my explanation is indeed a "set".
> 
> > 
> > > 
> > > The primitives used by the "synchronization frontend" are declared in the
> > > backend here:
> > > 
> > > kernel/trace/ring_buffer_page_backend_internal.h:
> > > 
> > > Interesting definitions and data structures for our current discussions:
> > > 
> > > 17 #define RCHAN_SB_IS_NOREF(x)    ((unsigned long)(x) & RCHAN_NOREF_FLAG)
> > > 18 #define RCHAN_SB_SET_NOREF(x)   \
> > 
> > I really hate caps, even for macros. If it acts like a function, keep it
> > lowercase. Caps are for constants not functions.
> > 
> > Linux convention has always had lowercase for macros that act like
> > functions. Heck, why not just make these static inlines?
> 
> Will do. Good point!
> 
> > 
> > 
> > > 19         (x = (struct ring_buffer_backend_page *) \
> > > 20                 ((unsigned long)(x) | RCHAN_NOREF_FLAG))
> > > 21 #define RCHAN_SB_CLEAR_NOREF(x) \
> > > 22         (x = (struct ring_buffer_backend_page *) \
> > > 23                 ((unsigned long)(x) & ~RCHAN_NOREF_FLAG))
> > > 24
> > > 25 struct ring_buffer_backend_page {
> > > 26         void *virt;                     /* page virtual address (cached) */
> > > 27         struct page *page;              /* pointer to page structure */
> > > 28 };
> > > 29
> > > 30 struct ring_buffer_backend_subbuffer {
> > > 31         /* Pointer to backend pages for subbuf */
> > > 32         struct ring_buffer_backend_page *pages;
> > > 33 };
> > > 
> > > ...
> > > 
> > > 41 struct ring_buffer_backend {
> > > 42         /* Array of chanbuf_sb for writer */
> > > 43         struct ring_buffer_backend_subbuffer *buf_wsb;
> > > 44         /* chanbuf_sb for reader */
> > > 45         struct ring_buffer_backend_subbuffer buf_rsb;
> > 
> > So this is equivalent to my reader_page?
> 
> Yes. But in this case, it is a reader "subbuffer", which is an array of pages.

It's still a subbuffer. Again, difference in semantics.


> 
> > 
> > > 
> > > ...
> > > 
> > > 97 /**
> > > 98  * ring_buffer_clear_noref_flag - Clear the noref subbuffer flag, for writer.
> > > 99  */
> > > 100 static __inline__
> > > 101 void ring_buffer_clear_noref_flag(struct ring_buffer_backend *bufb,
> > > 102                                   unsigned long idx)
> > > 103 {
> > > 104         struct ring_buffer_backend_page *sb_pages, *new_sb_pages;
> > > 105
> > > 106         sb_pages = bufb->buf_wsb[idx].pages;
> > > 107         for (;;) {
> > > 108                 if (!RCHAN_SB_IS_NOREF(sb_pages))
> > > 109                         return; /* Already writing to this buffer */
> > > 110                 new_sb_pages = sb_pages;
> > > 111                 RCHAN_SB_CLEAR_NOREF(new_sb_pages);
> > > 112                 new_sb_pages = cmpxchg(&bufb->buf_wsb[idx].pages,
> > > 113                         sb_pages, new_sb_pages);
> > > 114                 if (likely(new_sb_pages == sb_pages))
> > > 115                         break;
> > > 116                 sb_pages = new_sb_pages;
> > 
> > The writer calls this??
> 
> Yes. But the common case (for each event) is simply a
> "if (!RCHAN_SB_IS_NOREF(sb_pages))" test that returns. The cmpxchg() is only
> performed at subbuffer boundary.

Is the cmpxchg only contending with other writers?

> 
> Will update the comment above to:
> 
> /**
>  * ring_buffer_clear_noref - Clear the noref subbuffer flag, called by writer.
>  */
> static __inline__
> void ring_buffer_clear_noref(struct ring_buffer_backend *bufb,
>                              unsigned long idx)
> 
> 
> > 
> > > 117         }
> > > 118 }
> > > 119
> > > 120 /**
> > > 121  * ring_buffer_set_noref_flag - Set the noref subbuffer flag, for writer.
> > > 122  */
> > > 123 static __inline__
> > > 124 void ring_buffer_set_noref_flag(struct ring_buffer_backend *bufb,
> > > 125                                 unsigned long idx)
> > > 126 {
> > > 127         struct ring_buffer_backend_page *sb_pages, *new_sb_pages;
> > > 128
> > > 129         sb_pages = bufb->buf_wsb[idx].pages;
> > > 130         for (;;) {
> > > 131                 if (RCHAN_SB_IS_NOREF(sb_pages))
> > > 132                         return; /* Already set */
> > > 133                 new_sb_pages = sb_pages;
> > > 134                 RCHAN_SB_SET_NOREF(new_sb_pages);
> > > 135                 new_sb_pages = cmpxchg(&bufb->buf_wsb[idx].pages,
> > > 136                         sb_pages, new_sb_pages);
> > > 137                 if (likely(new_sb_pages == sb_pages))
> > > 138                         break;
> > > 139                 sb_pages = new_sb_pages;
> > 
> > Again, the writer calls this??
> 
> Yep.
> 
> > 
> > > 140         }
> > > 141 }
> > > 142
> > > 143 /**
> > > 144  * update_read_sb_index - Read-side subbuffer index update.
> > > 145  */
> > > 146 static __inline__
> > > 147 int update_read_sb_index(struct ring_buffer_backend *bufb,
> > > 148                          struct channel_backend *chanb,
> > > 149                          unsigned long consumed_idx)
> > > 150 {
> > > 151         struct ring_buffer_backend_page *old_wpage, *new_wpage;
> > > 152
> > > 153         if (unlikely(chanb->extra_reader_sb)) {
> > > 154                 /*
> > > 155                  * Exchange the target writer subbuffer with our own unused
> > > 156                  * subbuffer.
> > > 157                  */
> > > 158                 old_wpage = bufb->buf_wsb[consumed_idx].pages;
> > > 159                 if (unlikely(!RCHAN_SB_IS_NOREF(old_wpage)))
> > > 160                         return -EAGAIN;
> > > 161                 WARN_ON_ONCE(!RCHAN_SB_IS_NOREF(bufb->buf_rsb.pages));
> > > 162                 new_wpage = cmpxchg(&bufb->buf_wsb[consumed_idx].pages,
> > > 163                                 old_wpage,
> > > 164                                 bufb->buf_rsb.pages);
> > 
> > This looks just like the swap with reader_page that I do, except you use
> > a table and I use the list.  How do you replenish the buf_rsb.pages if
> > the splice keeps the page you just received active?
> 
> I don't allow other reads to proceed as long as splice is holding pages that
> belong to the reader-owned subbuffer. The read semantic is basically:
> 
> ring_buffer_open_read() /* only one reader at a time can open a ring buffer */
> get_subbuf_size()
> while (buffer is not finalized and empty) {
>   poll()
>   ret = ring_buffer_get_subbuf()
>   if (!ret)
>     continue;
>   /* The splice ops below can be performed in multiple calls, e.g. first splice
>    * only a portion of a subbuffer to a pipe, then splice to the disk/network,
>    * and move to the next subbuffer portion until all the subbuffer is sent.
>    */
>   splice one subbuffer worth of data to a pipe
>   splice the data from pipe to disk/network
>   ring_buffer_put_subbuf()
> }
> ring_buffer_close_read()
> 
> The reader code above works both with flight recorder and non-overwrite mode.
> 
> The code above assumes that upon return from the splice() to disk/network,
> splice() is not using the pages anymore (I assume that splice() performs the
> transfer synchronously with the call).
> 
> The VFS interface I use for get_subbuf_size(), ring_buffer_get_subbuf() and
> ring_buffer_put_subbuf() are new ioctls. Note that these can be used for both
> splice() and mmap() types of backend access, as they only call into the
> frontend.

Hmm, so basically you lose pages until they are returned. I guess I can
trivially add the same thing now to the current ring buffer.

-- Steve

> > 
> > > 165                 if (unlikely(old_wpage != new_wpage))
> > > 166                         return -EAGAIN;
> > > 167                 bufb->buf_rsb.pages = new_wpage;
> > > 168                 RCHAN_SB_CLEAR_NOREF(bufb->buf_rsb.pages);
> > > 169         } else {
> > > 170                 /* No page exchange, use the writer page directly */
> > > 171                 bufb->buf_rsb.pages = bufb->buf_wsb[consumed_idx].pages;
> > > 172                 RCHAN_SB_CLEAR_NOREF(bufb->buf_rsb.pages);
> > > 173         }
> > > 174         return 0;
> > > 175 }
> > > 
> > > 
> > 
> > 
> 


