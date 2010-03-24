Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0CXNzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:55:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:39763 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab0CXNzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:55:09 -0400
Subject: Re: [rfc][patch] mm: lockdep page lock
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100316022153.GJ2869@laptop>
References: <20100315155859.GE2869@laptop>
	 <20100315180759.GA7744@quack.suse.cz>  <20100316022153.GJ2869@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 14:54:59 +0100
Message-ID: <1269438899.5109.264.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 13:21 +1100, Nick Piggin wrote:
> > locking rule here is that we always lock pages in index increasing order. I
> > don't think lockdep will be able to handle something like that. Probably we
> > can just avoid lockdep checking in these functions (or just acquire the
> > page lock class for the first page) but definitely there will be some
> 
> You are right, I don't think lockdep would work with that, so just
> checking the lock for the first page should be better than nothing.
> It might require some lockdep support in order to add context so it
> doesn't go mad when unlock_page is called (would rather not add any
> page flags to track that).
> 
> If we were really clever and able to get back to the address of
> struct page that _is_ holding the lock, we could just do a simple
> check to ensure its index is < the index of the page we are trying
> to take.
> 
> That would give reasonable nesting checking without requiring lockdep
> to track new chains for every page (obviously not feasible).

Right, so lockdep does indeed not fancy such recursion things. Since the
page frames are static you could basically make each lock its own class,
but that will run lockdep out of chain storage real quick.

Another thing you can do is look at spin_lock_nest_lock() which
basically refcounts the class, you could do something like that for the
page frame class, where you teach lockdep about the index rule.


