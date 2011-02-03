Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1BCVka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:40:30 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57507 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab1BCVk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:40:29 -0500
Subject: Re: [RFC][PATCH 3/6] break out smaps_pte_entry() from
 smaps_pte_range()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <alpine.DEB.2.00.1102031315080.1307@chino.kir.corp.google.com>
References: <20110201003357.D6F0BE0D@kernel>
	 <20110201003401.95CFBFA6@kernel>
	 <alpine.DEB.2.00.1102031315080.1307@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 03 Feb 2011 13:40:23 -0800
Message-ID: <1296769223.8299.1658.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 13:22 -0800, David Rientjes wrote:
> On Mon, 31 Jan 2011, Dave Hansen wrote:
> > We will use smaps_pte_entry() in a moment to handle both small
> > and transparent large pages.  But, we must break it out of
> > smaps_pte_range() first.
> 
> The extraction from smaps_pte_range() looks good.  What's the performance 
> impact on very frequent consumers of /proc/pid/smaps, though, as the 
> result of the calls throughout the iteration if smaps_pte_entry() doesn't 
> get inlined (supposedly because you'll be reusing the extracted function 
> again elsewhere)?

We could try and coerce it in to always inlining it, I guess.  I just
can't imagine this changes the cost _that_ much.  Unless I have some
specific concers, I tend to leave this up to the compiler, and none of
the users look particularly fastpathy or performance sensitive to me.

...
> > -	}
> > +	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> > +	for (; addr != end; pte++, addr += PAGE_SIZE)
> > +		smaps_pte_entry(*pte, addr, walk);
> >  	pte_unmap_unlock(pte - 1, ptl);
> >  	cond_resched();
> >  	return 0;
> > diff -puN mm/huge_memory.c~break-out-smaps_pte_entry mm/huge_memory.c
> > _
> 
> Is there a missing change to mm/huge_memory.c?

Nope, it was just more of those empty diffs like in the last patch.
It's cruft from patch-scripts and some code that I use to ensure I don't
miss file edits when making patches.  I'll pull them out.

-- Dave

