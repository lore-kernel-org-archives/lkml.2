Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0DIJ5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:57:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:45348 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0DIJ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:57:07 -0400
Subject: Re: [PATCH 05/13] mm: Make use of the anon_vma ref count
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Ehrhardt <uni@c--e.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100409070416.GA14118@lisa.in-ulm.de>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.815377075@chello.nl>
	 <20100409070416.GA14118@lisa.in-ulm.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 11:57:00 +0200
Message-ID: <1270807020.20295.3299.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 09:04 +0200, Christian Ehrhardt wrote:
> Hi,
> 
> On Thu, Apr 08, 2010 at 09:17:42PM +0200, Peter Zijlstra wrote:
> > @@ -302,23 +307,33 @@ again:
> >  		goto out;
> >  
> >  	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
> > -	spin_lock(&anon_vma->lock);
> > +	if (!atomic_inc_not_zero(&anon_vma->ref))
> > +		anon_vma = NULL;
> >  
> >  	if (page_rmapping(page) != anon_vma) {
> > -		spin_unlock(&anon_vma->lock);
> > +		anon_vma_put(anon_vma);
> >  		goto again;
> >  	}
> 
> AFAICS anon_vma_put might be called with anon_vma == NULL here which
> will oops on the ref count. Not sure if
> 
>      page_rmapping(page) == anon_vma == NULL 
> 
> is possible, too.

Gah, you're right, thanks!

