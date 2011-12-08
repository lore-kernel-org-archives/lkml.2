Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1LHNK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 08:10:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44605 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab1LHNK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 08:10:56 -0500
Date: Thu, 8 Dec 2011 13:10:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][patch series] vfsmount gutting
Message-ID: <20111208131052.GG2203@ZenIV.linux.org.uk>
References: <20111208010251.GF2203@ZenIV.linux.org.uk>
 <20111208121956.GX4387@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208121956.GX4387@parisc-linux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 05:19:57AM -0700, Matthew Wilcox wrote:
> On Thu, Dec 08, 2011 at 01:02:52AM +0000, Al Viro wrote:
> > 	OK, that's something I wanted to do for a long time - struct vfsmount
> > contains too much stuff that is strictily VFS-internal and not needed by
> > anything outside of a very small subset of VFS, at that.  As the matter of
> > fact, only 3 fields, 1 of them redundant, are used by code outside of that
> > area - it's mnt_flags ("how it's mounted"), mnt_root ("what dentry tree
> > is mounted here", assign-once thing) and mnt_sb (always equal to
> > mnt_root->d_sb, also assign-once, might or might not be not needed).
> 
> If only these 3 fields are used, why not make the definition of struct
> vfsmount entirely hidden, and add accessor functions for those three?

Code churn from hell, for starters.  And cost of non-inlined calls on some
fairly sensitive paths, but that's secondary.

It might turn out to be feasible, but the price is likely to include several
method prototype changes affecting filesystems all over the place.  E.g.
I really suspect that ->show_options() taking vfsmount had been a mistake.
Mine, at that.  It ought to take root dentry of (sub)tree instead.  No,
passing struct super_block * will _not_ work; the things that share superblock
between several mounts really want to know e.g. which of the snapshots it
is (nilfs2), etc.  The same probably goes for the rest of ->show...() methods.

Hell knows; if we end up in a place where what you said would be doable -
great, but I'd prefer to pull what can be pulled without messing with
fs code first.  Besides, this separation really makes sense - it's
"what part of fs this vfsmount refers to" vs. "how vfsmounts are connected
into mount trees".
