Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424635Ab2LGV5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:57:37 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:53944 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424620Ab2LGV5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:57:36 -0500
X-ASG-Debug-ID: 1354917455-03d6a57f9b2d5210001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 7 Dec 2012 16:57:31 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Ric Wheeler <rwheeler@redhat.com>
CC: Chris Mason <clmason@fusionio.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207215731.GC25713@shiny>
X-ASG-Orig-Subj: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Chris Mason <clmason@fusionio.com>, Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
 <20121207204325.GC29435@thunk.org>
 <20121207210932.GA25713@shiny>
 <20121207212743.GE29435@thunk.org>
 <20121207214325.GB25713@shiny>
 <50C26450.8060909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50C26450.8060909@redhat.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354917455
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.3163 1.0000 -0.2804
X-Barracuda-Spam-Score: 0.32
X-Barracuda-Spam-Status: No, SCORE=0.32 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=COMMA_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.116378
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 COMMA_SUBJECT          Subject is like 'Re: FDSDS, this is a subject'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:49:04PM -0700, Ric Wheeler wrote:
> On 12/07/2012 04:43 PM, Chris Mason wrote:
> > On Fri, Dec 07, 2012 at 02:27:43PM -0700, Theodore Ts'o wrote:
> >> On Fri, Dec 07, 2012 at 04:09:32PM -0500, Chris Mason wrote:
> >>> Persistent trim is what I had in mind, but there are other ideas that do
> >>> imply a change in behavior as well.  Can we safely assume this feature
> >>> won't matter on spinning media?  New features like persistent
> >>> trim do make it much easier to solve securely, and using a bit for it
> >>> means we can toss back an error to the app if the underlying storage
> >>> isn't safe.
> >> We originally implemented no hide stale for spinning media.  Some
> >> folks have claimed that for XFS their superior technology means that
> >> no hide stale doesn't buy them anything for HDD's.  I'm not entirely
> >> sure I buy this, since if you need to update metadata, it means at
> >> least one extra seek for each random write into 4k preallocated space,
> >> and 7200 RPM disks only have about 200 seeks per second.
> > True, 7200 RPM disks are slow, but even allowing them to expose stale
> > data just makes them a little less slow.
> >
> > I know it's against the rules to pretend that disks don't matter.  But
> > really, once you're doing random IO into a spindle you've given up on
> > performance anyway.
> >
> > -chris
> 
> That's right.
> 
> And equally true, once you have moved the disk heads to that track, you can 
> write a lot as cheaply as a little (i.e., do 1MB instead of 4KB). That will also 
> avoid fragmentation of the extents.

When you do a 4K write, you have to remember that you've written just
those 4K.  When you do a 1MB write, you have to remember that you've
written just that 1MB.  It's the same operation, except with the 1MB
you've also had to setup all the bios and send down the zeros, and do
the proper locking to make sure you're not sending zeros down over
some concurrent IO.

The 1MB setup is actually more work, but it does greatly reduce the
amount of time the workload needs to run before it goes into a steady
state.  For smaller files it may work well, but for larger ones I don't
think it will be enough.

-chris
