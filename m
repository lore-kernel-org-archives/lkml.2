Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab1DAPwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:52:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723Ab1DAPwS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:52:18 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
 <AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
 <AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
 <alpine.LSU.2.00.1103182158200.18771@sister.anvils> <BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Apr 2011 08:44:50 -0700
Message-ID: <AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 7:34 AM, Robert Święcki <robert@swiecki.net> wrote:
>
> Hey, I'll apply your patch and check it out. In the meantime I
> triggered another Oops (NULL-ptr deref via sys_mprotect).
>
> The oops is here:
>
> http://alt.swiecki.net/linux_kernel/sys_mprotect-2.6.38.txt

That's not a NULL pointer dereference. That's a BUG_ON().

And for some reason you've turned off the BUG_ON() messages, saving
some tiny amount of memory.

Anyway, it looks like the first BUG_ON() in vma_prio_tree_add(), so it
would be this one:

        BUG_ON(RADIX_INDEX(vma) != RADIX_INDEX(old));

but it is possible that gcc has shuffled things around (so it _might_
be the HEAP_INDEX() one). If you had CONFIG_DEBUG_BUGVERBOSE=y, you'd
get a filename and line number. One reason I hate -O2 in cases like
this is that the basic block movement makes it way harder to actually
debug things. I would suggest using -Os too (CONFIG_OPTIMIZE_FOR_SIZE
or whatever it's called).

Anyway, I do find it worrying. The vma code shouldn't be this fragile.  Hugh?

I do wonder what triggers this. Is it a huge-page vma? We seem to be
lacking the check to see that mprotect() is on a hugepage boundary -
and that seems bogus. Or am I missing some check? The new transparent
hugepage support splits the page, but what if it's a _static_ hugepage
thing?

But why would that affect the radix_index thing? I have no idea. I'd
like to blame the anon_vma rewrites last year, but I can't see why
that should matter either. Again, hugepages had some special rules, I
think (and that would explain why nobody normal sees this).

Guys, please give this one a look.

                          Linus
