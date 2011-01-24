Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1AXMV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 07:21:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1AXMV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:21:27 -0500
Subject: Re: [PATCH 00/21] mm: Preemptibility -v6
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Nick Piggin <npiggin@kernel.dk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1295624034.28776.303.camel@laptop>
References: <20101126143843.801484792@chello.nl>
	 <alpine.LSU.2.00.1101172301340.2899@sister.anvils>
	 <1295457039.28776.137.camel@laptop>
	 <alpine.LSU.2.00.1101201052060.1603@sister.anvils>
	 <1295624034.28776.303.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Jan 2011 13:21:54 +0100
Message-ID: <1295871714.28776.406.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 16:33 +0100, Peter Zijlstra wrote:

> Index: linux-2.6/mm/rmap.c
> ===================================================================
> --- linux-2.6.orig/mm/rmap.c
> +++ linux-2.6/mm/rmap.c
> @@ -1559,9 +1559,20 @@ void __put_anon_vma(struct anon_vma *ano
>  	 * Synchronize against page_lock_anon_vma() such that
>  	 * we can safely hold the lock without the anon_vma getting
>  	 * freed.
> +	 *
> +	 * Relies on the full mb implied by the atomic_dec_and_test() from
> +	 * put_anon_vma() against the full mb implied by mutex_trylock() from
> +	 * page_lock_anon_vma(). This orders:
> +	 *
> +	 * page_lock_anon_vma()		VS	put_anon_vma()
> +	 *   mutex_trylock()			  atomic_dec_and_test()
> +	 *   smp_mb()				  smp_mb()
> +	 *   atomic_read()			  mutex_is_locked()

Bah!, I thought all mutex_trylock() implementations used an atomic op
with return value (which implies a mb), but it looks like (at least*)
PPC doesn't and only provides a LOCK barrier.


* possibly ARM and SH don't either, but I can't read either ASMs well
enough to tell.

