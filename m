Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0DFXmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:42:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757782Ab0DFXmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:42:16 -0400
Date: Tue, 6 Apr 2010 16:37:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <20100406225925.GA3446@liondog.tnic>
Message-ID: <alpine.LFD.2.00.1004061630410.3487@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org> <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org> <20100406194238.GB20357@a1.tnic> <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org> <20100406205123.GC20357@a1.tnic> <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
 <20100406225925.GA3446@liondog.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Borislav Petkov wrote:
> +
> +	if (!anon_vma->head.next) {
> +		printk(KERN_ERR "NULL anon_vma->head.next, page %lu\n",
> +				page_to_pfn(page));
> +
> +		object_err(anon_vma_cachep, page, (u8 *)anon_vma, "NULL next");

Oh, and since the debugging code never triggered ('head.next' wasn't 
actually NULL), you never got here, but the 'page' you passed in to 
object_error() should be the page of the slab allocation, not the page 
associated with the anon_vma.

So it should be something like "virt_to_head_page(anon_vma)" that you pass 
in to object_err().

Not that it matters. I assume it is the fact that SLAB debugging is on 
that actually turns the NULL into a non-NULL thing. Poisoning is not 
active for SLUb's with constructors or RCU-freeing, but things like 
redzoning still are. So enabling SLUB debugging will change the offsets 
within the pages of all the SLUB allocations.  I wonder if that's just 
what caused it to now have that 0x002e2e2e002e2e2e instead of NULL.

		Linus
