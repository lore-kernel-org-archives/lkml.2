Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2DLEMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:12:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48302 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2DLEMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120412040059.GA20462@redhat.com>
References: <20120412024751.GA17561@redhat.com> <20120412024810.GA17984@redhat.com>
 <20120412040059.GA20462@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Apr 2012 21:12:19 -0700
X-Google-Sender-Auth: 3dYVr_c506rkMRJUgAdn66nnjfQ
Message-ID: <CA+55aFyGsA5YPqrymJ8wwoS86SEeJh+X-dvfBTfo3gOTm73JNA@mail.gmail.com>
Subject: Re: hlist_for_each_entry && pos (Was: task_work_queue)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 9:00 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> This reminds me.
>
> hlist_for_each_entry_*() do not need "pos", it can be
>
>        #define hlist_for_each_entry(pos, head, member)                                 \
>                for (pos = (void*)(head)->first;                                        \
>                pos && ({ pos = hlist_entry((void*)pos, typeof(*pos), member); 1; });   \
>                pos = (void*)(pos)->member.next)

Ugh. I'm not sure that is any better, with the extra casts to hide the
fact that you use the wrong type pointers for it.

Are there any code generation improvements?

Because quite frankly, if there aren't, I think the code churn just
isn't worth it - especially with how ugly the macro is.

This is one of those things where the C99 features would actually be
nice: one of the few features from C++ that I actually liked is the
ability to declare the induction variable. So

  #define hlist_for_each_entry(pos, head, member) \
    for (void *__pos = (head)->first; \
        __pos && ({ pos = hlist_entry(__pos, typeof(*pos), member); 1; });   \
        __pos = __pos->next)

would actually be prettier. That said, "pretty macro" isn't very high
on the list of things to worry about. Not nearly as high as the pain
changing the interface would cause for things that *should* be trivial
(like backporting patches etc).

So I'd really want to see some more tangible advantage.

                 Linus
