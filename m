Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0D1CIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 22:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab0D1CI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 22:08:29 -0400
Date: Wed, 28 Apr 2010 03:44:34 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs
 when page tables are being moved after the VMA has already moved
Message-ID: <20100428014434.GM510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <1272403852-10479-4-git-send-email-mel@csn.ul.ie>
 <20100427223004.GF8860@random.random>
 <20100427225852.GH8860@random.random>
 <20100428102928.a3b25066.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428102928.a3b25066.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 10:29:28AM +0900, KAMEZAWA Hiroyuki wrote:
> Hmm..Mel's patch 2/3 takes vma->anon_vma->lock in vma_adjust(),
> so this patch clears vma->anon_vma...

yep, it should be safe with patch 2 applied too. And I'm unsure why Mel's
patch locks the anon_vma also when vm_start != start. See the other
email I sent about patch 2.

> I think we can unlock this just after move_page_tables().

Checking this, I can't see where exactly is vma->vm_pgoff adjusted
during the atomic section I protected with the anon_vma->lock?
For a moment it looks like these pages become unmovable.

I guess this is why I thought initially that it was move_page_tables
to adjust the page->index. If it doesn't then the vma->vm_pgoff has to
be moved down of shift >>PAGE_SHIFT and it doesn't seem to be
happening which is an unrelated bug.
