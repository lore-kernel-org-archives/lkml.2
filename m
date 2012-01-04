Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2ADSAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:00:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab2ADSAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:00:36 -0500
Date: Wed, 4 Jan 2012 19:00:33 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20120104180033.GE28907@quack.suse.cz>
References: <20120103124331.f0f0043f8ca464c9ff13f4d3@canb.auug.org.au>
 <20120103133942.GC31457@quack.suse.cz>
 <20120103144531.GA23916@ZenIV.linux.org.uk>
 <20120104021754.GD23916@ZenIV.linux.org.uk>
 <20120104025020.GW23662@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104025020.GW23662@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04-01-12 13:50:20, Dave Chinner wrote:
> On Wed, Jan 04, 2012 at 02:17:54AM +0000, Al Viro wrote:
> > I'm still not
> > sure about ->statfs(), BTW - any input on that would be welcome.  Can
> > it end up blocked on a frozen fs until said fs is thawed?
> 
> I don't see why this should ever happen - ->statfs has to work on
> read-only filesystems so shoul dnot be modifying state, and hence
> should never need to care about the frozen state of the superblock.
  Well, I'm also not aware of a filesystem where ->statfs would wait on
frozen filesystem. Just note that e.g. for stat(2) frozen filesystem and
RO filesystem *are* different because of atime updates. So stat(2) can
block on frozen fs because of atime update while on RO filesystem it is
just fine.

> So from a ->statfs POV, a frozen filesystem should look just like a
> read-only filesystem. If frozen filesystems are holding locks that
> ->statfs can block on until the filesystem us thawed, then I'd
> consider that a bug in the filesystem freeze implementation....
  In an ideal world yes. Practically, current freeze code has races
(vfs_check_frozen() is a totally racy check) which can leave processes
waiting for frozen fs with filesystem locks held. I believe we need
something like mnt_want_write()/mnt_drop_write() for freezing code in
->page_mkwrite() and ->write_begin/->write_end. I'm now looking into how
to do that in the best way.
 
> > to convert ustat(2) to "wait for thaw" semantics (should be interruptible,
> > BTW) or document that ->statfs() is not allowed to wait for thawing.
> > It's far too subtle to leave undocumented...
> 
> The latter, IMO.
  Agreed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
