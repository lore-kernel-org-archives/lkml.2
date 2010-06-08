Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0FHAlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:41:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42373 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab0FHAlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:41:12 -0400
Date: Tue, 8 Jun 2010 01:41:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 9p file system bug fixes for 2.6.35-rc2
Message-ID: <20100608004102.GQ31073@ZenIV.linux.org.uk>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com>
 <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 05:08:19PM -0700, Linus Torvalds wrote:

> In fact, the other thing that I find doing that whole "dentry->d_parent" 
> thing seems to literally be broken. If you look at v9fs_fid_lookup(), 
> you'll notice how it walks up the d_parent chain, and at that point you do 
> NOT own the directory i_mutex, so at that point d_parent really _can_ be 
> changing wildly due to concurrent renames or whatever.

Eh...  It's bogus, all right, but i_mutex is not the correct solution.
You'd have to take it on a lot of inodes along the way to root *and*
you'd violate the ordering in process (ancestors first).

I'm not sure what's the right thing to do there, actually - s_vfs_rename_sem
also won't do, since it'll give you ordering problems of its own (it's
taken before i_mutex in VFS, so trying to take it under i_mutex would not
do).

The _really_ interesting question is how do servers deal with topology-changing
renames.  Note that the problem exists only with extended 9P - with the
original one all of that had been a non-issue, since it didn't allow
cross-directory renames at all and the tree topology remained stable all along.
