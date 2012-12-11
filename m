Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2LKMRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:17:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab2LKMRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:17:18 -0500
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to
 fallocate UAPI
From: Steven Whitehouse <swhiteho@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20121210182053.GC7516@thunk.org>
References: <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
	 <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com>
	 <50C22923.90102@redhat.com>
	 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
	 <20121207190306.GB14972@shiny> <20121208001705.GO27172@dastard>
	 <20121210173739.GA1359@thunk.org> <1355162759.2704.50.camel@menhir>
	 <20121210181328.GB7516@thunk.org>  <20121210182053.GC7516@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 11 Dec 2012 12:16:03 +0000
Message-ID: <1355228163.2721.32.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2012-12-10 at 13:20 -0500, Theodore Ts'o wrote:
> A sentence or two got chopped out during an editing pass.  Let me try
> that again so it's a bit clearer what I was trying to say....
> 
> Sure, but if the block device supports WRITE_SAME or persistent
> discard, then presumably fallocate() should do this automatically all
> the time, and not require a flag to request this behavior.  The only
> reason why you might not is if the WRITE_SAME is more costly.  That is
> when a seek plus writing 1MB does take more time than the amount of
> disk time fraction that it consumes if you compare it to a seek plus
> writing 4k or 32k.
> 
Well there are two cases here I think....

One is the GFS2 type case where the metadata doesn't support "these
blocks are allocated but zero" so that we must, for all fallocate
requests, zero out the blocks at fallocate time to avoid exposing stale
data to userspace.

The advantage over dd from userspace in this case is firstly that no
copy from userspace means that it should be faster. Also the use of
sb_issue_zeroout means that block devices which don't need an explicit
block of zeros to write should be able to do this faster - however that
is implemented at the block layer. The fs shouldn't need to care about
how is it implemented. In the case of GFS2, we implemented fallocate
because it was useful to have the feature of being able to allocate
beyond the end of file without changing the file size. This helped us
fix a bug in our fs grow code, so performance was a secondary (but
welcome!) consideration. 

The other case is ext4/XFS type case where the metadata does support
"these blocks are allocated but zero" which means that the metadata
needs to be changed twice. Once to "these blocks are allocated but zero"
at fallocate time and again to "these blocks have valid content" at
write time. As I understand the issue, the problem is that this second
metadata change is what is causing the performance issue.

> Ext4 currently uses a threshold of 32k for this break point (below
> that, we will use sb_issue_zeroout; above that, we will break apart an
> uninitialized extent when writing into a preallocated region).  It may
> be that 32k is too low, especailly for certain types of devices (i.e.,
> SSD's versus RAID 5, where it should be aligned on a RAID strip,
> etc.).  More of an issue might be that there will be some disagreement
> about whether people want to the system to automatically tune for
> average throughput vs 99.9 percentile latency.
> 
> Regardless, this is actually something which I think the file system
> should try to do automatically if at all possible, via some kind of
> auto-tuning hueristic, instead of using an explicit fallocate(2) flag.
> (See, I don't propose using a new fallocate flag for everything.  :-)
> 
>       	      	      	      - Ted
> 

It sounds like it might well be worth experimenting with the thresholds
as you suggest, 32k is really pretty small. I guess that the real
question here is what is the cost of the metadata change (to say what is
written and what remains unwritten) vs. simply zeroing out the unwritten
blocks in the extent when the write occurs.

There are likely to be a number of factors affecting that, and the
answer doesn't appear straightforward,

Steve.


