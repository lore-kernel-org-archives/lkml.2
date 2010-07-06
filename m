Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0GFPz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:55:26 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:34828 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab0GFPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:55:24 -0400
Date: Tue, 6 Jul 2010 10:54:38 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] hugetlb: pin oldpage in page migration
In-Reply-To: <1278049646-29769-6-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.00.1007061050320.4938@router.home>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1278049646-29769-6-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010, Naoya Horiguchi wrote:

> This patch introduces pinning the old page during page migration
> to avoid freeing it before we complete copying.

The old page is already pinned due to the reference count that is taken
when the page is put onto the list of pages to be migrated. See
do_move_pages() f.e.

Huge pages use a different scheme?

> This race condition can happen for privately mapped or anonymous hugepage.

It cannot happen unless you come up with your own scheme of managing pages
to be migrated and bypass migrate_pages(). There you should take the
refcount.

>  	/*
> +	 * It's reasonable to pin the old page until unmapping and copying
> +	 * complete, because when the original page is an anonymous hugepage,
> +	 * it will be freed in try_to_unmap() due to the fact that
> +	 * all references of anonymous hugepage come from mapcount.
> +	 * Although in the other cases no problem comes out without pinning,
> +	 * it looks logically correct to do it.
> +	 */
> +	get_page(page);
> +
> +	/*

Its already pinned. Dont do this. migrate_pages() relies on the caller
having pinned the page already.

