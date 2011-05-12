Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1ELPQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:16:05 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52210 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab1ELPQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:16:03 -0400
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1105120942050.24560@router.home>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	 <1305127773-10570-4-git-send-email-mgorman@suse.de>
	 <alpine.DEB.2.00.1105120942050.24560@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 10:15:59 -0500
Message-ID: <1305213359.2575.46.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 09:43 -0500, Christoph Lameter wrote:
> On Wed, 11 May 2011, Mel Gorman wrote:
> 
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2198,7 +2198,7 @@ EXPORT_SYMBOL(kmem_cache_free);
> >   * take the list_lock.
> >   */
> >  static int slub_min_order;
> > -static int slub_max_order = PAGE_ALLOC_COSTLY_ORDER;
> > +static int slub_max_order;
> 
> If we really need to do this then do not push this down to zero please.
> SLAB uses order 1 for the meax. Lets at least keep it theere.

1 is the current value.  Reducing it to zero seems to fix the kswapd
induced hangs.  The problem does look to be some shrinker/allocator
interference somewhere in vmscan.c, but the fact is that it's triggered
by SLUB and not SLAB.  I really think that what's happening is some type
of feedback loops where one of the shrinkers is issuing a
wakeup_kswapd() so kswapd never sleeps (and never relinquishes the CPU
on non-preempt).

> We have been using SLUB for a long time. Why is this issue arising now?
> Due to compaction etc making reclaim less efficient?

This is the snark argument (I've said it thrice the bellman cried and
what I tell you three times is true).  The fact is that no enterprise
distribution at all uses SLUB.  It's only recently that the desktop
distributions started to ... the bugs are showing up under FC15 beta,
which is the first fedora distribution to enable it.  I'd say we're only
just beginning widespread SLUB testing.

James


