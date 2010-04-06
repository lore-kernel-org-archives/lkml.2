Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab0DFNld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:41:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab0DFNl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:41:26 -0400
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
 events on sparc 64
From: Steven Rostedt <srostedt@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       a.p.zijlstra@chello.nl, paulus@samba.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100405.191555.184824968.davem@davemloft.net>
References: <20100405065701.GC5127@nowhere>
	 <20100405.122233.188421941.davem@davemloft.net>
	 <20100405194055.GA5265@nowhere>
	 <20100405.191555.184824968.davem@davemloft.net>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 06 Apr 2010 09:41:04 -0400
Message-Id: <1270561264.2738.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

It's best to send to my rostedt@goodmis.org account, just like it is
best to send to your davem@davemloft.net ;-)


On Mon, 2010-04-05 at 19:15 -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 5 Apr 2010 21:40:58 +0200
> 
> > It happens without CONFIG_FUNCTION_TRACER as well (but it happens
> > when the function tracer runs). And I hadn't your
> > perf_arch_save_caller_regs() when I triggered this.
> 
> I think there's still something wrong with the ring buffer stuff on
> architectures like sparc64.
> 
> Stephen, I'm looking at the 8-byte alignment fix that was made a few
> weeks ago, commit:
> 
> commit 2271048d1b3b0aabf83d25b29c20646dcabedc05
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Thu Mar 18 17:54:19 2010 -0400
> 
>     ring-buffer: Do 8 byte alignment for 64 bit that can not handle 4 byte align
> 
> and I'm not so sure it's completely correct.
> 
> Originally, the ring buffer entries determine where the entry data
> resides (either &event->array[0] or &event->array[1]) based upon the
> length.
> 
> Beforehand, in all cases:
> 
> 1) If length could be encoded into event->type_len (ie. <=
>    RB_MAX_SMALL_DATA) then event->type_len holds the length
>    and the event data starts at &event->array[0]
> 
> 2) Otherwise (length > RB_MAX_SMALL_DATA) the length is
>    encoded into event->array[0] and the event data starts at
>    &event->array[1]
> 
> But now, there is a new semantic when CONFIG_64BIT is true and
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is false (which isn't the right
> test btw, f.e. sparc 32-bit needs this handling just like sparc 64-bit
> does since it uses full 64-bit loads and stores to access u64 objects
> and thus will crash without proper alignment, the correct test should
> be just CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS being false).

OK, so the a 64 bit word still needs 64 bit alignment when storing to a
data pointer.

I wonder if we should just have a special copy in this case for the
events and remove this patch in the ring buffer. That is:

	__assign_word(__entry->word, value);

And have in !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS be:

	#define __assgin_word(dest, src)	\
		memcpy(&(dest), &(src), sizeof(src));

This would fix it for all.

> 
> This new semantic is:
> 
> 1) Entries always encode the length in ->array[0] and ->type_len
>    is set to zero.
> 
> And then there are special cases like events of type
> RINGBUF_TYPE_PADDING which, even though ->type_len is non-zero, encode
> a length field in ->array[0] which is used by the ring buffer
> iterators such as rb_event_length(), but this only applies only if
> event->time_delta is non-zero.  (Phew!)

The RINGBUF_TYPE_PADDING is used to either fill the rest of the sub
buffer, where alignment does not matter, or to replace a deleted event
that had another event after, it, which should already be aligned.

> 
> The commit adjusts the code in rb_calculate_event_length() to force 8
> byte chunks when RB_FORCE_8BYTE_ALIGNMENT is set.  It also adjusted
> the rb_update_event() logic so that it unconditionally uses
> event->array[0] for the length on such platforms.
> 
> However I don't see any logic added to ring_buffer_event_length()
> to handle this forcing.   That alone can't explain the crashes
> Frederic and I are seeing, since only oprofile seems to use that
> helper function, but I can just imagine there might be other
> subtle bugs linering after the above commit.
> 
> Anyways, that's just the inital potential problem I've discovered.
> I'll start auditing the rest of this code.
> 
> I wonder if there's a simpler way to implement this alignment fix such
> that we don't have to constantly make sure scores of locations in
> ring_buffer.c get this magic exception case correct.
> 
> We should probably also BUILD_BUG_ON() if BUF_PAGE_HDR_SIZE is not
> a multiple of the necessary alignment, since the ring buffer
> entries start at the end of that.
> 
> Also I noticed (painfully :-) that 2.6.33 needs a backport of this
> alignment fix too, so we should submit it to -stable (once we sift
> out all the bugs of course).

What about removing the logic from the ring buffer and moving it to the
TRACE_EVENT() macros as I suggested above?

We would probably need a way to read the buffers too.

I also know that Mathieu has some strange tricks to force alignment but
I'm still not convinced it would make things any less fragile than what
is already there.

-- Steve


