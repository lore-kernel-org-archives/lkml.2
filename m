Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab0DBXKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 19:10:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11500 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0DBXKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 19:10:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=qTL3iEAhBhd47V76CKmGVHy8GktFTWnvQ8kL/NpftuH1FGvhj1JQIaEgXaPRlYhRS
	SsgOdj6LZQBLkC+/wwfMQ==
MIME-Version: 1.0
In-Reply-To: <1270084982.19685.8151.camel@gandalf.stny.rr.com>
References: <m2u5df78e1d1003301627ya1f621f7qaf0ad099f62d787e@mail.gmail.com>
	 <1269995724.22564.58.camel@localhost.localdomain>
	 <q2o5df78e1d1003302101q585143aan32e8872fcdb05c8a@mail.gmail.com>
	 <1270081707.19685.8095.camel@gandalf.stny.rr.com>
	 <p2t5df78e1d1003311814q1f270e41o4ebdc1f48659c034@mail.gmail.com>
	 <1270084982.19685.8151.camel@gandalf.stny.rr.com>
Date: Fri, 2 Apr 2010 16:10:44 -0700
Message-ID: <j2s5df78e1d1004021610p96e6454ezdc5d1a0a42aa78f@mail.gmail.com>
Subject: Re: lockup in rb_get_reader_page
From: Jiaying Zhang <jiayingz@google.com>
To: rostedt@goodmis.org
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally reproduced the problem again with an instrumented kernel. Here are
the logged debugging messages I put right after the spin label in
rb_get_reader_page():

<4>cpu 0 may deadlock, loops 100
<4>reader pgoff 11 list ffff8100025c9c40 prev ffff8100025c9b00 next
ffff8100025c9a41
<4>reader_page pgoff 11 list ffff8100025c9c40 prev ffff8100025c9b00
next ffff8100025c9a41
<4>head_page pgoff 11 list ffff8100025c9c40 prev ffff8100025c9b00 next
ffff8100025c9a41
<4>tail_page pgoff 3 list ffff8100025c9a40 prev ffff8100025c9d00 next
ffff8100025c9e40
<4>commit_page pgoff 3 list ffff8100025c9a40 prev ffff8100025c9d00
next ffff8100025c9e40
<4>page offset 4 list ffff8100025c9b00 prev ffff8100025c9c80 next
ffff8100025c9d00
<4>page offset 12 list ffff8100025c9d00 prev ffff8100025c9b00 next
ffff8100025c9a40
<4>page offset 3 list ffff8100025c9a40 prev ffff8100025c9d00 next
ffff8100025c9e40
<4>page offset 17 list ffff8100025c9e40 prev ffff8100025c9a40 next
ffff8100025c9d80
<4>page offset 14 list ffff8100025c9d80 prev ffff8100025c9e40 next
ffff8100025c9cc0
<4>page offset 10 list ffff8100025c9cc0 prev ffff8100025c9d80 next
ffff8100025c9b80
<4>page offset 7 list ffff8100025c9b80 prev ffff8100025c9cc0 next
ffff8100025c9ac0
<4>page offset 5 list ffff8100025c9ac0 prev ffff8100025c9b80 next
ffff8100025c9a00
<4>page offset 1 list ffff8100025c9a00 prev ffff8100025c9ac0 next
ffff8100025c9d40
<4>page offset 13 list ffff8100025c9d40 prev ffff8100025c9a00 next
ffff8100025c9e00
<4>page offset 15 list ffff8100025c9e00 prev ffff8100025c9d40 next
ffff8100025c9a80
<4>page offset 2 list ffff8100025c9a80 prev ffff8100025c9e00 next
ffff8100025c9bc0
<4>page offset 6 list ffff8100025c9bc0 prev ffff8100025c9a80 next
ffff8100025c9dc0
<4>page offset 16 list ffff8100025c9dc0 prev ffff8100025c9bc0 next
ffff8100025c99c0
<4>page offset 0 list ffff8100025c99c0 prev ffff8100025c9dc0 next
ffff8100025c9c00
<4>page offset 8 list ffff8100025c9c00 prev ffff8100025c99c0 next
ffff8100025c9c80
<4>page offset 9 list ffff8100025c9c80 prev ffff8100025c9c00 next
ffff8100025c9b00

The page offset is the index we added in the buffer_page structure.
You can ignore this field. The interesting part here is that both
cpu_buffer->head_page and cpu_buffer->reader_page point to the
same buffer_page. I am not sure yet how we entered this situation,
but the problem is once we get here, we will be in an infinite loop.

At the beginning of the spin loop, we call rb_set_head_page() to grab
the head_page. In that function, we check whether a page is the head_page
with rb_is_head_page(). The problem is that rb_is_head_page() may
return RB_PAGE_MOVED if the head_page has changed to another
page, and that is what has happened as the above messages show.
Shouldn't we just return 0 in case that head_page has moved so that
we can move to the next page in the loop inside rb_set_head_page()?

Jiaying

On Wed, Mar 31, 2010 at 6:23 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2010-03-31 at 18:14 -0700, Jiaying Zhang wrote:
>> On Wed, Mar 31, 2010 at 5:28 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >
>> > Are you doing reads from interrupt context?
>> >
>> No. We are using a user-space reader that reads ring buffer via syscall
>> or ioctl. But even though we don't read from interrupt context, as I
>> understand, we can still have a reader on another cpuB reads cpuA's
>> buffer when the writer on cpuA moves the head page. Will we have
>> any problem in that case?
>
> Nope, unless that write hangs for some reason ;-)
>
> The read may spin waiting for a writer to finish, hence it just can not
> preempt a writer in an interrupt context, because then it may spin
> forever, because it is blocking the writer. But if a writer is on
> another CPU, then all is well. In fact, the ring buffer was designed
> with that in mind.
>
> -- Steve
>
>
