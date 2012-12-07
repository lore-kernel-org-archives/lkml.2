Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab2LGV1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:27:53 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:37399 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab2LGV1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:27:52 -0500
Date: Fri, 7 Dec 2012 16:27:43 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207212743.GE29435@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Chris Mason <chris.mason@fusionio.com>,
	Chris Mason <clmason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20121126091202.GO32450@dastard>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
 <20121207204325.GC29435@thunk.org>
 <20121207210932.GA25713@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207210932.GA25713@shiny>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 04:09:32PM -0500, Chris Mason wrote:
> Persistent trim is what I had in mind, but there are other ideas that do
> imply a change in behavior as well.  Can we safely assume this feature
> won't matter on spinning media?  New features like persistent
> trim do make it much easier to solve securely, and using a bit for it
> means we can toss back an error to the app if the underlying storage
> isn't safe.

We originally implemented no hide stale for spinning media.  Some
folks have claimed that for XFS their superior technology means that
no hide stale doesn't buy them anything for HDD's.  I'm not entirely
sure I buy this, since if you need to update metadata, it means at
least one extra seek for each random write into 4k preallocated space,
and 7200 RPM disks only have about 200 seeks per second.

One of the problems that I've seen is that as disks get bigger, the
number of seeks per second have remained constant, and so an
application which required N TB spread out over a large number of
disks might now only require a fraction of the number of disks --- so
it's very easy for a cluster file system to become seek constrained by
the number of spindles that you have, and not capacity constrained.

This to me seems to be a fundamental problem, and I don't think it's
possible to wave one's hands to get rid of it.  All you can say is
that the people who care about this are crazy (that's OK, I don't mind
when Christoph or Dave call me crazy :-), and that their workload
doesn't matter.  But if you are trying to optimize out every last
seek, because you desperately care about latency and seeks are a
precious and scarce resource[1], then I don't see around away the
technique of not requiring an update to the metadata at the time that
you write the data block, and that kinda implies no-hide-stale.

Regards,

					- Ted

[1] Even if you don't care about the latency of the write operation,
the fact that the write operation has to do two seeks and not one can
very well slow down a subsequent high priority read request, where you
*do* care about latency.  The problem is that you only have about 200
seeks per spindle.

