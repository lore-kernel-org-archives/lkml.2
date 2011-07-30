Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1G3BMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 21:12:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59845 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1G3BMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 21:12:20 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=CRjEFeY9x6sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=_QjzcD7kFSR-eLiQn34A:9 a=bW5scL8riMTf5mwuv18A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=O9Z0s54ruV8lLMme:21 a=Fohq8CZbjUKCmIUc:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 4/5] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAL26m8K8_55r_KZ9hc1ZPxvFTnnRzmjB0RH62OUB=Be0FjpcjQ@mail.gmail.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
	 <1311721194-12164-5-git-send-email-vnagarnaik@google.com>
	 <1311974602.21143.92.camel@gandalf.stny.rr.com>
	 <CAL26m8K8_55r_KZ9hc1ZPxvFTnnRzmjB0RH62OUB=Be0FjpcjQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 21:12:17 -0400
Message-ID: <1311988337.21143.107.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 16:30 -0700, Vaibhav Nagarnaik wrote:
> On Fri, Jul 29, 2011 at 2:23 PM, Steven Rostedt <rostedt@goodmis.org> wrote:

> There should only be IRQs and NMIs that preempt this operation since
> the removal operation of a cpu ring buffer is scheduled on keventd of
> the same CPU. But you're right there is a race between reading the
> to_remove pointer and cmpxchg() operation.

Bah, this is what I get for reviewing patches and doing other work at
the same time. I saw the work/completion set up, but it didn't register
to me that this was calling schedule_work_on(cpu..). 

But that said, I'm not sure I really like that. This still seems a bit
too complex.

> 
> While we are trying to remove the head page, the writer could move to
> the head page. Additionally, we will be adding complexity to manage data
> from all the removed pages for read_page.
> 
> I discussed with David and here are some ways we thought to address
> this:
> 1. After the cmpxchg(), if we see that the tail page has moved to
>    to_remove page, then revert the cmpxchg() operation and try with the
>    next page. This might add some more complexity and doesn't work with
>    an interrupt storm coming in.

Egad no. That will just make things more complex, and harder to verify
is correct.

> 2. Disable/enable IRQs while removing pages. This won't stop traced NMIs
>    though and we are now affecting the system behavior.
> 3. David didn't like this, but we could increment
>    cpu_buffer->record_disabled to prevent writer from moving any pages
>    for the duration of this process. If we combine this with disabling
>    preemption, we would be losing traces from an IRQ/NMI context, but we
>    would be safe from races while this operation is going on.
> 
> The reason we want to remove the pages after tail is to give priority to
> empty pages first before touching any data pages. Also according to your
> suggestion, I am not sure how to manage the data pages once they are
> removed, since they cannot be freed and the reader might not be present
> which will make the pages stay resident, a form of memory leak.

They will be freed when they are eventually read. Right, if there's no
reader, then they will not be freed, but that isn't really a true memory
leak. It is basically just like we didn't remove the pages, but I do not
consider this a memory leak. The pages are just waiting to be reclaimed,
and will be freed on any reset of the ring buffer.

Anyway, the choices are:

* Remove from the HEAD and use the existing algorithm that we've been
using since 2008. This requires a bit of accounting on the reader side,
but nothing too complex.

Pros: Should not have any major race conditions. Requires no
schedule_work_on() calls. Uses existing algorithm

Cons: Can keep pages around if no reader is present, and ring buffer is
not reset.

* Read from tail. Modify the already complex but tried and true lockless
algorithm.

Pros: Removes empty pages first.

Cons: Adds a lot more complexity to a complex system that has been
working since 2008.


The above makes me lean towards just taking from HEAD.

If you are worried about leaked pages, we could even have a debugfs file
that lets us monitor the pages that are pending read, and have the user
(or application) be able to flush them if they see the ring buffer is
full anyway.

-- Steve



