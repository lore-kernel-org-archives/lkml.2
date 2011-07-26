Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1GZURM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:17:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab1GZURK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:17:10 -0400
Date: Tue, 26 Jul 2011 22:16:58 +0200
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Josef Bacik <josef@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>
Subject: Re: [PULL REQUEST] ext3, jbd, ext2, and quota fixes for 3.1-rc1
Message-ID: <20110726201658.GF27993@quack.suse.cz>
References: <20110726181418.GA27993@quack.suse.cz>
 <CA+55aFwYsdyE4KxFW70c_FfTb41m+EwchYvNJU-eUEw4usRkUw@mail.gmail.com>
 <20110726185220.GJ22133@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726185220.GJ22133@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-07-11 19:52:20, Al Viro wrote:
> On Tue, Jul 26, 2011 at 11:36:29AM -0700, Linus Torvalds wrote:
> 
> > So I *really* want people to take a look at that ext3_sync_file()
> > function. Please?
> 
> While we are at it, could somebody please explain what the hell is ext4
> doing in
> static int ext4_sync_parent(struct inode *inode)
> {
>         struct writeback_control wbc;
>         struct dentry *dentry = NULL;
>         int ret = 0;
> 
>         while (inode && ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
>                 ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
>                 dentry = list_entry(inode->i_dentry.next,
>                                     struct dentry, d_alias);
>                 if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
>                         break;
>                 inode = dentry->d_parent->d_inode;
>                 ret = sync_mapping_buffers(inode->i_mapping);
> 		...
> Note that dentry obviously can't be NULL there.  dentry->d_parent is never
> NULL.  And dentry->d_parent would better not be negative, for crying out
> loud!  What's worse, there's no guarantees that dentry->d_parent will
> remain our parent over that sync_mapping_buffers() *and* that inode won't
> just be freed under us (after rename() and memory pressure leading to
> eviction of what used to be our dentry->d_parent).  Moreover, even if
> inode survives in icache, there is no promise that it will have an alias
> in dcache by the time we get to the next iteration of the loop, so this
> list_entry() next time around can bloody well happen to &inode->i_dentry,
> dentry being a garbage address somewhere inside that struct inode (or a
> bit above it - I hadn't compared offsets).
> 
> What the hell is going on there?  It appeared more than a year ago in commit
> 14ece1028b3ed53ffec1b1213ffc6acaf79ad77c
> Author: Frank Mayhar <fmayhar@google.com>
> Date:   Mon May 17 08:00:00 2010 -0400
> ext4: Make fsync sync new parent directories in no-journal mode
> 
> and it had remained broken ever after...
  It really looks broken. Added Ted to CC...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
