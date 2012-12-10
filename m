Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2LJSVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:21:00 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:37816 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2LJSU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:20:59 -0500
Date: Mon, 10 Dec 2012 13:20:53 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Steven Whitehouse <swhiteho@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121210182053.GC7516@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
 <20121208001705.GO27172@dastard>
 <20121210173739.GA1359@thunk.org>
 <1355162759.2704.50.camel@menhir>
 <20121210181328.GB7516@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210181328.GB7516@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A sentence or two got chopped out during an editing pass.  Let me try
that again so it's a bit clearer what I was trying to say....

Sure, but if the block device supports WRITE_SAME or persistent
discard, then presumably fallocate() should do this automatically all
the time, and not require a flag to request this behavior.  The only
reason why you might not is if the WRITE_SAME is more costly.  That is
when a seek plus writing 1MB does take more time than the amount of
disk time fraction that it consumes if you compare it to a seek plus
writing 4k or 32k.

Ext4 currently uses a threshold of 32k for this break point (below
that, we will use sb_issue_zeroout; above that, we will break apart an
uninitialized extent when writing into a preallocated region).  It may
be that 32k is too low, especailly for certain types of devices (i.e.,
SSD's versus RAID 5, where it should be aligned on a RAID strip,
etc.).  More of an issue might be that there will be some disagreement
about whether people want to the system to automatically tune for
average throughput vs 99.9 percentile latency.

Regardless, this is actually something which I think the file system
should try to do automatically if at all possible, via some kind of
auto-tuning hueristic, instead of using an explicit fallocate(2) flag.
(See, I don't propose using a new fallocate flag for everything.  :-)

      	      	      	      - Ted

