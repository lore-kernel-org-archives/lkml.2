Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2LHARL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:17:11 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45797 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754230Ab2LHARJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:17:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloNAKSFwlB5LHa//2dsb2JhbABEDoU+sniFeRdzgh4BAQQBHR0cKAsIAxguFCUDIQESFId3BQ3BHRSMK4RDA5YEgR2PLII1Ug
Date: Sat, 8 Dec 2012 11:17:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121208001705.GO27172@dastard>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121126025520.GC22858@thunk.org>
 <20121126091202.GO32450@dastard>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207190306.GB14972@shiny>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:03:06PM -0500, Chris Mason wrote:
> On Fri, Dec 07, 2012 at 11:18:00AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 7 Dec 2012, Ric Wheeler wrote:
> > > 
> > > Review is part of the way we work as a community and we should figure out how
> > > to fix our review process so that we can have meaningful results from the
> > > review or we lose confidence in the process and it makes it much harder to get
> > > reviewers to spend time reviewing when their reviews are ultimately ignored.
> > 
> > Christ, I promised myself to not respond any more to this thread, but the 
> > insanity just continues, from people who damn well should know better.
> > 
> > The code wasn't merged. The review worked.
> > 
> > What you (and Dave, and Christoph) are trying to do is shut down a feature 
> > that somebody else decided they needed. That's not what code review is all 
> > about, and dammit, don't try to even claim it is.
> > 
> > So stop these dishonest and disingenious arguments. They are full of crap.
> > 
> > No amount of "review" has any meaning what-so-ever on whether somebody 
> > else decides they need a feature or not. You can review all you want, but 
> > it's irrelevant - if some company decides they are going to ship or use a 
> > feature, it's out of your hands.
> > 
> > What got merged was a ONE-LINER to make sure that possible future 
> > development didn't unnecessarily make things any more confusing, with the 
> > knowledge that there was a user of the code you didn't like. 
> > 
> > Every single argument I've heard of from the "please revert" camp has been 
> > inane. And they've been *transparently* inane, to the point where I don't 
> > understand how you can make them with a straght face and not be ashamed.
> 
> I really agree with Dave's statement that we should ioctl for private
> features and system call for features other filesystems are likely to
> implement.  So we really shouldn't have private bits in fallocate in use
> in production systems.
> 
> That's not what happened though, and the right way forward from here is
> to give the bit to the feature, maybe with a generic name like
> FALLOCATE_WITHOUT_BEING_HORRIBLY_SLOW.  It should have been done
> differently, but it wasn't.  And it's a problem we all have, so it makes
> sense that we'll all want to address it somehow.

Well, we could have a discussion about that if Linus were
to revert the original change. Not so much the name (that's just
bikeshedding), but if there is a better way to expand the fallocate
interface to allow people to sanely work around the supposedly
unfixable ext4 unwritten extent performance problems.

But he's not going to, so it is pointless to even suggest such
things.

> On a single flash drive doing random 4K writes, xfs does 950MB/s into
> regular extents but only 400MB/s into preallocated extents.
> 
> http://masoncoding.com/presentation/perf-linuxcon12/fallocate.png

This is bordering on irrelevancy, but can you provide the workload
you were running to generate this graph?  Random 4k writes could be
anything, really.

In my experience, applications that actually do processing between
random write IOs don't see anywhere near the same degradation as
such micro-benchmarks tend to indicate can occur with unwritten
extents. Are you seeing this level of degradation in real-world applications?
If you give me a reason to fix it (and the hardware to test it on),
I'm pretty sure I can bring the overhead down to just a few percent
on fully featured SSDs like FusionIO devices...

[ slightly more on topic ]

FWIW, if this was your production workload and you are using XFS
then you could always use XFS_IOC_ALLOCSP to write zeros during
preallocation rather than using unwritten extents. i.e. trade off
setup-time overhead for higher run-time performance.

[ Have I mentioned before that XFS has several of custom ioctls for
issuing different forms of preallocation? :) ]

I wouldn't recommend XFS_IOC_ALLOCSP as a user-friendly interface.
The concept, however, implemented by a new fallocate()
flag (say FALLOC_FL_WRITE_ZEROS) so that the filesystem knows that
the application considers unwritten extents undesirable is exactly
the sort of thing that we should be considering implementing.
Indeed, if the filesystem is on something with WRITE_SAME or
discards to zero, no data would need to be written, you wouldn't
have any unwritten extent overhead, and no stale data exposure.
And it's not a filesystem specific interface or optimisation...

[ back to original topic ]

This is exactly why Ted should have posted the patch for review. He
may not have got the flag through, but the discussion might just end
up in a place that is *better for everyone*. By subverting the
review process, he's deprived the community of that opportunity. now
we're stuck with a shitty change that we can't improve on and will
have to explain repeatedly over the next 15 years why it's not
implemented in any kernel filesystem.

And further - what happens if we add changes like I've mentioned
above and Google moves to using them instead? We'll have a bit in
the interface that nobody uses, nobody will ever implement, and we
can't remove. There's many, many good reasons why a revert is the
only sane thing to do at this point....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
