Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2DYPUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:20:46 -0400
Received: from fieldses.org ([174.143.236.118]:51410 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab2DYPUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:20:45 -0400
Date: Wed, 25 Apr 2012 11:20:41 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120425152041.GA751@fieldses.org>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
 <20120417180129.GW6589@ZenIV.linux.org.uk>
 <20120417182825.GX6589@ZenIV.linux.org.uk>
 <20120417211419.GC27426@fieldses.org>
 <CA+55aFwdh_QWG-R2FQ71kDXiNYZ04qPANBsY_PssVUwEBH4uSw@mail.gmail.com>
 <20120417234423.GY6589@ZenIV.linux.org.uk>
 <20120418215238.GA11959@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418215238.GA11959@fieldses.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 05:52:38PM -0400, J. Bruce Fields wrote:
> On Wed, Apr 18, 2012 at 12:44:24AM +0100, Al Viro wrote:
> > On Tue, Apr 17, 2012 at 03:08:26PM -0700, Linus Torvalds wrote:
> > > > Or I could increment that counter for all the conflicting operations and
> > > > rely on it instead of the i_mutex. ?I was trying to avoid adding
> > > > something like that (an inc, a dec, another error path) to every
> > > > operation. ?And hoping to avoid adding another field to struct inode.
> > > > Oh well.
> > > 
> > > We could just say that we can do a double inode lock, but then
> > > standardize on the order. And the only sane order is comparing inode
> > > pointers, not inode numbers like ext4 apparently does.
> > > 
> > > With a standard order, I don't think it would be at all wrong to just
> > > take the inode lock on rename.
> > 
> > In principle, yes, but have you tried to grep for i_mutex?  Note that
> > we have *another* place where multiple ->i_mutex might be held on
> > non-directories (and unless I'm missing something, ext4 move_extent.c
> > stuff doesn't play well with it): quota writes.  Which can, AFAICS,
> > happen while write(2) is holding ->i_mutex on a regular file.  So
> > it's not _that_ easy - we want something like "and quota file is goes
> > last"
> 
> So the idea would be to always take the i_mutex on non-quota files
> before taking it on quota files?
> 
> I tried pulling the ext4 thing into fs/inode.c, modifying the order to
> do that, and then doing the rename change on top of that.

Patches follow, with the ordering change at the end.

And a documentation fix that I suppose could go in whenever.

--b.
