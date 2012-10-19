Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422669Ab2JSQjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:39:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:51825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab2JSQjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:39:18 -0400
Message-ID: <1350664742.2768.40.camel@twins>
Subject: Re: question on NUMA page migration
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 19 Oct 2012 18:39:02 +0200
In-Reply-To: <5081777A.8050104@redhat.com>
References: <5081777A.8050104@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 11:53 -0400, Rik van Riel wrote:
> 
> If we do need the extra refcount, why is normal
> page migration safe? :) 

Its mostly a matter of how convoluted you make the code, regular page
migration is about as bad as you can get

Normal does:

  follow_page(FOLL_GET) +1

  isolate_lru_page() +1

  put_page() -1

ending up with a page with a single reference (for anon, or one extra
each for the mapping and buffer).

And while I suppose I could do a put_page() in migrate_misplaced_page()
that makes the function frob the page-count depending on the return
value.

I always try and avoid conditional locks/refs, therefore the code ends
up doing:

  page = vm_normal_page()
  if (page) {
    get_page()

    migrate_misplaced_page()

    put_page()
  }


where migrate_misplaced_page() does isolate_lru_page()/putback_lru_page,
and this leaves the page-count invariant.

We got a ref, therefore we must put a ref, is easier than we got a ref
and must put except when...
