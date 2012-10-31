Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423067Ab2JaPBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:01:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37786 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423015Ab2JaPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:01:50 -0400
MIME-Version: 1.0
In-Reply-To: <20121030143107.ee1f959b.akpm@linux-foundation.org>
References: <1351451576-2611-1-git-send-email-js1304@gmail.com>
	<1351451576-2611-3-git-send-email-js1304@gmail.com>
	<20121030143107.ee1f959b.akpm@linux-foundation.org>
Date: Thu, 1 Nov 2012 00:01:50 +0900
Message-ID: <CAAmzW4McRv5c4gVi7Ltn72jq7Kcmu8OSKLmcw-3iVKtb_PXejQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm, highmem: remove useless pool_lock
From: JoonSoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

2012/10/31 Andrew Morton <akpm@linux-foundation.org>:
> On Mon, 29 Oct 2012 04:12:53 +0900
> Joonsoo Kim <js1304@gmail.com> wrote:
>
>> The pool_lock protects the page_address_pool from concurrent access.
>> But, access to the page_address_pool is already protected by kmap_lock.
>> So remove it.
>
> Well, there's a set_page_address() call in mm/page_alloc.c which
> doesn't have lock_kmap().  it doesn't *need* lock_kmap() because it's
> init-time code and we're running single-threaded there.  I hope!
>
> But this exception should be double-checked and mentioned in the
> changelog, please.  And it's a reason why we can't add
> assert_spin_locked(&kmap_lock) to set_page_address(), which is
> unfortunate.

set_page_address() in mm/page_alloc.c is invoked only when
WANT_PAGE_VIRTUAL is defined.
And in this case, set_page_address()'s definition is not in highmem.c,
but in include/linux/mm.h.
So, we don't need to worry about set_page_address() call in mm/page_alloc.c

> The irq-disabling in this code is odd.  If ARCH_NEEDS_KMAP_HIGH_GET=n,
> we didn't need irq-safe locking in set_page_address().  I guess we'll
> need to retain it in page_address() - I expect some callers have IRQs
> disabled.

As Minchan described, if we don't disable irq when we take a lock for pas->lock,
it would be deadlock with page_address().
