Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab1KVQbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:31:34 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38785 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab1KVQbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:31:33 -0500
MIME-Version: 1.0
In-Reply-To: <4ECB6D60.1010702@redhat.com>
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
	<4ECB6D60.1010702@redhat.com>
Date: Tue, 22 Nov 2011 11:31:32 -0500
Message-ID: <CAG6tG3y+C4815b=bByU7ZeOVE9o1g71QoSpRRUud5jcDFqK_Ow@mail.gmail.com>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: Robert Love <rlove@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, thanks to John for driving this. I'd love to see something like
ashmem's cache functionality in Linux.

Comments inline:

On Tue, Nov 22, 2011 at 4:37 AM, Rik van Riel <riel@redhat.com> wrote:
> 1) How do you tell userspace some of its data got
>   discarded?

This is my big question, too. This must be addressed to make this
usable by user-space. Unfortunately there isn't a side channel
available in madvise or fadvise.

The ashmem use case is like this:

1. Create an ashmem mapping. All pages start off pinned.
2. Populate pages
3. Use pages.
4. Unpin some or all pages.
5. Re-pin pages. Return value tells you if they were jettisoned. If
so, goto #2. If not, goto #3.

> 2) How do you prevent the situation where every
>   volatile object gets a few pages discarded, making
>   them all unusable?
>   (better to throw away an entire object at once)

In ashmem, I prevent this by jettisoning pages in units of unpinned
chunks, ordered by least-recently-unpinned. Since pinned/unpinned
chunks tend to relate to user-space objects (e.g. you'd unpin a whole
image), you end up throwing away the entire user-space object.

Put another way, the eviction algorithm is least-recently-unpinned
chunk, not least-recently-unpinned page, which prevents thrashing lots
of objects. An alternative would be to toss not whole chunks, but
whole mappings.

> 3) Isn't it too slow for something like Firefox to
>   create a new tmpfs object for every single throw-away
>   cache object?

Nope, although user-space might want to create larger mappings and
sub-divide them if its objects are *really* small.

> Johannes, Jon and I have looked at an alternative way to
> allow the kernel and userspace to cooperate in throwing
> out cached data.  This alternative way does not touch
> the alloc/free fast path at all, but does require some
> cooperation at "shrink cache" time.

I'm open to whatever works, and I need to think about your proposal
more, but it sounds inferior to the model John is proposing.

I think we can sum the two models up as,

- User-space pins, unpins objects, and kernel handles eviction
- Kernel lets user-space register callbacks for notification during
cache shrink, user handles eviction

Right?

Actually, I can see the need for both. But the first is simpler, lets
the kernel evict pages from user-space even in low memory situations
(since you can call the cache shrinker atomically), and relies on the
fact that the "free caches" action is just jettisoning the pages, so
the kernel can do it. The actual work is in repopulating the caches.

That last point, btw, is why user-space developers like ashmem: It
fits their models of how they do work. They pin/unpin objects as part
of their normal access and repopulating is tied into the re-pin path,
which is where it makes sense.

In a callback model, you have two issues: One, user-space needs to do
its own jettisoning. Two, user-space now needs to keep track of
whether an object was jettisoned and repopulate it (when? on next use?
now you have user-space reimplementing the pin/unpin logic, right?).

         Robert
