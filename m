Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0EVQth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 12:49:37 -0400
Received: from mx2.netapp.com ([216.240.18.37]:42187 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab0EVQtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 12:49:36 -0400
X-IronPort-AV: E=Sophos;i="4.53,283,1272870000"; 
   d="scan'208";a="365398500"
Subject: Re: Possible NFS bug in 2.6.34...
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Stuart Sheldon <stu@actusa.net>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <4BF803F2.2010506@actusa.net>
References: <4BF72D34.60701@actusa.net>
	 <1274544580.4860.73.camel@heimdal.trondhjem.org>
	 <4BF803F2.2010506@actusa.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Sat, 22 May 2010 12:49:33 -0400
Message-ID: <1274546973.4860.78.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-2.fc13) 
X-OriginalArrivalTime: 22 May 2010 16:49:34.0729 (UTC) FILETIME=[C206DF90:01CAF9CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-22 at 09:18 -0700, Stuart Sheldon wrote: 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> On 05/22/2010 09:09 AM, Trond Myklebust wrote:
> > Do you see any more NFS traffic to the server when the above hang
> > occurs? I'm wondering if we don't need something like the following
> > patch.
> > 
> > Cheers
> >   Trond 
> > --------------------------------------------------------------------------------
> > From 0b574497e05f62fd49cfe26f1b97e3669525446c Mon Sep 17 00:00:00 2001
> > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Date: Sat, 22 May 2010 11:49:19 -0400
> > Subject: [PATCH] NFS: Ensure that we mark the inode as dirty if we exit early from commit
> > 
> > If we exit from nfs_commit_inode() without ensuring that the COMMIT rpc
> > call has been completed, we must re-mark the inode as dirty. Otherwise,
> > future calls to sync_inode() with the WB_SYNC_ALL flag set will fail to
> > ensure that the data is on the disk.
> > 
> > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Cc: stable@kernel.org
> > ---
> >  fs/nfs/write.c |   13 +++++++++++--
> >  1 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/nfs/write.c b/fs/nfs/write.c
> > index 3aea3ca..b8a6d7a 100644
> > --- a/fs/nfs/write.c
> > +++ b/fs/nfs/write.c
> > @@ -1386,7 +1386,7 @@ static int nfs_commit_inode(struct inode *inode, int how)
> >  	int res = 0;
> >  
> >  	if (!nfs_commit_set_lock(NFS_I(inode), may_wait))
> > -		goto out;
> > +		goto out_mark_dirty;
> >  	spin_lock(&inode->i_lock);
> >  	res = nfs_scan_commit(inode, &head, 0, 0);
> >  	spin_unlock(&inode->i_lock);
> > @@ -1398,9 +1398,18 @@ static int nfs_commit_inode(struct inode *inode, int how)
> >  			wait_on_bit(&NFS_I(inode)->flags, NFS_INO_COMMIT,
> >  					nfs_wait_bit_killable,
> >  					TASK_KILLABLE);
> > +		else
> > +			goto out_mark_dirty;
> >  	} else
> >  		nfs_commit_clear_lock(NFS_I(inode));
> > -out:
> > +	return res;
> > +	/* Note: If we exit without ensuring that the commit is complete,
> > +	 * we must mark the inode as dirty. Otherwise, future calls to
> > +	 * sync_inode() with the WB_SYNC_ALL flag set will fail to ensure
> > +	 * that the data is on the disk.
> > +	 */
> > +out_mark_dirty:
> > +	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
> >  	return res;
> >  }
> >  
> 
> Trond,
> 
> When it occurred, it continues to throw those errors in the log, and all
> access to the NFS mount stalled until I hard reset the client system.
> 
> Do you want me to apply the patch and see if I can recreate the condition?

Yes, please do. Could you also apply the following debugging patch on
top of the above one, and see if the WARN_ON() triggers when both
patches are applied?

Cheers
  Trond 
------------------------------------------------------------------------------------------------
>From 9883e35957468987f4338525c1d800d637bc05b7 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sat, 22 May 2010 10:46:41 -0400
Subject: [PATCH 2/2] NFS: debugging code for nfs_wb_page()

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/write.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index b8a6d7a..0558fab 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1519,12 +1519,21 @@ int nfs_wb_page(struct inode *inode, struct page *page)
 	int ret;
 
 	while(PagePrivate(page)) {
+		unsigned dirty;
+		int syncing;
+
 		wait_on_page_writeback(page);
 		if (clear_page_dirty_for_io(page)) {
 			ret = nfs_writepage_locked(page, &wbc);
 			if (ret < 0)
 				goto out_error;
+			continue;
 		}
+
+		dirty = inode->i_state & I_DIRTY;
+		syncing = inode->i_state & I_SYNC;
+		WARN_ON(!syncing && !dirty && PagePrivate(page));
+
 		ret = sync_inode(inode, &wbc);
 		if (ret < 0)
 			goto out_error;
-- 
1.7.0.1


