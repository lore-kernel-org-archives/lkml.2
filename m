Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1KUXTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:19:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab1KUXTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:19:21 -0500
Date: Mon, 21 Nov 2011 15:19:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <jens.axboe@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 4/8] readahead: record readahead patterns
Message-Id: <20111121151919.4b76a475.akpm@linux-foundation.org>
In-Reply-To: <20111121093846.510441032@intel.com>
References: <20111121091819.394895091@intel.com>
	<20111121093846.510441032@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 17:18:23 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Record the readahead pattern in ra_flags and extend the ra_submit()
> parameters, to be used by the next readahead tracing/stats patches.
> 
> 7 patterns are defined:
> 
>       	pattern			readahead for
> -----------------------------------------------------------
> 	RA_PATTERN_INITIAL	start-of-file read
> 	RA_PATTERN_SUBSEQUENT	trivial sequential read
> 	RA_PATTERN_CONTEXT	interleaved sequential read
> 	RA_PATTERN_OVERSIZE	oversize read
> 	RA_PATTERN_MMAP_AROUND	mmap fault
> 	RA_PATTERN_FADVISE	posix_fadvise()
> 	RA_PATTERN_RANDOM	random read

It would be useful to spell out in full detail what an "interleaved
sequential read" is, and why a read is considered "oversized", etc. 
The 'enum readahead_pattern' definition site would be a good place for
this.

> Note that random reads will be recorded in file_ra_state now.
> This won't deteriorate cache bouncing because the ra->prev_pos update
> in do_generic_file_read() already pollutes the data cache, and
> filemap_fault() will stop calling into us after MMAP_LOTSAMISS.
> 
> --- linux-next.orig/include/linux/fs.h	2011-11-20 20:10:48.000000000 +0800
> +++ linux-next/include/linux/fs.h	2011-11-20 20:18:29.000000000 +0800
> @@ -951,6 +951,39 @@ struct file_ra_state {
>  
>  /* ra_flags bits */
>  #define	READAHEAD_MMAP_MISS	0x000003ff /* cache misses for mmap access */
> +#define	READAHEAD_MMAP		0x00010000

Why leave a gap?

And what is READAHEAD_MMAP anyway?

> +#define READAHEAD_PATTERN_SHIFT	28

Why 28?

> +#define READAHEAD_PATTERN	0xf0000000
> +
> +/*
> + * Which policy makes decision to do the current read-ahead IO?
> + */
> +enum readahead_pattern {
> +	RA_PATTERN_INITIAL,
> +	RA_PATTERN_SUBSEQUENT,
> +	RA_PATTERN_CONTEXT,
> +	RA_PATTERN_MMAP_AROUND,
> +	RA_PATTERN_FADVISE,
> +	RA_PATTERN_OVERSIZE,
> +	RA_PATTERN_RANDOM,
> +	RA_PATTERN_ALL,		/* for summary stats */
> +	RA_PATTERN_MAX
> +};

Again, the behaviour is all undocumented.  I see from the code that
multiple flags can be set at the same time.  So afacit a file can be
marked RANDOM and SUBSEQUENT at the same time, which seems oxymoronic.

This reader wants to know what the implications of this are - how the
code chooses, prioritises and acts.  But this code doesn't tell me.

> +static inline unsigned int ra_pattern(unsigned int ra_flags)
> +{
> +	unsigned int pattern = ra_flags >> READAHEAD_PATTERN_SHIFT;

OK, no masking is needed because the code silently assumes that arg
`ra_flags' came out of an ra_state.ra_flags and it also silently
assumes that no higher bits are used in ra_state.ra_flags.

That's a bit of a handgrenade - if someone redoes the flags
enumeration, the code will explode.

> +	return min_t(unsigned int, pattern, RA_PATTERN_ALL);
> +}

<scratches head>

What the heck is that min_t() doing in there?

> +static inline void ra_set_pattern(struct file_ra_state *ra,
> +				  unsigned int pattern)
> +{
> +	ra->ra_flags = (ra->ra_flags & ~READAHEAD_PATTERN) |
> +			    (pattern << READAHEAD_PATTERN_SHIFT);
> +}
>  
>  /*
>   * Don't do ra_flags++ directly to avoid possible overflow:
>
> ...
>
