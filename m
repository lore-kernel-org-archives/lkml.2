Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab2HHQ0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:26:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab2HHQ0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:26:08 -0400
Date: Wed, 8 Aug 2012 18:26:07 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Will Deacon <will.deacon@arm.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: hugetlb: flush dcache before returning zeroed huge
 page to userspace
Message-ID: <20120808162607.GA7885@dhcp22.suse.cz>
References: <20120709122523.GC4627@tiehlicka.suse.cz>
 <20120709141324.GK7315@mudshark.cambridge.arm.com>
 <alpine.LSU.2.00.1207091622470.2261@eggly.anvils>
 <20120710094513.GB9108@mudshark.cambridge.arm.com>
 <20120710104234.GI9108@mudshark.cambridge.arm.com>
 <20120711174802.GG13498@mudshark.cambridge.arm.com>
 <20120712111659.GF21013@tiehlicka.suse.cz>
 <20120712112645.GG2816@mudshark.cambridge.arm.com>
 <20120712115708.GG21013@tiehlicka.suse.cz>
 <20120807160337.GC16877@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807160337.GC16877@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 07-08-12 17:03:37, Will Deacon wrote:
> <resurrecting this thread>
> 
> On Thu, Jul 12, 2012 at 12:57:08PM +0100, Michal Hocko wrote:
> > On Thu 12-07-12 12:26:45, Will Deacon wrote:
> > > Well, the comment in linux/page-flags.h does state that:
> > > 
> > >  * PG_arch_1 is an architecture specific page state bit.  The generic code
> > >  * guarantees that this bit is cleared for a page when it first is entered into
> > >  * the page cache.
> > > 
> > > so it's not completely clear cut that the architecture should be responsible
> > > for clearing this bit when allocating pages from the hugepage pool.
> > 
> > I think the wording is quite clear. It guarantees it gets cleared not
> > clears it. So it is up to an arch specific functions called from the
> > generic code to do that.
> 
> If we have to do this in arch-specific functions then:
> 
> 	1. Where should we do it?
> 	2. Why don't we also do this for normal (non-huge) pages?

As you describe below, it is done during the page freeing but hugetlb
tries to be clever and it doesn't do the reinitialization when the page
is just returned back to the pool. We have arch_release_hugepage and 
arch_prepare_hugepage defined only for s390 and they are not called on
the way in resp. out of the pool because we do not want to pointlessly
go over ptep free&alloc cycle.
I guess the cleanest way is to hook into dequeue_huge_page_node and add
something like arch_clear_hugepage_flags.
-- 
Michal Hocko
SUSE Labs
