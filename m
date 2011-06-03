Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1FCCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 22:09:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab1FCCJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 22:09:25 -0400
Date: Fri, 3 Jun 2011 03:09:20 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, akpm@linux-foundation.org,
        Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110603020920.GA26753@suse.de>
References: <20110531141402.GK19505@random.random>
 <20110601005747.GC7019@csn.ul.ie>
 <20110601175809.GB7306@suse.de>
 <20110601191529.GY19505@random.random>
 <20110601214018.GC7306@suse.de>
 <20110601233036.GZ19505@random.random>
 <20110602010352.GD7306@suse.de>
 <20110602132954.GC19505@random.random>
 <20110602145019.GG7306@suse.de>
 <20110602153754.GF19505@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110602153754.GF19505@random.random>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 05:37:54PM +0200, Andrea Arcangeli wrote:
> > There is an explanation in here somewhere because as I write this,
> > the test machine has survived 14 hours under continual stress without
> > the isolated counters going negative with over 128 million pages
> > successfully migrated and a million pages failed to migrate due to
> > direct compaction being called 80,000 times. It's possible it's a
> > co-incidence but it's some co-incidence!
> 
> No idea...

I wasn't able to work on this most of the day but was looking at this
closer this evening again and I think I might have thought of another
theory that could cause this problem.

When THP is isolating pages, it accounts for the pages isolated against
the zone of course. If it backs out, it finds the pages from the PTEs.
On !SMP but PREEMPT, we may not have adequate protection against a new
page from a different zone being inserted into the PTE causing us to
decrement against the wrong zone. While the global counter is fine,
the per-zone counters look corrupted. You'd still think it was the
anon counter tht got screwed rather than the file one if it really was
THP unfortunately so it's not the full picture. I'm going to start
a test monitoring both zoneinfo and vmstat to see if vmstat looks
fine while the per-zone counters that are negative are offset by a
positive count on the other zones that when added together become 0.
Hopefully it'll actually trigger overnight :/

-- 
Mel Gorman
SUSE Labs
