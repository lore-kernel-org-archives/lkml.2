Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab0J1XZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 19:25:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39843 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406Ab0J1XZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 19:25:17 -0400
Date: Fri, 29 Oct 2010 00:25:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, warthog9@kernel.org,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
Message-ID: <20101028232506.GL19804@ZenIV.linux.org.uk>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
 <20101028222404.GG2715@dastard>
 <AANLkTimG6o66SFHskkDOtLqYeSzwKt2c0jR3CWe+sd2w@mail.gmail.com>
 <1288305510.2610.13.camel@localhost.localdomain>
 <AANLkTimvEAj2SL7RrwTdypGA_PYJcZyw8OMBGckWpVs7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimvEAj2SL7RrwTdypGA_PYJcZyw8OMBGckWpVs7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 03:46:04PM -0700, Linus Torvalds wrote:
> On Thu, Oct 28, 2010 at 3:38 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >
> > Would making i_readcount atomic be enough in ima_rdwr_violation_check(),
> > or would it still need to take the spin_lock? IMA needs guarantees
> > that the i_readcount/i_writecount won't be updated in between.
> 
> If i_writecount is always updated under the i_lock, then the fix is
> probably to make that one non-atomic instead. There's no point in
> having an atomic that is always updated under a spinlock, that just
> makes everything slower.
> 
> Regardless, I don't think i_readcount should be different from i_writecount.
> 
> Al? Comments?

Well... the rules for i_writecount had been "protect zero->non-zero
transitions with spinlock".  Back then we had a single spinlock for that,
IIRC, and making it atomic had been an obvious solution.  Note that we
have a bunch of places in VM where we need to adjust it (VMA merges and
splitting) and I really wanted to avoid contention on that lock.

BTW, I suspect that the right first step would be to kill open-coded
manipulations of i_writecount in mmap.c and fork.c; there are inlined
helpers for that.

I *really* don't like what add_dquot_ref() is doing; it checks i_writecount
under inode_lock and skips the inodes for which it's zero.  It might be
OK if one of the quota locks held by callers will serialize it wrt the
relevant part of the open() path, but that needs a comment along those
lines, at the very least.

We probably can go for non-atomic; the lock is per-inode these days, so
it's less of a PITA.  I wonder if IMA holding it over its policy checks
would be a good thing, though - it calls LSM hooks and hell knows what
shit gets done from those...
