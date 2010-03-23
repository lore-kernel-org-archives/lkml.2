Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0CWO2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:28:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55751 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0CWO2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:28:45 -0400
Date: Tue, 23 Mar 2010 14:28:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
 ioctl
Message-ID: <20100323142843.GG30031@ZenIV.linux.org.uk>
References: <20100323142200.GA2381@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323142200.GA2381@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 10:22:00AM -0400, Josef Bacik wrote:
> Currently the way we do freezing is by passing sb>s_bdev to freeze_bdev and then
> letting it do all the work.  But freezing is more of an fs thing, and doesn't
> really have much to do with the bdev at all, all the work gets done with the
> super.  In btrfs we do not populate s_bdev, since we can have multiple bdev's
> for one fs and setting s_bdev makes removing devices from a pool kind of tricky.
> This means that freezing a btrfs filesystem fails, which causes us to corrupt
> with things like tux-on-ice which use the fsfreeze mechanism.  So instead of
> populating sb->s_bdev with a random bdev in our pool, I've broken the actual fs
> freezing stuff into freeze_super and thaw_super.  These just take the
> super_block that we're freezing and does the appropriate work.  It's basically
> just copy and pasted from freeze_bdev.  I've then converted freeze_bdev over to
> use the new super helpers.  I've tested this with ext4 and btrfs and verified
> everything continues to work the same as before.
> 
> The only new gotcha is multiple calls to the fsfreeze ioctl will return EBUSY if
> the fs is already frozen.  I thought this was a better solution than adding a
> freeze counter to the super_block, but if everybody hates this idea I'm open to
> suggestions.  Thanks,

Locking is all wrong there.  We don't need to worry about umount; we *already*
have an active reference.  And leaving a kernel object with semaphore held
when ioctl returns is completely wrong.
