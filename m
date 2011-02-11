Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1BKHDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 02:03:05 -0500
Received: from smtp-out.google.com ([216.239.44.51]:25438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1BKHDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 02:03:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=c4I3wgFwEzkBJPIyqOnktfLtvulpPior6RAPz9791MokF3H8FL50vdSW44lwGf/mCj
         hKZ5ZQfpeeK7abl74Fwg==
Date: Thu, 10 Feb 2011 23:02:50 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [mmotm] BUG: Bad page state in process khugepaged ?
In-Reply-To: <20110209200728.GQ3347@random.random>
Message-ID: <alpine.LSU.2.00.1102102243160.2331@sister.anvils>
References: <20110209151036.f24a36a6.kamezawa.hiroyu@jp.fujitsu.com> <20110209155001.0e369475.nishimura@mxp.nes.nec.co.jp> <20110209155246.69a7f3a1.kamezawa.hiroyu@jp.fujitsu.com> <20110209200728.GQ3347@random.random>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Andrea Arcangeli wrote:
> On Wed, Feb 09, 2011 at 03:52:46PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 9 Feb 2011 15:50:01 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > > 
> > > > In hex, pc->flags was 7A00000000004 and this means PCG_USED bit is set.
> > > > This implies page_remove_rmap() may not be called but ->mapping is NULL. Hmm?
> > > > (7A is encoding of section number.)
> > > > 
> > > Sigh.. it seems another freed-but-not-uncharged problem..
> > > 
> > 
> > Ah, ok, this is maybe caused by this. I'm sorry that I missed this.
> > ==
> > static inline int free_pages_check(struct page *page)
> > {
> >         if (unlikely(page_mapcount(page) |
> >                 (page->mapping != NULL)  |
> >                 (atomic_read(&page->_count) != 0) |
> >                 (page->flags & PAGE_FLAGS_CHECK_AT_FREE) |
> >                 (mem_cgroup_bad_page_check(page)))) {    <==========(*)
> >                 bad_page(page);
> >                 return 1;
> > ==
> > 
> > Then, ok, this is a memcgroup and hugepage issue.
> > 
> > I'll look into.
> 
> Yes, the rest of the info on the page looked ok and shouldn't have
> triggered a bad_page call. Thanks so much for looking into it.

There is a separate little issue here, Andrea.

Although we went to some trouble for bad_page() to take the page out
of circulation yet let the system continue, your VM_BUG_ON(!PageBuddy)
inside __ClearPageBuddy(page), from two callsites in bad_page(), is
turning it into a fatal error when CONFIG_DEBUG_VM.

You could that only MM developers switch CONFIG_DEBUG_VM=y, and they
would like bad_page() to be fatal; maybe, but if so we should do that
as an intentional patch, rather than as an unexpected side-effect ;)

I noticed this a few days ago, but hadn't quite decided whether just to
remove the VM_BUG_ON, or move it to __ClearPageBuddy's third callsite,
or... doesn't matter much.

I do also wonder if PageBuddy would better be _mapcount -something else:
if we've got a miscounted page (itself unlikely of course), there's a
chance that its _mapcount will be further decremented after it has been
freed: whereupon it will go from -1 to -2, PageBuddy at present.  The
special avoidance of PageBuddy being that it can pull a whole block of
pages into misuse if its mistaken.

Hugh
