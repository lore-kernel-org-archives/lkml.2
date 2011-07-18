Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab1GRQF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:05:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab1GRQF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:05:58 -0400
Date: Mon, 18 Jul 2011 17:05:52 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
Message-ID: <20110718160552.GB5349@suse.de>
References: <1310742540-22780-1-git-send-email-mgorman@suse.de>
 <1310742540-22780-2-git-send-email-mgorman@suse.de>
 <alpine.DEB.2.00.1107180951390.30392@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107180951390.30392@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 09:56:31AM -0500, Christoph Lameter wrote:
> On Fri, 15 Jul 2011, Mel Gorman wrote:
> 
> > Currently the zonelist cache is setup only after the first zone has
> > been considered and zone_reclaim() has been called. The objective was
> > to avoid a costly setup but zone_reclaim is itself quite expensive. If
> > it is failing regularly such as the first eligible zone having mostly
> > mapped pages, the cost in scanning and allocation stalls is far higher
> > than the ZLC initialisation step.
> 
> Would it not be easier to set zlc_active and allowednodes based on the
> zone having an active ZLC at the start of get_pages()?
> 

What do you mean by a zones active ZLC? zonelists are on a per-node,
not a per-zone basis (see node_zonelist) so a zone doesn't have an
active ZLC as such. If the zlc_active is set at the beginning of
get_page_from_freelist(), it implies that we are calling zlc_setup()
even when the watermarks are met which is unnecessary.

> Buffered_rmqueue is handling the situation of a zone with an ZLC in a
> weird way right now since it ignores the (potentially existing) ZLC
> for the first pass.

Where does buffered_rmqueue() refer to a zonelist_cache?

> zlc_setup() does a lot of things. So that is because
> there is a performance benefit?
> 

I do not understand this question. Are you asking if zonelist_cache
has a performance benefit? The answer is "yes" because you can see
how the performance when zone_reclaim degrades when it is not used
for the first zone.

-- 
Mel Gorman
SUSE Labs
