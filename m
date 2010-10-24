Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab0JXUEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 16:04:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53373 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091Ab0JXUEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:04:37 -0400
Date: Sun, 24 Oct 2010 16:04:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101024200432.GA21376@infradead.org>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
 <20101022031431.GK12506@dastard>
 <20101022103705.GK19804@ZenIV.linux.org.uk>
 <20101023213752.GR19804@ZenIV.linux.org.uk>
 <20101024141310.GA21513@infradead.org>
 <20101024162131.GA23677@infradead.org>
 <20101024191735.GU19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101024191735.GU19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 08:17:35PM +0100, Al Viro wrote:
> 	* call in ext2_remount() is hogwash - we do that with at least
> root inode pinned down, so it will fail, along with the remount attempt.

And having it fail is a good thing.  XIP mode means different file and
address_space operations, which we don't even try to deal with right
now.  Not allowing transitions from/to it is the right thing.

> 	* smb reconnect logics.  AFAICS, that's complete crap; we *never*
> retain inodes on smbfs.  IOW, nothing for invalidate_inodes() to do, other
> than evict fsnotify marks.  Which is to say, we are calling the wrong
> function there, even assuming that fsnotify should try to work there.

I don't think it should mess with fsnotify.  fsnotify_unmount_inodes
assumes it's only called on umount right now, and sends umount
notifications to userspace (see my mail from a few days ago).  So if
you split invalidate_inodes it really should only go into the umount
one.

