Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab0FINdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 09:33:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:46309 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab0FINdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 09:33:03 -0400
Subject: Re: [PATCH 10/28] mm: Make use of the anon_vma ref count
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100609132245.GF5650@csn.ul.ie>
References: <20100607110654.606530953@chello.nl>
	 <20100607111407.309924253@chello.nl>  <20100609132245.GF5650@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Jun 2010 15:32:27 +0200
Message-ID: <1276090347.1645.582.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 14:22 +0100, Mel Gorman wrote:
> This comment is no longer strictly correct. anon_vma_alloc() can also be
> called from anon_vma_fork where the root of the newly allocated anon_vma
> will be set to the same as the parents anon_vma. Maybe something like
> 
> /*
>  * Initialise the anon_vma root to point to itself. If called from
>  * fork, the root will be reset to the parents anon_vma 
>  */

Sure, I'll change the comment.

> Else, just leave the initialisation of the root where it was but only
> init the refcount here.

Ah, that would lead to problems. We use put_anon_vma() to free in the
create error path, and __put_anon_vma() will also check the
anon_vma->root, so by not setting it the error path will explode.
