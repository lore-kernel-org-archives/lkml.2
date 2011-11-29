Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1K2Esw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 23:48:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1K2Esv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 23:48:51 -0500
Date: Mon, 28 Nov 2011 20:49:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <jens.axboe@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 5/8] readahead: add /debug/readahead/stats
Message-Id: <20111128204950.29404d0b.akpm@linux-foundation.org>
In-Reply-To: <20111129032323.GC19506@localhost>
References: <20111121091819.394895091@intel.com>
	<20111121093846.636765408@intel.com>
	<20111121152958.e4fd76d4.akpm@linux-foundation.org>
	<20111129032323.GC19506@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 11:23:23 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> > > +{
> > > +#ifdef CONFIG_READAHEAD_STATS
> > > +	if (readahead_stats_enable) {
> > > +		readahead_stats(mapping, offset, req_size, ra_flags,
> > > +				start, size, async_size, actual);
> > > +		readahead_stats(mapping, offset, req_size,
> > > +				RA_PATTERN_ALL << READAHEAD_PATTERN_SHIFT,
> > > +				start, size, async_size, actual);
> > > +	}
> > > +#endif
> > > +}
> > 
> > The stub should be inlined, methinks.  The overhead of evaluating and
> > preparing eight arguments is significant.  I don't think the compiler
> > is yet smart enough to save us.
> 
> The parameter list actually becomes even out of control when doing the
> bit fields:
> 
> +       readahead_event(mapping, offset, req_size,
> +                       ra->pattern, ra->for_mmap, ra->for_metadata,
> +                       ra->start + ra->size >= eof,
> +                       ra->start, ra->size, ra->async_size, actual);
> 
> So I end up passing file_ra_state around. The added cost is, I'll have
> to dynamically create a file_ra_state for the fadvise case, which
> should be acceptable since it's a cold path.

That will reduce the cost of something which would have zero cost by
making this function a static inline when CONFIG_READAHEAD_STATS=n.

