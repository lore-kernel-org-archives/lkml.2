Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1EEGGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 02:06:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50766 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab1EEGGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 02:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Tc4fBfFOdmU3lyYR2YhP1nr1G5UXVzyWT4FTdnIipRNw9KyfGHKcV6TCtrcx923GJb
         2DOAVHCYAGsWO5lltm3A==
MIME-Version: 1.0
In-Reply-To: <BANLkTimMvEyzG-S=S6R4fVsui-9ok63jwg@mail.gmail.com>
References: <1304467520-31530-1-git-send-email-vnagarnaik@google.com>
 <BANLkTimorXOLcvB2dwXMAH8n2UU-C2ntcA@mail.gmail.com> <20110504212635.GE1804@nowhere>
 <BANLkTimMvEyzG-S=S6R4fVsui-9ok63jwg@mail.gmail.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 4 May 2011 23:05:41 -0700
Message-ID: <BANLkTi=Y9zRnzouBKq9NnXZE5+FmXAWyfg@mail.gmail.com>
Subject: Re: [PATCH] trace: Check for waiting readers before calling wakeup()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 8:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, May 4, 2011 at 2:26 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> On Wed, May 04, 2011 at 02:21:28PM -0700, Vaibhav Nagarnaik wrote:
>>> Steven, Frederic
>>>
>>> Does this patch look ok?
>>>
>>> Vaibhav Nagarnaik
>>>
>>
>> No problem for me. I'll let Steve give the last word.
>
> Almost every time somebody does this optimization, there's a race.
>
> The thing is, because waitqueue_active() implies no barriers, if there
> is somebody adding itself to the waitqueue just at the same time as
> somebody is waking things up, the waiter may lose wakeup events -
> there is no memory barriers to guarantee that the waker will see
> either the waiter, or the waiter will see the event that it waited
> for.
>
> I dunno. It's sometimes safe, but it's equally often not safe unless
> there is some other locking around the thing. So I'd be a bit nervous.
> The tracer people would need to do some serious thinking about it.
>
>                   Linus
>

Thanks for looking at the patch and weighing in.

The problem I was trying to solve here is the contention when trying
to wake up a process. The process calling wakeup() has to take a
spinlock. When concurrent processes are getting traced, they contend
on locking the spinlock and cause large tracing latency. Having safe
locking around this code would defeat the purpose of this patch.

One could argue that if the trace reader does not get a wakeup() event
due to race, it will get it when the tracepoint is hit the next time.

Also, it seems the current tracers cannot rely on polling on the trace
file. The wakeup() is called only when the syscalls get traced. If any
other events are traced, the trace logging function (in
include/linux/syscalls.h) does not call wakeup(). This was done due to
hard lockup in the kernel if sched events were being traced.

I am new to this area, so Frederic and/or Steven could address your
concerns better.



Vaibhav Nagarnaik
