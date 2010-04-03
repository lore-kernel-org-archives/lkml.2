Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab0DCMps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 08:45:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35227 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0DCMpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 08:45:43 -0400
X-Authority-Analysis: v=1.1 cv=W8jVbnnOFeMnsvu+vJfVVAGaiNyfzTaRLlU2b8ifu+8= c=1 sm=0 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=T1YicFVgjQXt0BkIlGEA:9 a=8kBWun28j1HPFDbYvgQA:7 a=sEqtNU7wK4PLu1F1O6lQUcirRSQA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: lockup in rb_get_reader_page
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiaying Zhang <jiayingz@google.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <j2s5df78e1d1004021610p96e6454ezdc5d1a0a42aa78f@mail.gmail.com>
References: <m2u5df78e1d1003301627ya1f621f7qaf0ad099f62d787e@mail.gmail.com>
	 <1269995724.22564.58.camel@localhost.localdomain>
	 <q2o5df78e1d1003302101q585143aan32e8872fcdb05c8a@mail.gmail.com>
	 <1270081707.19685.8095.camel@gandalf.stny.rr.com>
	 <p2t5df78e1d1003311814q1f270e41o4ebdc1f48659c034@mail.gmail.com>
	 <1270084982.19685.8151.camel@gandalf.stny.rr.com>
	 <j2s5df78e1d1004021610p96e6454ezdc5d1a0a42aa78f@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 03 Apr 2010 08:45:40 -0400
Message-ID: <1270298740.19685.11779.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 16:10 -0700, Jiaying Zhang wrote:

> The page offset is the index we added in the buffer_page structure.
> You can ignore this field. The interesting part here is that both
> cpu_buffer->head_page and cpu_buffer->reader_page point to the
> same buffer_page. I am not sure yet how we entered this situation,

You can ignore the cpu_buffer->head_page, it is used as a reference and
is not part of the main algorithm. It is just there to tell the reader
where the last head page was.

> but the problem is once we get here, we will be in an infinite loop.

But yes, it should never point to the reader page, because the reader
controls the head_page __and__ the reader page.

> 
> At the beginning of the spin loop, we call rb_set_head_page() to grab
> the head_page. In that function, we check whether a page is the head_page
> with rb_is_head_page(). The problem is that rb_is_head_page() may
> return RB_PAGE_MOVED if the head_page has changed to another
> page, and that is what has happened as the above messages show.

I don't see where it said that.

If RB_PAGE_MOVED is returned in rb_set_head_page then something is very
broken. Because that is only returned if the reader modified the code.
And since we only allow one reader at a time (we have locks to protect
that), and the rb_set_head_page is only called by the reader, then this
would mean another reader is reading the ring buffer.

I should add a:

	if ((ret = rb_is_head_page(cpu_buffer, page, page->list.prev))) {
		RB_WARN_ON(ret == RB_PAGE_MOVED);
		cpu_buffer->head_page = page;
		return page;
	}


> Shouldn't we just return 0 in case that head_page has moved so that
> we can move to the next page in the loop inside rb_set_head_page()?

No, when the reader moves the page, the RB_PAGE_MOVED forces the writer
to go into the conflict path (conflict between writer and reader).

-- Steve


