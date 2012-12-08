Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2LHAus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:50:48 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23348 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754971Ab2LHAuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:50:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloNAFqOwlB5LHa//2dsb2JhbABEhUyyeYV5F3OCHgEBBTocIxAIAw4KLhQlAyETGQKHdcEiFIwrhEMDklKDMpBJgwc
Date: Sat, 8 Dec 2012 11:50:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: Howard Chu <hyc@symas.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121208005042.GQ27172@dastard>
References: <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207193019.GA31591@home.goodmis.org>
 <20121207211440.GD29435@thunk.org>
 <50C263D6.9050003@redhat.com>
 <50C27B01.1010903@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C27B01.1010903@symas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 03:25:53PM -0800, Howard Chu wrote:
> Ric Wheeler wrote:
> >On 12/07/2012 04:14 PM, Theodore Ts'o wrote:
> >>On Fri, Dec 07, 2012 at 02:30:19PM -0500, Steven Rostedt wrote:
> >>>How is this similar? By adding this bit, we removed incentive from a
> >>>group of developers that have the means to fix the real issue at hand
> >>>(the performance problem with ext4). Thus, it means that they have a work
> >>>around that's good enough for them, but the rest of us suffer.
> >>That assumes that there **is** a way to claw back the performance
> >>loss, and Chris Mason has demonstrated the performance hit exists with
> >>xfs as well (950 MB/s vs. 400 MB/s; that's more than a factor of two).
> >>Sometimes, you have to make the engineering tradeoffs.  That's why
> >>we're engineers, for goodness sakes.  Sometimes, it's just not
> >>possible to square the circle.
> >>
> >>I don't believe that the technique of forcing people who need that
> >>performance to suffer in order to induce them to try to engineer a
> >>solution which may or may not exist is really the best or fairest way
> >>to go about things.
> >>
> >>					- Ted
> >
> >This is not a generally useful feature and won't ship in a way that helps most
> >users with this issue.
> 
> >Let's fix the problem properly.
> >
> >In the meantime, there are several obvious ways to avoid this performance hit
> >without changing the kernel (fully allocate and write the data, certainly
> >reasonable for even reasonable sized files).
> 
> I have to agree that, if this is going to be an ext4-specific
> feature, then it can just be implemented via an ext4-specific ioctl
> and be done with it. But I'm not convinced this should be an
> ext4-specific feature.
> 
> As for "fix the problem properly" - you're fixing the wrong problem.
> This type of feature is important to me, not just because of the
> performance issue. As has already been pointed out, the performance
> difference may even be negligible.
> 
> But on SSDs, the issue is write endurance. The whole point of
> preallocating a file is to avoid doing incremental metadata updates.
> Particularly when each of those 1-bit status updates costs entire
> blocks, and gratuitously shortens the life of the media. The fact
> that avoiding the unnecessary wear and tear may also yield a
> performance boost is just icing on the cake. (And if the perf boost
> is over a factor of 2:1 that's some pretty damn good icing.)

That's a filesystem implementation specific problem, not a generic
fallocate() or unwritten extent conversion problem.

Besides, ext4 doesn't write back every metadata modification that is
made - they are aggregated in memory and only written when the
journal is full or the metadata ages out. Hence unwritten extent
conversion has very little impact on the amount of writes that are
done to the flash because it is vastly dominated by the data writes.

Similarly, in XFS you might see a few thousand or tens of thousands
of metadata blocks get written once every 30s under such a random
write workload, but each metadata block might have gone through a
million changes in memory since the last time it was written.
Indeed, in that 30s, there would have been a few million random data
writes so the metadata writes are well and truly lost in the
noise...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
