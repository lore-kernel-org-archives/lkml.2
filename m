Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1EWPzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:55:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab1EWPzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:55:52 -0400
Date: Mon, 23 May 2011 17:55:50 +0200
From: Jan Kara <jack@suse.cz>
To: Alex Bligh <alex@alex.org.uk>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: BUG: Failure to send REQ_FLUSH on unmount on ext3, ext4, and
 FS in general
Message-ID: <20110523155550.GE4716@quack.suse.cz>
References: <959E4E25EAEC544D31199E6F@nimrod.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <959E4E25EAEC544D31199E6F@nimrod.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 22-05-11 20:11:08, Alex Bligh wrote:
> I have been doing some testing to see what file systems successfully send
> REQ_FLUSH after all writes to the file system in the case of an unmount.
> 
> Results so far:
> 1. ext2, ext3 (with default options), never send REQ_FLUSH
> 2. ext3 (with barrier=1) and ext4 do send REQ_FLUSH but then
>    send further writes afterwards.
> 3. btrfs and xfs do things right (i.e. either end with a REQ_FLUSH in
>    xfs's case, or a REQ_FLUSH and a REQ_FUA in btrfs's case)
> 
> So the first bug is that ext3 and ext4 appear to send writes (without a
> subsequent flush/fia) before an unmount, and thus will never fully
> flush a write-behind cache. They look like this:
  Yeah, I think ext3/4 write journal superblock and fs superblock without
issuing a barrier after everything is synced.

> But quite aside from the question of whether the FS supports barriers,
> should the kernel itself (rather than the FS) not be sending REQ_FLUSH on
> an unmount as the last thing that happens? IE shouldn't we see a flush
> even on (say) ext2 which is never going to support barriers. If the kernel
> itself generated a REQ_FLUSH for the block device, this would keep
> filesystems that don't support barriers safe provided the unmount
> completed successfully and would have no impact on ones that had already
> flushed the write-behind cache.
  Yes, I think that generic VFS helpers should send barriers in cases where
it makes sense and umount is one of them. There even have been some
attempts to do so if I recall right but they didn't go anywhere.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
