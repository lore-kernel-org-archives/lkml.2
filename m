Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab2BMOYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:24:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab2BMOYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:24:41 -0500
Date: Mon, 13 Feb 2012 15:24:18 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        mpatocka@redhat.com, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] vfs: Provide function to get superblock and wait
 for it to thaw
Message-ID: <20120213142418.GA6478@quack.suse.cz>
References: <1328868181-16979-1-git-send-email-jack@suse.cz>
 <1328868181-16979-2-git-send-email-jack@suse.cz>
 <20120212211325.GT23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120212211325.GT23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 12-02-12 21:13:25, Al Viro wrote:
> On Fri, Feb 10, 2012 at 11:03:00AM +0100, Jan Kara wrote:
> > In quota code we need to find a superblock corresponding to a device and wait
> > for superblock to be unfrozen. However this waiting has to happen without
> > s_umount semaphore because that is required for superblock to thaw. So provide
> > a function in VFS for this to keep dances with s_umount where they belong.
> 
> Eww...  All it takes is
> struct super_block *get_super_thawed(struct block_device *bdev)
> {
>         while (1) {
>                 struct super_block *s = get_super(bdev);
>                 if (!s || s->s_frozen == SB_UNFROZEN)
>                         return s;
> 		up_read(&s->s_umount);
> 		vfs_check_frozen(s, SB_FREEZE_WRITE);
> 		put_super(s);
>         }
> }
> and there's no need of extra arguments, etc. whatsoever.  Both patches
> applied, with implementation of get_super_thawed() done as above.
  Yeah, this looks better. Thanks!

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
