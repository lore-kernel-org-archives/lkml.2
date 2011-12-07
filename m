Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1LGJS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:18:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:34226 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab1LGJSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:18:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,313,1320652800"; 
   d="scan'208";a="83103839"
Date: Wed, 7 Dec 2011 17:18:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 7/9] readahead: add vfs/readahead tracing event
Message-ID: <20111207091820.GA7656@localhost>
References: <20111129130900.628549879@intel.com>
 <20111129131456.797240894@intel.com>
 <20111206153025.GA18974@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206153025.GA18974@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:30:25PM +0800, Christoph Hellwig wrote:
> > +	TP_printk("readahead-%s(dev=%d:%d, ino=%lu, "
> 
> please don't duplicate the tracepoint name in the output string.
> Also don't use braces, as it jsut complicates parsing.

OK. Changed to this format:

        TP_printk("pattern=%s bdi=%s ino=%lu "      
                  "req=%lu+%lu ra=%lu+%d-%d async=%d actual=%d",


> > +		  "req=%lu+%lu, ra=%lu+%d-%d, async=%d) = %d",
> > +			ra_pattern_names[__entry->pattern],
> 
> Instead of doing a manual array lookup please use __print_symbolic so
> that users of the binary interface (like trace-cmd) also get the
> right output.

The patch actually started with 

+#define show_pattern_name(val)                                            \
+       __print_symbolic(val,                                              \
+                       { RA_PATTERN_INITIAL,           "initial"       }, \
+                       { RA_PATTERN_SUBSEQUENT,        "subsequent"    }, \
+                       { RA_PATTERN_CONTEXT,           "context"       }, \
+                       { RA_PATTERN_THRASH,            "thrash"        }, \
+                       { RA_PATTERN_MMAP_AROUND,       "around"        }, \
+                       { RA_PATTERN_FADVISE,           "fadvise"       }, \
+                       { RA_PATTERN_RANDOM,            "random"        }, \
+                       { RA_PATTERN_ALL,               "all"           })

It's then converted to the current form so as to avoid duplicating the
num<>string mapping in two places.

The recently added writeback reason shares the same problem:

        TP_printk("bdi %s: sb_dev %d:%d nr_pages=%ld sync_mode=%d "
                  "kupdate=%d range_cyclic=%d background=%d reason=%s",
...
                  wb_reason_name[__entry->reason]
        )

Fortunately that's newly introduced in 3.2-rc1, so it's still the good
time to fix the writeback traces.

However the problem is, are we going to keep adding duplicate mappings
like this in future?

> > --- linux-next.orig/mm/readahead.c	2011-11-29 20:58:53.000000000 +0800
> > +++ linux-next/mm/readahead.c	2011-11-29 20:59:20.000000000 +0800
> > @@ -29,6 +29,9 @@ static const char * const ra_pattern_nam
> >  	[RA_PATTERN_ALL]                = "all",
> >  };
> >  
> > +#define CREATE_TRACE_POINTS
> > +#include <trace/events/vfs.h>
> 
> Maybe we should create a new fs/trace.c just for this instead of stickin
> it into the first file that created a tracepoint in the "vfs" namespace.

Yeah, it looks better to move it to a more general place.

Thanks,
Fengguang
