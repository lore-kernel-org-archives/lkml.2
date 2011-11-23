Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1KWJaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 04:30:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56922 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1KWJaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 04:30:21 -0500
MIME-Version: 1.0
In-Reply-To: <1321968559.14799.2.camel@twins>
References: <20111116145320.GA20146@quad>
	<1321958457.5148.17.camel@twins>
	<CABPqkBT-ZPZC2Ku6NjyMygWUU+kMr3h9FCdKTAjvhR6ywFmNqw@mail.gmail.com>
	<1321968559.14799.2.camel@twins>
Date: Wed, 23 Nov 2011 10:30:20 +0100
Message-ID: <CABPqkBTWqPNhMBEsLmto+3=2FYjyy_b2hzq2KLbKWDFSKNktsg@mail.gmail.com>
Subject: Re: [PATCH] perf_event: fix loss of notification with multi-event sampling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 2:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-11-22 at 14:15 +0100, Stephane Eranian wrote:
>
>> > Ah, could it be a race of poll()/wakeup() vs perf_event_set_output() ?
>> >
>> Are you saying that by dropping event->waitq in favor of event->rb->waitq
>> we make this problem disappear due to rcu protections?
>
> Well, except..
>
>> Poll_wait() is a blocking call. It may wait on a stale waitq.  But that problem
>> was probably already there. I am not clear as to what to do about that.
>> in perf_set_output() you would need to wakeup from poll_wait() and then
>> go back in with the new waitq.
>
> Right, the whole blocking thing is a problem, and the whole poll()
> interface always makes my head hurt.
>
> If there was a go-sleep and wake-up side to poll we could do
> ring_buffer_get()/put() and fix this problem, but I'm not finding a way
> to make that happen quite yet.
>
>> Similarly, I am not clear as to what happens when you close an event for
>> which you have  a waiter in poll_wait(). I assume you wakeup from it.
>> But I don't see where that's implemented.
>
> Good point, yes we should do that.
>
So I did run some checks on the behavior of poll() in case a polled fd is
closed. It appears that you don't get out of it in all cases. It depends on
the nature of the file. I believe you get out of poll() ONLY in case of a
producer-consumer file descriptor pair, e.g., a pipe, named pipe, socket.
In other words you need to have a producer file descriptor. In case the
producer is closed, the reader waiting in poll() returns with a POLLHUP
flag. I did verify that for named pipes: close the writer, and the reader
comes out of poll.

In the case of perf_event, we are not in a producer-consumer model, so
it seems like the behavior we have now is correct. The caller of poll()
gets stuck if the file descriptor is closed.
