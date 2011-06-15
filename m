Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1FOBWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:22:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624Ab1FOBWF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:22:05 -0400
MIME-Version: 1.0
In-Reply-To: <1308097798.17300.142.camel@schen9-DESK>
References: <1308097798.17300.142.camel@schen9-DESK>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Jun 2011 18:21:14 -0700
Message-ID: <BANLkTinEhVY4aZ+M6H=380zd0Osr_6VFCA@mail.gmail.com>
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock
 to mutex
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, ak@linux.intel.com,
        shaohua.li@intel.com, alex.shi@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 5:29 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
>
> On 2.6.39, the contention of anon_vma->lock occupies 3.25% of cpu.
> However, after the switch of the lock to mutex on 3.0-rc2, the mutex
> acquisition jumps to 18.6% of cpu.  This seems to be the main cause of
> the 52% throughput regression.

Argh. That's nasty.

Even the 3.25% is horrible. We scale so well in other situations that
it's really sad how the anon_vma lock is now one of our worst issues.

Anyway, please check me if I'm wrong, but won't the "anon_vma->root"
be the same for all the anon_vma's that are associated with one
particular vma?

The reason I ask is because when I look at anon_vma_clone(), we do that

   list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
      ...
      anon_vma_chain_link(dst, avc, pavc->anon_vma);
   }

an dthen we do that anon_vma_lock()/unlock() dance on each of those
pavc->anon_vma's. But if the anon_vma->root is always the same, then
that would mean that we could do the lock just once, and hold it over
the loop.

Because I think the real problem with that anon_vma locking is that it
gets called so _much_. We'd be better off holding the lock for a
longer time, and just not do the lock/unlock thing so often. The
contention would go down simply because we wouldn't waste our time
with those atomic lock/unlock instructions as much.

Gaah. I knew exactly how the anon_vma locking worked a few months ago,
but it's complicated enough that I've swapped out all the details. So
I'm not at all sure that the anon_vma->root will be the same for every
anon_vma on the same_vma list.

Somebody hit me over the head with a clue-bat. Anybody?

                   Linus
