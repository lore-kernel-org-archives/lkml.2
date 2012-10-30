Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726Ab2J3VbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:31:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933973Ab2J3VbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:31:09 -0400
Date: Tue, 30 Oct 2012 14:31:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/5] mm, highmem: remove useless pool_lock
Message-Id: <20121030143107.ee1f959b.akpm@linux-foundation.org>
In-Reply-To: <1351451576-2611-3-git-send-email-js1304@gmail.com>
References: <Yes>
	<1351451576-2611-1-git-send-email-js1304@gmail.com>
	<1351451576-2611-3-git-send-email-js1304@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 04:12:53 +0900
Joonsoo Kim <js1304@gmail.com> wrote:

> The pool_lock protects the page_address_pool from concurrent access.
> But, access to the page_address_pool is already protected by kmap_lock.
> So remove it.

Well, there's a set_page_address() call in mm/page_alloc.c which
doesn't have lock_kmap().  it doesn't *need* lock_kmap() because it's
init-time code and we're running single-threaded there.  I hope!

But this exception should be double-checked and mentioned in the
changelog, please.  And it's a reason why we can't add
assert_spin_locked(&kmap_lock) to set_page_address(), which is
unfortunate.


The irq-disabling in this code is odd.  If ARCH_NEEDS_KMAP_HIGH_GET=n,
we didn't need irq-safe locking in set_page_address().  I guess we'll
need to retain it in page_address() - I expect some callers have IRQs
disabled.


ARCH_NEEDS_KMAP_HIGH_GET is a nasty looking thing.  It's ARM:

/*
 * The reason for kmap_high_get() is to ensure that the currently kmap'd
 * page usage count does not decrease to zero while we're using its
 * existing virtual mapping in an atomic context.  With a VIVT cache this
 * is essential to do, but with a VIPT cache this is only an optimization
 * so not to pay the price of establishing a second mapping if an existing
 * one can be used.  However, on platforms without hardware TLB maintenance
 * broadcast, we simply cannot use ARCH_NEEDS_KMAP_HIGH_GET at all since
 * the locking involved must also disable IRQs which is incompatible with
 * the IPI mechanism used by global TLB operations.
 */
#define ARCH_NEEDS_KMAP_HIGH_GET
#if defined(CONFIG_SMP) && defined(CONFIG_CPU_TLB_V6)
#undef ARCH_NEEDS_KMAP_HIGH_GET
#if defined(CONFIG_HIGHMEM) && defined(CONFIG_CPU_CACHE_VIVT)
#error "The sum of features in your kernel config cannot be supported together"
#endif
#endif

