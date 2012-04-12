Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2DLE3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab2DLE3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:29:40 -0400
Date: Thu, 12 Apr 2012 06:28:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: hlist_for_each_entry && pos (Was: task_work_queue)
Message-ID: <20120412042850.GA22354@redhat.com>
References: <20120412024751.GA17561@redhat.com> <20120412024810.GA17984@redhat.com> <20120412040059.GA20462@redhat.com> <CA+55aFyGsA5YPqrymJ8wwoS86SEeJh+X-dvfBTfo3gOTm73JNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyGsA5YPqrymJ8wwoS86SEeJh+X-dvfBTfo3gOTm73JNA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Linus Torvalds wrote:
>
> On Wed, Apr 11, 2012 at 9:00 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > This reminds me.
> >
> > hlist_for_each_entry_*() do not need "pos", it can be
> >
> >        #define hlist_for_each_entry(pos, head, member)                                 \
> >                for (pos = (void*)(head)->first;                 �	\
> >                pos && ({ pos = hlist_entry((void*)pos, typeof(*pos), member); 1; });   \
> >                pos = (void*)(pos)->member.next)
>
> Ugh. I'm not sure that is any better, with the extra casts to hide the
> fact that you use the wrong type pointers for it.
>
> Are there any code generation improvements?

Not sure, I'll check...

> Because quite frankly, if there aren't, I think the code churn just
> isn't worth it - especially with how ugly the macro is.

Ah, personally I think that "how ugly the macro" doesn't matter.
What does matter (imho again), it simplifies the usage.

> This is one of those things where the C99 features would actually be
> nice: one of the few features from C++ that I actually liked is the
> ability to declare the induction variable. So
>
>   #define hlist_for_each_entry(pos, head, member) \
>     for (void *__pos = (head)->first; \

Agreed. But,

	error: 'for' loop initial declaration used outside C99 mode

we should change CFLAGS, I guess. BTW, personally I'd like very much
to use "for (type var; ...")" if this was allowed.

> That said, "pretty macro" isn't very high
> on the list of things to worry about. Not nearly as high as the pain
> changing the interface would cause for things that *should* be trivial
> (like backporting patches etc).

Yes, agreed, that was the question.

> So I'd really want to see some more tangible advantage.

OK, I'll check the code generation just in case.

Oleg.

