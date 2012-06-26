Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2FZNqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:46:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:34212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab2FZNqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:46:15 -0400
Message-ID: <1340718349.21991.81.camel@twins>
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, minchan@gmail.com,
        kosaki.motohiro@gmail.com, andi@firstfloor.org, hannes@cmpxchg.org,
        mel@csn.ul.ie, linux-kernel@vger.kernel.org, danielfsantos@att.net
Date: Tue, 26 Jun 2012 15:45:49 +0200
In-Reply-To: <4FE9B3B4.1050305@redhat.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	      <1340315835-28571-2-git-send-email-riel@surriel.com>
	     <1340359115.18025.57.camel@twins> <4FE47D0E.3000804@redhat.com>
	    <1340374439.18025.75.camel@twins> <4FE48054.5090407@redhat.com>
	   <1340375872.18025.77.camel@twins> <4FE4922D.8070501@surriel.com>
	  <1340652578.21991.18.camel@twins> <4FE8DD80.9040108@redhat.com>
	 <1340699507.21991.32.camel@twins> <4FE9B3B4.1050305@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 09:05 -0400, Rik van Riel wrote:
> On 06/26/2012 04:31 AM, Peter Zijlstra wrote:
> 
> > If you look at your patch 1, __vma_unlink has an adjust_free_gap() right
> > next to the rb_augment_erase(), vma_adjust() has 3 adjust_free_gap()
> > calls right next to each other.
> >
> > All these will do an entire path walk back to the root. I would think we
> > could save quite a bit of updating by not having them all walk back to
> > the root. No point in re-computing the top levels if you know the next
> > update will change them again anyway.
> 
> The problem is, unless we look at the augmented data at
> rotate time, we do not know when it is safe to stop
> iterating up the tree.

argh,.. you're using adjust_vma_gap() for insertions instead of
rb_augment_insert().

I was going on the premise that you're doing updates for augmented data
without modifying the tree structure and that doing insert/delete will
keep the stuff up-to-date.

So now I'm not sure why you do if (insert) adjust_free_gap(insert),
since __insert_vm_struct(mm, insert) -> __vma_link() -> __vma_link_rb()
already does an augment update.


