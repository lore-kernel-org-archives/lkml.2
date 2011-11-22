Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1KVN3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:29:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37239 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab1KVN3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:29:23 -0500
Message-ID: <1321968559.14799.2.camel@twins>
Subject: Re: [PATCH] perf_event: fix loss of notification with multi-event
 sampling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Tue, 22 Nov 2011 14:29:19 +0100
In-Reply-To: <CABPqkBT-ZPZC2Ku6NjyMygWUU+kMr3h9FCdKTAjvhR6ywFmNqw@mail.gmail.com>
References: <20111116145320.GA20146@quad> <1321958457.5148.17.camel@twins>
	 <CABPqkBT-ZPZC2Ku6NjyMygWUU+kMr3h9FCdKTAjvhR6ywFmNqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 14:15 +0100, Stephane Eranian wrote:

> > Ah, could it be a race of poll()/wakeup() vs perf_event_set_output() ?
> >
> Are you saying that by dropping event->waitq in favor of event->rb->waitq
> we make this problem disappear due to rcu protections?

Well, except..

> Poll_wait() is a blocking call. It may wait on a stale waitq.  But that problem
> was probably already there. I am not clear as to what to do about that.
> in perf_set_output() you would need to wakeup from poll_wait() and then
> go back in with the new waitq.

Right, the whole blocking thing is a problem, and the whole poll()
interface always makes my head hurt.

If there was a go-sleep and wake-up side to poll we could do
ring_buffer_get()/put() and fix this problem, but I'm not finding a way
to make that happen quite yet.

> Similarly, I am not clear as to what happens when you close an event for
> which you have  a waiter in poll_wait(). I assume you wakeup from it.
> But I don't see where that's implemented.

Good point, yes we should do that.
