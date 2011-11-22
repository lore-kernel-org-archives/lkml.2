Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1KVO2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:28:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42889 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab1KVO2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:28:23 -0500
MIME-Version: 1.0
In-Reply-To: <CABPqkBQLvZ1VY6Xn+X2Tw_+dXvfZe8zqvqqyLVuBpkjNYOVuyA@mail.gmail.com>
References: <20111116145320.GA20146@quad>
	<1321958457.5148.17.camel@twins>
	<CABPqkBT-ZPZC2Ku6NjyMygWUU+kMr3h9FCdKTAjvhR6ywFmNqw@mail.gmail.com>
	<1321968559.14799.2.camel@twins>
	<CABPqkBQLvZ1VY6Xn+X2Tw_+dXvfZe8zqvqqyLVuBpkjNYOVuyA@mail.gmail.com>
Date: Tue, 22 Nov 2011 15:28:02 +0100
Message-ID: <CABPqkBT+XT4Oq9p0aquJgFZy8DBVudamFU4jRZqmdLUDR-Cpqg@mail.gmail.com>
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

On Tue, Nov 22, 2011 at 3:13 PM, Stephane Eranian <eranian@google.com> wrote:
> On Tue, Nov 22, 2011 at 2:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, 2011-11-22 at 14:15 +0100, Stephane Eranian wrote:
>>
>>> > Ah, could it be a race of poll()/wakeup() vs perf_event_set_output() ?
>>> >
>>> Are you saying that by dropping event->waitq in favor of event->rb->waitq
>>> we make this problem disappear due to rcu protections?
>>
>> Well, except..
>>
>>> Poll_wait() is a blocking call. It may wait on a stale waitq.  But that problem
>>> was probably already there. I am not clear as to what to do about that.
>>> in perf_set_output() you would need to wakeup from poll_wait() and then
>>> go back in with the new waitq.
>>
>> Right, the whole blocking thing is a problem, and the whole poll()
>> interface always makes my head hurt.
>>
>> If there was a go-sleep and wake-up side to poll we could do
>> ring_buffer_get()/put() and fix this problem, but I'm not finding a way
>> to make that happen quite yet.
>>
>>> Similarly, I am not clear as to what happens when you close an event for
>>> which you have  a waiter in poll_wait(). I assume you wakeup from it.
>>> But I don't see where that's implemented.
>>
>> Good point, yes we should do that.
>>
> I looked at how this is done for regular files: eventpoll_release(file);

Well, but's that called as part of __fput(), which is called before
fops->release().
So it should do it, unless you have to set some more flags in poll(),
i.e., more than
POLLIN.
