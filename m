Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2LHAjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:39:40 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:33790 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932282Ab2LHAjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:39:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkNAB2LwlB5LHa//2dsb2JhbABEhUyyeYV5F3OCHgEBBTocIxAIAw4KLhQlAyETHodywSIUjCuEQwOWBJBJgwc
Date: Sat, 8 Dec 2012 11:39:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@fusionio.com>,
        Chris Mason <clmason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121208003936.GP27172@dastard>
References: <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
 <20121207204325.GC29435@thunk.org>
 <20121207210932.GA25713@shiny>
 <50C262AE.5060701@redhat.com>
 <20121207215727.GF29435@thunk.org>
 <50C26778.7000500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C26778.7000500@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 05:02:32PM -0500, Ric Wheeler wrote:
> On 12/07/2012 04:57 PM, Theodore Ts'o wrote:
> >On Fri, Dec 07, 2012 at 04:42:06PM -0500, Ric Wheeler wrote:
> >>The other things that I think we should try would be to convert over
> >>larger chunks as we discussed on the list back in the summer (just
> >>because the user writes 4KB does not mean that we cannot flip over
> >>1MB and zero that).
> >Writing a megabyte is not free.  If you assume that your HDD has a
> >sustained write throughput of 100-125 MB/s, writing a megabyte will
> >take 8-10ms.  It might be a win if you amortize it over a large number
> >of writes, but it doesn't help your 99.9 percentile latency numbers.
> >(99.9 percentile latency numbers matters because eventually you'll
> >have a user request which hits multiple serial long latency
> >operations, and then the delay looks **really** user visible.)
> >
> >	    	     	       	     		- Ted
> 
> Writing 4KB at a time to a disk cost XX units of time.
> 
> Writing to the same sector (especially for a HDD), cost XX units + a small amount.
> 
> I suggest that we try it out.
> 
> For SSD's, much better to use specific HW offload commands if
> possible like WRITE_SAME (zeroed) or UNMAP/TRIM to get that
> performance boost since no actual data is moved...

Yup, that could be done quite trivially in XFS. Just mark the
preallocated extents as "busy" rather than unwritten, mark the
transaction as synchronous and the transaction commit will issue a
discard on the preallocated ranges before returning to userspace.
The extra overhead to the preallocation command is unlikely to be
noticed, and unwritten extent conversion overhead just goes away...

No fallocate() API changes necessary, though I think it would be
better if the user application gave a hint that it preferred "writing
zeros" (i.e. FALLOC_FL_WRITE_ZEROS) to allocating unwritten extents
as there are workloads where one will always be clearly better than
the other...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
