Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab0FPQmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:42:42 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:32925 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab0FPQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:42:41 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p file system bug fixes for 2.6.35-rc2
In-Reply-To: <20100608004102.GQ31073@ZenIV.linux.org.uk>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com> <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org> <20100608004102.GQ31073@ZenIV.linux.org.uk>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Wed, 16 Jun 2010 22:12:32 +0530
Message-ID: <87pqzrexon.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010 01:41:02 +0100, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Mon, Jun 07, 2010 at 05:08:19PM -0700, Linus Torvalds wrote:
> 
> > In fact, the other thing that I find doing that whole "dentry->d_parent" 
> > thing seems to literally be broken. If you look at v9fs_fid_lookup(), 
> > you'll notice how it walks up the d_parent chain, and at that point you do 
> > NOT own the directory i_mutex, so at that point d_parent really _can_ be 
> > changing wildly due to concurrent renames or whatever.
> 
> Eh...  It's bogus, all right, but i_mutex is not the correct solution.
> You'd have to take it on a lot of inodes along the way to root *and*
> you'd violate the ordering in process (ancestors first).
> 
> I'm not sure what's the right thing to do there, actually - s_vfs_rename_sem
> also won't do, since it'll give you ordering problems of its own (it's
> taken before i_mutex in VFS, so trying to take it under i_mutex would not
> do).

Can we use dcache_lock in v9fs_fid_lookup ? Since we are holding
parent directory inode->i_mutex in other places where we refer
dentry->d_parent I guess those access are ok ?. And for v9fs_fid_lookup we
can hold dcache_lock, walk the parent, build the full path name and use
that for TWALK ? 

Another option is we deny a cross directory rename when
doing fid_lookup. That is we can introduce a per superblock v9fs
specific rwlock that get taken (in write mode) in a cross directory
rename and in fid_lookup we take them in read mode ? We will have to set
FS_RENAME_DOES_D_MOVE for 9p.

> 
> The _really_ interesting question is how do servers deal with topology-changing
> renames.  Note that the problem exists only with extended 9P - with the
> original one all of that had been a non-issue, since it didn't allow
> cross-directory renames at all and the tree topology remained stable all along.
> 

True the problem exist only with .L extension since .u protocol don't
allow a cross directory renames. In the server we update the path names
attached to a fid during rename. This happen to all fids that have path
component matching the changed name.

-aneesh

