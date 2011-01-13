Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab1AMF4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 00:56:23 -0500
Received: from thunk.org ([69.25.196.29]:50318 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab1AMF4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 00:56:18 -0500
Date: Thu, 13 Jan 2011 00:56:12 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
        LKML Kernel <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Oops while going into hibernate
Message-ID: <20110113055612.GF13496@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Sebastian Ott <sebott@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	LKML Kernel <linux-kernel@vger.kernel.org>,
	pm list <linux-pm@lists.linux-foundation.org>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
 <20110112162655.GA13496@thunk.org>
 <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
 <20110112172646.GB13496@thunk.org>
 <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
 <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 07:44:17PM -0500, Theodore Tso wrote:
> 
> You said originally that the oops was happening "while going into
> hibernation right after resuming with...".  So that means you did a
> successful suspend/resume, and then the second suspend caused the
> oops?  It looks like somehow the pages were left marked as dirty, so
> the writeback daemons attempted writing back a page to an inode
> which was never opened read/write (and in fact as a text page for
> /usr/bin/killall, was mapped read/only).  Given that ext4
> initializes jinode only when the file is opened read/write, the fact
> that it is null, and the fact that it makes no sense that a program
> would be modifying /usr/bin/killall as part of a suspend/resume, it
> looks very much like we just unmasked a software suspend bug....

... and I think I've found the problem.  In kernel/power/block_io.c,
in the function submit(), we see this:

	if (bio_chain == NULL) {
		submit_bio(bio_rw, bio);
		wait_on_page_locked(page);
		if (rw == READ)
			bio_set_pages_dirty(bio); <====
		bio_put(bio);

So when we read in pages from the software suspend device, we end up
marking the pages as dirty(!).  I'm guessing this was caused by a copy
and paste from the only other caller of bio_set_pages_dirty(), which
is the direct I/O code, which needs this when we are writing from a
file into a user-provided buffer.  But for restoring from a software
suspend case, this is as far as I can tell wholely inappropriate.

This causes needless writes, which is bad even before ext4 unmasked
the problem.  I will send a patch under separate cover; could you give
it a try and see if it fixes your crash?

I will look into bulletproofing ext4 by adding checks for this case
and printing warning messages, but neverthe less, I think the root
cause is actually in the hibernation's bio code.

					- Ted
