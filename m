Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab0DFVMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:12:53 -0400
Received: from smtp-out.google.com ([74.125.121.35]:51626 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab0DFVMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:12:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=WsUXpzMW9HVLEuakG/TUKj1QEqafXqKaAkuSHUyCaLnIR61M6T8stbx80RZdYREka
	ZDuPRXIXN+/xwJOeaNEng==
MIME-Version: 1.0
In-Reply-To: <1270298740.19685.11779.camel@gandalf.stny.rr.com>
References: <m2u5df78e1d1003301627ya1f621f7qaf0ad099f62d787e@mail.gmail.com>
	 <1269995724.22564.58.camel@localhost.localdomain>
	 <q2o5df78e1d1003302101q585143aan32e8872fcdb05c8a@mail.gmail.com>
	 <1270081707.19685.8095.camel@gandalf.stny.rr.com>
	 <p2t5df78e1d1003311814q1f270e41o4ebdc1f48659c034@mail.gmail.com>
	 <1270084982.19685.8151.camel@gandalf.stny.rr.com>
	 <j2s5df78e1d1004021610p96e6454ezdc5d1a0a42aa78f@mail.gmail.com>
	 <1270298740.19685.11779.camel@gandalf.stny.rr.com>
Date: Tue, 6 Apr 2010 14:12:44 -0700
Message-ID: <j2v5df78e1d1004061412mda3e6556qfc5c2ca3041c17b3@mail.gmail.com>
Subject: Re: lockup in rb_get_reader_page
From: Jiaying Zhang <jiayingz@google.com>
To: rostedt@goodmis.org
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Sat, Apr 3, 2010 at 5:45 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2010-04-02 at 16:10 -0700, Jiaying Zhang wrote:
>
>> The page offset is the index we added in the buffer_page structure.
>> You can ignore this field. The interesting part here is that both
>> cpu_buffer->head_page and cpu_buffer->reader_page point to the
>> same buffer_page. I am not sure yet how we entered this situation,
>
> You can ignore the cpu_buffer->head_page, it is used as a reference and
> is not part of the main algorithm. It is just there to tell the reader
> where the last head page was.
>
>> but the problem is once we get here, we will be in an infinite loop.
>
> But yes, it should never point to the reader page, because the reader
> controls the head_page __and__ the reader page.
>
>>
>> At the beginning of the spin loop, we call rb_set_head_page() to grab
>> the head_page. In that function, we check whether a page is the head_page
>> with rb_is_head_page(). The problem is that rb_is_head_page() may
>> return RB_PAGE_MOVED if the head_page has changed to another
>> page, and that is what has happened as the above messages show.
>
> I don't see where it said that.
>
> If RB_PAGE_MOVED is returned in rb_set_head_page then something is very
> broken. Because that is only returned if the reader modified the code.
> And since we only allow one reader at a time (we have locks to protect
> that), and the rb_set_head_page is only called by the reader, then this
> would mean another reader is reading the ring buffer.
>
> I should add a:
>
>        if ((ret = rb_is_head_page(cpu_buffer, page, page->list.prev))) {
>                RB_WARN_ON(ret == RB_PAGE_MOVED);
>                cpu_buffer->head_page = page;
>                return page;
>        }
>
>
I added the RB_WARN_ON(ret == RB_PAGE_MOVED) in rb_set_head_page()
as you suggested and I think it has helped me figure out the problem.

I saw a warning triggered by this WARN_ON this morning and realized
that although we are not doing read from interrupt context, we sometimes
call ring_buffer_empty() from a timer interrupt handler that checks whether
there is new data coming in the trace buffer and if so wakes up the
user-space reader. ring_buffer_empty() calls rb_set_head_page()
that can move the head_page. As far as I understand, it should be
ok to have ring_buffer_empty() preempt a writer so I guess we should leave
that RB_WARN_ON out from rb_set_head_page(). The problem in our case
is that we use our own locking mechanism to guarantee a single reader
instead of using the cpu_buffer->reader_lock so the reader is not synchronized
with ring_buffer_empty(). So when ring_buffer_empty() is called while
we are in the process of swapping the reader_page and head_page, the
head_page pointer can point to the old head, i.e., the new reader_page,
and we will enter into an infinite loop.

I wrapped our rb_get_reader_page() calls with cpu_buffer->reader_lock
spinlock and it seems to have solved the problem.

Thank you very much for the help!

Jiaying

>> Shouldn't we just return 0 in case that head_page has moved so that
>> we can move to the next page in the loop inside rb_set_head_page()?
>
> No, when the reader moves the page, the RB_PAGE_MOVED forces the writer
> to go into the conflict path (conflict between writer and reader).
>
> -- Steve
>
>
>
