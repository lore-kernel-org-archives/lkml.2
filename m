Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424333Ab2LGUnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:43:41 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:37375 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424123Ab2LGUnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:43:40 -0500
Date: Fri, 7 Dec 2012 15:43:25 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207204325.GC29435@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
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
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:03:06PM -0500, Chris Mason wrote:
> 
> That's not what happened though, and the right way forward from here is
> to give the bit to the feature, maybe with a generic name like
> FALLOCATE_WITHOUT_BEING_HORRIBLY_SLOW.  

I don't think that's a good idea, because the current name explicitly
calls out the fact that we are making a tradeoff between what
***might*** be a security exposure in some cases (but which might be
perfectly fine in others) for performance.  Using the generic name
would hide the fact that this tradeoff is being made, and the
arguments (which I've never seen backed up with a specific design) is
that it's possible to speed up random writes into preallocated space
on a flash device without making any kind of tradeoff that might imply
a security tradeoff.

If indeed it is possible to speed up this particular workload without
making any kind of no-hide-stale tradeoff, then we won't need the bit
--- writes into fallocated space will just get faster, with or without
the bit

I am sure it will be possible to do this in some cases (for example if
you have a device that supports persistent trim which can quickly
zeroize the blocks in question), but I would be very surprised if it's
possible to completely eliminate the performance degradation for all
devices and workloads.  (Not all storage devices support persistent
trim, just for starters.)

In answer's to Linus's question, the reason why people are
hyperventilating so badly about this is that in some circles,
revealing stale data is so horrible that anyone who even tries to
suggest this should be excommunicated.  The mere existence of the
code, or that people are using it, horribly offends those people.

(Witness how people reacted when Linus changed the default of ext3 to
data=writeback many years ago in order to solve a performance problem
that was impacting him and other desktop users very badly.  At the
time, I understood why he made that change, but I know a lot of people
were horrified.  These days we have a better solution which is used by
ext4, but for desktop users at that time, it was a completely fair
engineering choice to make.)

						- Ted
