Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab1KWAjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:39:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759169Ab1KWAjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:39:41 -0500
Message-ID: <4ECC40B0.5040108@redhat.com>
Date: Tue, 22 Nov 2011 19:39:12 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Robert Love <rlove@google.com>
CC: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Johannes Weiner <jweiner@redhat.com>, Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org> <4ECB6D60.1010702@redhat.com> <CAG6tG3xTkW1J=6xmUmmJoswJyR6ii5RDXvAsYrcH0CkVuUmJrQ@mail.gmail.com>
In-Reply-To: <CAG6tG3xTkW1J=6xmUmmJoswJyR6ii5RDXvAsYrcH0CkVuUmJrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 10:40 AM, Robert Love wrote:

>     3) Isn't it too slow for something like Firefox to
>        create a new tmpfs object for every single throw-away
>        cache object?
>
>
> Nope, although user-space might want to create larger mappings and
> sub-divide them if its objects are *really* small.

At first glance, it sounds like a great idea to have a program
like Firefox create a new object for every tab.

However, this quickly runs into the practical problem that
Firefox does not know in advance how much memory each tab will
require.

Without a good way to size each mapping in advance, it may not
be practical to group related bits of memory together.

Never mind that it would require userspace programs to grow new
memory allocators...

>     Johannes, Jon and I have looked at an alternative way to
>     allow the kernel and userspace to cooperate in throwing
>     out cached data.  This alternative way does not touch
>     the alloc/free fast path at all, but does require some
>     cooperation at "shrink cache" time.
>
>
> I'm open to whatever works, and I need to think about your proposal
> more, but it sounds inferior to the model John is proposing. I think we
> can sum the two models up as,
>
> - User-space pins, unpins objects, and kernel handles eviction
> - Kernel lets user-space register callbacks for notification during
> cache shrink, user handles eviction
>
> Right?

Yes, this characterization is correct.

Note how in the object I proposed, when there is no memory
pressure, userspace can hold on to freed pages and quickly
reuse them for something else.

There is no need for pages to be handed back to the kernel,
and then zeroed again when they get handed back to userspace
later on.

There is also no need to write a new memory allocator for
programs that want to pack related objects together in one
_VOLATILE mapping.

The reason is that, on memory pressure, any arbitrary set of
pages can be nuked from userspace, so any memory allocator will
be compatible.

> Actually, I can see the need for both. But the first is simpler, lets
> the kernel evict pages from user-space even in low memory situations
> (since you can call the cache shrinker atomically), and relies on the
> fact that the "free caches" action is just jettisoning the pages, so the
> kernel can do it. The actual work is in repopulating the caches.
>
> That last point, btw, is why user-space developers like ashmem: It fits
> their models of how they do work. They pin/unpin objects as part of
> their normal access and repopulating is tied into the re-pin path, which
> is where it makes sense.

Which userspace programs work that way already?

