Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab2FUPq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:46:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3142 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2FUPq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 11:46:58 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XOt6boVe9ZQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=E8fJSAIFpq_AM9qLJUAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340293617.27036.177.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ring-buffer: fix uninitialized read_stamp
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com
Date: Thu, 21 Jun 2012 11:46:57 -0400
In-Reply-To: <1340060577-9112-1-git-send-email-dhsharp@google.com>
References: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
	 <1340060577-9112-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I did look at this more.


On Mon, 2012-06-18 at 16:02 -0700, David Sharp wrote:
> This fixes a scenario in which trace_pipe_raw will return events with invalid
> timestamps when events are copied out one at a time (instead of swapping out
> the reader page with a spare page). In this scenario, ring_buffer_read_page()
> uses cpu_buffer->read_stamp to keep track of the time of the earliest event.
> However, cpu_buffer->read_stamp was not always updated.



>  The only function that
> sets read_stamp to a new valid value is rb_reset_reader_page(), which is called
> only by rb_get_reader_page().

Correct, which is the only way to get the reader page no matter how you
read the buffer.

>  rb_reset_reader_page() was not called when there
> is data immediately available on the page to read (read < rb_page_size()). This
> is the bug.

It is not called? but how did you get the reader_page without the swap
in the first place?

When the ring buffer is first allocated the reader page is set to a
zero'd page, making the "read" and "commit" both zero.

The first time rb_get_reader_page() is called, the compare of read <
rb_page_size() (which is the commit field) fails (0 < 0 is false).

A swap from the writable ring buffer takes place and the
cpu_buffer->read_stamp is updated.

Ah! I think this is where the bug you see happens. But your analysis is
flawed.

If the ring buffer is currently empty, we swap an empty page for an
empty page. But the writer ends up on the reader page preventing new
swaps from taking place.

    commit_page == reader_page

If the writer starts writing, it will update the time stamp of the page.
If your next read happens now, and it's just a single read, then you are
correct that it will not update the read_stamp.

I'm wondering if it would be better to just not do the swap, and return
NULL when it is empty. This would also fix the problem, as the
read_stamp will only be set when you actually have data.

Or it may just be simpler to take your patch.

-- Steve



