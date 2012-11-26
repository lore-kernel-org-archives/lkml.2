Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2KZDQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 22:16:11 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35029 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab2KZDQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 22:16:10 -0500
Date: Sun, 25 Nov 2012 22:15:18 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        akpm@linux-foundation.org, mgorman@suse.de, Valdis.Kletnieks@vt.edu,
        jirislaby@gmail.com, jslaby@suse.cz, zkabelac@redhat.com,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] mm,vmscan: only loop back if compaction would fail in
 all zones
Message-ID: <20121126031518.GC2799@cmpxchg.org>
References: <20121119202152.4B0E420004E@hpza10.eem.corp.google.com>
 <20121125175728.3db4ac6a@fem.tu-ilmenau.de>
 <20121125132950.11b15e38@annuminas.surriel.com>
 <20121125224433.GB2799@cmpxchg.org>
 <20121125191645.0ebc6d59@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121125191645.0ebc6d59@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2012 at 07:16:45PM -0500, Rik van Riel wrote:
> On Sun, 25 Nov 2012 17:44:33 -0500
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Sun, Nov 25, 2012 at 01:29:50PM -0500, Rik van Riel wrote:
> 
> > > Could you try this patch?
> > 
> > It's not quite enough because it's not reaching the conditions you
> > changed, see analysis in https://lkml.org/lkml/2012/11/20/567
> 
> Johannes,
> 
> does the patch below fix your problem?

I can not reproduce the problem anymore with my smoke test.

> I suspect it would, because kswapd should only ever run into this
> particular problem when we have a tiny memory zone in a pgdat,
> and in that case we will also have a larger zone nearby, where
> compaction would just succeed.

What if there is a higher order GFP_DMA allocation when the other
zones in the system meet the high watermark for this order?

There is something else that worries me: if the preliminary zone scan
finds the high watermark of all zones alright, end_zone is at its
initialization value, 0.  The final compaction loop at `if (order)'
goes through all zones up to and including end_zone, which was never
really set to anything meaningful(?) and the only zone considered is
the DMA zone again.  Very unlikely, granted, but if you'd ever hit
that race and kswapd gets stuck, this will be fun to debug...
