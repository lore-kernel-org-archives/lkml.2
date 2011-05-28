Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab1E1VLO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 17:11:14 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55095
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723Ab1E1VLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 17:11:11 -0400
Subject: Re: [PATCH] mm: fix page_lock_anon_vma leaving mutex locked
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.LSU.2.00.1105281317090.13319@sister.anvils>
References: <alpine.LSU.2.00.1105281317090.13319@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 May 2011 23:14:30 +0200
Message-ID: <1306617270.2497.516.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 13:20 -0700, Hugh Dickins wrote:
> On one machine I've been getting hangs, a page fault's anon_vma_prepare()
> waiting in anon_vma_lock(), other processes waiting for that page's lock.
> 
> This is a replay of last year's f18194275c39
> "mm: fix hang on anon_vma->root->lock".
> 
> The new page_lock_anon_vma() places too much faith in its refcount: when
> it has acquired the mutex_trylock(), it's possible that a racing task in
> anon_vma_alloc() has just reallocated the struct anon_vma, set refcount
> to 1, and is about to reset its anon_vma->root.
> 
> Fix this by saving anon_vma->root, and relying on the usual page_mapped()
> check instead of a refcount check: if page is still mapped, the anon_vma
> is still ours; if page is not still mapped, we're no longer interested.

Interesting race.. but can we guarantee that the page didn't get
remapped meanwhile?

The updated comment by page_get_anon_vma() describes the lack of
serialization against page_remove_rmap() but fails to mention the
page_add_anon_rmap cases (bad me, I know I checked at the time, but
can't for the life of me remember what it was now).

_IFF_ we are serialized, your patch should suffice, since then
page_mapped() implies a >0 refcount, if not however, I think we need
both tests since in that case the page might be mapped again against a
different anon_vma and our current anon_vma (the one we locked against)
might have refcount == 0 and already be past the mutex_is_locked() test
in anon_vma_free(), at which point we're up shit creek since then the
anon_vma we're returning can disappear the moment we do
rcu_read_unlock().

Or am I delusional due to lack of sleep?

