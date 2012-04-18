Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750830Ab2DREAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:00:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60695 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2DREAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:00:36 -0400
Date: Tue, 17 Apr 2012 21:00:23 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Mel Gorman <mgorman@suse.de>, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-S390 <linux-s390@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] s390: mm: rmap: Transfer storage key to struct page
 under the page lock
In-Reply-To: <20120417150237.0abb8ec5@de.ibm.com>
Message-ID: <alpine.LSU.2.00.1204172052360.1609@eggly.anvils>
References: <20120416141423.GD2359@suse.de> <20120416175040.0e33b37f@de.ibm.com> <20120417122925.GG2359@suse.de> <20120417150237.0abb8ec5@de.ibm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012, Martin Schwidefsky wrote:
> On Tue, 17 Apr 2012 13:29:25 +0100
> Mel Gorman <mgorman@suse.de> wrote:
> > 
> > In the zap_pte_range() case at least, pte_dirty() is only being checked
> > for !PageAnon pages so if we took this approach we would miss
> > PageSwapCache pages. If we added the check then the same problem is hit
> > and we'd need additional logic there for s390 to drop the PTL, take the
> > page lock and retry the operation. It'd still be ugly :(
> 
> Well if x86 can get away with ignoring PageSwapCache pages in zap_pte_range()
> pages then s390 should be able to get away with it as well, no ?

When it's zap_pte_range() calling page_remove_rmap(), yes; but that's not
the only caller of page_remove_rmap(), and I believe there's at least one
caller which absolutely needs it to do that s390 set_page_dirty() on swap.

But I don't see any need to be discussing ugly patches for this any more:
there's a very simple patch which improves the swap path anyway, and if
deemed advisable, we can also rearrange __add_to_swap_cache() a little.

Hugh
