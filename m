Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714Ab2FVUvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:51:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58352 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab2FVUvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:51:06 -0400
MIME-Version: 1.0
In-Reply-To: <1340293617.27036.177.camel@gandalf.stny.rr.com>
References: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
 <1340060577-9112-1-git-send-email-dhsharp@google.com> <1340293617.27036.177.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Fri, 22 Jun 2012 13:50:43 -0700
Message-ID: <CAJL_ekt-iVgh-GG_PoY_eqobgdUGf_L4TH6zmVa4D9oBgohCsA@mail.gmail.com>
Subject: Re: [PATCH] ring-buffer: fix uninitialized read_stamp
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 7:52 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Do you believe that this is an urgent fix and should be marked for
> stable, or do you think it can wait till 3.6? If you think it should be
> marked for stable, then it should be pushed for 3.5.

I think it should be considered for 3.5, since it affects the accuracy
of the timestamps in very roughly 20% of traces read with read() on
trace_pipe_raw. otoh, it only affects the first page or so on lightly
loaded CPUs. Personally it doesn't make much difference to us what
release it gets into.

On Thu, Jun 21, 2012 at 8:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> OK, I did look at this more.

>>  The only function that
>> sets read_stamp to a new valid value is rb_reset_reader_page(), which is called
>> only by rb_get_reader_page().
>
> Correct, which is the only way to get the reader page no matter how you
> read the buffer.
>
>>  rb_reset_reader_page() was not called when there
>> is data immediately available on the page to read (read < rb_page_size()). This
>> is the bug.
>
> It is not called?

Correct. I was able to add WARN_ONs that showed that it reached "out:"
without reaching rb_reset_reader_page() first while still having a
poison value in cpu_buffer->read_stamp.

> but how did you get the reader_page without the swap
> in the first place?
>
> When the ring buffer is first allocated the reader page is set to a
> zero'd page, making the "read" and "commit" both zero.
>
> The first time rb_get_reader_page() is called, the compare of read <
> rb_page_size() (which is the commit field) fails (0 < 0 is false).
>
> A swap from the writable ring buffer takes place and the
> cpu_buffer->read_stamp is updated.
>
> Ah! I think this is where the bug you see happens. But your analysis is
> flawed.

I admit I didn't look into it that closely, so flaws are quite
possible (also, I'm human).

>
> If the ring buffer is currently empty, we swap an empty page for an
> empty page. But the writer ends up on the reader page preventing new
> swaps from taking place.
>
>    commit_page == reader_page
>
> If the writer starts writing, it will update the time stamp of the page.
> If your next read happens now, and it's just a single read, then you are
> correct that it will not update the read_stamp.
>
> I'm wondering if it would be better to just not do the swap, and return
> NULL when it is empty. This would also fix the problem, as the
> read_stamp will only be set when you actually have data.

But we do have data... That's how we know we're getting invalid timestamps.

I don't quite understand what you're describing. Here's what I think
is happening though:

When the ring buffer is reset, commit_page == tail_page == head_page.
rb_get_reader_page() will pick up the head page. Then a few (less than
1 page worth) writes happen, on the tail_page which is currently (or
soon to be) also the reader_page. Now read == 0, but
rb_page_size(reader) is however many bytes have been written to the
page.

So we have valid data on the reader page, but read_stamp has not been set yet.

>
> Or it may just be simpler to take your patch.

Please? :)

On Thu, Jun 21, 2012 at 8:56 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Does something like this work for you. Note, this is totally untested!
>
> -- Steve
>
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index ad0239b..5943044 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -3246,6 +3246,10 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>        if (cpu_buffer->commit_page == cpu_buffer->reader_page)
>                goto out;
>
> +       /* Don't bother swapping if the ring buffer is empty */

This doesn't make sense, since the ring buffer isn't empty in this
scenario. (I didn't bother testing it.)

> +       if (rb_num_of_entries(cpu_buffer) == 0)

Did you mean rb_page_entries(something?)

> +               goto out;
> +
>        /*
>         * Reset the reader page to size zero.
>         */
>
>
