Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0EJHbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 03:31:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:36793 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0EJHbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 03:31:40 -0400
Subject: Re: [PATCH 08/22] lmb: Add get_free_all_memory_range()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
In-Reply-To: <1273331860-14325-9-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
	 <1273331860-14325-9-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 17:29:17 +1000
Message-ID: <1273476557.23699.81.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 08:17 -0700, Yinghai Lu wrote:
> get_free_all_memory_range is for CONFIG_NO_BOOTMEM=y, and will be called by
> free_all_memory_core_early().
> 
> It will use early_node_map aka active ranges subtract lmb.reserved to
> get all free range, and those ranges will convert to slab pages.

Ok, so after looking more, and more or less understanding the very
convoluted code path you have created there:

You basically end up calling into lmb to create that "range" array of
ranges that represent the overlap of LMB's with a node ranges.

That itself is done by LMB itself calling into page_alloc.c which
creates a struct range array of all the node ranges, LMB then does the
intersection, sorts it, returns that to bootmem, which can finally
iterate that, do the free's and discard it.

Wow !

All of that could fit in one single function, inside or outside LMB (I
vote for outside for now, since it's all about NO_BOOTMEM).

Do like I do for my nid allocator: Call get_pfn_range_for_nid(),
then walk the LMB array and pick up intersecting ranges & free them.
Easy. One function, not 3 layers spread as many files, no need to
allocate that range array thing etc...

BTW. You -really- need to get rid of that kernel/range.c and associated
range.h. We don't need -yet-another- range management system in Linux,
seriously.

So all that stuff goes out of LMB for now. Just rebase your shit on top
of my patches when I post them, use my new for_each_lmb() along with
get_pfn_range_for_nid() as explained above, and do that inside bootmem.c
for now.

Note that the entire NO_BOOTMEM should be a sparate file. Call it
bootmem-lmb.c and make it CONFIG_BOOTMEM_LMB or something like that to
make it clear that it depends on ARCH_HAVE_LMB.

You should be able to remove a ton of crap code with that.

Cheers,
Ben.


