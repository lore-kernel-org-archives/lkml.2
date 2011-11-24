Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab1KXRvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 12:51:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55036 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab1KXRvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 12:51:50 -0500
Date: Thu, 24 Nov 2011 17:51:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.1-rc10 oops in nameidata_to_filp
Message-ID: <20111124175147.GN2203@ZenIV.linux.org.uk>
References: <20111124145141.GB22640@quack.suse.cz>
 <20111124164406.22919.qmail@science.horizon.com>
 <20111124173829.GL2203@ZenIV.linux.org.uk>
 <20111124175002.GM2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124175002.GM2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[grr... wrong To: on that one; instead of going it akpm it went to George,
in one too many copies; my apologies...]

On Thu, Nov 24, 2011 at 05:50:03PM +0000, Al Viro wrote:
> On Thu, Nov 24, 2011 at 05:38:29PM +0000, Al Viro wrote:
> > Said that, I'm not buying the theory of open assigning to ->f_mapping and
> > screwing it up; all such assignments end up with ->i_mapping of *some*
> > inode, as far as I can see from cursory grep over the tree.  Just in case:
> > do you have CONFIG_FS_POSIX_ACL set?
> 
> BTW, why are we going through that dance with ->host->i_mapping anyway?
> It had been introduced by commit by akpm back in 2004 and from my reading
> of the commit message it was an overkill even back then.  Basically,
> that call got moved to the point past the call of ->open() (good, ->f_mapping
> could've been changed by it) *and* converted from ->f_mapping to
> ->f_mapping->host->i_mapping, which is useless.  Definitely so in the
> case mentioned in that commit (blkdev_open() sets ->f_mapping 
> bdev->bd_inode->i_mapping and that thing will have ->host pointing
> back to bdev->bd_inode).  Commit was in BK, its copy in historical tree
> is commit 1c211088833a27daa4512348bcae9890e8cf92d4
> Author: Andrew Morton <akpm@osdl.org>
> Date:   Wed May 26 17:35:42 2004 -0700
> 
>     [PATCH] Fix the setting of file->f_ra on block-special files
>     
>     We need to set file->f_ra _after_ calling blkdev_open(), when inode->i_mapping
>     points at the right thing.  And we need to get it from
>     inode->i_mapping->host->i_mapping too, which represents the underlying device.
>     
>     Also, don't test for null file->f_mapping in the O_DIRECT checks.
>     
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
> 
> and the only difference wrt setting ->f_mapping on bdev open back then
> is that it used to be done in do_open() instead of blkdev_open() itself.
> So I don't understand what that part of changes had been for...  Andrew?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
