Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab1EWRwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:52:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab1EWRwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:52:06 -0400
Date: Mon, 23 May 2011 13:52:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alex Bligh <alex@alex.org.uk>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: BUG: Failure to send REQ_FLUSH on unmount on ext3, ext4, and FS
 in general
Message-ID: <20110523175204.GA21110@infradead.org>
References: <959E4E25EAEC544D31199E6F@nimrod.local>
 <20110523155550.GE4716@quack.suse.cz>
 <EC63F9E077B362A0FDCF3527@Ximines.local>
 <20110523172906.GH4716@quack.suse.cz>
 <16968FD306209AF92D4660B9@Ximines.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16968FD306209AF92D4660B9@Ximines.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 06:39:23PM +0100, Alex Bligh wrote:
> I'm presuming that if just umount() were altered to do a REQ_FLUSH,
> the potential presence of 2 sync()s would not be too offensive, as
> unmount isn't exactly time critical, and as Christoph pointed out in
> the other thread, a REQ_FLUSH when the write cache has recently been
> emptied isn't going to take long.

Umount actually is the only place where adding it generically makes
sense.  It's not time-critical, and with kill_block_super we actually
have a block specific place to put it, instead of having to hack
it into the generic VFS, which is something we've been trying to avoid.

> Ah, fsdevel not here. OK. Partly I'd like to understand whether
> sync() not flushing write caches on barrier-less file systems
> is a good thing or a bad thing. I know barriers are better, but if
> writing to (e.g.) FAT32, I'm betting there is little prospect of
> barrier support.

"Barrier" support it's gone.  It's really just the FUA and FLUSH
flags these days.  For transactional filesystem these need to be
used to guarantee transaction integrity, but for all others just
adding one blkdev_issue_flush call to ->fsync and ->sync_fs is
enough.  That's discounting filesystem that use multiple block
devices, which are a bit more complicated.

