Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab0JXUg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 16:36:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33720 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793Ab0JXUgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:36:24 -0400
Date: Sun, 24 Oct 2010 21:36:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101024203620.GV19804@ZenIV.linux.org.uk>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
 <20101022031431.GK12506@dastard>
 <20101022103705.GK19804@ZenIV.linux.org.uk>
 <20101023213752.GR19804@ZenIV.linux.org.uk>
 <20101024141310.GA21513@infradead.org>
 <20101024162131.GA23677@infradead.org>
 <20101024191735.GU19804@ZenIV.linux.org.uk>
 <20101024200432.GA21376@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101024200432.GA21376@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 04:04:32PM -0400, Christoph Hellwig wrote:
> On Sun, Oct 24, 2010 at 08:17:35PM +0100, Al Viro wrote:
> > 	* call in ext2_remount() is hogwash - we do that with at least
> > root inode pinned down, so it will fail, along with the remount attempt.
> 
> And having it fail is a good thing.  XIP mode means different file and
> address_space operations, which we don't even try to deal with right
> now.  Not allowing transitions from/to it is the right thing.

Exactly.  But that should be done without that ridiculous call to
invalidate_inodes() - we should simply fail remount() and be done
with that.

> > 	* smb reconnect logics.  AFAICS, that's complete crap; we *never*
> > retain inodes on smbfs.  IOW, nothing for invalidate_inodes() to do, other
> > than evict fsnotify marks.  Which is to say, we are calling the wrong
> > function there, even assuming that fsnotify should try to work there.
> 
> I don't think it should mess with fsnotify.  fsnotify_unmount_inodes
> assumes it's only called on umount right now, and sends umount
> notifications to userspace (see my mail from a few days ago).  So if
> you split invalidate_inodes it really should only go into the umount
> one.

No, I mean that it's not obvious that fsnotify clients can realistically
work on smbfs in the first place.  I.e. I suspect that fsnotify should
refuse to set marks on that sucker.
