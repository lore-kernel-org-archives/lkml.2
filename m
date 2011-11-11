Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1KKIPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 03:15:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab1KKIPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 03:15:20 -0500
Date: Fri, 11 Nov 2011 09:15:18 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 2/3] tile: remove irqsave pgd_lock locking
Message-ID: <20111111081518.GB29463@tiehlicka.suse.cz>
References: <1320853639-18048-1-git-send-email-mhocko@suse.cz>
 <1320853639-18048-2-git-send-email-mhocko@suse.cz>
 <4EBC1CDD.1020608@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBC1CDD.1020608@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-11-11 13:50:05, Chris Metcalf wrote:
> On 11/9/2011 10:47 AM, Michal Hocko wrote:
> >a79e53d8: x86/mm: Fix pgd_lock deadlock dropped irqsave locking to fix a
> >deadlock. pgd_lock is not used from an irq context so we can drop
> >irqsave locking here as well.
> >The original patch was x86 only but the same applies here
> >because pgd_ctor (aka mm_alloc_pgd), pgd_dtor (aka mm_free_pgd),
> >shatter_huge_page (not used anywhere) and vmalloc_sync_all are not used
> >from an interrupt contexts.
> 
> In fact, shatter_huge_page() is used by some code in our internal
> version of arch/tile/mm/homecache.c that we haven't yet pushed back
> to the community, and that CAN be called from an interrupt context.
> (For example, we may shatter a huge page to dynamically change the
> "home cache" of a small page when it's allocated from the page
> allocator, causing us to need to map all the memory under the old
> huge page with separate small pages that can now each carry separate
> "home cache" locations for those pages.)

OK

> 
> We don't suffer from the x86 deadlock risk, since we handle TLB
> flushing using our hypervisor API, flush_remote(), which doesn't pay
> attention to the irq-disabled state on the remote core.

this deserves a comment in the code

> 
> So this patch would not be safe for our architecture, but thanks for
> exploring the possibility.  I'll add some comments explaining this
> (at the definition of pgd_lock) to avoid confusion in the future.

great

> In fact, reviewing the shatter_huge_page() code, I realize I should
> hold init_mm.page_table_lock as well as pgtable_lock to guard
> against another thread updating init_mm in parallel; I think this is
> only a theoretical issue but I'll add the locking to be consistent.
> 
> -- 
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
