Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1G2Xa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 19:30:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3769 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1G2Xax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 19:30:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=bGxnZk9HT6ekbYP7HgnerRA/D1N25/M5cixxdntk5ouoFZMai8nvl2JVa8D7jPXDM
	9hG55VGW+OdkjX7uBkV+g==
MIME-Version: 1.0
In-Reply-To: <1311974602.21143.92.camel@gandalf.stny.rr.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
 <1311721194-12164-5-git-send-email-vnagarnaik@google.com> <1311974602.21143.92.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Jul 2011 16:30:20 -0700
Message-ID: <CAL26m8K8_55r_KZ9hc1ZPxvFTnnRzmjB0RH62OUB=Be0FjpcjQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] trace: Make removal of ring buffer pages atomic
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 2:23 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-07-26 at 15:59 -0700, Vaibhav Nagarnaik wrote:
>
>> +
>> +             } else if (((unsigned long)to_remove & ~RB_PAGE_HEAD) ==
>> +                                     (unsigned long)to_remove) {
>> +
>> +                     /* not a head page, just update the next pointer */
>> +                     ret = cmpxchg(&tail_page->next, to_remove, next_page);
>
> This is not, it wont work.
>
> You can *only* remove the HEAD from the ring buffer without causing
> issues.
>
> As you probably know, the trick is done with the list pointers. We or
> the pointer with 1 for head, and the writer will or it with 2 when it
> updates the page.
>
> This only works if we have a 1 or 2 here. Now if we try to do what you
> suggest, by starting with a 0, and ending with 0, we may fail. Between
> the  to_remove = tail_page->next and the cmpxchg(), the writer could
> easily move to the tail page, and you would never know it.
>
> Now we just removed the tail page with no idea that the write is on it.
> The writer could have also moved on to the next page, and we just
> removed the most recently recorded data.
>
> The only way to really make this work is to always get it from the HEAD
> page. If there's data there, we could just store it separately, so that
> the read_page can read from it first. We will still need to be careful
> with the writer on the page. But I think this is doable.
>
> That is, read the pages from head, if there's no data on it, simply
> remove the pages. If there is data, we store it off later. If the writer
> happens to be on the page, we will can check that. We could even
> continue to get pages, because we will be moving the header page with
> the cmpxchg, and the writer does that too. It will take some serious
> thought, but it is possible to do this.
>
> -- Steve

There should only be IRQs and NMIs that preempt this operation since
the removal operation of a cpu ring buffer is scheduled on keventd of
the same CPU. But you're right there is a race between reading the
to_remove pointer and cmpxchg() operation.

While we are trying to remove the head page, the writer could move to
the head page. Additionally, we will be adding complexity to manage data
from all the removed pages for read_page.

I discussed with David and here are some ways we thought to address
this:
1. After the cmpxchg(), if we see that the tail page has moved to
   to_remove page, then revert the cmpxchg() operation and try with the
   next page. This might add some more complexity and doesn't work with
   an interrupt storm coming in.
2. Disable/enable IRQs while removing pages. This won't stop traced NMIs
   though and we are now affecting the system behavior.
3. David didn't like this, but we could increment
   cpu_buffer->record_disabled to prevent writer from moving any pages
   for the duration of this process. If we combine this with disabling
   preemption, we would be losing traces from an IRQ/NMI context, but we
   would be safe from races while this operation is going on.

The reason we want to remove the pages after tail is to give priority to
empty pages first before touching any data pages. Also according to your
suggestion, I am not sure how to manage the data pages once they are
removed, since they cannot be freed and the reader might not be present
which will make the pages stay resident, a form of memory leak.



Vaibhav Nagarnaik
