Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab0EDOpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:45:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795Ab0EDOpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:45:34 -0400
Date: Tue, 4 May 2010 16:44:53 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages()
 and rmap_walk() during migration by not migrating temporary stacks
Message-ID: <20100504144453.GP19891@random.random>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie>
 <1272529930-29505-3-git-send-email-mel@csn.ul.ie>
 <20100429162120.GC22108@random.random>
 <20100504103213.GB20979@csn.ul.ie>
 <20100504125606.GK19891@random.random>
 <20100504143311.GI20979@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504143311.GI20979@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 03:33:11PM +0100, Mel Gorman wrote:
> I'm currently testing this and have seen no problems after an hour which
> is typically good. To be absolutly sure, it needs 24 hours but so far so
> good. The changelog is a tad on the light side so maybe you'd like to take
> this one instead and edit it to your liking?

I'll take your changelog for aa.git thanks! And the non trivial stuff
was documented in the code too.

So now in aa.git I've two branches, master -> old-anon_vma,
anon_vma_chain -> new-anon_vma.

anon_vma_chain starts with Rik's patch 1/2 and then this
patch. old-anon_vma starts with backout-anon-vma and then this patch 2
backported to old anon-vma code. After the removal of all
vma->anon_vma->lock usages from THP code, and switching to a slower
get_page() spin_unlock(page_table_lock) page_lock_anon_vma(page)
model, the anon_vma_chain branch has a chance to be as solid as the
master branch. anon_vma_chain branch can be pulled from mainline
branches too. The master branch is also not using anymore any
vma->anon_vma->lock even if it still could and it'd be a bit faster,
to give more testing to the anon_vma_chain code.

You can see the difference with "git diff master anon_vma_chain".

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=summary
http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=shortlog;h=refs/heads/anon_vma_chain

This should be THP-23 and THP-23-anon_vma_chain tags, I'll do proper
release soon.
