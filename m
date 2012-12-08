Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2LHCxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 21:53:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53291 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496Ab2LHCxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 21:53:08 -0500
Date: Fri, 7 Dec 2012 18:52:51 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Mason <clmason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to
 fallocate UAPI
Message-ID: <20121208025250.GP22789@localhost>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
	Ric Wheeler <rwheeler@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	Chris Mason <chris.mason@fusionio.com>,
	Chris Mason <clmason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
 <20121207204325.GC29435@thunk.org>
 <20121207210932.GA25713@shiny>
 <50C262AE.5060701@redhat.com>
 <20121207215727.GF29435@thunk.org>
 <50C26778.7000500@redhat.com>
 <20121208003936.GP27172@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121208003936.GP27172@dastard>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 11:39:36AM +1100, Dave Chinner wrote:
> On Fri, Dec 07, 2012 at 05:02:32PM -0500, Ric Wheeler wrote:
> > On 12/07/2012 04:57 PM, Theodore Ts'o wrote:
> > >On Fri, Dec 07, 2012 at 04:42:06PM -0500, Ric Wheeler wrote:
> > >>The other things that I think we should try would be to convert over
> > >>larger chunks as we discussed on the list back in the summer (just
> > >>because the user writes 4KB does not mean that we cannot flip over
> > >>1MB and zero that).
> > >Writing a megabyte is not free.  If you assume that your HDD has a
> > >sustained write throughput of 100-125 MB/s, writing a megabyte will
> > >take 8-10ms.  It might be a win if you amortize it over a large number
> > >of writes, but it doesn't help your 99.9 percentile latency numbers.
> > >(99.9 percentile latency numbers matters because eventually you'll
> > >have a user request which hits multiple serial long latency
> > >operations, and then the delay looks **really** user visible.)
> > >
> > >	    	     	       	     		- Ted
> > 
> > Writing 4KB at a time to a disk cost XX units of time.
> > 
> > Writing to the same sector (especially for a HDD), cost XX units + a small amount.
> > 
> > I suggest that we try it out.
> > 
> > For SSD's, much better to use specific HW offload commands if
> > possible like WRITE_SAME (zeroed) or UNMAP/TRIM to get that
> > performance boost since no actual data is moved...
> 
> Yup, that could be done quite trivially in XFS. Just mark the
> preallocated extents as "busy" rather than unwritten, mark the
> transaction as synchronous and the transaction commit will issue a
> discard on the preallocated ranges before returning to userspace.
> The extra overhead to the preallocation command is unlikely to be
> noticed, and unwritten extent conversion overhead just goes away...
> 
> No fallocate() API changes necessary, though I think it would be
> better if the user application gave a hint that it preferred "writing
> zeros" (i.e. FALLOC_FL_WRITE_ZEROS) to allocating unwritten extents
> as there are workloads where one will always be clearly better than
> the other...

	Wait, I missed something.  We're letting fallocate be dumb?
Let's not do that, then.
	Over in ocfs2-land, we CoW in 1MB hunks.  That's the entire
extent if it is 1MB or less, or some MB multiple if it is large enough
to slice it.  This is for very similar reasons to unwritten clearing,
with the added benefit of less fragmentation from CoW.
	On spinning media, any read/write of up to 1MB is roughly about
the same penalty as reading/writing a sector.  You're already paying the
seek.  On SSD, WRITE_SAME is *way* better than leaking data.
	At the end of the day, you have to pay for zeroing.  You can do
it up front, or you can do it at write time.  A certain large commercial
database takes advantage of fallocate+unwritten by getting large swaths
of contiguous storage; it then writes to the whole space before using
it.  This allows the allocation benefits of fallocate, doesn't pay for
unneeded zeros, and yet peforms correctly at runtime.
	We should not be leaking data so that we can be lazy.

Joel


> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

Life's Little Instruction Book #182

	"Be romantic."

			http://www.jlbec.org/
			jlbec@evilplan.org
