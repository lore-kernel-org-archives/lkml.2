Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0GGGql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 02:46:41 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37197 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0GGGqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 02:46:40 -0400
Date: Wed, 7 Jul 2010 15:40:56 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] hugetlb: pin oldpage in page migration
Message-ID: <20100707064056.GA21962@spritzera.linux.bs1.fc.nec.co.jp>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1278049646-29769-6-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.DEB.2.00.1007061050320.4938@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007061050320.4938@router.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for your reviewing.

On Tue, Jul 06, 2010 at 10:54:38AM -0500, Christoph Lameter wrote:
> On Fri, 2 Jul 2010, Naoya Horiguchi wrote:
> 
> > This patch introduces pinning the old page during page migration
> > to avoid freeing it before we complete copying.
> 
> The old page is already pinned due to the reference count that is taken
> when the page is put onto the list of pages to be migrated. See
> do_move_pages() f.e.

OK.

> Huge pages use a different scheme?

Different scheme is in soft offline, where the target page is not pinned
before migration.  So I should have pinned in soft offline side.
I'll fix it.

> > This race condition can happen for privately mapped or anonymous hugepage.
> 
> It cannot happen unless you come up with your own scheme of managing pages
> to be migrated and bypass migrate_pages(). There you should take the
> refcount.

Yes.

> >  	/*
> > +	 * It's reasonable to pin the old page until unmapping and copying
> > +	 * complete, because when the original page is an anonymous hugepage,
> > +	 * it will be freed in try_to_unmap() due to the fact that
> > +	 * all references of anonymous hugepage come from mapcount.
> > +	 * Although in the other cases no problem comes out without pinning,
> > +	 * it looks logically correct to do it.
> > +	 */
> > +	get_page(page);
> > +
> > +	/*
> 
> Its already pinned. Dont do this. migrate_pages() relies on the caller
> having pinned the page already.

I agree.

Thanks,
Naoya Horiguchi
