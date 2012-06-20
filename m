Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2FTNwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:52:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57744 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2FTNv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:51:59 -0400
Subject: Re: [PATCH 08/17] net: Do not coalesce skbs belonging to
 PFMEMALLOC sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
In-Reply-To: <20120620133656.GH4011@suse.de>
References: <1340192652-31658-1-git-send-email-mgorman@suse.de>
	 <1340192652-31658-9-git-send-email-mgorman@suse.de>
	 <1340193892.4604.865.camel@edumazet-glaptop>
	 <20120620133656.GH4011@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jun 2012 15:51:52 +0200
Message-ID: <1340200312.4604.1008.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 14:36 +0100, Mel Gorman wrote:
> The intention was to avoid any coalescing in the input path due to avoid
> packets that "were held back due to TCP_CORK or attempt at coalescing
> tiny packet". I recognise that it is clumsy and will take the approach
> instead of having __tcp_push_pending_frames() use sk_gfp_atomic() in the
> output path.

But coalescing in input path needs no additional memory allocation, it
can actually free some memory.

And it avoids most of the time the infamous "tcp collapses" that needed
extra memory allocations to group tcp payload on single pages.


If you want tcp output path being safer, you should disable TSO/GSO
because some drivers have special handling for skbs that cannot be
mapped because of various hardware limitations.

(for example, tg3 and its tg3_tso_bug() or tigon3_dma_hwbug_workaround()
functions)




