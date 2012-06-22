Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847Ab2FVXbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:31:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14025 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2FVXbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:31:41 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XOt6boVe9ZQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=7TRcv_joNegSr4y0KooA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340407900.27036.275.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ring-buffer: fix uninitialized read_stamp
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com
Date: Fri, 22 Jun 2012 19:31:40 -0400
In-Reply-To: <CAJL_ekt-iVgh-GG_PoY_eqobgdUGf_L4TH6zmVa4D9oBgohCsA@mail.gmail.com>
References: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
	 <1340060577-9112-1-git-send-email-dhsharp@google.com>
	 <1340293617.27036.177.camel@gandalf.stny.rr.com>
	 <CAJL_ekt-iVgh-GG_PoY_eqobgdUGf_L4TH6zmVa4D9oBgohCsA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 13:50 -0700, David Sharp wrote:
> On Thu, Jun 21, 2012 at 7:52 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Do you believe that this is an urgent fix and should be marked for
> > stable, or do you think it can wait till 3.6? If you think it should be
> > marked for stable, then it should be pushed for 3.5.
> 
> I think it should be considered for 3.5, since it affects the accuracy
> of the timestamps in very roughly 20% of traces read with read() on
> trace_pipe_raw. otoh, it only affects the first page or so on lightly
> loaded CPUs. Personally it doesn't make much difference to us what
> release it gets into.

If there's a simple fix then I can try to get this into 3.5.

> 
> On Thu, Jun 21, 2012 at 8:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > OK, I did look at this more.
> 
> >>  The only function that
> >> sets read_stamp to a new valid value is rb_reset_reader_page(), which is called
> >> only by rb_get_reader_page().
> >
> > Correct, which is the only way to get the reader page no matter how you
> > read the buffer.
> >
> >>  rb_reset_reader_page() was not called when there
> >> is data immediately available on the page to read (read < rb_page_size()). This
> >> is the bug.
> >
> > It is not called?
> 
> Correct. I was able to add WARN_ONs that showed that it reached "out:"
> without reaching rb_reset_reader_page() first while still having a
> poison value in cpu_buffer->read_stamp.

NO! You didn't understand what I wrote. The writer can not get onto the
reader page without a swap! The reader page is not part of the main ring
buffer.

> 
> > but how did you get the reader_page without the swap
> > in the first place?
> >
> > When the ring buffer is first allocated the reader page is set to a
> > zero'd page, making the "read" and "commit" both zero.
> >
> > The first time rb_get_reader_page() is called, the compare of read <
> > rb_page_size() (which is the commit field) fails (0 < 0 is false).
> >
> > A swap from the writable ring buffer takes place and the
> > cpu_buffer->read_stamp is updated.
> >
> > Ah! I think this is where the bug you see happens. But your analysis is
> > flawed.
> 
> I admit I didn't look into it that closely, so flaws are quite
> possible (also, I'm human).

I didn't mean to offend, as this is not something that can be easily
picked up.

> 
> >
> > If the ring buffer is currently empty, we swap an empty page for an
> > empty page. But the writer ends up on the reader page preventing new
> > swaps from taking place.
> >
> >    commit_page == reader_page
> >
> > If the writer starts writing, it will update the time stamp of the page.
> > If your next read happens now, and it's just a single read, then you are
> > correct that it will not update the read_stamp.
> >
> > I'm wondering if it would be better to just not do the swap, and return
> > NULL when it is empty. This would also fix the problem, as the
> > read_stamp will only be set when you actually have data.
> 
> But we do have data... That's how we know we're getting invalid timestamps.

I bet this never happens if you add a little data and then do a read. I
only happens when you read from an empty ring buffer, then do a small
write, and then read again. That's where it will get you.

> 
> I don't quite understand what you're describing. Here's what I think
> is happening though:
> 
> When the ring buffer is reset, commit_page == tail_page == head_page.

And at this moment, the writer is off the reader page and will not be on
the reader page. The only way to get date at this point is if you do a
swap.

> rb_get_reader_page() will pick up the head page.

Right. But this requires a read to happen. If you never do a read, then
rb_get_reader_page will not pick up the head page. The problem is when
you read from an empty ring buffer.


>  Then a few (less than
> 1 page worth) writes happen, on the tail_page which is currently (or
> soon to be) also the reader_page. Now read == 0, but
> rb_page_size(reader) is however many bytes have been written to the
> page.

Correct.

> 
> So we have valid data on the reader page, but read_stamp has not been set yet.

Yep

> 
> >
> > Or it may just be simpler to take your patch.
> 
> Please? :)

Now I think you may understand my patch.

> 
> On Thu, Jun 21, 2012 at 8:56 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Does something like this work for you. Note, this is totally untested!
> >
> > -- Steve
> >
> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > index ad0239b..5943044 100644
> > --- a/kernel/trace/ring_buffer.c
> > +++ b/kernel/trace/ring_buffer.c
> > @@ -3246,6 +3246,10 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
> >        if (cpu_buffer->commit_page == cpu_buffer->reader_page)
> >                goto out;
> >
> > +       /* Don't bother swapping if the ring buffer is empty */
> 
> This doesn't make sense, since the ring buffer isn't empty in this
> scenario. (I didn't bother testing it.)

Yes it is! If you never did a read on the empty buffer, the *only* way
to get what was written is to do the swap.

The problem you are seeing is that you did a read on an empty buffer
before writing. In this case the swap happens but all we have is an
empty page with the write pointer (commit and tail) on it. When a write
happens, and you do another read, *then* we do not do the swap and you
get the stale time stamp.

Thus, if you never let the first swap happen, you wont get into this
scenario that you read and do not update the read_stamp.

> 
> > +       if (rb_num_of_entries(cpu_buffer) == 0)
> 
> Did you mean rb_page_entries(something?)

Nope, I meant the actual ring buffer. If the ring buffer is empty, do
not perform the swap. Because we only update the read stamp when we
perform a swap, and it takes a write to happen before the page's
timestamp is updated. If we do the swap before any writes happen, we get
an invalid timestamp from the page.

Now do you understand?

-- Steve

> 
> > +               goto out;
> > +
> >        /*
> >         * Reset the reader page to size zero.
> >         */
> >
> >


