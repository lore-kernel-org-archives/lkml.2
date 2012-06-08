Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934514Ab2FHUuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:50:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab2FHUud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:50:33 -0400
Date: Fri, 8 Jun 2012 22:50:31 +0200
From: Jan Kara <jack@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
Message-ID: <20120608205031.GG21080@quack.suse.cz>
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
 <20120608150736.GF21080@quack.suse.cz>
 <20120608154535.GA887@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XMCwj5IQnwKtuyBG"
Content-Disposition: inline
In-Reply-To: <20120608154535.GA887@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat 09-06-12 00:45:35, Wu Fengguang wrote:
> On Fri, Jun 08, 2012 at 05:07:36PM +0200, Jan Kara wrote:
> > On Fri 08-06-12 10:36:13, Ted Tso wrote:
> > > 
> > > I can reproduce this fairly easily by using ext4 w/o a journal, running
> > > under KVM with 1024megs memory, with fsstress (xfstests #13):
> 
> Good catch, thanks!
> 
> >   Argh, I wonder how come I didn't hit this. Does attached patch fix the
> > problem?
> 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 8d2fb8c..41a3ccf 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -664,6 +664,7 @@ static long writeback_sb_inodes(struct super_block *sb,
> >  			/* Wait for I_SYNC. This function drops i_lock... */
> >  			inode_sleep_on_writeback(inode);
> >  			/* Inode may be gone, start again */
> > +			spin_lock(&wb->list_lock);
> >  			continue;
> >  		}
> 
> That looks like the fix. So I pushed it to writeback-for-next.
> Thanks for the quick fixing!
  Attached is a version with proper sign-off and changelog. Just in case
you didn't create one yourself already.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--XMCwj5IQnwKtuyBG
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-writeback-Fix-lock-imbalance-in-writeback_sb_inodes.patch"

>From 98fecbcb9edf39b4ab6aab8a85342f77665cac4d Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 8 Jun 2012 17:08:03 +0200
Subject: [PATCH] writeback: Fix lock imbalance in writeback_sb_inodes()

Fix bug introduced by 169ebd90.  We have to have wb_list_lock locked when
restarting writeback loop after having waited for inode writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8d2fb8c..41a3ccf 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -664,6 +664,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 			/* Wait for I_SYNC. This function drops i_lock... */
 			inode_sleep_on_writeback(inode);
 			/* Inode may be gone, start again */
+			spin_lock(&wb->list_lock);
 			continue;
 		}
 		inode->i_state |= I_SYNC;
-- 
1.7.1


--XMCwj5IQnwKtuyBG--
