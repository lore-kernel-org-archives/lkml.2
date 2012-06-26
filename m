Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab2FZIcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:32:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:58227 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525Ab2FZIcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:32:17 -0400
Message-ID: <1340699507.21991.32.camel@twins>
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, minchan@gmail.com,
        kosaki.motohiro@gmail.com, andi@firstfloor.org, hannes@cmpxchg.org,
        mel@csn.ul.ie, linux-kernel@vger.kernel.org, danielfsantos@att.net
Date: Tue, 26 Jun 2012 10:31:47 +0200
In-Reply-To: <4FE8DD80.9040108@redhat.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	     <1340315835-28571-2-git-send-email-riel@surriel.com>
	    <1340359115.18025.57.camel@twins> <4FE47D0E.3000804@redhat.com>
	   <1340374439.18025.75.camel@twins> <4FE48054.5090407@redhat.com>
	  <1340375872.18025.77.camel@twins> <4FE4922D.8070501@surriel.com>
	 <1340652578.21991.18.camel@twins> <4FE8DD80.9040108@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 17:52 -0400, Rik van Riel wrote:
> The downside? This makes the rbtree code somewhat more
> complex, vs. the brute force walk up the tree the current
> augmented rbtree code does. 

Something like that should be in the git history of that code. See
b945d6b2554d55 ("rbtree: Undo augmented trees performance damage and
regression").

I removed that because it adds overhead to the scheduler fast paths, but
if we can all agree to move lib/rbtree.c into inlines in
include/linux/rbtree.h (possibly utilizing Daniel Santos' magic) then we
could do this again.

Anyway, doing the updates in the insertion/deletion might speed up
those, but you still have the regular modifications what don't do
insert/delete to think about.

If you look at your patch 1, __vma_unlink has an adjust_free_gap() right
next to the rb_augment_erase(), vma_adjust() has 3 adjust_free_gap()
calls right next to each other.

All these will do an entire path walk back to the root. I would think we
could save quite a bit of updating by not having them all walk back to
the root. No point in re-computing the top levels if you know the next
update will change them again anyway.
