Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab0K2RBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:01:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab0K2RBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:01:05 -0500
Date: Mon, 29 Nov 2010 17:59:25 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 18 of 66] add pmd mangling functions to x86
Message-ID: <20101129165925.GF24474@random.random>
References: <patchbomb.1288798055@v2.random>
 <c681aaa016f2bd9ce393.1288798073@v2.random>
 <20101118130446.GO8135@csn.ul.ie>
 <20101126175751.GY6118@random.random>
 <20101129102310.GC13268@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129102310.GC13268@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 10:23:11AM +0000, Mel Gorman wrote:
> > > > @@ -353,7 +353,7 @@ static inline unsigned long pmd_page_vad
> > > >   * Currently stuck as a macro due to indirect forward reference to
> > > >   * linux/mmzone.h's __section_mem_map_addr() definition:
> > > >   */
> > > > -#define pmd_page(pmd)	pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT)
> > > > +#define pmd_page(pmd)	pfn_to_page((pmd_val(pmd) & PTE_PFN_MASK) >> PAGE_SHIFT)
> > > >  
> > > 
> > > Why is it now necessary to use PTE_PFN_MASK?
> > 
> > Just for the NX bit, that couldn't be set before the pmd could be
> > marked PSE.
> > 
> 
> Sorry, I still am missing something. PTE_PFN_MASK is this
> 
> #define PTE_PFN_MASK            ((pteval_t)PHYSICAL_PAGE_MASK)
> #define PHYSICAL_PAGE_MASK      (((signed long)PAGE_MASK) & __PHYSICAL_MASK)
> 
> I'm not seeing how PTE_PFN_MASK affects the NX bit (bit 63).

It simply clears it by doing & 0000... otherwise bit 51 would remain
erroneously set on the pfn passed to pfn_to_page.

Clearing bit 63 wasn't needed before because bit 63 couldn't be set on
a not huge pmd.
