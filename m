Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1KWPwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:52:11 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61683 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab1KWPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:52:09 -0500
MIME-Version: 1.0
In-Reply-To: <4ECC40B0.5040108@redhat.com>
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
	<4ECB6D60.1010702@redhat.com>
	<CAG6tG3xTkW1J=6xmUmmJoswJyR6ii5RDXvAsYrcH0CkVuUmJrQ@mail.gmail.com>
	<4ECC40B0.5040108@redhat.com>
Date: Wed, 23 Nov 2011 10:52:08 -0500
Message-ID: <CAG6tG3y7gX=xdyJnTgGnyRix961eLiz1HOZC0iYTx-gXiiyQog@mail.gmail.com>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: Robert Love <rlove@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Johannes Weiner <jweiner@redhat.com>, Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rik.

On Tue, Nov 22, 2011 at 7:39 PM, Rik van Riel <riel@redhat.com> wrote:
> At first glance, it sounds like a great idea to have a program
> like Firefox create a new object for every tab.
>
> However, this quickly runs into the practical problem that
> Firefox does not know in advance how much memory each tab will
> require.
>
> Without a good way to size each mapping in advance, it may not
> be practical to group related bits of memory together.

On Android (and Firefox for Android for that matter) we manage just
about every resource (such as images, rendered web pages, etc) through
ashmem. I don't recall the details of how the various subsystems that
utilize ashmem decide whether to use a mapping-per-object versus
packing multiple objects into a single mapping, but it works.

> Never mind that it would require userspace programs to grow new
> memory allocators...

Agreed.

> Yes, this characterization is correct.
>
> Note how in the object I proposed, when there is no memory
> pressure, userspace can hold on to freed pages and quickly
> reuse them for something else.
>
> There is no need for pages to be handed back to the kernel,
> and then zeroed again when they get handed back to userspace
> later on.

Agreed, this is a nice benefit. However, couldn't user-space do the
same thing now with MADV_DONTNEED?

I do think we have two different features here, and we may want both.

I'm concerned your proposal isn't ideal for Android or similar
systems. It is heavy, and will involve too much process involvement.
Remember, these systems are always running at memory capacity and are
constantly LRU-freeing small amounts of pages. Having a way to say to
the kernel, "you can toss these pages if you must, just let me know
later if I try to reuse them" -- in a way that is very simple and very
cheap -- is really valuable.

> There is also no need to write a new memory allocator for
> programs that want to pack related objects together in one
> _VOLATILE mapping.
>
> The reason is that, on memory pressure, any arbitrary set of
> pages can be nuked from userspace, so any memory allocator will
> be compatible.

In ashmem, you can pin and unpin any arbitrary set of pages. You don't
have to pin the whole mapping, allowing user-space to pack arbitrary
mappings into a single mapping and have the kernel jettison only the
unused objects.

>> That last point, btw, is why user-space developers like ashmem: It fits
>> their models of how they do work. They pin/unpin objects as part of
>> their normal access and repopulating is tied into the re-pin path, which
>> is where it makes sense.
>
> Which userspace programs work that way already?

What I mean is, user-space implicitly (if not explicitly) has get and
put methods via things like reference counting, locking & unlocking,
or the RAII pattern. And user-space already has a concept of "populate
this object." So adding ashmem pin and unpin calls is often very
simple, because the ashmem use case maps very nicely on top of how
user-space applications are already managing resources.

      Robert
