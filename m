Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1IEObU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:31:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1IEObQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:31:16 -0400
Date: Mon, 5 Sep 2011 16:31:10 +0200
From: Jan Kara <jack@suse.cz>
To: awp47 <awp47.swjtu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: a oops about orphan inode
Message-ID: <20110905143110.GI5466@quack.suse.cz>
References: <CAHq9w0JEe6+cqNTSOAQQZgVvtLdF-X6ic-3PZi14gVvunLQ-4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHq9w0JEe6+cqNTSOAQQZgVvtLdF-X6ic-3PZi14gVvunLQ-4g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-08-11 23:51:11, awp47 wrote:
> hi ,all
> recently, I meet a oops in a old kernel(2.6.5-suse9).
> General process are:
> 1.mount a block device: mount -t ext3 -o data=journal /dev/device
> /some, it return ok.
> 2.in userspace, execute the rm commond, and the rm will call sys_unlink():
> 2.1.sys_unlink() will call path_lookup(), it will call
> ext3_lookup()->ext3_read_inode(), it's get a inode from
>    disk, but it's inode->i_nlink and inode->i_mode are both 0, so it's
> a bad inode(make_bad_inode()).
> 2.2.after lookup path, sys_unlink() will call
> vfs_unlink()->ext3_unlink(), in ext3_unlink() it will find the bad
>    inode, and put it in orphan inode list both memory and disk.
> 2.3.after vfs_unlink(), sys_unlink() will call
> iput()->ext3_delete_inode(), in ext3_delete_inode() it will check
>    the inode, if it is bad, it will goto end(don't remove orphan inode
> from the memory and disk list)
> 3.umount the block device, at this time, kernel oops in
> ext3_put_super(): J_ASSERT(list_empty(&sbi->s_orphan));
> 
> can somebody tell me, how to deal with bad inode in kernel? if we get
> a bad inode from disk, it will don't remove
> from orphan inode list?
> 
> I checked the newest stable kernel 3.0.3. ext3_read_inode() change
> into ext3_iget(): if we get a bad inode, it will
> call iget_failed(), it will mark inode as bad(make_bad_inode) and call
> iput(), at last will call ext3_evict_inode. now
> in ext3_evict_inode also checked inode, if it is bad, don't remove
> from orphan inode list.
  Hmm, where does it check for bad inode and exit without removing inode
from orphan list? I don't see anything like that in ext3_evict_inode().

  BTW: Sending this question to linux-ext4@vger.kernel.org would have
higher chances of getting some attention.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
